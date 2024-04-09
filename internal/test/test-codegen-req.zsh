#!/bin/zsh

# MEZX_startup{ v1.3
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
# }MEZX_startup v1.3


modL=( internal/codegen/framework  internal/codegen/req );  INTERNAL_FRAMEWORK_A_loadDependencies
STR_L   modS=test-codegen-req
INTERNAL_FRAMEWORK_A_defStart

INT_L   PREerrI  resultI
STR_L   PREerrS
while true; do
    INTERNAL_CODEGEN_FRAMEWORK_F_stdinCodegen < $0; resultI=$?
    if [[ ${resultI} -ne ${B_T} ]]; then
        PREerrI=30;  print -v PREerrS -f \
            "call to \"%s\" failed; errS=%s  errI=%d" --  INTERNAL_CODEGEN_FRAMEWORK_F_stdinCodegen  ${INTERNAL_CODEGEN_FRAMEWORK_V_errS}  ${INTERNAL_CODEGEN_FRAMEWORK__V_errI}
        break;  fi

    print -f "# GENERATED_CODE{\n"
    print -f "%s\n" -- "${(@)INTERNAL_CODEGEN_FRAMEWORK_V_codeL}"
    print -f "# }GENERATED_CODE\n"
    print ""
    
    INTERNAL_CODEGEN_FRAMEWORK_F_codePrepare; resultI=$?
    if [[ ${resultI} -ne ${B_T} ]]; then
        PREerrI=30;  print -v PREerrS -f \
            "call to \"%s\" failed; errS=%s  errI=%d" --  INTERNAL_CODEGEN_FRAMEWORK_F_codePrepare  ${INTERNAL_CODEGEN_FRAMEWORK_V_errS}  ${INTERNAL_CODEGEN_FRAMEWORK_V_errI}
        break;  fi

    print -f "# PREPARED_CODE{\n"
    print -f "%s\n" -- "${INTERNAL_CODEGEN_FRAMEWORK_V_codeS}"
    print -f "# }PREPARED_CODE\n"
    print ""
    
    #functions | fgrep CODEGEN | fgrep '()'
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

STR_L   selfS=usesStatic
STR_G   ${selfS}_V_errS
INT_G   ${selfS}_V_errI
BOOL_G  ${selfS}_V_errB
STR_G   ${selfS}_V_replyS
INT_G   ${selfS}_V_replyI
BOOL_G  ${selfS}_V_replyB
STR_G   ${selfS}_VS_argProcessorES=
STR_G   ${selfS}_V_firstErrnoI=1
STR_G   ${selfS}_V_baseErrnoI
function ${selfS}() {
    STR_L   selfS=$0
    INT_L   resultI
    BOOL_L  errB=${B_T}
    STR_L   errS
    INT_L   errI=0

    repeat 1; do
        BOOL_G   ${selfS}_V_errB=${B_T}
        if [[ ${#${(P)${:-${selfS}_VS_argProcessorES}}} -eq 0 ]]; then
            INTERNAL_CODEGEN_REQ_F_varReqsE  -p  -X  -I  -M ${(L)selfS}_mod  -V xI  -H PRO \
                -E ${(P)${:-${selfS}_V_firstErrnoI}} \
                -S :is:defined \
                -S flipB:not:defined \
                -S :is:type:EQT:I \
                -S :is:value:RANGE:100..400 \
                -S :is:value:NE:162 \
                -S :is:value:EQ:161 \
                -S zlortI:is:defined \
                -S zlortI:not:value:EQ:777
            INT_G   ${selfS}_V_baseErrnoI=${INTERNAL_CODEGEN_REQ_V_replyI}
            STR_G   ${selfS}_VS_argProcessorES=${INTERNAL_CODEGEN_REQ_V_replyS}; fi
        eval ${(P)${:-${selfS}_VS_argProcessorES}};  resultI=$?
        if [[ ${resultI} -ne 0 ]]; then
            errI=$(( ${(P)${:-${selfS}_V_baseErrnoI}} + 1 ))
            print -v errS -f "arg processor eval failed: %d; argProcesorES=%q" -- \
                ${resultI}  "${(P)${:-${selfS}_VS_argProcessorES}}"
            break;  fi
        errB=${B_F}
        break;  done
    if [[ ${errB} -ne ${B_F} ]]; then
        if [[ ${PROerrI} -ne 0 ]]; then
            errI=$(( ${(P)${:-${selfS}_V_baseErrnoI}} + 2 ))
            print -v errS -f "%s: arg processing failure: errS=%s; errI=%d" --  ${selfS}  ${PROerrS}  ${PROerrI};  fi
        BOOL_G  ${selfS}_V_errB=${errB}
        INT_G   ${selfS}_V_errI=${errI}
        STR_G   ${selfS}_V_errS=${errS}
        return ${B_F}; fi
    return ${B_T}
}


echo "######{"

INT_L   resultI  xI

xI=161
usesStatic; resultI=$?
if [[ ${resultI} -ne ${B_T} ]]; then
    print -f "ERROR: %s: call #0 to \"useStatic\" failed: %d;  errS=%s;  errI=%d\n" -- \
        ${modS}  ${resultI}  ${usesStatic_V_errS}  ${usesStatic_V_errI};  fi

xI=162
usesStatic; resultI=$?
if [[ ${resultI} -ne ${B_T} ]]; then
    print -f "ERROR: %s: call #1 to \"useStatic\" failed: %d;  errS=%s;  errI=%d\n" -- \
        ${modS}  ${resultI}  ${usesStatic_V_errS}  ${usesStatic_V_errI};  fi

xI=161
zlortI=12
usesStatic; resultI=$?
if [[ ${resultI} -ne ${B_T} ]]; then
    print -f "ERROR: %s: call #1 to \"useStatic\" failed: %d;  errS=%s;  errI=%d\n" -- \
        ${modS}  ${resultI}  ${usesStatic_V_errS}  ${usesStatic_V_errI};  fi

echo "}######"


#CODEGEN_EXEC{
    unset TEST_CODEGEN_FRAMEWORK_V_codeL
#}CODEGEN_EXEC


#}CODEGEN_ACTIVE
fi
