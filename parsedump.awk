#!/usr/bin/awk
func flushKey()
{
  if(buffer != 0)
  {
    key = substr(buffer, 0, keylen);
    buffer = 0;
  }
}

BEGIN{
  buffer = 0;
  key = 0;
}
{
  if($1 ~ /[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{6}/)
    flushKey();
  else if($1 ~ /0x[0-9]{4}:/)
  {
    pos = (substr($1,0,6) + 0);
    if(pos == 32)
    {
      keylen = ("0x"$7) + 0;
      keypos = ("0x"substr($8,0,2)) + 64;
      offset = keypos % 16;
    }
    else if(pos == keypos - offset)
      buffer = substr($NF, offset+1)
    else if(buffer != 0 && pos > keypos)
    {
      buffer = buffer $NF;
      if(length(buffer) >= keylen)
        flushKey();
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
