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


LIST_L  modL=( internal/rex );  INTERNAL_FRAMEWORK_A_loadDependencies
STR_L   modS=test/rex
STR_L   modUS=${(U)modS//\//_}
INTERNAL_FRAMEWORK_A_defStart


STR_L   selfS=${modUS}_A_selfmodSetup
alias ${selfS}='
    STR_L   modS="'${modS}'"  modUS="'${modUS}'";
'




INTERNAL_FRAMEWORK_A_defEnd
print -- "---- vars (start) ----"
set | sed 's/=.*$//' | fgrep INTERNAL_REX
print -- "---- vars (end) ----"
print ""
print -- "---- aliases (start) ----"
alias | sed 's/=.*$//' | fgrep INTERNAL_REX
print -- "---- aliases (end) ----"
