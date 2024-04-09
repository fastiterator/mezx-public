#!/bin/zsh

# MEZX_startup{ v1.4
typeset +g selfpathS=$0
function {
    typeset +g pathnameS=${MEZXDIR-MEZXDIR_VAR_NOT_DEFINED}/internal/bootstrap.zsh  tmpbaseS=/tmp/${selfpathS:t}.$$
    . ${pathnameS} 1>${tmpbaseS}.out 2>${tmpbaseS}.err
    typeset +g -i resultI=$?  exitI=0
    exec >&0 2>&1
    if [[ ${resultI} -ne 0 ]]; then
	print -f "ERROR: %s (mezx-startup):  { failed to bootstrap MEZX;  pathnameS=%s;  resultI=%d;\n---- outS start ----\n%s\n---- outS end ----\n\n---- errS start ----\n%s\n---- errS end ----\n}\n" -- \
	      ${selfpathS}  ${pathnameS}  ${resultI}  "$(cat ${tmpbaseS}.out)"  "$(cat ${tmpbaseS}.err)"
	exitI=1;  fi
    rm -f ${tmpbaseS}.{out,err}
    if [[ ${exitI} -ne 0 ]]; then exit ${exitI};  fi
}
unset selfpathS
# }MEZX_startup v1.4


# module name & setup

STR_L   modS=lib/fsm
STR_L   modUS=${(U)modS//\//_}
#INTERNAL_FRAMEWORK_A_defStart
LIST_L  modL=(  );  INTERNAL_FRAMEWORK_A_loadDependencies
INTERNAL_FRAMEWORK_A_retsReset


# global constants

STR_G   ${modUS}_CI_char_TAB_S  ${modUS}_CI_char_SP_S
eval 'print -v ${modUS}_CI_char_TAB_S -f "\t"'
eval 'print -v ${modUS}_CI_char_SPC_S -f " "'


# global variables

INT_G  ${modUS}_V_nextidI=1
MAP_G  ${modUS}_V_idM
MAP_G  ${modUS}_V_fsmnameS_idI_M
MAP_G  ${modUS}_V_pathnameS_fsmnameS_M


# aliases

STR_L selfS=${modUS}_A_selfmodSetup
# USAGE
#     <selfS>
#
# NOTE
#     - Since callers in effect have no way of catching errors thrown by this alias,
#       it cannot use "break" to break out beyond its borders.
#
STR_G   ${selfS}_SE='
    STR_L   modS="'${modS}'"  modUS="'${modUS}'";
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L selfS=${modUS}_A_localModCommonvarsCreate
#
# USAGE
#     eval <selfS>
#
STR_G   ${selfS}_SE='
; '
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L selfS=${modUS}_F_validate
#
# USAGE
#     <selfS>  <fsmS>
#
# RETURN
#     on success: ${B_T} in ${modUS}_V_replyB
#     on failure: ${B_F} in ${modUS}_V_replyB
#     on error:
#       - ${B_N} in ${modUS}_V_replyB
#       - ${B_T} in ${modUS}_V_errB
#       - Error text in ${modUS}_V_errS
#
# VALIDITY TESTS
#     - Per FSM: no duplicate state names
#     - Per FSM: contains both INIT and DONE states
#     - Per FSM: any state mentioned in a "go" statememt must exist
#     - Per FSM: all states other than INIT must be referenced at least in at least one "go" statement
#     - Per state: count of each substate type <= 1
#     - Per state: at least one case
#     - Per state: requirement: there must be a default, i.e.  1. has no "if" or has "if NOTHING", and  2. does contain a "go"
#     - Per state: no obviously-unreachable cases allowed (i.e. no cases after default case)
#     - Per case: only keys allowed are:  ( if exec go stop fail )
#
function ${selfS}() {
    return ${B_T}
}


STR_L selfS=${modUS}_F_setup
#
# USAGE
#     <selfS>  <fsmnameS>  <fsmL_varS>
#
# RETURN
#     <fsmnameS> in ${modUS}_V_replyS
#
# SIDE-EFFECT
#     New entry in ${modUS}_V_fsmnameS_idI_M
#     FSM as encoded by <fsmL_varS> in:
#         ${modUS}_V_fsm_<fsmidI>_stateL                               (value: ( statenameS... ) )
#         ${modUS}_V_fsm_<fsmidI>_stateM                               (key: statenameS;  value: stateidI)
#         ${modUS}_V_fsm_<fsmidI>_state_<stateidI>_caseM               (key: casenameS (1..9);  value: caseidI)
#         ${modUS}_V_fsm_<fsmidI>_state_<stateidI>_caseL               (value: ( casenameS... ) )
#         ${modUS}_V_fsm_<fsmidI>_state_<stateidI>_case_<caseidI>_actionL    (value: ( typenameS... ) )
#         ${modUS}_V_fsm_<fsmidI>_state_<stateidI>_case_<caseidI>_actionM    (key: typenameS; value: (appropriate to the type))
#
function ${selfS}(){
    eval LIB_FSM_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   fsmnameS  fsmL_varS
    STR_L   lineS  stateS  caseS  actionS  reS  varnameS  base0S  base1S  base2S  typeS
    STR_L   reBsqSpcTabS="[${(P)${:-${modUS}_CI_char_SPC_S}}${(P)${:-${modUS}_CI_char_TAB_S}}]"
    INT_L   countI  idI=${(P)${:-${modUS}_V_nextidI}}  lineI=1
    BOOL_L  stateB=${B_F}  caseB=${B_F}
    LIST_L  lineL
    LIST_L  stateL  caseL  actionL
    MAP_L   stateM  caseM  actionM
    INT_L   stateI  caseI
 
    repeat 1; do
        calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_retsReset  curerrI=1;  \
	    INTERNAL_FRAMEWORK_A_callSimple  \${modS}
	if [[ ${argcI} -ne 2 ]]; then
	    errI=2
            print -v errS -f 'argcI != 2: %d;  argL=( %s )' -- \
		  ${argcI}  "$(INTERNAL_FRAMEWORK_F_arrayToStrR -P -A -- argL)";  break;  fi
	fsmnameS=$1  fsmL_varS=$2
	if [[ ${#fsmnameS} -eq 0 ]]; then
	    errI=3
            print -v errS -f '"%s" arg is zero length' -- \
		  fsmnameS;  break;  fi
	if [[ -v "${modUS}_V_fsmnameS_idI_M[${fsmnameS}]" ]]; then
	    errI=4
            print -v errS -f 'FSM named by "%s" arg already exists: "%s"' -- \
		  fsmnameS  ${fsmnameS};  break;  fi
	if ! [[ -v ${fsmL_varS} ]]; then
	    errI=5
            print -v errS -f '"%s" arg does not refer to extant var: "%s"' -- \
		  fsmL_varS  ${fsmL_varS};  break;  fi
	if ! [[ ${(tP)fsmL_varS} =~ '^array.*' ]]; then
	    errI=6
            print -v errS -f '*("%s") arg not of type "%s": "%s";  "%s" arg value="%s"' -- \
		  fsmL_varS  array'*'  ${(tP)fsmL_varS}  fsmL_varS  ${fsmL_varS};  break;  fi
        calleemodUS=${modUS}  calleeS=F_validate  curerrI=7;  \
	    INTERNAL_FRAMEWORK_A_callSimple  \${fsmL_varS}
	calleeS=F_setup
 
	for lineI in {1..${(P)#fsmL_varS}}; do
	    eval "lineS=\${${fsmL_varS}[${lineI}]}"
	    lineL=( ${(s/ /)lineS} )
	    if [[ ${#lineL} -eq 0 ]]; then  caseB=${B_F};  continue;  fi
	    if [[ ${lineL[1][1]} = '#' ]]; then  continue;  fi
	    case ${lineL[1]} in
		(state)
		    if [[ ${stateB} -eq ${B_T} ]]; then
			errI=100;  break 2;  fi
		    if [[ ${#lineL} -ne 3 ]]; then
			errI=101;  break 2;  fi
		    if [[ ${lineL[3]} != '{' ]]; then
			errI=102;  break 2;  fi
		    stateS=${lineL[2]}
		    if [[ -v "stateM[${stateS}]" ]]; then
			errI=103;  break 2;  fi
		    stateB=${B_T}
		    stateL+=( ${stateS} )
		    stateM[${stateS}]=${#stateL}
		    caseL=()  caseM=()
		    ;;
		(case)
		    if [[ ${stateB} -ne ${B_T} ]]; then
			errI=104;  break 2;  fi
		    if [[ ${caseB} -eq ${B_T} ]]; then
			errI=105;  break 2;  fi
		    if [[ ${#lineL} -ne 3 ]]; then
			errI=106;  break 2;  fi
		    if [[ ${lineL[3]} != '{' ]]; then
			errI=107;  break 2;  fi
		    caseS=${lineL[2]}
		    if [[ -v "caseM[${caseS}]" ]]; then
			errI=108;  break 2;  fi
		    caseB=${B_T}
		    caseL+=( ${caseS} )
		    caseM[${caseS}]=${#caseL}
		    actionL=()  actionM=()
		    ;;
		(if) ;&
		(exec) ;&
		(go) ;&
		(stop) ;&
		(fail)
		    reS="${reBsqSpcTabS}*${lineL[1]}${reBsqSpcTabS}+(.*)"
		    [[ ${lineS} =~ ${reS} ]]
		    actionS=${lineL[1]}
		    if [[ ${caseB} -ne ${B_T} ]]; then
			errI=109;  break 2;  fi
		    if [[ -v "actionM[${actionS}]" ]]; then
			errI=110;  break 2;  fi
		    if [[ ${actionS} = go  &&  ${#lineL} -ne 2 ]]; then
			errI=111;  break 2;  fi
		    if [[ ${actionS} = stop  &&  ${#lineL} -ne 1 ]]; then
			errI=111;  break 2;  fi
		    actionL+=( ${actionS} )
		    actionM[${actionS}]=${match[1]}
		    ;;
		(\})
		    if [[ ${#lineL} -gt 1 ]]; then
			errI=112;  break 2;  fi
		    if [[ ${caseB} -eq ${B_T} ]]; then
			caseB=${B_F}
			countI=0
			for typeS in go stop fail; do
			    if [[ -v "actionM[${typeS}]" ]]; then
				countI+=1;  fi;  done
			if [[ ${countI} -gt 1 ]]; then
			    errI=113;  break 2;  fi
			eval "LIST_L  state_${#stateL}_case_${#caseL}_actionL=( \${actionL} )"
			eval "MAP_L   state_${#stateL}_case_${#caseL}_actionM=( \${(kv)actionM} )"
			continue;  fi
		    if [[ ${stateB} -eq ${B_T} ]]; then
			stateB=${B_F}
			eval "LIST_L  state_${#stateL}_caseL=( \${caseL} )"
			eval "MAP_L   state_${#stateL}_caseM=( \${(kv)caseM} )"
			continue;  fi
		    errI=114;  break 2
		    ;;
		(*)
		    errI=115;  break 2
		    ;;  esac;  done
 	base0S="${modUS}_V_fsm_${idI}"
	eval "LIST_G  ${base0S}_stateL=( \${stateL} )"
	eval "MAP_G   ${base0S}_stateM=( \${(kv)stateM} )"
	for stateI in {1..${#stateL}}; do
	    base1S="${base0S}_state_${stateI}"
	    varnameS="state_${stateI}_caseM"
	    eval "LIST_G  ${base1S}_caseM=( \${(kvP)varnameS} )"
	    varnameS="state_${stateI}_caseL"
	    eval "LIST_G  ${base1S}_caseL=( \${(P)varnameS} )"
	    for caseI in {1..${(P)#varnameS}}; do
		base2S="${base1S}_case_${caseI}"
		varnameS="state_${stateI}_case_${caseI}"
		eval "LIST_G  ${base2S}_actionL=( \${${varnameS}_actionL} )"
		eval "MAP_G   ${base2S}_actionM=( \${(kv)${varnameS}_actionM} )"
	    done;  done
	eval "${modUS}_V_fsmnameS_idI_M[\${fsmnameS}]=\${idI}"
	eval "${modUS}_V_idM[${idI}]=1"
	replyS=${fsmnameS};  okB=${B_T};  done
    eval LIB_FSM_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


INT_G ${modUS}_V_gffCountI=0
STR_L selfS=${modUS}_F_getFromFile
#
# USAGE
#     <selfS>  <fsmnameS>  [ <pathnameS> ]
#
# SIDE-EFFECT
#     New entry in ${modUS}_V_pathnameS_fsmnameS_M
#
# RETURN
#     On success:
#       - Return value: ${B_T}
#       - ${B_F} in ${modUS}_V_errB
#       - <fsmnameS> in ${modUS}_V_replyS
#     On failure:
#       - Return value: ${B_F}
#       - ${B_T} in ${modUS}_V_errB
#       - Detailed error text in ${modUS}_V_errS
#
function ${selfS}() {
    eval LIB_FSM_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   fsmnameS  pathnameS
    STR_L   realpathS
    LIST_L  fsmtextL
 
    repeat 1; do
        calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_retsReset  curerrI=1;  \
	    INTERNAL_FRAMEWORK_A_callSimple  \${modS}
	if [[ ${argcI} -ne 1  &&  ${argcI} -ne 2 ]]; then
	    errI=2
            print -v errS -f 'argcI not in ( 1 2 ): %d;  argL=( %s )' -- \
		  ${argcI}  "$(INTERNAL_FRAMEWORK_F_arrayToStrR -P -A -- argL)";  break;  fi
	fsmnameS=$1  pathnameS=UNDEF
	if [[ ${argcI} -eq 2 ]]; then
	    pathnameS=$2;  fi
	if [[ ${#fsmnameS} -eq 0 ]]; then
	    errI=3
            print -v errS -f '"%s" arg is zero length' -- \
		  fsmnameS;  break;  fi
	if [[ ${#pathnameS} -eq 0 ]]; then
	    errI=4
            print -v errS -f '"%s" arg is zero length' -- \
		  pathnameS;  break;  fi
	if [[ ${pathnameS} = UNDEF ]]; then
	    print -v realpathS -f "%s/lib/fsm/%s.fsm" -- \
		  ${MEZXDIR}  ${fsmnameS}
	else  realpathS=${pathnameS};  fi
	if ! [[ -f ${realpathS}  &&  -r ${realpathS} ]]; then
	    errI=6
            print -v errS -f 'pathname denoted by args "%s" ("%s") and "%s" ("%s") does not exist or is not readable: "%s"' -- \
		  fsmnameS  ${fsmnameS}  pathnameS  ${pathnameS}  ${realpathS};  break;  fi
	if [[ -v "${modUS}_V_fsmnameS_idI_M[${fsmnameS}]" ]]; then
	    if [[ -v "${modUS}_V_pathnameS_fsmnameS_M[${realpathS}]" ]]; then
		if [[ ${(P)${:-${modUS}_V_pathnameS_fsmnameS_M[${realpathS}]}} = ${fsmnameS} ]]; then
		    replyS=${fsmnameS};  okB=${B_T};  break;  fi;  fi
	    errI=5
            print -v errS -f 'FSM denoted by "%s" arg already instantiated: "%s";  id=%s' -- \
		  fsmnameS  ${fsmnameS}  ${(P)${:-${modUS}_V_pathS_idI_M[${fsmnameS}]}};  break;  fi
        calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_fileReadToList  curerrI=7; \
	    INTERNAL_FRAMEWORK_A_callSimple  \${realpathS}
	fsmtextL=( "${(@)INTERNAL_FRAMEWORK_V_replyL}" )
        calleemodUS=LIB_FSM  calleeS=F_setup  curerrI=8; \
	    INTERNAL_FRAMEWORK_A_callSimple  ${fsmnameS}  fsmtextL
	eval "${modUS}_V_pathnameS_fsmnameS_M[\${realpathS}]=\${fsmnameS}"
	replyS=${fsmnameS};  okB=${B_T};  done
    eval LIB_FSM_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_run
#
# USAGE
#     <selfS>  <fsmnameS>  <startS>
#
# RETURN
#     ${B_T} on success, ${B_F} on failure
#
# NOTE
#     Global variables are typically created or modified by code embedded in FSM states
#
function ${selfS}() {
    eval LIB_FSM_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   fsmnameS  startS
    STR_L   fsmidS  varnameS  varname2S  varname3S  stateS  caseS  actionS  actioninfoS
    STR_L   baseS  basestateS  basecaseS
    INT_L   stateI  caseI  actionI  retI
 
    repeat 1; do
        calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_retsReset  curerrI=1;  \
	    INTERNAL_FRAMEWORK_A_callSimple  \${modS}
	if [[ ${argcI} -ne 2 ]]; then
	    errI=2
            print -v errS -f 'argcI != 2: %d;  argL=( %s )' -- \
		  ${argcI}  "$(INTERNAL_FRAMEWORK_F_arrayToStrR -P -A -- argL)";  break;  fi
	fsmnameS=$1  startS=$2
	if ! [[ -v "${modUS}_V_fsmnameS_idI_M[${fsmnameS}]" ]]; then
	    errI=3
            print -v errS -f '"%s" arg does not refer to known FSM: "%s"' -- \
		  fsmnameS  ${fsmnameS};  break;  fi
	fsmidS=${(P)${:-${modUS}_V_fsmnameS_idI_M[$fsmnameS]}}
	stateS=${startS}
	baseS="LIB_FSM_V_fsm_${fsmidS}"
	if ! [[ -v "${baseS}_stateM[${startS}]" ]]; then
	    errI=4
	    print -v errS -f '"%s" arg refers to nonexistent state for FSM "%s": "%s"' -- \
		  startS  ${fsmnameS}  "${startS}";  break;  fi
	while true; do
	    varnameS="${baseS}_stateM[${stateS}]"
	    stateI=${(P)varnameS}
	    basestateS="${baseS}_state_${stateI}"
	    varnameS="${basestateS}_caseL"
	    for caseI in {1..${(P)#varnameS}}; do
		varnameS="${basestateS}_caseL[${caseI}]"
		caseS="${(P)varnameS}"
		basecaseS="${basestateS}_case_${caseI}"
		varnameS="${basecaseS}_actionL"
		for actionI in {1..${(P)#varnameS}}; do
		    varname2S="${varnameS}[${actionI}]"
		    actionS="${(P)varname2S}"
		    varname3S="${basecaseS}_actionM[${actionS}]"
		    actioninfoS="${(P)varname3S}"
		    case ${actionS} in
			(if)
			    eval "retI=1;  if [[ ${actioninfoS} ]]; then  retI=0;  fi"
			    if [[ ${retI} -ne 0 ]]; then
				break;  fi ;;
			(exec)
			    eval "${actioninfoS}"
			    continue  ;;
			(go)
			    if ! [[ -v "${baseS}_stateM[${actioninfoS}]" ]]; then
				errI=99
				print -v errS -f \
				  'unknown state in "%s" action: "%s"; stateS="%s"  caseS="%s"' -- \
				  ${actionS}  ${actioninfoS}  ${stateS}  ${caseS};  break 4;  fi
			    stateS=${actioninfoS}
			    break 2 ;;
			(stop)
			    break 3 ;;
			(fail)
			    errI=99
			    print -v errS -f \
				  'failed with "%s";  stateS="%s"  caseS="%s"' -- \
				  "${actioninfoS}"  ${stateS}  ${caseS};  break 4 ;;
			(*)
			    errI=99
			    print -v errS -f \
				  'unknown action: "%s"; stateS="%s"  caseS="%s"' -- \
				  ${actionS}  ${stateS}  ${caseS};  break 4  ;;  esac
		done
	    done
	done
	okB=${B_T};  done
    eval LIB_FSM_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


INTERNAL_FRAMEWORK_F_modCacheWrite \
    --module ${modS}
#INTERNAL_FRAMEWORK_A_defEnd
