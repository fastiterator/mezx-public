#!/bin/zsh

# USAGE
#     <self> fileS


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


LIST_L  modL=( lib/tsv );  INTERNAL_FRAMEWORK_A_loadDependencies
STR_L   modS=app/lens/show
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


STR_L   selfS=${modUS}_A_localCommonvarsCreate
#
# USAGE
#     eval <selfS>
#
STR_G   ${selfS}_SE='
    INT_L   argcReqI;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_G   selfS=${modUS}_F_unlistedExtract
#
# USAGE
#     ${selfS}  <fileS>
#
# RETURN
#     ${B_T}
#
# PERFORM
#     Print data for each lens for which pictures are available, but which has not yet been listed
#
function ${selfS}() {
    eval APP_LENS_SHOW_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   fileS  nameS  patternS  outputS  varnameS  headerS  lineS  idS
    BOOL_L  firstB=${B_T}
    STR_L   kS  vS
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
 
    repeat 1; do
        calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_retsReset  curerrI=1; INTERNAL_FRAMEWORK_A_callSimple  \${modS}
	if [[ ${argcI} -ne 1 ]]; then
	    curerrI=2;  calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_argL_to_argL_S  curerrI=1;  INTERNAL_FRAMEWORK_A_callSimple
	    errI=3
            print -v errS -f 'argcI != 1: %d;  argL=( %s )' -- \
		  ${argcI}  "${argL_S}";  break;  fi
	fileS=$1
	if ! [[ -r "${fileS}" ]]; then
	    errI=4
            print -v errS -f '"%s" arg does not refer to extant, readable file: "%s"' -- \
		  fileS  "${fileS}";  break;  fi
	head -1 ${fileS} | read -r headerS
	headerS=${headerS/\/}
	calleemodUS=LIB_TSV calleeS=F_setup curerrI=5;  INTERNAL_FRAMEWORK_A_callSimple  nameS_patternS_outputS_L  \${headerS}
	idS=${LIB_TSV_V_replyS}
	tail +2 ${fileS} | while read -r lineS; do
	    lineS=${lineS/\/}
	    calleemodUS=LIB_TSV calleeS=F_extract curerrI=6;  INTERNAL_FRAMEWORK_A_callSimple  \${idS}  \${lineS}
	    if [[ ${LIB_TSV_V_replyM[ready]} = y  &&  ${LIB_TSV_V_replyM[listing]} != y ]]; then
		if [[ ${firstB} -eq ${B_F} ]]; then  print "";  fi
		firstB=${B_F}
		for  nameS patternS outputS  in  ${nameS_patternS_outputS_L}; do
		    if [[ ${nameS} = pictures  ||  ${nameS} = listing ]]; then  continue;  fi
		    if [[ ${LIB_TSV_V_replyM[${nameS}]} = ''  ||  ${LIB_TSV_V_replyM[${nameS}]} = '-' ]]; then  continue;  fi
		    print -f '%s: %s\n' -- \
			  ${outputS}  ${LIB_TSV_V_replyM[${nameS}]};  done;  fi;  done
	okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


eval APP_LENS_SHOW_A_selfmodSetup
eval INTERNAL_FRAMEWORK_A_funcStart
eval INTERNAL_FRAMEWORK_A_retsReset
repeat 1; do
    repeat 1; do
	if [[ ${argcI} -ne 1 ]]; then
	    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_argL_to_argL_S  curerrI=1;  INTERNAL_FRAMEWORK_A_callSimple
	    errI=2
            print -v errS -f 'argcI != 1: %d;  argL=( %s )' -- \
		  ${argcI}  "${argL_S}";  break;  fi
	calleemodUS=${modUS}  calleeS=F_unlistedExtract  curerrI=1;  INTERNAL_FRAMEWORK_A_callSimple \$1
	okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd;  done
if [[ ${APP_LENS_SHOW_V_errB} -ne ${B_F} ]]; then
    print -v errS -f 'ERROR: %s; errI=%d' -- \
	  ${APP_LENS_SHOW_V_errS}  ${APP_LENS_SHOW_V_errI}
    print -f '%s\n' -- ${errS}
    exit 1;  fi
exit 0
