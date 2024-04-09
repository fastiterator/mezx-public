#!/bin/zsh

# MEZX_startup{ v1.5
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
# }MEZX_startup v1.5


# module name & setup

STR_L   modS=lib/csv
STR_L   modUS=${(U)modS//\//_}
#INTERNAL_FRAMEWORK_A_defStart
LIST_L  modL=( lib/fsm );  INTERNAL_FRAMEWORK_A_loadDependencies
INTERNAL_FRAMEWORK_A_retsReset


# global constants

STR_G   ${modUS}_CI_char_LF_S  ${modUS}_CI_char_TAB_S  ${modUS}_CI_char_SPC_S  ${modUS}_CI_char_COMMA_S
eval 'print -v ${modUS}_CI_char_TAB_S -f "\t"'
eval 'print -v ${modUS}_CI_char_SPC_S -f " "'
eval 'print -v ${modUS}_CI_char_COMMA_S -f ","'
STR_G   ${modUS}_CI_reWhitespaceS="([${(P)${:-${modUS}_CI_char_TAB_S}}${(P)${:-${modUS}_CI_char_SPC_S}}]*)"


# global variables

INT_G  ${modUS}_V_nextidI
MAP_G  ${modUS}_V_idI_fsmnameS_M
MAP_G  ${modUS}_V_csvnameS_idI_M


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


STR_L selfS=${modUS}_F_lineParse
#
# USAGE
#     ${selfS}  <csvnameS>  <lineS>
#
# RETURN
#     Parsed line in ${modUS}_V_replyL
#
function ${selfS}() {
    eval LIB_CSV_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   csvnameS  lineS
    STR_L   fsmnameS
 
    repeat 1; do
        calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_retsReset  curerrI=1;  \
	    INTERNAL_FRAMEWORK_A_callSimple  \${modS}
	if [[ ${argcI} -ne 2 ]]; then
	    errI=2
            print -v errS -f 'argcI != 2: %d;  argL=( %s )' -- \
		  ${argcI}  "$(INTERNAL_FRAMEWORK_A_listToStrR -P -A -- argL)";  break;  fi
	csvnameS=$1  lineS=$2
	if ! [[ -v "${modUS}_V_csvnameS_idI_M[${csvnameS}]" ]]; then
	    errI=3
            print -v errS -f '"%s" arg value not a known CSV name: "%s"' -- \
		  csvnameS  ${csvnameS};  break;  fi
	varnameS="${modUS}_V_csvnameS_idI_M[${csvnameS}]"
	idS=${(P)varnameS}
	varnameS="${modUS}_V_idI_fsmnameS_M[${idS}]"
	fsmnameS=${(P)varnameS}
	lineS=${lineS/\/}
	calleemodUS=LIB_FSM  calleeS=F_run  curerrI=4; \
	    INTERNAL_FRAMEWORK_A_callSimple  \${fsmnameS}  init
	replyL=( "${(@)LIB_FSM_V_replyL}" )
	okB=${B_T};  done
    eval LIB_CSV_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_setup
#
# USAGE
#     ${selfS}  <csvtypeS>  <csvnameS>  <npoL_varS>  <headerS>
#
# RETURN
#     <csvnameS> in ${modUS}_V_replyS
#
# SIDE EFFECT
#     FSM created
#     Lookup table in: ${modUS}_V_<id>_nameS_fieldI_M
#     Lookup table in: ${modUS}_V_<id>_fieldI_nameS_M
#     Lookup table in: ${modUS}_V_<id>_fieldI_headS_M
#     Copy of input npo list in: ${modUS}_V_<id>_npoL
#     <id> added to ${modUS}_V_idI_fsmnameS_M as:  ${modUS}_V_idI_fsmnameS_M[<id>]=${fsmnameS}
#     <csvnameS> added to ${modUS}_V_csvnameS_idI_M as:  ${modUS}_V_csvnameS_idI_M[<csvnameS>]=<id>
#
function ${selfS}() {
    eval LIB_CSV_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   csvtypeS  csvnameS  npoL_varS  headerS
    STR_L   fieldS  nameS  patternS  outputS  filepathS  fsmnameS  lineS
    INT_L   fieldI  idI=${(P)${:-${modUS}_V_nextidI}}
    BOOL_L  foundB
    LIST_L  headerS_L  fsmtextL
    MAP_L   nameS_fieldI_M  fieldI_nameS_M  fieldI_headS_M
 
    repeat 1; do
        calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_retsReset  curerrI=1;  \
	    INTERNAL_FRAMEWORK_A_callSimple  \${modS}
	if [[ ${argcI} -ne 4 ]]; then
	    errI=2
            print -v errS -f 'argcI != 4: %d;  argL=( %s )' -- \
		  ${argcI}  "$(INTERNAL_FRAMEWORK_A_listToStrR -P -A -- argL)";  break;  fi
	csvtypeS=$1  csvnameS=$2  npoL_varS=$3  headerS=$4
	if [[ ${#csvnameS} -eq 0 ]]; then
	    errI=3
            print -v errS -f '"%s" arg is zero length' -- \
		  csvnameS;  break;  fi
	if [[ -v "${modUS}_V_csvnameS_idI_M[${csvnameS}]" ]]; then
	    errI=4
            print -v errS -f 'CSV name denoted by "%s" arg already in use: "%s"' -- \
		  csvnameS  ${csvnameS};  break;  fi
	if ! [[ -v "${npoL_varS}" ]]; then
	    errI=5
            print -v errS -f '"%s" arg does not refer to extant var: "%s"' -- \
		  npoL_varS  ${npoL_varS};  break;  fi
	if ! [[ ${(tP)npoL_varS} =~ '^array.*' ]]; then
	    errI=6
            print -v errS -f '*("%s") arg not of type "%s": "%s";  "%s" arg value="%s"' -- \
		  npoL_varS  array'*'  ${(tP)npoL_varS}  npoL_varS  ${npoL_varS};  break;  fi
	if [[ $(( ${(P)#npoL_varS} % 3 )) -ne 0 ]]; then
	    errI=7
            print -v errS -f '*("%s" arg) length not divisible by 3: %d;  "%s" arg value="%s"' -- \
		  npoL_varS  ${(P)#npoL_varS}  npoL_varS  ${npoL_varS};  break;  fi
	if [[ ${#headerS} -eq 0 ]]; then
	    errI=8
            print -v errS -f '"%s" arg is zero length' -- \
		  headerS;  break;  fi
        calleemodUS=LIB_FSM  calleeS=F_getFromFile  curerrI=9; \
	    INTERNAL_FRAMEWORK_A_callSimple  csv\-\${csvtypeS}
	fsmnameS=${LIB_FSM_V_replyS}
	headerS=${headerS/\/}
	lineS=${headerS}
	calleemodUS=LIB_FSM  calleeS=F_run  curerrI=10; \
	    INTERNAL_FRAMEWORK_A_callSimple  \${fsmnameS}  init
	headerS_L=( ${LIB_FSM_V_replyL} )
	for  nameS patternS outputS  in ${(P)npoL_varS}; do
	    foundB=${B_F}
	    for fieldI in {1..${#headerS_L}}; do
		fieldS=${headerS_L[${fieldI}]}
		fieldI_headS_M[${fieldI}]=${fieldS}
		if [[ ${fieldS} =~ ${patternS} ]]; then
		    foundB=${B_T}  nameS_fieldI_M[${nameS}]=${fieldI}  fieldI_nameS_M[${fieldI}]=${nameS};  break;  fi;  done
	    if [[ ${foundB} -ne ${B_T} ]]; then
		errI=11
		print -v errS -f '"%s" value (from "%s" arg) not found in header line: "%s";  headerS_L=( %s );' -- \
		      patternS  npoL_varS  ${patternS}  "$(INTERNAL_FRAMEWORK_A_listToStrR -P -A -- headerS_L)"
		break 2;  fi;  done
	eval "LIST_G  ${modUS}_V_${idI}_npoL=( \${${npoL_varS}} )"
	eval "MAP_G   ${modUS}_V_${idI}_nameS_fieldI_M=( \"\${(kv@)nameS_fieldI_M}\" )"
	eval "MAP_G   ${modUS}_V_${idI}_fieldI_nameS_M=( \"\${(kv@)fieldI_nameS_M}\" )"
	eval "MAP_G   ${modUS}_V_${idI}_fieldI_headS_M=( \"\${(kv@)fieldI_headS_M}\" )"
	eval "INT_G   ${modUS}_V_nextidI=\$(( \${idI} + 1 ))"
	eval "${modUS}_V_idI_fsmnameS_M[\${idI}]=\${fsmnameS}"
	eval "${modUS}_V_csvnameS_idI_M[\${csvnameS}]=\${idI}"
	replyS=${csvnameS};  okB=${B_T};  done
    eval LIB_CSV_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_headerAuto
#
# USAGE
#     ${selfS}  <csvtypeS>  <csvnameS>  <headerS>  [ <requiredfieldsVarnameS> ]
#
# RETURN
#     <csvnameS> in ${modUS}_V_replyS
#
# DESCRIPTION
#     - Parses <headerS> text per <csvtypeS> reader
#     - Creates npoL automatically
#     - Calls ..._F_setup for the created npoL
#
# SIDE EFFECT
#     Ref side effects of ..._F_setup
#
function ${selfS}() {
    eval LIB_CSV_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   csvtypeS  csvnameS  headerS  requiredfieldsVarnameS
    STR_L   fieldS  fieldnameS  fieldrexS  fsmnameS
    INT_L   countI
    LIST_L  npoL  headerS_L  missingL
    MAP_L   fieldM
 
    repeat 1; do
        calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_retsReset  curerrI=1;  \
	    INTERNAL_FRAMEWORK_A_callSimple  \${modS}
	if [[ ${argcI} -ne 3  &&  ${argcI} -ne 4 ]]; then
	    errI=2
	    print -v errS -f 'argcI not in ( 3 4 ): %d;  argL=( %s )' -- \
		  ${argcI}  "$(INTERNAL_FRAMEWORK_A_listToStrR -P -A -- argL)";  break;  fi
	csvtypeS=$1  csvnameS=$2  headerS=$3  requiredfieldsVarnameS=UNDEF
	if [[ ${argcI} -eq 4 ]]; then
	    requiredfieldsVarnameS=$4;  fi
	if [[ ${#csvtypeS} -eq 0 ]]; then
	    errI=3
            print -v errS -f '"%s" arg is zero length' -- \
		  csvtypeS;  break;  fi
	if [[ ${#csvnameS} -eq 0 ]]; then
	    errI=4
            print -v errS -f '"%s" arg is zero length' -- \
		  csvnameS;  break;  fi
	if [[ -v "${modUS}_V_csvnameS_idI_M[${csvnameS}]" ]]; then
	    errI=5
            print -v errS -f 'CSV name denoted by "%s" arg already in use: "%s"' -- \
		  csvnameS  ${csvnameS};  break;  fi
	if [[ ${#headerS} -eq 0 ]]; then
	    errI=6
            print -v errS -f '"%s" arg is zero length' -- \
		  headerS;  break;  fi
	if [[ ${requiredfieldsVarnameS} != UNDEF ]]; then
	    if [[ ! -v ${requiredfieldsVarnameS} ]]; then
		errI=7
		print -v errS -f '"%s" arg does not refer to extant var: "%s"' -- \
		      requiredfieldsVarnameS  ${requiredfieldsVarnameS};  break;  fi
	    if [[ ! ${(Pt)requiredfieldsVarnameS} = array* ]]; then
		errI=8
		print -v errS -f '"%s" arg does not refer to "array" type var: "%s"; type="%s"' -- \
		      requiredfieldsVarnameS  ${requiredfieldsVarnameS} \
		      ${(Pt)requiredfieldsVarnameS};  break;  fi
	fi

        calleemodUS=LIB_FSM  calleeS=F_getFromFile  curerrI=9; \
	    INTERNAL_FRAMEWORK_A_callSimple  csv\-\${csvtypeS}
	fsmnameS=${LIB_FSM_V_replyS}
	headerS=${headerS/\/}
	lineS=${headerS}
	calleemodUS=LIB_FSM  calleeS=F_run  curerrI=10; \
	    INTERNAL_FRAMEWORK_A_callSimple  ${fsmnameS}  init
	headerS_L=( ${LIB_FSM_V_replyL} )
	countI=0
	for fieldS in ${(@)headerS_L}; do
	    countI+=1
	    if [[ ${#fieldS} -eq 0 ]]; then
		errI=11
		print -v errS -f 'zero length value for field: %d;  headerS_L=( %s )' -- \
		      ${countI}  "$(INTERNAL_FRAMEWORK_A_listToStrR -P -A -- headerS_L)";  break;  fi
	    fieldnameS=${(L)fieldS// /-}
            calleemodUS=INTERNAL_REX  calleeS=F_strEscape  curerrI=12; \
		INTERNAL_FRAMEWORK_A_callSimple  \${fieldS}
	    fieldrexS=${INTERNAL_REX_V_replyS}
	    fieldM[${fieldnameS}]=1
	    npoL+=( ${fieldnameS}  ${fieldrexS}  ${fieldS} );  done
	if [[ ${errI} -ne 0 ]]; then
	    break;  fi
	if [[ ${requiredfieldsVarnameS} != UNDEF ]]; then
	    for fieldnameS in ${(P@)requiredfieldsVarnameS}; do
		if [[ ! -v "fieldM[${fieldnameS}]" ]]; then
		    missingL+=( ${fieldnameS} );  fi;  done
	    if [[ ${#missingL} -ne 0 ]]; then
		errI=13
		print -v errS -f 'missing required fields: ( %s )' -- \
		      "$(INTERNAL_FRAMEWORK_A_listToStrR -P -A -- missingL)";  break;  fi;  fi
	calleemodUS=LIB_CSV calleeS=F_setup curerrI=14; \
	    INTERNAL_FRAMEWORK_A_callSimple  ${csvtypeS}  ${csvnameS}  npoL  \${headerS}
	replyS=${csvnameS};  okB=${B_T};  done
    eval LIB_CSV_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


STR_L selfS=${modUS}_F_extract
#
# USAGE
#     ${selfS}  <csvnameS>  <lineS>
#
# RETURN
#     Extracted csv line, as a MAP, in ${modUS}_V_replyM
#
function ${selfS}() {
    eval LIB_CSV_A_selfmodSetup
    eval INTERNAL_FRAMEWORK_A_funcStart
    STR_L   csvnameS  lineS
    STR_L   nameS  patternS  outputS  varnameS  idS  fsmnameS
    LIST_L  lineS_L
    MAP_L   replyM
 
    repeat 1; do
        calleemodUS=INTERNAL_FRAMEWORK  calleeS=F_retsReset  curerrI=1;  \
	    INTERNAL_FRAMEWORK_A_callSimple  \${modS}
	if [[ ${argcI} -ne 2 ]]; then
	    errI=1
            print -v errS -f 'argcI != 2: %d;  argL=( %s )' -- \
		  ${argcI}  "$(INTERNAL_FRAMEWORK_A_listToStrR -P -A -- argL)";  break;  fi
	csvnameS=$1  lineS=$2
        calleemodUS=${modUS}  calleeS=F_lineParse  curerrI=2;  \
	    INTERNAL_FRAMEWORK_A_callSimple  \${csvnameS}  \${lineS}
	lineS_L=( "${(@)LIB_CSV_V_replyL}" )
	varnameS="${modUS}_V_csvnameS_idI_M[${csvnameS}]"
	idS=${(P)varnameS}
	for  nameS patternS outputS  in ${(P)${:-${modUS}_V_${idS}_npoL}}; do
	    varnameS="${modUS}_V_${idS}_nameS_fieldI_M"
	    if [[ -v "lineS_L[${varnameS}[${nameS}]}]" ]]; then
		eval "replyM[\${nameS}]=\${lineS_L[\${${varnameS}[\${nameS}]}]}"
	    else  replyM[${nameS}]=;  fi;  done
	okB=${B_T};  done
    eval INTERNAL_FRAMEWORK_A_funcEnd
}


INTERNAL_FRAMEWORK_F_modCacheWrite \
    --module ${modS}
#INTERNAL_FRAMEWORK_A_defEnd
