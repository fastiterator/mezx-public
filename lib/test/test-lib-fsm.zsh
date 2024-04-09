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


LIST_L  modL=( lib/fsm );  INTERNAL_FRAMEWORK_A_loadDependencies
STR_L   modS=test/lib/fsm
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
#     <selfS>  <fsmfileS>
#
function ${selfS}() {
    eval TEST_LIB_FSM_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
 
    repeat 1; do
        calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_retsReset  curerrI=1; INTERNAL_FRAMEWORK_A_callSimple  \${modS}
	if [[ ${argcI} -ne 1 ]]; then
	    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_argL_to_argL_S  curerrI=1;  INTERNAL_FRAMEWORK_A_callSimple
	    errI=2
            print -v errS -f 'argcI != 1: %d;  argL=( %s )' -- \
		  ${argcI}  "${argL_S}";  break;  fi
	STR_L   fsmfileS=$1
	if ! [[ -f ${fsmfileS}  &&  -r ${fsmfileS} ]]; then
	    errI=3
	    print -v errS -f '"%s" arg does not refer to extant/readable file: "%s"' -- \
		  fsmfileS  "${fsmfileS}";  break;  fi
	cat ${fsmfileS} | while read -r sS; do
	    sS=${sS/\/}
	    fsmtextL+=( ${sS} );  done
        calleemodUS=LIB_FSM  calleeS=F_setup  curerrI=2; INTERNAL_FRAMEWORK_A_callSimple  fsmtextL
	fsmidS=${LIB_FSM_V_replyS}
	# set | egrep '^LIB_FSM_'
	for lineS in  'a,b,c'  '  a  ,b'  ' "axe"  , biff ,zap'  '"fiffle zippy foo"   , forf, '  'z,b,  k  ,' \
			       ''  'xyz pqr  zap ,flip'  ' flip , zip""zoop,'  'zip,he said his name was "hello" but no' \
			       'zip, "is the way we ""help"" each other" , niffle'  '' \
			       '"abc","def","ghi"' \
			       '"Lens","Inventory #","Title","Ready for Pictures","Pictures Taken","Listing Made","Maker","Model / Series","Serial #","Mount (CFD/KAR/...)","Type (Prime/Zoom)","Aperture (min)","Aperture (max)","Aperture (minmax)","Focal Length (lesser)","Focal Length (greater)","Focus","Weight w/caps (g)","Weight in case (g)","Filter  Diameter (mm)","Close Focus (cm) ","Elements/ Groups","Condition","Notes (e.g.:) - dust specks / haze / fungus - scratches / damage - focus smoothness / tightness - aperture blade activity / sluggishness"' \
		      ; do
	    print -f '%s: INFO: lineS="%s"\n' -- \
		  ${selfS}  ${lineS}
            calleemodUS=LIB_FSM  calleeS=F_run  curerrI=3; INTERNAL_FRAMEWORK_A_callSimple  ${fsmidS}  init
	    print -f "%s: INFO: LIB_FSM_V_replyL=( %s )\n" -- \
		  ${selfS}  "$(INTERNAL_FRAMEWORK_F_arrayToStrR -P -A --  LIB_FSM_V_replyL)"; done
	okB=${B_T};  done
    eval TEST_LIB_FSM_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


eval TEST_LIB_FSM_A_selfmodSetup
eval INTERNAL_FRAMEWORK_A_funcStart
repeat 1; do
    repeat 1; do
	if [[ ${argcI} -ne 1 ]]; then
	    calleemodUS=INTERNAL_FRAMEWORK  calleeS=A_argL_to_argL_S  curerrI=1;  INTERNAL_FRAMEWORK_A_callSimple
	    errI=2
            print -v errS -f 'argcI != 1: %d;  argL=( %s )' -- \
		  ${argcI}  "${argL_S}";  break;  fi
	STR_L   fsmfileS=$1
	calleemodUS=${modUS}  calleeS=F_main  curerrI=1;  INTERNAL_FRAMEWORK_A_callSimple  "${fsmfileS}"
	okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd;  done
if [[ ${TEST_LIB_FSM_V_errB} -ne ${B_F} ]]; then
    print -v errS -f 'ERROR: %s; errI=%d' -- \
	  ${TEST_LIB_FSM_V_errS}  ${TEST_LIB_FSM_V_errI}
    print -f '%s\n' -- ${errS}
    exit 1;  fi
exit 0
