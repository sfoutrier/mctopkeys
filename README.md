mctopkeys
=========

Simple bash script to get most frequent keys used over a binary memcache protocol

REQUIREMENTS:

* tcpdump
* sudo to execute tcpdump
* awk
* sed

HOW TO USE:

You can use it both on client or server side.
This script will monitor only requests, not responses to parse the keys in it and reporting stats over them.

If you're in a standard case (memcached listening on 11211, bound on eth0, you want to parse all requests and the full keys)

./mctopkeys -c 100

This will capture 100 memcache requests and output a report (in stdio, you can see some other messages in stderr)

ARGUMENTS:

* -p: You can use -p to specify the port (if running on couchbase, "-p 11210" could helps you)
* -i: To speficy the interface, for instance "-i eth1"
* -m: the capture size, can improve performance, but truncate keys if your keys are to big.
      It won't truncate the same key size, it depends on the extra field size. So you could expect some weird behavior.
* -o: memcache opcode, -o 0 for get, -o 1 for set.
      see https://code.google.com/p/memcached/wiki/BinaryProtocolRevamped#Command_Opcodes for complete list
* -t: filter on TTL higher than the given one, works only combined with a opcode that match extra field to TTL.
      This parameter will works only if your client use the number of second to keep alive and does not specify the expiration timestamp.
      (both are valid on memcached protocol)
* -e: specify a filtering regex. for instance if you want to filter only the 4 first chars of the keys:
      -e '^(.{5}).*$'
      if you want chars until a separator (let say @)
      -e '^([^@]*)@.*$'

