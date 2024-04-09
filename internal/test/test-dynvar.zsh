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


LIST_L  modL=( internal/dynvar );  INTERNAL_FRAMEWORK_A_loadDependencies
STR_L   modS=test_dynvar
STR_L   modUS=${(U)modS//\//_}
STR_L   parentmodS=internal/dynvar
STR_L   parentmodUS=${(U)parentmodS//\//_}
INTERNAL_FRAMEWORK_A_defStart


STR_L   selfS=${modUS}_A_selfmodSetup
alias ${selfS}='
    STR_L   modS="'${modS}'"  modUS="'${modUS}'"  parentmodS="'${parentmodS}'"  parentmodUS="'${parentmodUS}'";
    print "'${modUS}': ENTRY to $0";
'


alias ${modUS}_A_funcEnd='
    if (( ${'${parentmodUS}'_V_errB} == ${B_T} )); then ;
        print -f "ERROR: '${parentmodUS}'_V_errS=%s;  '${parentmodUS}'_V_errI=%d\n" --  ${'${parentmodUS}'_V_errS}  ${'${parentmodUS}'_V_errI}; fi;
    '${modUS}_F_dynshow';  print "";
    STR_L   modS='${parentmodS}';  INTERNAL_FRAMEWORK_A_retsReset;
'


function ${modUS}_F_dynshow() {
    eval TEST_DYNVAR_A_selfmodSetup
    STR_L   xtypeS  typeS
    case $# in
	(0)  typeS=INT   ;;
	(1)  typeS="$1"  ;;
	(*)
	    print -f "ERROR: %s: invalid arg count: %d;  required: 0-1" --  $#
	    exit 1;  esac
    case "${typeS}" in
	(BOOL) ;;  (INT) ;;  (STR) ;;  (FLOATF) ;;  (FLOATE) ;;  (LIST) ;;  (MAP) ;;  (ANY) ;;
        (*)
	    print -f "ERROR: %s: bad typeS value: \"%s\"\n" --  $0  "${typeS}"
	    exit 1;  esac
    if [[ "${typeS}" = ANY ]]; then  xtypeS=;  else  print -v xtypeS -f "_%s_" --  "${typeS}";  fi
    print -- "\n---- DYNVAR{ ----"
    set | egrep "^${parentmodUS}_V.*_(BOOL|INT|STR|FLOATF|FLOATE|LIST|MAP)_.*" | fgrep "${xtypeS}"
    print -- "---- }DYNVAR ----"
}


INT_G   ${modUS}_V_refI
function ${modUS}_F_allocINT() {
    eval TEST_DYNVAR_A_selfmodSetup
    INTERNAL_FRAMEWORK_A_localErrvarsCreate
    STR_L   varnameS
    
    INTERNAL_DYNVAR_F_allocINT
    eval ${modUS}_V_refI=${INTERNAL_DYNVAR_V_replyI}
    varnameS=${parentmodUS}_V_replyS
    eval ${(P)varnameS}=${RANDOM}
    eval ${modUS}_A_funcEnd
}


function ${modUS}_F_freeINT() {
    eval TEST_DYNVAR_A_selfmodSetup
    INTERNAL_FRAMEWORK_A_localErrvarsCreate
    STR_L   varnameS
    
    INTERNAL_DYNVAR_F_freeINT $1
    eval ${modUS}_A_funcEnd
}


function ${modUS}_F_allocfreeINT() {
    eval TEST_DYNVAR_A_selfmodSetup
    INTERNAL_FRAMEWORK_A_localErrvarsCreate
    STR_L   varnameS
    INT_L   refI
    
    eval ${modUS}_F_dynshow
    INTERNAL_DYNVAR_F_allocINT
    varnameS=${INTERNAL_DYNVAR_V_replyS}
    refI=${INTERNAL_DYNVAR_V_replyI}
    eval ${modUS}_F_dynshow
    eval ${varnameS}=${RANDOM}
    eval ${modUS}_F_dynshow
    INTERNAL_DYNVAR_F_freeINT ${refI}
    
    eval ${modUS}_A_funcEnd
}


function ${modUS}_F_freelistTest() {
    eval TEST_DYNVAR_A_selfmodSetup
    INTERNAL_FRAMEWORK_A_localErrvarsCreate
    LIST_L  varnameS_L
    LIST_L  refI_L
    INT_L   countI

    eval ${modUS}_F_dynshow
    for countI in {1..4};  do
	INTERNAL_DYNVAR_F_allocINT
	varnameS_L+=( ${INTERNAL_DYNVAR_V_replyS} )
	refI_L+=( ${INTERNAL_DYNVAR_V_replyI} );
	eval ${varnameS_L[-1]}=${RANDOM};  done
    eval ${modUS}_F_dynshow
    for countI in {1..4};  do
	INTERNAL_DYNVAR_F_freeINT ${refI_L[${countI}]}
	eval ${modUS}_F_dynshow;  done
    eval ${modUS}_A_funcEnd
}


function ${modUS}_F_allocLISTx3() {
    eval TEST_DYNVAR_A_selfmodSetup
    INTERNAL_FRAMEWORK_A_localErrvarsCreate
    LIST_L  varnameS_L
    LIST_L  refI_L
    INT_L   countI  c2I

    eval ${modUS}_F_dynshow LIST
    for countI in {1..5};  do
        INTERNAL_DYNVAR_F_allocLIST
        varnameS_L+=( ${INTERNAL_DYNVAR_V_replyS} )
        refI_L+=( ${INTERNAL_DYNVAR_V_replyI} );
	for c2I in {1..$(( ${RANDOM} % 12 ))}; do
	    eval "${varnameS_L[-1]}+=( \"random: ${RANDOM}\" ); ";  done
	eval ${modUS}_F_dynshow LIST;  done
    for countI in {5..1..-1};  do
	INTERNAL_DYNVAR_F_freeLIST ${refI_L[${countI}]}; done
    eval ${modUS}_F_dynshow LIST
    return ${B_T}
}


function ${modUS}_F_main() {
    eval TEST_DYNVAR_A_selfmodSetup
    INTERNAL_FRAMEWORK_A_localErrvarsCreate
    ${modUS}_F_allocINT
    eval ${modUS}_F_freeINT \${${modUS}_V_refI}
    ${modUS}_F_allocfreeINT
    ${modUS}_F_freelistTest
    ${modUS}_F_allocLISTx3
}


${modUS}_F_main
INTERNAL_FRAMEWORK_A_defEnd
