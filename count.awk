#!/bin/awk
function getTime()
{
  cmd = "date +%s.%N";
  cmd | getline time;
  close(cmd);
  return time;
}

BEGIN {
  start = getTime();
}

{
  r[$0]++
}

END {
  exec = getTime() - start;
  for(i in r)
  {
    printf("%d\t%.2f\t%s\n", r[i], r[i]/exec, i)
  }
}
