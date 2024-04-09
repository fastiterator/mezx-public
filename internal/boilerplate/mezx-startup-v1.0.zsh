# MEZX_startup{ v1.0
typeset +g selfpathS=$0
function {
    typeset +g formatS=
    
    if [[ ${+MEZXDIR} -eq 0 ]]; then  print -f "ERROR: %s:  { MEZXDIR is not defined }" --  ${selfpathS};  exit 1;  fi
    typeset +g pathnameS=${MEZXDIR}/internal/bootstrap.zsh  tmppathbaseS=/tmp/MEZX_startup_$$  resultI
    . ${pathnameS}  >${tmppathbaseS}_out  2>${tmppathbaseS}_err;  resultI=$?
    if [[ ${resultI} -ne 0 ]]; then
	formatS+="ERROR: MEZX_startup:  { failed to bootstrap MEZX;  pathnameS=%s;  resultI=%d;\n"
	formatS+="---- outS start ----\n%s\n---- outS end ----\n\n---- errS start ----\n%s\n---- errS end ----\n}\n"
	print -f ${formatS} --  ${pathnameS}  ${resultI}  "$(cat ${tmppathbaseS}_out)"  "$(cat ${tmppathbaseS}_err)";  fi
    rm -f ${tmppathbaseS}_out ${tmppathbaseS}_err
    if [[ ${resultI} -ne 0 ]]; then  exit 1;  fi
}
# }MEZX_startup
