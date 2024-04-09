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


print -f '%s: INFO: loading dependencies...' -- $0
LIST_L  modL=( app/ebay_transactions_csv_parse:t23419 );  INTERNAL_FRAMEWORK_A_loadDependencies
print '  DONE'
STR_L   modS=app/ebay_check_transactions_data
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


STR_L     idS  tmpS  titleS
STR_L     order_number_S  sold_for_S  shipping_and_handling_S  sale_date_S
STR_L     final_value_fee___fixed_S  final_value_fee___variable_S
INT_L     numI  countI  mcountI  ordercountI
MAP_L     itemS_costF_M
LIST_L    itemS_feeF_L
FLOATF_L  sold_total_F  shipping_and_handling_total_F  feeF  fvf_fixed_F  fvf_variable_F  net_amount_F
FLOATF_L  final_value_fee___fixed_F  final_value_fee___variable_F  net_total_F
FLOATF_L  fee_subtotal_F  fee_total_F
BOOL_L    ignoreB

for idS in ${(k)APP_EBAY_TRANSACTIONS_CSV_PARSE_V_order_number_S_M}; do
    countI=${APP_EBAY_TRANSACTIONS_CSV_PARSE_V_order_number_S_M[${idS}]}
    itemS_costF_M=()  itemS_feeF_L=()  fvf_fixed_F=0  fvf_variable_F=0  feeF=0  net_amount_F=0
    order_number_S=  sale_date_S=  ignoreB=${B_F}
    for numI in {1..${countI}}; do
	eval MAP_L infoM="( \"\${(kv@)APP_EBAY_TRANSACTIONS_CSV_PARSE_V_order_${idS}_${numI}_M}\" )"
	tmpS=${infoM[item-title]}
	if [[ ${tmpS} != ''  &&  ${tmpS} != '--' ]]; then
	    titleS=${tmpS};  fi
	if [[ ${numI} -eq 1 ]]; then
	    order_number_S=${infoM[order-number]//_/-}
	    sale_date_S=${infoM[_transaction-creation-date]}
	    if ! [[ ${sale_date_S} =~ '^Nov ' ]]; then
		ignoreB=${B_T};  break;  fi
	    ordercountI+=1;  fi
	if [[ ${infoM[item-subtotal]} != '--' ]]; then
	    sold_for_S=${infoM[item-subtotal]/$/};  fi
	if [[ ${infoM[net-amount]} != '--' ]]; then
	    tmpS=${infoM[net-amount]/$/}
	    net_amount_F=$(( ${net_amount_F} + ${tmpS} ));  fi
	if [[ ${infoM[shipping-and-handling]} != '--' ]]; then
	    shipping_and_handling_S=${infoM[shipping-and-handling]/$/};  fi
	if [[ ${infoM[final-value-fee---fixed]} != '--' ]]; then
	    fvf_fixed_F+=${infoM[final-value-fee---fixed]};  fi
	if [[ ${infoM[final-value-fee---variable]} != '--' ]]; then
	    fvf_variable_F+=${infoM[final-value-fee---variable]};  fi
	if [[ ${infoM[item-id]} != '--' ]]; then
	    itemS_costF_M[${infoM[item-id]}]=${sold_for_S};  fi
	if [[ ${fvf_fixed_F} -ne 0 ]]; then
	    feeF=$(( ${feeF} + ${fvf_fixed_F} ));  fi
	if [[ ${fvf_variable_F} -ne 0 ]]; then
	    feeF=$(( ${feeF} + ${fvf_variable_F} ));  fi
	itemS_feeF_L+=( ${feeF} );  done
    if [[ ${ignoreB} -eq ${B_F} ]]; then
	print -f 'order-number=%s  sale-date=%s  net-amount=%.2f  sold-for=%.2f  s-and-h=%.2f  fvf-fixed-subtotal=%.2f  fvf-variable-subtotal=%.2f  items=( %s )  items-fees=( %s )  item-title=%q\n' -- \
	      "${order_number_S}"  "${sale_date_S}"  "${net_amount_F}"  "${sold_for_S}"  "${shipping_and_handling_S}"  "${fvf_fixed_F}"  "${fvf_variable_F}" \
	      "$(INTERNAL_FRAMEWORK_F_mapToStrR -P itemS_costF_M)" \
	      "$(INTERNAL_FRAMEWORK_A_listToStrR -P itemS_feeF_L)" \
	      "${titleS}"
	sold_total_F=$(( ${sold_total_F} + ${sold_for_S} ))
	fee_total_F=$(( ${fee_total_F} + ${fee_subtotal_F} ))
	net_total_F=$(( ${net_total_F} + ${net_amount_F} ))
	fee_total_F=$(( ${fee_total_F} + ${feeF} ))
	shipping_and_handling_total_F=$(( ${shipping_and_handling_total_F} + ${shipping_and_handling_S} ))
    fi
done
print -f 'order-count=%s  sales-total=%.2f  net-total=%.2f  s-and-h-total=%.2f  fee-total=%.2f\n' -- \
      ${ordercountI}  ${sold_total_F}  ${net_total_F}  ${shipping_and_handling_total_F}  ${fee_total_F}
