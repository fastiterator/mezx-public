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
LIST_L  modL=( app/ebay_csv_parse  app/ebay_marketing_csv_parse  app/ebay_transactions_csv_parse:t8633  app/pirate_csv_parse );  INTERNAL_FRAMEWORK_A_loadDependencies
print '  DONE'
set -vx
STR_L   modS=app/ebay_monster_high
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


STR_L     idS  promoteS
STR_L     order_number_S  sold_for_S  shipping_and_handling_S  sale_date_S
STR_L     final_value_fee___fixed_S  final_value_fee___variable_S
INT_L     numI  countI  mcountI  ordercountI
MAP_L     itemS_costF_M  itemS_promoteF_M
LIST_L    itemS_feeF_L
FLOATF_L  sold_total_F  shipping_and_handling_total_F  promoteF  feeF
FLOATF_L  final_value_fee___fixed_F  final_value_fee___variable_F
FLOATF_L  fee_subtotal_F  fee_total_F  promote_subtotal_F  promote_total_F  pirate_subtotal_F  pirate_total_F

for idS in ${(k)APP_EBAY_CSV_PARSE_V_orderM}; do
    ordercountI+=1
    countI=${APP_EBAY_CSV_PARSE_V_orderM[${idS}]}
    itemS_costF_M=()
    for numI in {1..${countI}}; do
	eval MAP_L infoM="( \"\${(kv@)APP_EBAY_CSV_PARSE_V_order_${idS}_${numI}_M}\" )"
	if ! [[ ${infoM[item-title]} =~ '^Monster'  ]]; then
	    break; fi
	if [[ ${numI} -eq 1 ]]; then
	    order_number_S=${infoM[order-number]//_/-}
	    sale_date_S=${infoM[sale-date]}
	    sold_for_S=${infoM[sold-for]/$/}
	    shipping_and_handling_S=${infoM[shipping-and-handling]/$/}
	    if [[ ${countI} -gt 1 ]]; then
		continue;  fi;  fi
	itemS_costF_M[${infoM[item-number]}]=${infoM[sold-for]//$/};  done
    itemS_promoteF_L=()
 
    promote_subtotal_F=0
    itemS_promoteF_M=()
    for itemS in ${(k)itemS_costF_M}; do
	promoteF=0
	if [[ -v "APP_EBAY_MARKETING_CSV_PARSE_V_itemS_M[${itemS}]" ]]; then
	    for campaignS in ${(k)APP_EBAY_MARKETING_CSV_PARSE_V_campaignS_M}; do
		if [[ -v "APP_EBAY_MARKETING_CSV_PARSE_V_campaignS_itemS_M[${campaignS}-${itemS}]" ]]; then
		    mcountI=${APP_EBAY_MARKETING_CSV_PARSE_V_campaignS_itemS_M[${campaignS}-${itemS}]}
		    for numI in {1..${mcountI}}; do
			eval MAP_L infoM="( \"\${(kv@)APP_EBAY_MARKETING_CSV_PARSE_V_campaign_${campaignS}_item_${itemS}_${numI}_M}\" )"
			if ! [[ ${infoM[title]} =~ '^Monster' ]]; then
			    break;  fi
			promoteS=${infoM[ad-fees]/$/}
			promoteS=${promoteS/ /}
			if [[ ${promoteS} != '0.00' ]]; then
			    promoteF=$(( ${promoteF} + ${promoteS} ));  fi;  done;  fi;  done;  fi
	if [[ ${promoteF} -ne 0 ]]; then
	    itemS_promoteF_M[${itemS}]=${promoteF};  fi
	promote_subtotal_F=$(( ${promote_subtotal_F} + ${promoteF} ));  done
 
    itemS_feeF_L=()
    fee_subtotal_F=0
    if [[ ! -v "APP_EBAY_TRANSACTIONS_CSV_PARSE_V_order_number_S_M[${idS}]" ]]; then
	print -f 'WARNING: %s: order-id not found in transactions data: "%s"\n' -- \
	      $0  ${idS//_/-}
    else
	mcountI=${APP_EBAY_TRANSACTIONS_CSV_PARSE_V_order_number_S_M[${idS}]}
	for numI in {1..${mcountI}}; do
	    eval MAP_L infoM="( \"\${(kv@)APP_EBAY_TRANSACTIONS_CSV_PARSE_V_order_${idS}_${numI}_M}\" )"
	    if ! [[ ${infoM[item-title]} =~ '^Monster' ]]; then
		break;  fi
	    final_value_fee___fixed_S=${infoM[final-value-fee---fixed]}
	    final_value_fee___variable_S=${infoM[final-value-fee---variable]}
	    final_value_fee___fixed_F=0  final_value_fee___variable_F=0
	    if [[ X${final_value_fee___fixed_S} != X-- ]]; then
		final_value_fee___fixed_F=${final_value_fee___fixed_S}; fi
	    if [[ X${final_value_fee___variable_S} != X-- ]]; then
		final_value_fee___variable_F=${final_value_fee___variable_S}; fi
	    feeF=$(( ${final_value_fee___fixed_F} + ${final_value_fee___variable_F} ))
	    if (( ${feeF} < 0 )); then
		feeF=$(( ${feeF} * -1 ));  fi
	    itemS_feeF_L+=( ${feeF} )
	    fee_subtotal_F=$(( ${fee_subtotal_F} + ${feeF} ));  done;  fi
    pirate_subtotal_F=0.00
    if [[ -v "APP_PIRATE_CSV_PARSE_V_orderM[${idS}]" ]]; then
	eval MAP_L infoM="( \"\${(kv@)APP_PIRATE_CSV_PARSE_V_order_${idS}_1_M}\" )"
	pirate_subtotal_F=${infoM[cost]};  fi
    print -f 'order-number=%s  sale-date=%s  sold-for=%.2f  s-and-h=%.2f  pirate-cost=%.2f  fee-subtotal=%.2f  promote-subtotal=%.2f  items=( %s )  items-fees=( %s )  items-promote=( %s )\n' -- \
	  ${order_number_S}  ${sale_date_S}  ${sold_for_S}  ${shipping_and_handling_S}  ${pirate_subtotal_F}  ${fee_subtotal_F}  ${promote_subtotal_F} \
	  "$(INTERNAL_FRAMEWORK_F_mapToStrR -P itemS_costF_M)" \
	  "$(INTERNAL_FRAMEWORK_A_listToStrR -P itemS_feeF_L)" \
	  "$(INTERNAL_FRAMEWORK_F_mapToStrR -P itemS_promoteF_M)"
    sold_total_F=$(( ${sold_total_F} + ${sold_for_S} ))
    fee_total_F=$(( ${fee_total_F} + ${fee_subtotal_F} ))
    promote_total_F=$(( ${promote_total_F} + ${promote_subtotal_F} ))
    shipping_and_handling_total_F=$(( ${shipping_and_handling_total_F} + ${shipping_and_handling_S} ))
    pirate_total_F=$(( ${pirate_total_F} + ${pirate_subtotal_F} ));  done
print -f 'order-count=%s  sales-total=%.2f  s-and-h-total=%.2f  pirate-total=%.2f  fee-total=%.2f  promote-total=%.2f\n' -- \
      ${ordercountI}  ${sold_total_F}  ${shipping_and_handling_total_F}  ${pirate_total_F}  ${fee_total_F}  ${promote_total_F}
