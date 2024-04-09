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

STR_L   modS=internal/rep
STR_L   modUS=${(U)modS//\//_}
INTERNAL_FRAMEWORK_A_defStart
LIST_L  modL=( internal/rex  internal/codegen/framework )
INTERNAL_FRAMEWORK_A_retsReset

repeat 1; do
    INTERNAL_FRAMEWORK_A_localErrvarsCreate;  errB=${B_T}
    INTERNAL_FRAMEWORK_A_loadDependencies
    INTERNAL_FRAMEWORK_A_retsReset
    eval INTERNAL_CODEGEN_FRAMEWORK_A_selfCodegen
    eval INTERNAL_CODEGEN_FRAMEWORK_A_stateReset
    unset codeL thiscodeL
    INTERNAL_FRAMEWORK_F_modCacheWrite \
	--module ${modS} \
	--depend internal/rex internal/codegen/framework \
	--include alias \
            "${modUS}_[A-Za-z0-9_]+" \
            "${modUS}_[A-Za-z0-9_]+\{" \
            "\}${modUS}_[A-Za-z0-9][A-Za-z0-9_]*" 
    if [[ ${INTERNAL_FRAMEWORK_V_errB} -eq ${B_T} ]]; then
	errI=1;  print -v errS -f "call to \"%s\" failed:  { %s;  errI=%d }" --  \
            INTERNAL_FRAMEWORK_F_modCacheWrite  ${INTERNAL_FRAMEWORK_V_errS}  ${INTERNAL_FRAMEWORK_V_errI};  break;  fi
    errB=${B_F};  done
if [[ ${errB} -eq ${B_T} ]]; then
    print -f "ERROR: %s:  { %s;  errI=%d }\n" --  ${modUS}  ${errS}  ${errI};  exit 1;  fi
INTERNAL_FRAMEWORK_A_defEnd


if false; then
#CODEGEN_ACTIVE{

# global variables

INTERNAL_FRAMEWORK_A_retsReset
eval "LIST_G  ${modUS}_V_countI_L=( )"
eval "LIST_G  ${modUS}_V_limitI_L=( )"
eval "LIST_G  ${modUS}_V_conditionS_L=( )"
eval "LIST_G  ${modUS}_V_typeS_L=( )"
eval "LIST_G  ${modUS}_V_prependL=( REP_ _ )"
INT_G   ${modUS}_V_depthI=0
eval 'MAP_G   '${modUS}_V_abbrevM'=(
    FOREVER            pair:
    ONCE               pair:
    TWICE              pair:
    THRICE             pair:
    WHILE              pair:
    UNTIL              pair:
    N                  pair:
    N_WHILE            pair:
    N_UNTIL            pair:
    N_THEN_WHILE       pair:
    N_THEN_UNTIL       pair:
    REPEAT             pair:N
    REPEAT_WHILE       pair:N_WHILE
    REPEAT_UNTIL       pair:N_UNTIL
    REPEAT_THEN_WHILE  pair:N_THEN_WHILE
    REPEAT_THEN_UNTIL  pair:N_THEN_UNTIL
    EXIT               singular:
    NEXT               singular:
    END                right:
)'


#CODEGEN_EXEC{
INTERNAL_FRAMEWORK_A_localErrvarsCreate
STR_L   kS  vS
STR_L   qd_S='"'  qs_S="'"  bs_S='\'
STR_L   bs2_S="${bs_S}${bs_S}"
LIST_L  codeL=()  thiscodeL=()
STR_L   modS=internal/rep
STR_L   modUS=${(U)modS//\//_}

errB=${B_T}
MAP_G   constructM=(
  FOREVER \
    '; ' \
  ONCE \
    'if [[ ${'${modUS}'_V_countI_L[${'${modUS}'_V_depthI}]} -gt 1 ]]; then  break;  fi; '
  TWICE \
    'if [[ ${'${modUS}'_V_countI_L[${'${modUS}'_V_depthI}]} -gt 2 ]]; then  break;  fi; '
  THRICE \
    'if [[ ${'${modUS}'_V_countI_L[${'${modUS}'_V_depthI}]} -gt 3 ]]; then  break;  fi; '
  WHILE \
    'eval "if ! [[ ${='${modUS}'_V_conditionS_L[${'${modUS}'_V_depthI}]} ]]; then  break;  fi; "; '
  UNTIL \
    'eval "if   [[ ${='${modUS}'_V_conditionS_L[${'${modUS}'_V_depthI}]} ]]; then  break;  fi; "; '
  N \
    'if [[ ${'${modUS}'_V_countI_L[${'${modUS}'_V_depthI}]} -gt ${'${modUS}'_V_limitI_L[${'${modUS}'_V_depthI}]} ]]; then  break;  fi; '
  N_WHILE \
    'eval "if ! [[ ${'${modUS}'_V_countI_L[${'${modUS}'_V_depthI}]} -le ${'${modUS}'_V_limitI_L[${'${modUS}'_V_depthI}]} ]]   ||  ! [[ ${='${modUS}'_V_conditionS_L[${'${modUS}'_V_depthI}]} ]]; then  break; fi;"; '
  N_UNTIL \
    'eval "if [[ ${'${modUS}'_V_countI_L[${'${modUS}'_V_depthI}]} -le ${'${modUS}'_V_limitI_L[${'${modUS}'_V_depthI}]} ]] && ! [[ ${='${modUS}'_V_conditionS_L[${'${modUS}'_V_depthI}]} ]]; then :; else break; fi;"; '
  N_THEN_WHILE \
    'eval "if [[ ${'${modUS}'_V_countI_L[${'${modUS}'_V_depthI}]} -le ${'${modUS}'_V_limitI_L[${'${modUS}'_V_depthI}]} ]] || [[ ${='${modUS}'_V_conditionS_L[${'${modUS}'_V_depthI}]} ]]; then :; else break; fi;"; '
  N_THEN_UNTIL \
    'eval "if ! [[ ${'${modUS}'_V_countI_L[${'${modUS}'_V_depthI}]} -le ${'${modUS}'_V_limitI_L[${'${modUS}'_V_depthI}]} ]] && [[ ${='${modUS}'_V_conditionS_L[${'${modUS}'_V_depthI}]} ]]; then break; fi;"; '
)

while true; do
    for kS in ${(ko)constructM}; do
        vS=${constructM[${kS}]}
        thiscodeL=(
"STR_L   selfS=${qd_S}${kS}${qd_S}; "
"alias -g ${qd_S}${modUS}_\${selfS}{${qd_S}=${qs_S}  ; "
"    : ${qd_S}REP_TYPE=${qs_S}\$selfS${qs_S}{  prev REP_V_depthI=\${${modUS}_V_depthI}${qd_S}; "
"    ${modUS}_V_countI_L+=( 0 );  ${modUS}_V_limitI_L+=( \${REP_P_nI-0} ); "
"    ${modUS}_V_conditionS_L+=( \${REP_P_condS-0\ ==\ 0} );  ${modUS}_V_typeS_L+=( ${qs_S}\${selfS}${qs_S} ); "
"    ${modUS}_V_depthI=\${#${modUS}_V_countI_L}; "
"    while true;  do ; "
"        ${modUS}_V_countI_L[\${${modUS}_V_depthI}]=\$(( ${modUS}_V_countI_L[${modUS}_V_depthI] + 1 )); "
"        ${vS} ; "
"${qs_S}; "
""

"alias -g ${qd_S}}${modUS}_\${selfS}${qd_S}=${qs_S}  ; "
"        : ${qd_S}REP_TYPE=}${qs_S}\${selfS}${qs_S}  prev REP_V_depthI=\${${modUS}_V_depthI}${qd_S}; "
"        if [[ \${${modUS}_V_typeS_L[\${${modUS}_V_depthI}]} != ${qd_S}${qs_S}\${selfS}${qs_S}${qd_S} ]]; then ; "
"            print -v ${modUS}_V_errS -f ${qd_S}mismatch between %s and %s${qd_S} --  ${qd_S}\${${modUS}_V_typeS_L[\${${modUS}_V_depthI}]}{${qd_S}  ${qd_S}}${qs_S}\${selfS}${qs_S}${qd_S}; "
"            ${modUS}_V_errI=1;  ${modUS}_V_errB=\${B_T}; "
"            break;  fi;  done; "
"    ${modUS}_V_countI_L[\${${modUS}_V_depthI}]=( );      ${modUS}_V_limitI_L[\${${modUS}_V_depthI}]=( ); "
"    ${modUS}_V_conditionS_L[\${${modUS}_V_depthI}]=( );  ${modUS}_V_typeS_L[\${${modUS}_V_depthI}]=( ); "
"    ${modUS}_V_depthI=\${#${modUS}_V_countI_L}; "
"${qs_S}; "
"unset selfS; "
""
"" )
        codeL+=( "${(@)thiscodeL}" ); done
    INTERNAL_CODEGEN_FRAMEWORK_F_codeListAdd  codeL
    #print "codeL=\n----"
    #print -f "%s\n" ${codeL}
    #print -f "----\n"
    errB=${B_F}
    break;  done
if [[ ${errB} -ne ${B_F} ]]; then
    print "### ERROR ###";  exit 1;  fi
unset  kS  vS  qd_S  qs_S  bs_S  constructM
#}CODEGEN_EXEC


# aliases

# USAGE
#     ..._A_selfmodSetup
#
# NOTE
#     - Since callers in effect have no way of catching errors thrown by this alias,
#       it cannot use "break" to break out beyond its borders.
#
STR_L   selfS=${modUS}_A_selfmodSetup
alias ${selfS}='
    STR_L   modS="'"${modS}"'"  modUS="'"${modUS}"'";
'


# DESC
#     marks end of REP block
#
# USAGE
#     <REP*>
#         …
#     REP_END
#
# NOTE
#     internal use only
#
STR_L   selfS=INTERNAL_REP_END
alias -g "}"${selfS}='
        : "REP_TYPE='${selfS}'  prev REP_V_depthI=${'${modUS}'_V_depthI}  ";
    done;
    '${modUS}'_V_countI_L[$'${modUS}'_V_depthI]=( );  '${modUS}'_V_limitI_L[$'${modUS}'_V_depthI]=( );  '${modUS}'_V_conditionS_L[$'${modUS}'_V_depthI]=( );
    '${modUS}'_V_typeS_L[$'${modUS}'_V_depthI]=( );   '${modUS}'_V_depthI=$#'${modUS}'_V_countI_L;
'
unset selfS


# DESC
#     marks end of REP block
#
# USAGE
#     <REP*>
#         …
#         REP_EXIT
#         …
#
# NOTE
#     internal use only
#
STR_L   selfS=INTERNAL_REP_EXIT
alias -g ${selfS}='
        : "REP_TYPE='${selfS}'  prev REP_V_depthI=${'${modUS}'_V_depthI}  ";
        break; 
'
unset selfS


# DESC
#     skip to next repetition of this <REP*>
#
# USAGE
#     <REP*>{
#         REP_NEXT
#     }<REP*>
#
STR_L   selfS=INTERNAL_REP_NEXT
alias -g ${selfS}='
    : "REP_TYPE='${selfS}'  PREV  #REP_V_countI_L=${#'${modUS}'_V_countI_L}  ";
    continue;
'
unset selfS


# DESC
#     creates aliases for INTERNAL_REP_A_... aliases, e.g. "REP_WHILE{" and "WHILE{" are both aliased to "INTERNAL_REP_WHILE{"
#
# USAGE
#     ..._F_abbrevsCreate
#
function ${modUS}_F_abbrevsCreate() {
    INTERNAL_REP_A_selfmodSetup
    STR_L   kS  vS  typeS  targetS  prependS
    LIST_L  typeTargetL  prependL
    prependL=( "${(@P)${:-${modUS}_V_prependL}}" )
    INTERNAL_FRAMEWORK_A_localErrvarsCreate
    INTERNAL_FRAMEWORK_A_localMatchvarsCreate
    
    errB=${B_T}
    while true; do
	INTERNAL_FRAMEWORK_A_retsReset
	if ! [[ -v ${modUS}_V_abbrevM ]]; then
	    errI=1;  print -v errS -f "%s var does not exist" -- ${modUS}_V_abbrevM;  break;  fi
	for kS in ${(koP)${:-${modUS}_V_abbrevM}}; do
	    vS=${(P)${:-${modUS}_V_abbrevM[${kS}]}}
	    typeTargetL=( "${(@s/:/)vS}" )
	    if [[ ${#typeTargetL} -ne 2 ]]; then
		errI=2;  print -v errS -f "sub-element count not 2 in element of %s var: %d;  elementS=%s" -- \
		    ${modUS}_V_abbrevM  ${#typeTargetL}  ${vS};  break 2;  fi;
	    typeS=${typeTargetL[1]}  targetS=${typeTargetL[2]}
	    if [[ ${targetS} = "" ]]; then  targetS=${kS};  fi
	    if ! [[ ${targetS} =~ ${INTERNAL_REX_C_reIdentA_S} ]]; then
		errI=3;  print -v errS 
                    -f "targetS value seen in \"%s\" var does not match \"%s\" regex (\"%s\"): %s" -- \
		        ${modUS}_V_abbrevM \
		        INTERNAL_REX_C_reIdentA_S  ${INTERNAL_REX_C_reIdentA_S} \
			${targetS};  break;  fi
	    case X${typeS} in
		(Xpair)
		    for prependS in "${(@)prependL}"; do
			alias -g "${prependS}${targetS}{"="${modUS}_${targetS}{"
			alias -g "}${prependS}${targetS}"="}${modUS}_${targetS}"; done  ;;
		(Xsingular)
		    for prependS in "${(@)prependL}"; do
			alias -g "${prependS}${targetS}"="${modUS}_${targetS}";  done  ;;
		(Xright)
		    for prependS in "${(@)prependL}"; do
			alias -g "}${prependS}${targetS}"="}${modUS}_${targetS}";  done  ;;
		(Xleft)
		    for prependS in "${(@)prependL}"; do
			alias -g "${prependS}${targetS}{"="${modUS}_${targetS}{";  done  ;;
		(*)
		    errI=4;  print -v errS 
                        -f "invalid typeS value seen in \"%s\" var: %s; must be one of  ( %s )" -- \
			${modUS}_V_abbrevM  ${typeS}  "singular  pair  right  left";  break 2 ;;  esac
	done;  errB=${B_F};  break;  done
    if [[ ${errB} -ne ${B_F} ]]; then
	print -v errS -f "%s:  { %s;  errI=%d }" --  $0  ${errS}  ${errI}
	BOOL_G  ${modUS}_errB=${B_T}
	INT_G   ${modUS}_errI=${errI}
	STR_G   ${modUS}_errS=${errS}
	return ${B_F};  fi
    return ${B_T}
}


# DESC
#     initializes module.  intended to be called by INTERNAL_FRAMEWORK_loadDependencies
#
# USAGE
#     ..._F_init
#
function ${modUS}_F_init() {
    INT_L   resultI
    INTERNAL_FRAMEWORK_A_localErrvarsCreate
    INTERNAL_FRAMEWORK_A_retsReset
    INTERNAL_REP_A_selfmodSetup
    
    eval ${modUS}_F_abbrevsCreate;  resultI=$?
    if [[ ${resultI} -ne ${B_T} ]]; then
	errI=1
	print -v errS -f "%s:  { %s;  errI=%d }" --  $0  ${(P)${:-${modUS}_V_errS}}  ${errI}
	BOOL_G  ${modUS}_errB=${B_T}
	INT_G   ${modUS}_errI=${errI}
	STR_G   ${modUS}_errS=${errS}
	return ${B_F};  fi
    return ${B_T}
}


#}CODEGEN_ACTIVE
fi
true
