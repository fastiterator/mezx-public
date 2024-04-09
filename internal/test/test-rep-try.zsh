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


LIST_L  modL=( internal/rep internal/try );  INTERNAL_FRAMEWORK_A_loadDependencies
STR_L   modS=test_rep_try
STR_L   modUS=${(U)modS//\//_}
zmodload zsh/stat
#INTERNAL_FRAMEWORK_A_defStart



STR_L   selfS=${modUS}_A_selfmodSetup
alias ${selfS}='
    STR_L   modS="'${modS}'"  modUS="'${modUS}'";
'
unset selfS


# usage: set <errI> <printspecS>  [ <psArg1> ... <psArgN> ];  ..._A_errorThrow
STR_L   selfS=${modUS}_A_errorThrow
alias ${selfS}='
    errB=${B_T};
    if [[ $# -lt 2 ]]; then  ;
        errI=1;  print -v errS -f "%s: invalid arg count: %d; required: 2+; seen while processing: ( %s )" -- \
             "'${selfS}'"  $#  "$*";
    elif ! [[ $1 =~ "[1-9][0-9]*" ]]; then  ;
        errI=2;  print -v errS -f "%s: invalid errI arg content: %s; must match regex: ^[1-9][0-9]*$; seen while processing: ( %s )" -- \
            "'${selfS}'"  $1  "$*";
    else  ;
        errI=$1; print -v errS -f $2 -- ${@[3,-1]};  fi;
    _THROW;
'


STR_L   selfS=${modUS}_A_retsReset
alias ${selfS}='
    INTERNAL_FRAMEWORK_F_retsReset '${modS}';
    if [[ ${INTERNAL_FRAMEWORK_V_errB} -eq ${B_T} ]]; then
        set 1 "call to \"%s\" failed: { errS=%s; errI=%d }" INTERNAL_FRAMEWORK_F_retsReset ${INTERNAL_FRAMEWORK_V_errI} ${INTERNAL_FRAMEWORK_V_errS};
        '${modUS}_A_errorThrow';  fi; 
'


# usage: ..._statRecurse <dirpathS>...
STR_L   selfS=${modUS}_F_statRecurse
STR_L evalS=
evalS+="MAP_G   ${selfS}_V_statM=();  : 'keyed on pathS'; "
evalS+="MAP_G   ${selfS}_V_dirM=();  : 'keyed on dirpathS'; "
evalS+="MAP_G   ${selfS}_V_fileM=();  : 'keyed on filepathS'; "
eval ${evalS}; unset evalS

function ${selfS}() {
    setopt nullglob
    STR_L   dirpathS  nameS  filenameS  startdirNormalS  savedirNormalS  curdirNormalS  tmpS  evalS=  selfS=$0
    INT_L   deviceI inodeI modeI nlinkI uidI gidI rdevI sizeI atimeI mtimeI ctimeI blksizeI blocksI  exitI=0
    
    evalS+="LIST_L  dirpathOrigS_L=()  dirpathS_L=()  statinfoL=()  filenameL=()  livelinkL=()  deadlinkL=(); "
    evalS+="MAP_L   statinfoM=(); "
    evalS+="MAP_G   ${selfS}_V_statM=()  ${selfS}_V_dirM=()  ${selfS}_V_fileM=(); "
    eval ${evalS}
    _TRY{
        TEST_REP_TRY_A_selfmodSetup
	INTERNAL_FRAMEWORK_A_localErrvarsCreate
        if [[ $# -lt 1 ]]; then
	    set 1 "invalid arg count: %d; required: 1+" $#;  eval ${modUS}_A_errorThrow;  fi
	savedirNormalS=$(/bin/pwd);  startdirNormalS=${savedirNormalS}
	dirpathOrigS_L=( "${@[1,-1]}" )
	for dirpathS in ${dirpathOrigS_L}; do
	    if [[ -d ${dirpathS} ]]; then
		cd ${dirpathS};  curdirNormalS=$(/bin/pwd);  cd ${savedirNormalS}
		${selfS}_V_dirM[${curdirNormalS}]=1
		dirpathS_L+=( ${curdirNormalS} );  fi;  done
	if [[ ${#dirpathS_L} -eq 0 ]]; then
	    set 2 "no valid dirs found in arg list: %s" "${dirpathOrigS_L}";  eval ${modUS}_A_errorThrow;  fi
	while [[ ${#dirpathS_L} -ne 0 ]]; do
	    dirpathS=${dirpathS_L[${#dirpathS_L}]}
	    dirpathS_L[${#dirpathS_L}]=()
	    savedirNormalS=$(/bin/pwd);  cd ${dirpathS};  curdirNormalS=$(/bin/pwd)
	    filenameL=()  livelinkL=()  deadlinkL=()
	    for filenameS in .* *; do
		if ! [[ -L ${filenameS} ]]; then
		    filenameL+=( ${filenameS} )

		    continue;  fi
		if ! [ -f ${filenameS} -o -d ${filenameS} ]; then
		    deadlinkL+=( ${filenameS} );  continue;  fi
		livelinkL+=( ${filenameS} );  done
	    if [[ ${#filenameL} -eq 0 ]]; then  continue;  fi
	    stat -n -A statinfoL ${filenameL}
	    cd ${savedirNormalS}
	    for nameS deviceI inodeI modeI nlinkI uidI gidI rdevI sizeI atimeI mtimeI ctimeI blksizeI blocksI in ${statinfoL}; do
		if [[ -d ${curdirNormalS}/${nameS} ]]; then
		    dirpathS_L+=( ${curdirNormalS}/${nameS} )
		    eval "${selfS}_V_dirM[\${curdirNormalS}/\${filenameS}]=1;"
		else
		    ${selfS}_V_fileM[${curdirNormalS}/${filenameS}]=1;  fi
		print -v tmpS -f "%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:" -- \
		    ${deviceI}  ${inodeI}  ${modeI}  ${nlinkI}  ${uidI}  ${gidI}  ${rdevI}  ${sizeI} \
		    ${atimeI}  ${mtimeI}  ${ctimeI}  ${blksizeI}  ${blocksI}
		statinfoM[${dirpathS}/${nameS}]=${tmpS}
		eval "${selfS}_V_statM[\${curdirNormalS}/\${filenameS}]=\${tmpS};"
	    done
	done
	_CATCH{
	    if (( ${errB} == ${B_T} )); then
		print -f "ERROR: %s:  { %s;  errI=%d }\n" --  $0  ${errS}  ${errI};  exitI=1;  fi
	    if (( ${INTERNAL_TRY_V_errB} == ${B_T} )); then
		print -f "ERROR: %s:  { %s;  errI=%d }\n" --  $0  ${INTERNAL_TRY_V_errS}  ${INTERNAL_TRY_V_errI};  exitI=2;  fi
	}_CATCH
	_FINALLY{  cd ${startdirNormalS}  }_FINALLY
    }_TRY
    if (( ${INTERNAL_TRY_V_errB} == ${B_T} )); then
	print -f "ERROR: %s:  { %s;  errI=%d }\n" --  $0  ${INTERNAL_TRY_V_errS}  ${INTERNAL_TRY_V_errI};  exitI=3;  fi
    if [[ ${exitI} -ne 0 ]]; then
	print -f "ERROR: %s: exiting;  exitI=%d\n" --  $0  ${exitI}
	exit ${exitI};  fi
    #print -f "dirM=("
    #print -f "   [%s]=%s" --  ${(kvP)${:-${selfS}_V_dirM}}
    #print -f " )\n"
    print -f "dirM=("
    print -f "  %s  " --  ${(kP)${:-${selfS}_V_dirM}}
    print -f ")\n"
}


eval ${modUS}_F_statRecurse /Users/marke/20221217-ME-code/gh
