#!/bin/bash

############################################# XPM2BIN #####################################
# command: ./xpm2bin file.xpm
# Takes XPM file and then changes secondary structure assignment to binary numbers, creates a temp file, transposes and finally saves output as file.xpm.converted
# ~     Coil    0
# H     A-Helix 1
# G     3-Helix 2 
# I     5-Helix 3
# S     Bend    4
# T     Turn    5
# B     B-Bridge 6
# E	B-Sheet 7

xpm="$1"


 sed -n -e '/\/\* y-axis/,$p' $xpm | sed -n -e '/\"/,$p' |  sed 's/\~/0/g' | sed 's/H/1/g' | sed 's/G/2/g' | sed 's/I/3/g' | sed 's/S/4/g' | sed 's/T/5/g'| sed 's/B/6/g' | sed 's/E/7/g' | sed 's/"//g' | sed 's/,//g' | sed 's/./& /g' > foo

exec awk '
NR == 1 {
        n = NF
        for (i = 1; i <= NF; i++)
                row[i] = $i
        next
}
{
        if (NF > n)
                n = NF
        for (i = 1; i <= NF; i++)
                row[i] = row[i] " " $i
}
END {
        for (i = 1; i <= n; i++)
                print row[i]
}'  < foo > $1.converted
rm foo

