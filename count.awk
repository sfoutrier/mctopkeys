#!/bin/awk
{
  r[$0]++
} 
END {
  for(i in r)
  {
    print i" "r[i]
  }
}
