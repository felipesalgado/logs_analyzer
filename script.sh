#!/bin/bash
grep -i ": failed" -A 1 network.log | grep -i from -A 1 | grep -E -o '([0-9]{1,3}[.]){3}[0-9]{1,3}'| sort -n | uniq -c | sort -r -k 1 > failed.txt;grep -i ": reverse" -A 1 network.log | grep -i from -A 1 | grep -E -o '([0-9]{1,3}[.]){3}[0-9]{1,3}'| sort -n | uniq -c | sort -r -k 1 > reverse.txt

LENGTH=$(awk 'END{print FNR}' failed.txt)

if (($# == 0))
  then
    echo "Debe indicar la cantidad de registros a mostrar."
  else
    if (($* <= $LENGTH))
    then
      LENGTH="$*"

      for (( i=1; i<=$LENGTH; i++ ))
      do
        IP=$(awk "NR==$i{print \$2}" failed.txt)
        COUNTFAILED=$(awk "NR==$i{print \$1}" failed.txt)

        COUNTREVERSE=$(grep $IP reverse.txt | wc -l)

        if [ $COUNTREVERSE != 0 ]
        then
          COUNTREVERSE=$(grep $IP reverse.txt | awk "{print \$1}")
        fi

        COUNTRY=$(whois $IP | grep Country | awk "NR==1{print \$2}")

        echo LA IP ES: $IP Failed: $COUNTFAILED Reverse: $COUNTREVERSE Total: $((COUNTFAILED+COUNTREVERSE)) PAIS: $COUNTRY
        
      done
    else
      echo La cantidad de registros no puede ser superior a $LENGTH
    fi
fi
