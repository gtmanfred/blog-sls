#!/bin/bash
output="$(curl -s --fail http://localhost/health/monitoring 2>/dev/null)"
ret="$?"

printf "metric retcode int32 %d\n" $ret
if [[ -n $output ]]; then
    printf "metric output string %s\n" $output
else
    printf "metric output string %s\n" 'FAIL'
fi
