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


LIST_L  modL=( internal/rex  lib/fsm  lib/csv );  INTERNAL_FRAMEWORK_A_loadDependencies
STR_L   modS=app/ebay_csv_parse2
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
    eval APP_EBAY_CSV_PARSE2_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   pathnameS  headerS  lineS  platformidS  nameS  patternS  outputS  varnameS
    INT_L   subnumI
    LIST_L  requiredfieldL
 
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
	requiredfieldL=( order-number )
	calleemodUS=LIB_CSV calleeS=F_headerAuto curerrI=5; \
	    INTERNAL_FRAMEWORK_A_callSimple  excel  target  \${headerS}  requiredfieldL
	print -f 'INFO: %s: processing records... ' -- $0
	INT_L   termI=0  countI=0
	tail +2 ${pathnameS} | while read -r lineS; do
	    lineS=${lineS/\/}
	    calleemodUS=LIB_CSV calleeS=F_extract curerrI=7;  \
		INTERNAL_FRAMEWORK_A_callSimple  target  \${lineS}
	    platformidS=${LIB_CSV_V_replyM[order-number]}
	    platformidS=${platformidS//-/_}
	    LIB_CSV_V_replyM[order-number]=${platformidS}
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
    eval APP_EBAY_CSV_PARSE2_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


eval APP_EBAY_CSV_PARSE2_A_selfmodSetup
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
	calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_modCacheWrite  curerrI=4
	INTERNAL_FRAMEWORK_A_callSimple \
	    --module ${modS} \
	    --tag $$ \
	    --exclude func ${modUS}_F_main
	okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd;  done
if [[ ${(P)${:-${modUS}_V_errB}} -ne ${B_F} ]]; then
    print -v errS -f 'ERROR: %s; errI=%d' -- \
	  ${(P)${:-${modUS}_V_errS}}  ${(P)${:-${modUS}_V_errI}}
    print -f '%s\n' -- ${errS}
    exit 1;  fi
exit 0
