# MEZX_startup{ v1.2
typeset +g selfpathS=$0
function {
    typeset +g -i  resultI
    typeset +g     pathnameS=${MEZXDIR-MEZXDIR_VAR_NOT_DEFINED}/internal/bootstrap.zsh  tmpbaseS=/tmp/${selfpathS:t}.$$
    . ${pathnameS} 1>${tmpbaseS}.out 2>${tmpbaseS}.err;  resultI=$?
    if [[ ${resultI} -ne 0 ]]; then
	print -f "ERROR: %s (mezx-startup): { failed to bootstrap MEZX;  pathnameS=%s;  resultI=%d;\n---- outS start ----\n%s\n---- outS end ----\n\n---- errS start ----\n%s\n---- errS end ----\n }\n" -- \
	      ${selfpathS}  ${pathnameS}  ${resultI}  "$(cat ${tmpbaseS}.out)"  "$(cat ${tmpbaseS}.err)"
	rm -f ${tmpbaseS}.out ${tmpbaseS}.err;  exit 1;  fi
}
# }MEZX_startup v1.2
