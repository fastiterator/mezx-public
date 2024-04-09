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

STR_L   modS=lib/tsv
STR_L   modUS=${(U)modS//\//_}
INTERNAL_FRAMEWORK_A_defStart
LIST_L  modL=(  );  INTERNAL_FRAMEWORK_A_loadDependencies
INTERNAL_FRAMEWORK_A_retsReset


# global constants

STR_G   ${modUS}_CI_char_TAB_S  ${modUS}_CI_char_SP_S
eval 'print -v ${modUS}_CI_char_TAB_S -f "\t"'
eval 'print -v ${modUS}_CI_char_SPC_S -f " "'
STR_G   ${modUS}_CI_reWhitespaceS="([${(P)${:-${modUS}_CI_char_TAB_S}}${(P)${:-${modUS}_CI_char_SPC_S}}]*)"


# global variables

INT_G  ${modUS}_V_nextidI
MAP_G  ${modUS}_V_idM


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


STR_L selfS=${modUS}_F_setup
#
# USAGE
#     ${selfS}  <npoL_varS>  <headerS>
#
# RETURN
#     <id> in ${modUS}_V_replyS
#
# SIDE EFFECT
#     Lookup table in: ${modUS}_V_<id>_nameS_fieldI_M
#     Lookup table in: ${modUS}_V_<id>_fieldI_nameS_M
#     Lookup table in: ${modUS}_V_<id>_fieldI_headS_M
#     Copy of input npo list in: ${modUS}_V_<id>_npoL
#     <id> added to ${modUS}_V_idM
#
function ${selfS}() {
    eval LIB_TSV_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   fieldS  nameS  patternS  outputS  npoL_varS
    INT_L   fieldI  idI=${(P)${:-${modUS}_V_nextidI}}
    BOOL_L  foundB
    LIST_L  headerS_L
    MAP_L   nameS_fieldI_M  fieldI_nameS_M  fieldI_headS_M
 
    repeat 1; do
        calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_retsReset  curerrI=1; eval INTERNAL_FRAMEWORK_A_callSimple  \${modS}
	if [[ ${argcI} -ne 2 ]]; then
	    errI=2
            print -v errS -f 'argcI != 2: %d;  argL=( %s )' -- \
		  ${argcI}  "$(INTERNAL_FRAMEWORK_F_arrayToStrR -P -A -- argL)";  break;  fi
	npoL_varS=$1  headerS=$2
	if ! [[ -v ${npoL_varS} ]]; then
	    errI=3
            print v errS -f '"%s" arg does not refer to extant var: "%s"' -- \
		  npoL_varS  ${npoL_varS};  break;  fi
	if ! [[ ${(tP)npoL_varS} =~ '^array.*' ]]; then
	    errI=4
            print -v errS -f '*("%s") arg not of type "%s": "%s";  "%s" arg value="%s"' -- \
		  npoL_varS  array'*'  ${(tP)npoL_varS}  npoL_varS  ${npoL_varS};  break;  fi
	if [[ $(( ${(P)#npoL_varS} % 3 )) -ne 0 ]]; then
	    errI=5
            print -v errS -f '*("%s" arg) length not divisible by 3: %d;  "%s" arg value="%s"' -- \
		  npoL_varS  ${(P)#npoL_varS}  npoL_varS  ${npoL_varS};  break;  fi
	if [[ ${#headerS} -eq 0 ]]; then
	    errI=6
            print -v errS -f '"%s" arg is zero length' -- \
		  headerS;  break;  fi
	headerS=${headerS/\/}
	headerS_L=("${(@s[	])headerS}")
	for  nameS patternS outputS  in ${(P)npoL_varS}; do
	    foundB=${B_F}
	    for fieldI in {1..${#headerS_L}}; do
		fieldS=${headerS_L[${fieldI}]}
		# print -f "fieldI=%s  fieldS=%s\n" -- ${fieldI} "${fieldS}"
		fieldI_headS_M[${fieldI}]=${fieldS}
		if [[ ${fieldS} =~ ${patternS} ]]; then
		    foundB=${B_T}  nameS_fieldI_M[${nameS}]=${fieldI}  fieldI_nameS_M[${fieldI}]=${nameS}
		    break;  fi;  done
	    if [[ ${foundB} -ne ${B_T} ]]; then
		errI=7
		print -v errS -f '"%s" value (from "%s" arg) not found in header line: "%s";  headerS_L=( %s )' -- \
		      patternS  npoL_varS  ${patternS}  "$(INTERNAL_FRAMEWORK_F_arrayToStrR -P -A -- headerS_L)"
		break 2;  fi;  done
	eval "LIST_G  ${modUS}_V_${idI}_npoL=( \${${npoL_varS}} )"
	eval "MAP_G   ${modUS}_V_${idI}_nameS_fieldI_M=( \"\${(kv@)nameS_fieldI_M}\" )"
	eval "MAP_G   ${modUS}_V_${idI}_fieldI_nameS_M=( \"\${(kv@)fieldI_nameS_M}\" )"
	eval "MAP_G   ${modUS}_V_${idI}_fieldI_headS_M=( \"\${(kv@)fieldI_headS_M}\" )"
	eval "INT_G   ${modUS}_V_nextidI=$(( ${idI} + 1 ))"
	eval "${modUS}_V_idM[\${idI}]=1"
	replyS=${idI};  okB=${B_T};  done
    eval LIB_TSV_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_extract
#
# USAGE
#     ${selfS}  <idS>  <lineS>
#
# RETURN
#     Extracted tsv line, as a MAP, in ${modUS}_V_replyM
#
function ${selfS}() {
    eval LIB_TSV_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   lineS  nameS  patternS  outputS  varnameS  idS
    LIST_L  lineS_L
    MAP_L   replyM
 
    repeat 1; do
        calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_retsReset  curerrI=1; eval INTERNAL_FRAMEWORK_A_callSimple  \${modS}
	if [[ ${argcI} -ne 2 ]]; then
	    errI=1
            print -v errS -f 'argcI != 2: %d;  argL=( %s )' -- \
		  ${argcI}  "$(INTERNAL_FRAMEWORK_F_arrayToStrR -P -A -- argL)";  break;  fi
	idS=$1  lineS=$2
	if ! [[ -v "${modUS}_V_idM[${idS}]" ]]; then
	    errI=2
            print -v errS -f 'unknown/invalid "%s" arg value: "%s"' -- \
              idS  ${idS};  break;  fi
	if [[ ${#lineS} -eq 0 ]]; then
            errI=3
	    print -v errS -f '"%s" arg is zero length' -- \
              lineS;  break;  fi
	if [[ ${lineS} =~ "^${(P)${:-${modUS}_CI_reWhitespaceS}}" ]]; then
	    lineS="XXX${(P)${:-${modUS}_CI_char_TAB_S}}${lineS}";  fi
	lineS_L=( "${(@s[	])lineS}" )
	for  nameS patternS outputS  in ${(P)${:-${modUS}_V_${idS}_npoL}}; do
	    varnameS="${modUS}_V_${idS}_nameS_fieldI_M"
	    if [[ -v "lineS_L[${varnameS}[${nameS}]}]" ]]; then
		eval "replyM[\${nameS}]=\${lineS_L[\${${varnameS}[\${nameS}]}]}"
	    else  replyM[${nameS}]=;  fi;  done
	okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_inject
#
# USAGE
#     ${selfS}  <idS>  <varnameS>
#
# RETURN
#     Injected tsv line, as a STR, in ${modUS}_V_replyS
#
function ${selfS}() {
    eval LIB_TSV_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   nameS  varnameS  idS  valueS  sepS  fieldI_headS_M_varnameS  fieldI_nameS_M_varnameS  headS
    INT_L   fieldI
 
    repeat 1; do
        calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_retsReset  curerrI=1; eval INTERNAL_FRAMEWORK_A_callSimple  \${modS}
	if [[ ${argcI} -ne 2 ]]; then
	    errI=1
            print -v errS -f 'argcI != 2: %d;  argL=( %s )' -- \
		  ${argcI}  "$(INTERNAL_FRAMEWORK_F_arrayToStrR -P -A -- argL)";  break;  fi
	idS=$1  varnameS=$2
	if ! [[ -v "${modUS}_V_idM[${idS}]" ]]; then
	    errI=2
            print -v errS -f 'unknown/invalid "%s" arg value: "%s"' -- \
              idS  ${idS};  break;  fi
	if ! [[ -v ${varnameS} ]]; then
            errI=3
            print v errS -f '"%s" arg does not refer to extant var: "%s"' -- \
              varnameS  "${varnameS}";  break;  fi
        if ! [[ ${(tP)varnameS} =~ '^association.*' ]]; then
            errI=4
            print -v errS -f '*("%s") arg not of type "%s": "%s";  "%s" arg value="%s"' -- \
                  varnameS  association'*'  ${(tP)varnameS}  varnameS  ${varnameS};  break;  fi
	# need to look up fields, in order, from ${modUS}_V_<id>_fieldI_headS_M
	set | egrep '^LIB_TSV_V_[0-9]+_(fieldI|nameS)_(fieldI|nameS|headS)_M='
	fieldI_headS_M_varnameS="${modUS}_V_${idS}_fieldI_headS_M"
	fieldI_nameS_M_varnameS="${modUS}_V_${idS}_fieldI_nameS_M"
	for fieldI in {1..${(P)#fieldI_headS_M_varnameS}}; do
	    eval "headS=\${${fieldI_headS_M_varnameS}[${fieldI}]}"
	    valueS=
	    if [[ -v "${fieldI_nameS_M_varnameS}[${fieldI}]" ]]; then
		eval "nameS=\${${fieldI_nameS_M_varnameS}[${fieldI}]}"
		if [[ -v "${varnameS}[${nameS}]" ]]; then
		    eval "valueS=\${${varnameS}["${nameS}"]}";  fi;  fi
	    replyS+="${sepS}${valueS}"
	    sepS=${(P)${:-${modUS}_CI_char_TAB_S}};  done
	okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


INTERNAL_FRAMEWORK_F_modCacheWrite \
    --module ${modS}
INTERNAL_FRAMEWORK_A_defEnd
