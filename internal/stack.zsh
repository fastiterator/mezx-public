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


# module name & setup

STR_L   modS=internal/stack
STR_L   modUS=${(U)modS//\//_}
#INTERNAL_FRAMEWORK_A_defStart
LIST_L  modL=( internal/rex codegen/req )


# usage: ..._F_push <stacknameS> <valueS>
function ${modUS}_F_push() {
    INTERNAL_FRAMEWORK_A_localErrvarsCreate;  errB=${B_T}
    repeat 1; do
	if [[ $# -ne 2 ]]; then
	    errI=1;  print -v errS -f "invalid arg count: %d; required: 2" --  $#;  break;  fi
	stacknameS=$1  valueS=$2
	if ! [[ ${stacknameS} =~ ${reIdentifierA_S} ]]; then
	    errI=2;  print -v errS -f "\"%s\" arg must match \"%s\" regex (%s): %s" -- \
                stacknameS  reIdentifierA_S  ${reIdentifierA_S}  ${stacknameS};  break;  fi
	if [[ ${+${stacknameS}} -eq 0 ]]; then
	    errI=3;  print -v errS -f "var referenced by \"%s\" arg does not exist: %s" -- \
                stacknameS  ${stacknameS};  break;  fi
	case ${(tP)+${stacknameS}} in
	    (array*) ;;
	    (*)
		errI=4;  print -v errS -f "var referenced by \"%s\" arg is not of array* type: %s;  type=%s" -- \
	            stacknameS  ${stacknameS}  ${(tP)+${stacknameS}};  break  ;;   esac
	eval "${stacknameS}+=( \${valueS} ); "
    done
}


repeat 1; do
    INTERNAL_FRAMEWORK_A_localErrvarsCreate;  errB=${B_T}
    INTERNAL_FRAMEWORK_A_loadDependencies
    INTERNAL_FRAMEWORK_A_retsReset
    errB=${B_F};  done
if [[ ${errB} -eq ${B_T} ]]; then
    print -f "ERROR: %s:  { %s;  errI=%d }\n" --  ${modUS}  ${errS}  ${errI};  exit 1;  fi
#INTERNAL_FRAMEWORK_A_defEnd



    INTERNAL_FRAMEWORK_F_modCacheWrite \
	--module ${modS}
    if [[ ${INTERNAL_FRAMEWORK_V_errB} -eq ${B_T} ]]; then
	errI=1;  print -v errS -f "call to \"%s\" failed:  { %s;  errI=%d }" --  \
            INTERNAL_FRAMEWORK_F_modCacheWrite  ${INTERNAL_FRAMEWORK_V_errS}  ${INTERNAL_FRAMEWORK_V_errI};  break;  fi
