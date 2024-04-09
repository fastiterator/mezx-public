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
STR_L   modS=test/lib/csv
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


STR_L   selfS=${modUS}_F_main
#
# USAGE
#     <selfS>  <fileS>
#
function ${selfS}() {
    eval TEST_LIB_CSV_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    LIST_L  nameS_patternS_outputS_L=(
	'id'		'^Invent'			'Inventory#'
	'title'		'^Title'			'Title'
	'notes'		'^Notes'			'Notes'
	'maker'		'^Maker'			'Maker'
	'model'		'^Model'			'Model'
	'condition'     '^Condition'			'Condition'
	'serial'	'^Serial'			'Serial#'
	'mount'		'^Mount'			'Mount'
	'type'		'^Type'				'Type'
	'ap-max'	'^Aperture [(]min[)]'		'Max Aperture (f)'
	'ap-min'	'^Aperture [(]max[)]'		'Min Aperture (f)'
	'ap-maxzoom'	'^Aperture [(]minmax[)]'	'Max Aperture @ Max Focal Length (f)'
	'fl-min'	'[(]lesser[)]'			'Min Focal Length (mm)'
	'fl-max'	'[(]greater[)]'			'Max Focal Length (mm)'
	'foc-type'	'^Focus'			'Focus Type'
	'filt-size'	'^Filter'			'Filter Diameter (mm)'
	'mass-w-caps'	'^Weight w/caps'		'Weight w/ caps (g)'
	'mass-w-case'	'^Weight in case'		'Weight w/ case (g)'
	'dist-close'	'^Close Focus'			'Close Focus Distance (cm)'
	'pictures'	'^Pictures'			'Pix Available'
	'ready'		'^Ready'			'Ready for pictures'
	'listing'	'^Listing'			'Listing Made'
    )
    STR_L   fileS  headerS  lineS  nameS  patternS  outputS
    BOOL_L  firstB
 
    repeat 1; do
	if [[ ${argcI} -ne 1 ]]; then
	    curerrI=2;  calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_argL_to_argL_S  curerrI=1;  INTERNAL_FRAMEWORK_A_callSimple
	    errI=1
            print -v errS -f 'argcI != 1: %d;  argL=( %s )' -- \
		  ${argcI}  "${argL_S}";  break;  fi
	fileS=$1
	if ! [[ -f ${fileS}  &&  -r ${fileS} ]]; then
	    errI=3
            print -v errS -f '"%s" arg value does not refer to extant/readable file: "%s"' -- \
		  fileS  "${fileS}";  break;  fi
	head -1 ${fileS} | read -r headerS
	headerS=${headerS/\/}
	calleemodUS=LIB_CSV calleeS=F_setup curerrI=5; \
	    INTERNAL_FRAMEWORK_A_callSimple  excel  test  nameS_patternS_outputS_L  \${headerS}
	tail +2 ${fileS} | while read -r lineS; do
	    lineS=${lineS/\/}
	    calleemodUS=LIB_CSV calleeS=F_extract curerrI=6;  \
		INTERNAL_FRAMEWORK_A_callSimple  test  \${lineS}
	    if [[ ${LIB_CSV_V_replyM[ready]} = y  &&  ${LIB_CSV_V_replyM[listing]} != y ]]; then
		if [[ ${firstB} -eq ${B_F} ]]; then  print "";  fi
		firstB=${B_F}
		for  nameS patternS outputS  in  ${nameS_patternS_outputS_L}; do
		    if [[ ${nameS} = pictures  ||  ${nameS} = listing ]]; then  continue;  fi
		    if [[ ${LIB_CSV_V_replyM[${nameS}]} = ''  ||  ${LIB_CSV_V_replyM[${nameS}]} = '-' ]]; then  continue;  fi
		    print -f '%s: %s\n' -- \
			  ${outputS}  ${LIB_CSV_V_replyM[${nameS}]};  done;  fi;  done
	okB=${B_T};  done
    eval TEST_LIB_CSV_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


eval TEST_LIB_CSV_A_selfmodSetup
eval INTERNAL_FRAMEWORK_A_funcStart
eval INTERNAL_FRAMEWORK_A_retsReset
repeat 1; do
    repeat 1; do
	if [[ ${argcI} -ne 1 ]]; then
	    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_argL_to_argL_S  curerrI=1;  INTERNAL_FRAMEWORK_A_callSimple
	    errI=2
            print -v errS -f 'argcI != 1: %d;  argL=( %s )' -- \
		  ${argcI}  "${argL_S}";  break;  fi
	STR_L   fileS=$1
	calleemodUS=${modUS}  calleeS=F_main  curerrI=1;  INTERNAL_FRAMEWORK_A_callSimple  \${fileS}
	okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd;  done
if [[ ${TEST_LIB_CSV_V_errB} -ne ${B_F} ]]; then
    print -v errS -f 'ERROR: %s; errI=%d' -- \
	  ${TEST_LIB_CSV_V_errS}  ${TEST_LIB_CSV_V_errI}
    print -f '%s\n' -- ${errS}
    exit 1;  fi
exit 0
