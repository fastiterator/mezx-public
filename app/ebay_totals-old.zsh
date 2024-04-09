#!/bin/zsh

# MEZX_startup{ v1.5
typeset +g selfpathS=$0
function {
    typeset +g pathnameS=${MEZXDIR-MEZXDIR_VAR_NOT_DEFINED}/internal/bootstrap.zsh  tmpbaseS=/tmp/${selfpathS:t}.$$
    . ${pathnameS} 1>${tmpbaseS}.out 2>${tmpbaseS}.err
    typeset +g -i resultI=$?  exitI=0
    if [[ ${resultI} -ne 0 ]]; then
        print -f "ERROR: %s (mezx-startup):  { failed to bootstrap MEZX;  pathnameS=%s;  resultI=%d;\n---- outS start ----\n%s\n---- outS end ----\n\n---- errS start ----\n%s\n---- errS end ----\n}\n" -- \
              ${selfpathS}  ${pathnameS}  ${resultI}  "$(cat ${tmpbaseS}.out)"  "$(cat ${tmpbaseS}.err)"
        exitI=1;  fi
    rm -f ${tmpbaseS}.{out,err}
    if [[ ${exitI} -ne 0 ]]; then exit ${exitI};  fi
}
unset selfpathS
# }MEZX_startup v1.5


LIST_L  modL=( app/mrg_ebay_reconcile );  INTERNAL_FRAMEWORK_A_loadDependencies
STR_L   modS=app/ebay_totals
STR_L   modUS=${(U)modS//\//_}
STR_L   selfS=${modUS}_A_selfmodSetup
#
# USAGE
#     eval <selfS>
#
STR_G   ${selfS}_SE='
    STR_L   modS="'${modS}'"  modUS="'${modUS}'"  selfS="$0";
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_localModCommonvarsCreate
#
# USAGE
#     eval <selfS>
#
STR_G   ${selfS}_SE='
; '
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   idS
STR_L   order_number_S  sold_for_S  shipping_and_handling_S  sale_date_S
INT_L   numI  countI
MAP_L   itemS_costF_M
FLOATF_L sold_total_F  shipping_and_handling_total_F

for idS in ${(k)APP_MRG_EBAY_RECONCILE_V_ebay_orderM}; do
    countI=${APP_MRG_EBAY_RECONCILE_V_ebay_orderM[${idS}]}
    itemS_costF_M=()
    for numI in {1..${countI}}; do
	eval MAP_L infoM="( \"\${(kv@)APP_MRG_EBAY_RECONCILE_V_ebay_order_${idS}_${numI}_M}\" )"
	if [[ ${numI} -eq 1 ]]; then
	    order_number_S=${infoM[order-number]//_/-}
	    sale_date_S=${infoM[sale-date]}
	    sold_for_S=${infoM[sold-for]/$/}
	    shipping_and_handling_S=${infoM[shipping-and-handling]/$/}
	    if [[ ${countI} -gt 1 ]]; then
		continue;  fi;  fi
	itemS_costF_M[${infoM[item-number]}]=${infoM[sold-for]};  done
    print -f 'order-number=%s  sale-date=%s  sold-for=%s  s-and-h=%s  items=( %s )\n' -- \
	  ${order_number_S}  ${sale_date_S}  ${sold_for_S}  ${shipping_and_handling_S} \
	  "$(INTERNAL_FRAMEWORK_F_mapToStrR -P itemS_costF_M)"
    sold_total_F=$(( ${sold_total_F} + ${sold_for_S} ))
    shipping_and_handling_total_F=$(( ${shipping_and_handling_total_F} + ${shipping_and_handling_S} ));  done
print -f 'sales-total=%s  s-and-h-total=%s\n' -- \
      ${sold_total_F}  ${shipping_and_handling_total_F}
