# MEZX_startup{ v1.1
typeset +g selfpathS=$0
function {
    typeset -g -i  B_T=0  B_F=1  B_N=2
    typeset +g     pathnameS  tmppathbaseS  formatS  errS
    typeset +g -i  resultI  errI
    typeset +g -i  pidI=$$  errB=${B_T}
    
    while true; do
	if [[ ${+MEZXDIR} -eq 0 ]]; then
	    errI=1;  print -v errS -f "MEZXDIR var not defined" --  ${selfpathS};  break;  fi
	pathnameS=${MEZXDIR}/internal/bootstrap.zsh  tmppathbaseS=/tmp/MEZX_startup_${pidI}
	if ! [[ -f ${pathnameS} ]]; then
	    errI=2;  print -v errS -f "MEZX bootstrap file does not exist: %s;  MEZXDIR=%s" -- \
                ${pathnameS}  ${MEZXDIR};  break;  fi
	. ${pathnameS}  >${tmppathbaseS}_out  2>${tmppathbaseS}_err;  resultI=$?
	if [[ ${resultI} -ne 0 ]]; then
	    errI=3;  formatS="failed to bootstrap MEZX;  pathnameS=%s;  resultI=%d;\n"
	    formatS+="---- outS start ----\n%s\n---- outS end ----\n\n---- errS start ----\n%s\n---- errS end ----\n}\n"
	    print -v errS -f ${formatS} --  ${pathnameS}  ${resultI}  "$(cat ${tmppathbaseS}_out)"  "$(cat ${tmppathbaseS}_err)";  break;  fi
	errB=${B_F};  break;  done
    rm -f ${tmppathbaseS}_out ${tmppathbaseS}_err
    if [[ ${errB} -ne ${B_F} ]]; then
	print -f "ERROR: %s (mezx-startup): { %s;  errI=%d }\n" --  ${selfpathS}  ${errS}  ${errI}
	exit 1;  fi
}
# }MEZX_startup v1.1
