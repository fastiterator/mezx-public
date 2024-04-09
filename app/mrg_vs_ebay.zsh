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
STR_L   modS=app/ebay_mrg_compare
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
for idS in ${(k)APP_MRG_EBAY_RECONCILE_V_ebay_orderM}; do
    if ! [[ -v "APP_MRG_EBAY_RECONCILE_V_mrg_orderM[${idS}]" ]]; then
	eval MAP_L infoM="( \"\${(kv@)APP_MRG_EBAY_RECONCILE_V_ebay_order_${idS}_M}\" )"
	print -f "in ebay, not mrg: order=%s  sale-date=%s  item=%s  title=%s\n" -- \
	      ${idS//_/-}  ${infoM[sale-date]}  ${infoM[item-number]}  ${infoM[item-title]};  fi
done
for idS in ${(k)APP_MRG_EBAY_RECONCILE_V_mrg_orderM}; do
    if ! [[ -v "APP_MRG_EBAY_RECONCILE_V_ebay_orderM[${idS}]" ]]; then
	eval MAP_L infoM="( \"\${(kv@)APP_MRG_EBAY_RECONCILE_V_mrg_order_${idS}_M}\" )"
	print -f "in mrg, not ebay: order=%s  sale-date=%s  title=%s\n" -- \
	      ${idS//_/-}  ${infoM[sale-date]}  ${infoM[item-title]};  fi
done
