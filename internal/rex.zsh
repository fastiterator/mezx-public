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

STR_L   modS=internal/rex
STR_L   modUS=${(U)modS//\//_}
INTERNAL_FRAMEWORK_A_defStart
LIST_L  modL=( );  INTERNAL_FRAMEWORK_A_loadDependencies
INTERNAL_FRAMEWORK_A_retsReset


STR_L   selfS=${modUS}_A_selfmodSetup
alias ${selfS}='
    STR_L   modS="'${modS}'"  modUS="'${modUS}'";
'


# global regex constants

# USAGE
#     rexAdd_SE <nameS> <valueS>;  eval ${(U)modS}_V_replyS
#
# NOTE
#     Eval of ${modUS}_V_replyS creates:
#         STR_L   <nameS>=<valueS>
#         STR_G   ${modUS}_C_<nameS>=<valueS>
#         LIST_G  ${modUS}_C_reNameL (and adds <nameS> as its last element)
#
function ${modUS}_F_rexAdd_SE() {
    eval INTERNAL_REX_A_selfmodSetup
    STR_L   errS=  replyS=  sepS=  qd_S='"'  reRexnameS='^[_A-Za-z][_A-Za-z0-9]*S$';
    INT_L   errI=0
    BOOL_L  errB=${B_T}  retB=${B_F}
    LIST_L  match mbegin mend
 
    repeat 1; do
        INTERNAL_FRAMEWORK_A_retsReset
        if [[ $# -ne 2 ]]; then
            errI=1;  print -v errS -f "arg count is not 2";  break;  fi
        if ! [[ $1 =~ ${reRexnameS} ]]; then
            errI=2;  print -v errS -f "%s%s%s arg does not match %s%s%s regex (%s%s%s): %s%s%s" -- \
                ${qd_S} nameS ${qd_S}  ${qd_S} reRexnameS ${qd_S}  ${qd_S} ${reRexnameS} ${qd_S}  ${qd_S} $1 ${qd_S};  break;  fi
        print -v replyS -f "%s%sSTR_L   %s=%q" -- \
            "${replyS}"  "${sepS}"  "$1"  "$2";  sepS=";  "
        print -v replyS -f "%s%sSTR_G   %s_C_%s=%q" -- \
            "${replyS}"  "${sepS}"  ${modUS}  "$1"  "$2";  sepS=";  "
        print -v replyS -f "%s%sLIST_G  %s" -- \
            "${replyS}"  "${sepS}"  ${modUS}_C_reNameL;  sepS=";  "
        print -v replyS -f "%s%sLIST_G  %s=( %s\${(@)%s}%s %s )" -- \
            "${replyS}"  "${sepS}"  ${modUS}_C_reNameL  ${qd_S} ${modUS}_C_reNameL ${qd_S}  "$1";  sepS=";  "
        STR_G   ${modUS}_V_replyS=${replyS};
        errB=${B_F};  retB=${B_T}
        break; done
    if [[ ${errB} -ne ${B_F} ]]; then
        print -v errS -f "%s: %s" --  $0  ${errS}
        BOOL_G  ${modUS}_V_errB=${errB}
        INT_G   ${modUS}_V_errI=${errI}
        STR_G   ${modUS}_V_errS=${errS}; fi
    return ${retB}
}


alias ${modUS}_A_rexAdd='
    '${modUS}_F_rexAdd_SE' "$1" "$2";
    if [[ ${'${modUS}_V_errB'} -ne ${B_F} ]]; then  ;
        print -v errS -f "call to \"%s\" failed;  errS=%s;  errI=%d" -- \
            '${modUS}_F_rexAdd_SE'  ${'${modUS}_V_errS'}  ${'${modUS}_V_errI'};  break;  fi;
    eval ${'${modUS}_V_replyS'};  INT_L   resultI=$?;
    if [[ ${resultI} -ne 0 ]]; then  ;
        print -v errS -f "eval of return from \"%s\" failed;  retI=%d;  replyS=%s" -- \
            '${modUS}_F_rexAdd_SE'  ${resultI}  ${'${modUS}_V_replyS'};  unset resultI;  break;  fi;
    unset resultI;
'


# USAGE
#     ..._F_strEscape  <stringS>
#
# RETURN
#     On success:
#       - ${B_T} return value
#       - ${B_F} (i.e. true) in ${modUS}_V_errB
#       - Escaped string in ${modUS}_V_replyS
#     On error:
#       - ${B_F} return value
#       - ${B_T} (i.e. true) in ${modUS}_V_errB
#       - Detailed error text in ${modUS}_V_errS
#
function ${modUS}_F_strEscape() {
    eval INTERNAL_REX_A_selfmodSetup
    STR_L   strS  replyS
    INT_L   errI=0
    BOOL_L  errB=${B_T}  retB=${B_F}
    STR_L   charS  bslashS='\'  escapeS='(){}[].+*?^$|\'
    INT_L   indexI
 
    repeat 1; do
        INTERNAL_FRAMEWORK_A_retsReset
	if [[ $# -ne 1 ]]; then
	    errB=${B_T}  errI=1
	    print -v errS -f "argcI != 1: %d" -- $#;  break;  fi
	strS=$1
	for indexI in {1..${#strS}}; do
	    charS=${strS[${indexI}]}
	    if [[ ${escapeS} = *${charS}* ]]; then
		replyS+="${bslashS}"; fi
	    replyS+="${charS}";  done
        STR_G   ${modUS}_V_replyS=${replyS};
        errB=${B_F}  retB=${B_T}
        break; done
    if [[ ${errB} -ne ${B_F} ]]; then
        print -v errS -f "%s: %s" --  $0  ${errS}
        BOOL_G  ${modUS}_V_errB=${errB}
        INT_G   ${modUS}_V_errI=${errI}
        STR_G   ${modUS}_V_errS=${errS}; fi
    return ${retB}
}


function ${modUS}_F_main() {
    eval INTERNAL_REX_A_selfmodSetup
    STR_L   varnameS  errS=
    INT_L   errI=0
    BOOL_L  errB=${B_T}  retB=${B_F}
 
    alias REXADD=${modUS}_A_rexAdd
    repeat 1; do
        set reCharUnderS '_'; eval REXADD
        set reRangeDigitS '0-9'; eval REXADD
        set reRangeAlphaUpperS 'A-Z'; eval REXADD
        set reRangeAlphaLowerS 'a-z'; eval REXADD
        set reRangeAlphaS "${reRangeAlphaUpperS}${reRangeAlphaLowerS}"; eval REXADD
        set reSetDigitS "[${reRangeDigitS}]"; eval REXADD
        set reSetAlphaUpperS "[${reRangeAlphaUpperS}]"; eval REXADD
        set reSetAlphaLowerS "[${reRangeAlphaLowerS}]"; eval REXADD
        set reSetAlphaS "[${reRangeAlphaS}]"; eval REXADD
        set reSetAlphaUnderS "[${reRangeAlphaS}${reCharUnderS}]"; eval REXADD
        set reSetAlphaDigitS "[${reRangeAlphaS}${reRangeDigitS}]"; eval REXADD
        set reSetAlphaDigitUnderS "[${reRangeAlphaS}${reRangeDigitS}${reCharUnderS}]"; eval REXADD
 
        set reVartypeShort_S "(B|I|S|F|E|L|M|ST|STD)";  eval REXADD
        set reAlphaZerop_S "(${reSetAlphaS}*)"; eval REXADD
        set reAlphaOnep_S "(${reSetAlphaS}+)"; eval REXADD
        set reDigitZerop_S "(${reSetDigitS}*)"; eval REXADD
        set reDigitOnep_S "(${reSetDigitS}+)"; eval REXADD
        set reAlphaDigitZerop_S "(${reSetAlphaDigitS}*)"; eval REXADD
        set reAlphaDigitOnep_S "(${reSetAlphaDigitS}+)"; eval REXADD
        set reAlphaDigitUnderZerop_S "(${reSetAlphaDigitUnderS}*)"; eval REXADD
        set reAlphaDigitUnderOnep_S "(${reSetAlphaDigitUnderS}+)"; eval REXADD
        set reIdent_S "(${reSetAlphaUnderS}${reAlphaDigitUnderZerop_S})"; eval REXADD
        set reVarname_S "(${reIdent_S}${reVartypeShort_S})";  eval REXADD
        set reNumrange_S "(${reDigitOnep_S}|${reDigitOnep_S}-${reDigitOnep_S})"; eval REXADD
 
        for varnameS in AlphaZerop  AlphaOnep  DigitZerop  DigitOnep  AlphaDigitZerop  AlphaDigitOnep \
                AlphaDigitUnderZerop  AlphaDigitUnderOnep  Ident  Varname  Numrange;  do
            set re${varnameS}F_S "${(P)${:-re${varnameS}_S}}";  eval REXADD
            set re${varnameS}A_S "^${(P)${:-re${varnameS}_S}}$";  eval REXADD;  done
        errB=${B_F};  done
    unalias REXADD
    return ${B_T}
}


${modUS}_F_main
INTERNAL_FRAMEWORK_F_modCacheWrite \
    --module ${modS} \
    --exclude func   ${modUS}_F_main  ${modUS}_F_rexAdd_SE \
    --exclude alias  ${modUS}_A_rexAdd
INTERNAL_FRAMEWORK_A_defEnd
