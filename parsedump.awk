#!/usr/bin/awk
func flushKey()
{
  if(buffer != 0)
  {
    key = substr(buffer, 0, keyLen);
    buffer = 0;
    keyPos = -1;
    keyLenPos = -1;
    extraLenPos = -1;
  }
}

BEGIN{
  buffer = 0;
  key = 0;
}
{
  if($1 ~ /[0-9]+:[0-9]+:[0-9]+\.[0-9]+/)
    flushKey();
  else if($1 ~ /0x[0-9]+:/)
  {
    pos = (substr($1,0,6) + 0);

    # capturing the begin of the tcp payload
    if(pos == 32)
    {
      # 4 * tcp header size + IP header size
      tcpBegin = ("0x"substr($2,0,1) + 0) * 4 + 20;
      keyLenPos = tcpBegin + 2;
      keyLenOffset = keyLenPos % 16;
      extraLenPos = tcpBegin + 4;
      extraLenOffset = extraLenPos % 16;
    }

    if(pos >= 32)
    {
      # get the key length
      if(pos == keyLenPos - keyLenOffset)
      {
        keyLen = ("0x" $(2 + keyLenOffset / 2)) + 0;
      }
      # get the extra length
      if(pos == extraLenPos - extraLenOffset)
      {
        extraLen = ("0x"substr($(2 + extraLenOffset / 2),0,2)) + 0;
        keyPos = tcpBegin + 24 + extraLen;
        keyOffset = keyPos % 16;
      }
      if(pos == keyPos - keyOffset)
      {
        buffer = substr($NF, keyOffset+1)
      }
      else if(buffer != 0)
      {
        buffer = buffer $NF;
        if(length(buffer) >= keyLen)
          flushKey();
      }
    }
  }

  if(key != 0)
  {
    print key;
    key = 0;
  }
}
END{
  flushKey();
}
