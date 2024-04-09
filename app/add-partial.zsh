#/bin/zsh
#
# USAGE
#     MEZXDIR=.. zsh ./ebay_totals.zsh | fgrep 'Monster' | ${this}

awk '{print $1 " " $3 " " $4 " " $5 " " $6 " " $7 }' | \
    sed 's/[-a-z]*=//g' | \
    awk '
    {
        count++;
        f2+=$2; f3+=$3; f4+=$4; f5+=$5; f6+=$6;
    }
    END {
        print "count,sold_for,s+h,pirate,fees,advertising";
	print count "," f2 "," f3 "," f4 "," f5 "," f6;
    }'
