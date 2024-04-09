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


modL=( internal/codegen/framework );  INTERNAL_FRAMEWORK_A_loadDependencies
STR_L   modS=test-codegen-framework
INTERNAL_FRAMEWORK_A_defStart

INT_L   PREerrI  resultI
STR_L   PREerrS
while true; do
    INTERNAL_CODEGEN_FRAMEWORK_F_stdinCodegen < $0; resultI=$?
    if [[ ${resultI} -ne ${B_T} ]]; then
        PREerrI=30
	print -v PREerrS -f \
	      "call to \"%s\" failed; errS=%s  errI=%d" -- \
	      INTERNAL_CODEGEN_FRAMEWORK_F_stdinCodegen  ${INTERNAL_CODEGEN_FRAMEWORK_V_errS}  ${INTERNAL_CODEGEN_FRAMEWORK__V_errI}
        break;  fi
 
    print -f "# GENERATED_CODE{\n"
    print -f "%s\n" -- "${(@)INTERNAL_CODEGEN_FRAMEWORK_V_codeL}"
    print -f "# }GENERATED_CODE\n"
    print ""
 
    INTERNAL_CODEGEN_FRAMEWORK_F_codePrepare; resultI=$?
    if [[ ${resultI} -ne ${B_T} ]]; then
        PREerrI=30
	print -v PREerrS -f \
              "call to \"%s\" failed; errS=%s  errI=%d" -- \
	      INTERNAL_CODEGEN_FRAMEWORK_F_codePrepare  ${INTERNAL_CODEGEN_FRAMEWORK_V_errS}  ${INTERNAL_CODEGEN_FRAMEWORK_V_errI}
        break;  fi

    print -f "# PREPARED_CODE{\n"
    print -f "%s\n" -- "${INTERNAL_CODEGEN_FRAMEWORK_V_codeS}"
    print -f "# }PREPARED_CODE\n"
    print ""
 
    print -f "# EXECUTED_CODE{\n"
    INTERNAL_CODEGEN_FRAMEWORK_A_codeExec
    print -f "# }EXECUTED_CODE\n"
    print ""
 
    break; done

if [[ ${PREerrI} -ne 0 ]]; then
    print -f "%s: %s; errI=%d\n" --  ${(U)modS}  ${PREerrS}  ${PREerrI}; fi

INTERNAL_FRAMEWORK_A_defEnd


if false; then
#CODEGEN_ACTIVE{

#CODEGEN_EXEC{
    LIST_G  TEST_CODEGEN_FRAMEWORK_V_codeL
    TEST_CODEGEN_FRAMEWORK_V_codeL=()

    function makething() {
        INT_L iI
        STR_L sS=
        INT_L fromI=$1 toI=$2
 
        for iI in {${fromI}..${toI}}; do
            print -v sS -f "xI+=%d" -- ${iI}
            TEST_CODEGEN_FRAMEWORK_V_codeL+=( ${sS} )
        done
    }
#}CODEGEN_EXEC



function hascompiledparts() {
    #CODEGEN_EXEC{
        INT_L indexI  nextErrnoI
        STR_L thingS  sS
 
        for thingS in a b c d e f; do
            for indexI in {1..10}; do
                print -v sS -f "INT_L %s%s%s%d=%d" -- ${thingS}  ${thingS}  ${thingS}  ${indexI}  ${indexI}
                INTERNAL_CODEGEN_FRAMEWORK_F_codeStrAdd ${sS};  done;  done
    #}CODEGEN_EXEC

    INT_L   PREerrI
    STR_L   PREerrS
    INT_L   xI=6  zlortI=555
    while true; do
        #CODEGEN_EXEC{
            makething 11 20
            INTERNAL_CODEGEN_FRAMEWORK_F_codeListAdd TEST_CODEGEN_FRAMEWORK_V_codeL
        #}CODEGEN_EXEC
 
        break; done
    if [[ ${PREerrI} -ne 0 ]]; then
        print -f "ERROR: %s: PREerrI=%d;  PREerrS=%s\n" --  $0  ${PREerrI}  ${PREerrS}
        return ${B_F}; fi
    return ${B_T}
}


echo "######{"

INT_L   resultI  xI
hascompiledparts; resultI=$?
if [[ ${resultI} -ne ${B_T} ]]; then
    print -f "ERROR: %s: call to \"hascompiledparts\" failed: %d\n" --  ${modS} ${resultI};  fi

echo "}######"


#CODEGEN_EXEC{
    unset -f makething
    unset TEST_CODEGEN_FRAMEWORK_V_codeL
#}CODEGEN_EXEC


#}CODEGEN_ACTIVE
fi
