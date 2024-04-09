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


LIST_L  modL=( lib/fsm lib/csv );  INTERNAL_FRAMEWORK_A_loadDependencies
STR_L   modS=app/mrg_csv_parse
STR_L   modUS=${(U)modS//\//_}
MAP_G   ${modUS}_V_orderM
INT_G   ${modUS}_V_countI


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


STR_L   selfS=${modUS}_F_main
#
# USAGE
#     <selfS>  <fileS>
#
function ${selfS}() {
    eval APP_MRG_CSV_PARSE_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    LIST_L  nameS_patternS_outputS_L=(
	"id"	"id"	"id"
	"platform-id"	"Platform ID"	"Platform ID"
	"item-title"	"Item Title"	"Item Title"
	"department"	"Department"	"Department"
	"category"	"Category"	"Category"
	"subcategory"	"Sub Category"	"Sub Category"
	"vendor"	"Vendor"	"Vendor"
	"brand"	"Brand"	"Brand"
	"location"	"Location"	"Location"
	"sku"	"SKU"	"SKU"
	"purchase-date"	"Purchase Date"	"Purchase Date"
	"list-date"	"List Date"	"List Date"
	"sale-date"	"Sale Date"	"Sale Date"
	"days-on-platform"	"Days On Platform"	"Days On Platform"
	"sale-price"	"Sale Price"	"Sale Price"
	"purchase-price"	"Purchase Price"	"Purchase Price"
	"shipping-costs"	"Shipping Costs"	"Shipping Costs"
	"shipping-costs-from=expense-detail"	"Shipping Costs .From Expense Detail."	"Shipping Costs (From Expense Detail)"
	"transaction-fees"	"Transaction Fees"	"Transaction Fees"
	"other-costs-from-expense-detail"	"Other Costs .From Expense Detail."	"Other Costs (From Expense Detail)"
	"gross-profit"	"Gross profit"	"Gross profit"
	"sale-state"	"Sale State"	"Sale State"
	"sales-tax"	"Sales Tax"	"Sales Tax"
	"liable-to-pay"	"Liable To Pay"	"Liable To Pay"
	"platforms-listed"	"Platforms Listed"	"Platforms Listed"
	"sale-platform"	"Sale Platform"	"Sale Platform"
	"notes"	"Notes"	"Notes"
	"status"	"Status"	"Status"
    )
    STR_L   pathnameS  headerS  lineS  platformidS  nameS  patternS  outputS  varnameS
    INT_L   subnumI
 
    repeat 1; do
	if [[ ${argcI} -ne 1 ]]; then
	    curerrI=2;  calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_argL_to_argL_S  curerrI=1;  INTERNAL_FRAMEWORK_A_callSimple
	    errI=1
            print -v errS -f 'argcI != 1: %d;  argL=( %s )' -- \
		  ${argcI}  "${argL_S}";  break;  fi
	pathnameS=$1
	if ! [[ -f ${pathnameS}  &&  -r ${pathnameS} ]]; then
	    errI=4
            print -v errS -f '"%s" arg value does not refer to extant/readable file: "%s"' -- \
		  pathnameS  "${pathnameS}";  break;  fi

	head -1 ${pathnameS} | read -r headerS
	headerS=${headerS/\/}
	calleemodUS=LIB_CSV calleeS=F_setup curerrI=5; \
	    INTERNAL_FRAMEWORK_A_callSimple  excel  target  nameS_patternS_outputS_L  \${headerS}

	print -f 'INFO: %s: processing records... ' -- $0
	INT_L   termI=0  countI=0
	tail +2 ${pathnameS} | while read -r lineS; do
	    lineS=${lineS/\/}
	    calleemodUS=LIB_CSV calleeS=F_extract curerrI=6;  \
		INTERNAL_FRAMEWORK_A_callSimple  target  \${lineS}
	    platformidS=${LIB_CSV_V_replyM[platform-id]}
	    platformidS=${platformidS//-/_}
	    LIB_CSV_V_replyM[platform-id]=${platformidS}
	    varnameS="${modUS}_V_orderM[\${platformidS}]"
	    if ! [[ -v ${varnameS} ]]; then
		eval "${varnameS}=0"; fi
	    eval "${varnameS}=\$(( \${${varnameS}} + 1 ));  subnumI=\${${varnameS}}"
	    varnameS="${modUS}_V_order_${platformidS}_${subnumI}_M"
	    eval "MAP_G   ${varnameS}=()"
	    eval "${varnameS}=( \"\${(kv@)LIB_CSV_V_replyM}\" )"
	    countI+=1
	    termI+=-1
	    if (( ${countI} % 100 == 0 )); then
		print -f '%d  ' -- ${countI};  fi
	    if [[ ${termI} -eq 0 ]]; then
		okB=${B_T};  break;  fi
	    okB=${B_T};  done
	print -f '%d  DONE\n' -- ${countI}
	INT_G   ${modUS}_V_countI=${countI};  done
    eval APP_MRG_CSV_PARSE_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


eval APP_MRG_CSV_PARSE_A_selfmodSetup
eval INTERNAL_FRAMEWORK_A_funcStart
eval INTERNAL_FRAMEWORK_A_retsReset
repeat 1; do
    repeat 1; do
	if [[ ${argcI} -ne 1 ]]; then
	    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_argL_to_argL_S  curerrI=1;  INTERNAL_FRAMEWORK_A_callSimple
	    errI=2
            print -v errS -f 'argcI != 1: %d;  argL=( %s )' -- \
		  ${argcI}  "${argL_S}";  break;  fi
	STR_L   pathnameS=$1
	calleemodUS=${modUS}  calleeS=F_main  curerrI=3;  INTERNAL_FRAMEWORK_A_callSimple  \${pathnameS}
	print -f 'INFO: %s: writing cache...  ' -- $0
	calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_modCacheWrite  curerrI=4
	INTERNAL_FRAMEWORK_A_callSimple \
	    --module ${modS} \
	    --exclude func ${modUS}_F_main
	print 'DONE'
	okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd;  done
if [[ ${(P)${:-${modUS}_V_errB}} -ne ${B_F} ]]; then
    print -v errS -f 'ERROR: %s; errI=%d' -- \
	  ${(P)${:-${modUS}_V_errS}}  ${(P)${:-${modUS}_V_errI}}
    print -f '%s\n' -- ${errS}
    exit 1;  fi
exit 0
