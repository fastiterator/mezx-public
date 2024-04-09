#!/bin/zsh


# type aliases
 
alias LOCAL='typeset +g'
 
alias STR_L='LOCAL'
alias INT_L='LOCAL -i'
alias FLOATE_L='LOCAL -E'
alias FLOATF_L='LOCAL -F'
alias LIST_L='LOCAL -a'
alias MAP_L='LOCAL -A'
alias BOOL_L='INT_L'
 
alias GLOBAL='typeset -g'
alias STR_G='GLOBAL'
alias INT_G='GLOBAL -i'
alias FLOATE_G='GLOBAL -E'
alias FLOATF_G='GLOBAL -F'
alias LIST_G='GLOBAL -a'
alias MAP_G='GLOBAL -A'
alias BOOL_G='INT_G'


# module name
 
STR_L   modS=internal/framework
STR_L   modUS=${(U)modS//\//_}


# global misc constants
 
INT_L   B_T=0  B_F=1  B_N=2
STR_L   evalS=
evalS+=";  MAP_G   ${modUS}_C_initToTypenameM=( B BOOL   I INT   S STR   F FLOATF   E FLOATE"
evalS+="   L LIST   M MAP   ST STRUCT  SD STRUCTDEF )"
evalS+=";  MAP_G   ${modUS}_C_typenameToInitM=( )"
eval ${evalS};  evalS=
STR_L   kS  vS
for kS vS in ${(kvP)${:-${modUS}_C_initToTypenameM}}; do
    evalS+=";  ${modUS}_C_typenameToInitM[${vS}]=${kS}";  done
eval ${evalS};  evalS=
evalS+=";  LIST_G  ${modUS}_C_typenameL=( \${(k)${modUS}_C_typenameToInitM} )"
evalS+=";  LIST_G  ${modUS}_C_initL=( \${(v)${modUS}_C_typenameToInitM} )"
evalS+=";  MAP_G   ${modUS}_C_initToStartvalueM=( B \"\${B_T}\"   I \"0\"   S \"\"   F \"0.0\"   E \"0.0\""
evalS+="   L \"()\"   M \"()\"   ST \"NULL\"   SD \"NULL\" )"
eval ${evalS};  evalS=


# global char constants

MAP_L   nametocharM=(
    exclamationpoint '!'  exclamation '!'  excl '!'  ep '!'  bang '!'
    signat '@'  atsign '@'  at '@'
    pound '#'  lb '#'  comment '#'
    dollar '$'  dlr '$'
      regexend '$'  reend '$'  reterm '$'
    percent '%'  pct '%'
    caret '^'  circumflex '^'  cflex '^'  cf '^'
        regexstart '^'  restart '^'  reinitial '^'  reinit '^'
    and '&'
    or '|'  pipe '|'  barvertical '|'  verticalbar '|'  bvertical '|'  vbar '|'  bv '|'  vb '|'
    asterisk '*'  ast '*'  star '*'  splat '*'  glob '*'
        rezeroormore '*'  rezeromore '*'  rezm '*'
    parenleft '('  parenl '('  pl '('
        regroupopen '('  regroupo '('  rego '('  regroupleft '('  regroupl '('  regl '('
    parenright ')'  parenr ')'  pr ')'
        regroupclose ')'  regroupc ')'  regc ')'  regroupright ')'  regroupr ')'  regr ')'
    bracecurlyleft '{'  bcurlyl '{'  bcl '{'  bracecurlyopen '{'  bcurlyo '{'  bco '{'
    bracecurlyright '}'  bcurlyr '}'  bcr '}'  bracecurlyclose '}'  bcurlyc '}'  bcc '}'
    bracketsquareleft '['  bsquarel '['  bsl '['  bracketsquareopen '['  bsquareo '['  bso '['
        resetopen '['  reseto '['  reso '['  setopen '['  seto '['  so '['  setleft '['
    bracketsquareright ']'  bsquarer ']'  bsr ']'  bracketsquareclose ']'  bsquarec ']'  bsc ']'
        resetclose ']'  resetc ']'  resc ']'  setclose ']'  setc ']'  sc ']'  setright ']'
    dash '-'  minus '-'  min '-'
        rerangejoin '-'  rerangej '-'  rerj '-'
    underline '_'  under '_'  ul '_'
    plus '+'
        reoneormore '+'  reonemore '+'  reom '+'
    equalssign '='  equals '='  eq '='
    tilde '~'  tld '~'  td '~'
    bracketangleleft '<'  banglel '<'  bal '<'
        lessthan '<'  less '<'  lt '<'
    bracketangleright '>'  bangler '>'  bar '>'
        greaterthan '>'  greater '>'  gt '>'  more '>'
    semicolon ';'  colonsemi ';'  csemi ';'  semi ';'  cs ';'
    colon ':'  colonfull ':'  cfull ':'  cf ':'
    quotedouble '"'  qdouble '"'  qd '"'
    quotesingle "'"  qsingle "'"  qs "'"
    comma ','
    dot '.'  period '.'
      reanychar '.'  reany '.'
    questionmark '?'  markquestion '?'  question '?'  markq '?'  mq '?'  qm '?'  q '?'
      rezeroorone '?'  rezeroone '?'  rez1 '?'
    slashforward '/'  slashf  '/'  sf '/'
        divide '/'  div '/'
    slashbackward '\'  slashb '\'  sb '\'  bs '\'
    quoteback '`'  tickback '`'  qback '`'  tback '`'  qb '`'  tb '`'
    space ' '  sp ' '
)
 
MAP_L   unprintNameToDecM=(
    nul  0   soh  1   stx  2   etx  3   eot  4   enq  5   ack  6   bel  7
    bs   8   tab  9   lf  10   vt  11   ff  12   cr  13   so  14   si  15
    dle 16   dc1 17   dc2 18   dc3 19   dc4 20   nak 21   syn 22   etb 23
    can 24   em  25   sub 26   esc 27   fs  28   gs  29   rs  30   us  31
    spc 32   del 127
    c_at 0   c_A  1   c_b  2   c_c  3   c_d  4   c_e  5   c_f  6   c_g  7
    c_h  8   c_i  9   c_j 10   c_k 11   c_l 12   c_m 13   c_n 14   c_o 15
    c_p 16   c_q 17   c_r 18   c_s 19   c_t 20   c_u 21   c_v 22   c_w 23
    c_x 24   c_y 25   c_z 26   c_tilde 127   c_qmark 127
)
 
INT_L   decI
STR_L   hexS  charS  realkeyS
for kS vS in ${(kv)unprintNameToDecM}; do
    print -v hexS -f '%x' ${vS}
    print -v charS -f "\x${hexS}"
    realkeyS=${kS}
    if ! [[ ${kS} =~ '^c_' ]]; then
	realkeyS="np_${kS}";  fi
    nametocharM[${realkeyS}]=${charS}
done
 
STR_L   vS_printS
evalS+=";  MAP_G   ${modUS}_CI_nametocharM=( )"
eval ${evalS};  evalS=
for kS vS in ${(@kv)nametocharM}; do
    print -v vS_printS -f "%q" -- ${vS}
    eval "${modUS}_CI_nametocharM[\${kS}]=${vS_printS}"
done
unset  kS  vS  evalS  nametocharM
set +vx

# global regex constants

STR_L   reSetIdentInitialcharS='[A-Za-z]'
STR_L   reSetIdentRestcharS='[A-Za-z0-9_]'
STR_L   reSetIdentLowInitialcharS='[a-z]'
STR_L   reSetIdentLowRestcharS='[a-z0-9_]'
STR_L   reSetIdentHighInitialcharS='[A-Z]'
STR_L   reSetIdentHighRestcharS='[A-Z0-9_]'
STR_L   reSetDigitS='[0-9]'
STR_L   reSetDigitNonzeroS='[1-9]'
STR_L   reSetFilenameS='[-A-Za-z0-9_@#%=~.]'
 
STR_L   reIdentX_S=${reSetIdentInitialcharS}${reSetIdentRestcharS}'*'
STR_L   reNumPosX_S="${reSetDigitNonzeroS}${reSetDigitS}*"
STR_L   reNumNonnegX_S="${reSetDigitS}+"
STR_L   reIdentLowX_S=${reSetIdentLowInitialcharS}${reSetIdentLowRestcharS}'*'
STR_L   reIdentHighX_S=${reSetIdentHighInitialcharS}${reSetIdentHighRestcharS}'*'
STR_L   reVartypeShortX_S=${(j:|:)${(P)${:-${modUS}_C_initL}}}
STR_L   reTypenameX_S=${(j:|:)${(P)${:-${modUS}_C_typenameL}}}
STR_L   reFilenameX_S=${reSetFilenameS}${reSetFilenameS}'*'
STR_L   rePathnameX_S='(/?'${reFilenameX_S}'(/'${reFilenameX_S}')*)'
 
STR_L   nameS  typeS  initS  letterS
LIST_L  nameL  name2L
for nameS in \
    Ident  NumPos  NumNonneg  IdentLow  IdentHigh  VartypeShort  Typename  Filename  Pathname \
    ; do
    STR_L   re${nameS}F_S="(${(P)${:-re${nameS}X_S}})"
    STR_L   re${nameS}A_S="^${(P)${:-re${nameS}F_S}}$"
    name2L+=( ${nameS} );  done
 
STR_L   reModnameX_S="${reIdentLowF_S}(/${reIdentLowF_S})"'*'
STR_L   reModUSnameX_S="${reIdentHighF_S}(_${reIdentHighF_S})"'*'
STR_L   reFuncnameX_S="${reIdentF_S}"
STR_L   reVarnameX_S="${reIdentF_S}${reVartypeShortF_S}"
STR_L   reAliasnameX_S="${reIdentF_S}"

for typeS initS in ${(kv)${(P)${:-${modUS}_C_typenameToInitM}}}; do
    STR_L   re${(C)typeS}nameX_S="${reIdentF_S}${initS}";  done
 
LIST_L  nameL=( Mod  ModUS  Func  Var  Alias )
for nameS in ${(k)${(P)${:-${modUS}_C_typenameToInitM}}}; do
    nameL+=( ${(C)${(L)nameS}} );  done
for nameS in ${nameL}; do
    STR_L   re${nameS}nameF_S="(${(P)${:-re${nameS}nameX_S}})"
    STR_L   re${nameS}nameA_S="^${(P)${:-re${nameS}nameF_S}}$"
    name2L+=( ${nameS}name );  done
 
STR_L   reStructtypenameX_S="${reModUSnameF_S}_${reStructdefnameF_S}"
STR_L   reStructfieldnameX_S="${reIdentF_S}([.]${reIdentF_S})*"
STR_L   reStructrefX_S="${reIdentF_S}"
STR_L   reVarrefX_S="^${reModUSnameF_S}_V_${reTypenameF_S}_value_L\[${reNumPosF_S}\]$"
LIST_L  nameL=( Structtypename  Structref  Structfieldname  Varref )
for nameS in ${nameL}; do
    STR_L   re${nameS}F_S="(${(P)${:-re${nameS}X_S}})"
    STR_L   re${nameS}A_S="^${(P)${:-re${nameS}F_S}}$"
    name2L+=( ${nameS} );  done
 
for nameS in ${name2L}; do
    for letterS in F A; do
        STR_G  ${modUS}_C_re${nameS}${letterS}_S=${(P)${:-re${nameS}${letterS}_S}};  done;  done
 
for nameS in  IdentInitialchar  IdentRestchar  IdentLowInitialchar  IdentLowRestchar  IdentHighInitialchar  IdentHighRestchar  Digit  DigitNonzero; do
    name2L+=( Set${nameS} );  done
 
for nameS in ${name2L}; do
    unset  re${nameS}{,{X,F,A}_}S;  done



# foundational supporting functions and aliases


STR_L   selfS=${modUS}_A_listToStrR
alias ${selfS}="${modUS}_F_arrayToStrR"


STR_L   selfS=${modUS}_A_localErrvarsCreate
# USAGE
#     <selfS>
#
# NOTE
#     - Since callers in effect have no way of catching errors thrown by this alias,
#       it cannot use "break" to break out beyond its borders.
#
STR_G ${selfS}_SE='
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasEntry;
    BOOL_L  errB=${B_F};
    INT_L   errI=0  curerrI=0  errbaseI=1;
    STR_L   errS=;
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
'
alias ${selfS}="${(P)${:-${selfS}_SE}}"


STR_L   selfS=${modUS}_A_localErrvarsDestroy
# USAGE
#     <selfS>
#
# NOTE
#     - Since callers in effect have no way of catching errors thrown by this alias,
#       it cannot use "break" to break out beyond its borders.
#
STR_G   ${selfS}_SE='
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasEntry;
    unset  errB  errI  errS;
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_localMatchvarsCreate
# USAGE
#     <selfS>
#
# NOTE
#     - Since callers in effect have no way of catching errors thrown by this alias,
#       it cannot use "break" to break out beyond its borders.
#
STR_G   ${selfS}_SE='
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasEntry;
    LIST_L  match  mbegin  mend;
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_localMatchvarsDestroy
# USAGE
#     <selfS>
#
# NOTE
#     - Since callers in effect have no way of catching errors thrown by this alias,
#       it cannot use "break" to break out beyond its borders.
#
STR_G   ${selfS}_SE='
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasEntry;
    unset   match  mbegin  mend;
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_localArgvarsCreate
# USAGE
#     <selfS>
#
# NOTE
#     - Since callers in effect have no way of catching errors thrown by this alias,
#       it cannot use "break" to break out beyond its borders.
#
STR_G   ${selfS}_SE='
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasEntry;
    INT_L   argcReqI  argcI=$#  argindexI=1  argerrB=${B_T};
    LIST_L  argL=( "${(@)@}" );
    STR_L   argnameS  arglhsS  argrhsS;
    STR_L   argevalS=  argS=   argL_S=UNDEF;
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_localArgvarsDestroy
# USAGE
#     <selfS>
#
# NOTE
#     - Since callers in effect have no way of catching errors thrown by this alias,
#       it cannot use "break" to break out beyond its borders.
#
STR_G   ${selfS}_SE='
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasEntry;
    unset   argcI  argcReqI  argindexI  argL  argS  argL_S
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_localReplyvarsCreate
# USAGE
#     <selfS>
#
# NOTE
#     - Since callers in effect have no way of catching errors thrown by this alias,
#       it cannot use "break" to break out beyond its borders.
#
STR_G   ${selfS}_SE='
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasEntry;
    BOOL_L    replyB=${B_N};
    INT_L     replyI=0;
    STR_L     replyS=;
    FLOATF_L  replyF=0.0;
    FLOATE_L  replyE=0.0;
    LIST_L    replyL=( );
    MAP_L     replyM=( );
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_localReplyvarsDestroy
# USAGE
#     <selfS>
#
# NOTE
#     - Since callers in effect have no way of catching errors thrown by this alias,
#       it cannot use "break" to break out beyond its borders.
#
STR_G   ${selfS}_SE='
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasEntry;
    unset     replyB  replyI  replyS  replyF  replyE  replyL  replyM
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_F_varsMakeStandardSE
# USAGE
#     <selfS>  <modUS>
#
# NOTE
#     This is used by ...F_retsReset, thus it cannot depend on ...F_retsReset, or anything else other than:
#       ..._A_selfmodSetup  ..._A_localErrvarsCreate  ..._A_localMatchvarsCreate
#
function ${selfS}() {
    setopt  LOCAL_OPTIONS  NO_LOCAL_LOOPS
    eval INTERNAL_FRAMEWORK_A_selfmodSetup
    eval ${modUS}_A_localErrvarsCreate
    eval ${modUS}_A_localMatchvarsCreate
    STR_L   argmodS  replyS  argmodUS  formatS=
    LIST_L  argmodUS_repL=()
 
    repeat 1; do
        errB=${B_T}
        BOOL_G  ${modUS}_V_errB=${B_F}
        INT_G   ${modUS}_V_errI=0
        STR_G   ${modUS}_V_errS=
        if [[ $# -ne 1 ]]; then
            errI=1;  print -v errS -f "arg count not 1: %d" --  $#;  break;  fi
        argmodS=$1
        if ! [[ ${argmodS} =~ ${(P)${:-${modUS}_C_reModnameA_S}} ]]; then
            errI=2;  print -v errS -f "\"%s\" arg value does not match \"%s\" regex (\"%s\"): \"%s\"" -- \
                modS  ${modUS}_C_reModnameA_S  ${(P)${:-${modUS}_C_reModnameA_S}}  ${argmodS};  break;  fi
        argmodUS=${(U)argmodS//\//_}
        argmodUS_repL=( ${argmodUS} ${argmodUS} ${argmodUS} ${argmodUS} ${argmodUS} ${argmodUS} ${argmodUS} \
                        ${argmodUS} ${argmodUS} ${argmodUS} ${argmodUS} ${argmodUS} ${argmodUS} ${argmodUS} )
        formatS+="BOOL_G     %s_V_errB=${B_F}  %s_V_replyB=${B_T}; \\n"
        formatS+="INT_G      %s_V_errI=0  %s_V_replyI=0; \\n"
        formatS+="STR_G      %s_V_errS=  %s_V_replyS=; \\n"
        formatS+="FLOATE_G   %s_V_errE=0.0  %s_V_replyE=0.0; \\n"
        formatS+="FLOATF_G   %s_V_errF=0.0  %s_V_replyF=0.0; \\n"
        formatS+="LIST_G     %s_V_errL=()  %s_V_replyL=(); \\n"
        formatS+="MAP_G      %s_V_errM=()  %s_V_replyM=(); \\n"
        print -v replyS -f ${formatS} --  ${(@)argmodUS_repL}
        errB=${B_F};  done
    if [[ ${errB} -ne ${B_F} ]]; then
        if [[ ${errI} -eq 0 ]]; then
            errI=3;  errS=${(P)${:-${modUS}_V_errS}};  fi
        print -v errS -f "%s:  { %s;  errI=%d }" -- \
              ${selfS}  ${errS}  ${errI}
        BOOL_G  ${modUS}_V_errB=${B_T}
        INT_G   ${modUS}_V_errI=${errI}
        STR_G   ${modUS}_V_errS=${errS}
        break
    else
        STR_G    ${modUS}_V_replyS=${replyS}
        STR_G    ${argmodUS}_C_retsResetSE=${replyS};  fi
    return ${B_T}
}


STR_L   selfS=${modUS}_F_retsReset
# USAGE
#     <selfS>  <modS>
#
# NOTE
#   It is critically important that this function depends on no functions or aliases other than:
#       ..._F_varsMakeStandardSE  ..._A_selfmodSetup  ..._A_localErrvarsCreate  ..._A_localMatchvarsCreate
#
function ${selfS}() {
    setopt  LOCAL_OPTIONS  NO_LOCAL_LOOPS
    eval INTERNAL_FRAMEWORK_A_selfmodSetup
    STR_L   argmodS  argmodUS  calleemodUS  calleeS
    STR_L   evalS
 
    repeat 1; do
        eval ${modUS}_A_localErrvarsCreate
        eval ${modUS}_A_localMatchvarsCreate
        errB=${B_T}
        if [[ $# -ne 1 ]]; then
            errI=$(( ${errbaseI} + 0 ))
            print -v errS -f "arg count not 1: %d" --  ${selfS}  $#;  break;  fi
        argmodS=$1
        if ! [[ ${argmodS} =~ ${(P)${:-${modUS}_C_reModnameA_S}} ]]; then
            errI=$(( ${errbaseI} + 1 ))
            print -v errS -f "\%s\" arg value does not match \"%s\" regex (\"%s\"): \"%s\"" -- \
                argmodS  ${modUS}_C_reModnameA_S  ${(P)${:-${modUS}_C_reModnameA_S}}  ${argmodS};  break;  fi
        argmodUS=${(U)argmodS//\//_}
        if [[ ${(P)+${:-${argmodUS}_C_retsResetSE}} -eq 0 ]]; then
            calleemodUS=${modUS}  calleeS=F_varsMakeStandardSE;  eval ${calleemodUS}_${calleeS}  ${argmodS};  fi
        calleemodUS=${argmodUS}  calleeS=${argmodUS}_C_retsResetSE;  eval ${(P)${:-${argmodUS}_C_retsResetSE}}
        errB=${B_F};  done
    if [[ ${errB} -ne ${B_F} ]]; then
        if [[ ${errI} -eq 0 ]]; then
            errI=$(( ${errbaseI} + 2 ))
            print -v errS -f "call to \"%s_%s\" failed: { %s;  errI=%d }" -- \
                  ${calleemodUS}  ${calleeS}  ${(P)${:-${calleemodUS}_V_errS}}  ${(P)${:-${calleemodUS}_V_errI}};  fi
        print -v errS -f "%s:  { %s;  errI=%d }" -- \
              ${selfS}  ${errS}  ${errI}
        break;  fi
    return ${B_T}
}


STR_L   selfS=${modUS}_A_retsReset
# USAGE
#     errbaseI=<errbaseI>  modS=<modnameS>  <selfS>
#
# CRITICAL NOTE
#   It is important that this alias depends on no other functions or aliases, other than:
#       ..._F_retsReset  ..._A_aliasEntry  ..._A_aliasExit
#       ..._A_localErrvarsCreate_SE  ..._A_localMatchvarsCreate_SE
#       ..._C_re*
#
# NOTES
#     - must be used within a loop (e.g. "repeat 1; do")
#     - requires that ${errbaseI} be set
#     - updates ${errbaseI}
#     - sets errI and errS on error
#
STR_G   ${selfS}_SE='
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasEntry;
    function {
        setopt  NO_LOCAL_LOOPS  LOCAL_OPTIONS;
        INT_L   resultI=0;
        BOOL_G  '${modUS}'_V_errB=${B_F};
        INT_G   '${modUS}'_V_errI=0;
        STR_G   '${modUS}'_V_errS=;
        '"${(P)${:-${modUS}_A_localErrvarsCreate_SE}}"' ;
        '"${(P)${:-${modUS}_A_localMatchvarsCreate_SE}}"' ;
        repeat 1; do  ;
            if [[ ${+modS} -eq 0 ]]; then  ;
                errI=$(( ${errbaseI} + 0 ));  print -v errS -f "\"%s\" var not defined" -- \
                    modS;  break;  fi;
            case ${(t)modS} in
                (scalar*) ;;
                (*)
                    errI=$(( ${errbaseI} + 1 ));
                    print -v errS -f "\"%s\" var not \"%s*\" type: \"%s\"" -- \
                        modS  scalar  ${(t)modS};  break ;;  esac;
            if ! [[ ${modS} =~ ${'${modUS}_C_reModnameA_S'} ]]; then
                errI=$(( ${errbaseI} + 2 ));
                print -v errS -f "\"%s\" var does not match \"%s\" regex (\"%s\"): \"%s\"" -- \
                    '${modUS}_C_reModnameA_S'  ${'${modUS}_C_reModnameA_S'}  "${modS}";  break;  fi;
            '${modUS}_F_retsReset' ${modS};  resultI=$?;
            if [[ ${resultI} -ne 0 ]]; then  ;
                errI=$(( ${errbaseI} + 3 ));
                print -v errS -f "call to \"%s\" failed; retI=%d" -- \
                    '${modUS}_F_retsReset'  ${resultI};  break;  fi;
            errB=${B_F};  done;
        if [[ ${errB} -ne ${B_F} ]]; then  ;
            if [[ ${errI} -eq 0 ]]; then  ;
                errI=$(( ${errbaseI} + 4 ));  errS=${'${modUS}_V_errS'};  fi;
            print -v errS -f "%s:  { %s;  errI=%d }\n" --  '${selfS}'  ${errS}  ${errI};
            BOOL_G  '${modUS}_V_errB'=${B_T};
            INT_G   '${modUS}_V_errI'=${errI};
            STR_G   '${modUS}_V_errS'=${errS};
            STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
            : "'${selfS}' EXIT (error)";
            break;  fi;
    }
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
    : "'${selfS}' EXIT (ok)";
    errbaseI+=5;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_callSimple
#
# USAGE
#     calleemodUS=<calleemodUS>  calleeS=<calleeS>;  <selfS>  <funcarg>...
#
STR_G   ${selfS}_SE='eval ${calleemodUS}_${calleeS}'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_localCallsimplevarsCreate
#
# USAGE
#     eval <selfS>
#
STR_G   ${selfS}_SE='
    BOOL_L  okB=${B_F};
    STR_L   calleemodUS  calleeS  evalS;
    INT_L   curerrI;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_localModCommonvarsCreate
#
# USAGE
#     eval <selfS>
#
STR_G   ${selfS}_SE='
; '
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_funcStart
#
# USAGE
#     eval <selfS>
#
# NOTE
#     requires that modS and modUS be properly set prior to invocation
#
STR_G   ${selfS}_SE='
    setopt  NO_LOCAL_LOOPS;
    '"${INTERNAL_FRAMEWORK_A_localErrvarsCreate_SE}"' ;
    '"${INTERNAL_FRAMEWORK_A_localMatchvarsCreate_SE}"' ;
    '"${INTERNAL_FRAMEWORK_A_localReplyvarsCreate_SE}"' ;
    '"${INTERNAL_FRAMEWORK_A_localArgvarsCreate_SE}"' ;
    '"${INTERNAL_FRAMEWORK_A_localCallsimplevarsCreate_SE}"' ;
    '"${(P)${:-${modUS}_A_localModCommonvarsCreate_SE}}"' ;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_funcEnd
#
# USAGE
#     eval <selfS>
#
STR_G   ${selfS}_SE='
    if [[ ${okB} -ne ${B_T} ]]; then  ;
        if [[ ${errI} -eq 0 ]]; then  ;
            errI=${curerrI};
            print -v errS -f "call to \"%s_%s\" failed:  { %s; errI=%d }" -- \
                  "${calleemodUS}"  "${calleeS}"  ${(P)${:-${calleemodUS}_V_errS}}  ${(P)${:-${calleemodUS}_V_errI}};  fi;
        print -v errS -f "%s:  { %s; errI=%d }" -- \
              $0  ${errS}  ${errI};
        evalS="${modUS}_V_errB=\${B_T}  ${modUS}_V_errS=\${errS}  ${modUS}_V_errI=\${errI}";
        eval ${evalS};  break;  fi;
    evalS="${modUS}_V_replyI=\${replyI}  ${modUS}_V_replyS=\${replyS};  ${modUS}_V_replyL=()  ${modUS}_V_replyM=();  ";
    evalS+="if  [[ \${#replyL} -gt 0 ]]; then  ${modUS}_V_replyL=( \"\${(@)replyL}\" );  fi; ";
    evalS+="if  [[ \${#replyM} -gt 0 ]]; then  ${modUS}_V_replyM=( \"\${(kv@)replyM}\" );  fi; ";
    eval ${evalS};
    return ${B_T};
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_argL_to_argL_S
# USAGE
#     <selfS>
#
# NOTES
#     - must be used within a loop (e.g. "repeat 1; do")
#     - requires that ${errbaseI} is set
#     - requires that ${argL} is set
#     - updates ${errbaseI}
#     - sets errI and errS on error
#
STR_G   ${selfS}_SE='
    : "entering '"${selfS}"'";
    eval '${modUS}_F_retsReset' '${modS}';
    eval '${modUS}_F_arrayToStrR' -A -p argL;
    if [[ ${'${modUS}_V_errB'} -ne ${B_F} ]]; then  ;
        errI=${errbaseI};
        print -v errS -f "call to \"%s\" failed:  { %s; errI=%d }" \
              '${modUS}_F_arrayToStrR'  ${'${modUS}_V_errS'}  ${'${modUS}_V_errI'};
        break;  fi;
    argL_S=${'${modUS}_V_replyS'};
    errbaseI+=1;
    : "exiting '"${selfS}"'";
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_F_rexValid
# USAGE
#     <selfS>  <reS>
#
# DESCRIPTION
#     Checks the validity of the <reS> regex.
#
#     On no error:
#         ..._V_errB=${B_F}
#         ..._V_replyB=${B_(T|F)}
#         ..._V_replyS=<human-readable_answer>
#
#     On error:
#         ..._V_errB=${B_T}
#         ..._V_errI=<errI>
#         ..._V_errS=<error_str>
#
function ${selfS}() {
    setopt  NO_LOCAL_LOOPS
    eval INTERNAL_FRAMEWORK_A_selfmodSetup
    eval ${modUS}_F_retsReset ${modS}
    eval ${modUS}_A_localErrvarsCreate
    eval ${modUS}_A_localMatchvarsCreate
    eval ${modUS}_A_localArgvarsCreate
    eval ${modUS}_A_localReplyvarsCreate
    LIST_L   optS_L
    STR_L    optS  outS  formatS  reS
 
    errB=${B_T}  replyB=${B_T}
    repeat 1; do
        if [[ ${argcI} -ne 1 ]]; then
            errI=1
            print -v errS -f "argcI is not 1: %d" --  ${argcI};  break;  fi
        reS=$1
        setopt | while read optS; do  optS_L+=( ${optS} );  done
        setopt noxtrace noverbose
        [[ '' =~ ${reS} ]] |& read outS
        setopt ${(@)optS_L}
        if [[ ${#outS} -ne 0 ]]; then
            replyB=${B_F}
            print -v replyS -f "\"%s\" arg value is not a valid regex: \"%s\";  outS=\"%s\"" -- \
                  reS  ${reS}  ${outS}
        else
            print -v replyS -f "\"%s\" arg value is a valid regex: \"%s\"" -- \
                  reS  ${reS};  fi
        errB=${B_F};  done
    if [[ ${errB} -ne ${B_F} ]]; then
        if [[ ${errI} -eq 0 ]]; then
            errI=2;  errS=${(P)${:-${modUS}_V_errS}};  fi
        BOOL_G  ${modUS}_V_errB=${B_T}
        INT_G   ${modUS}_V_errI=${errI}
        print -v errS -f "%s:  { %s;  errI=%d }" --  ${selfS}  ${errS}  ${errI}
        STR_G   ${modUS}_V_errS=${errS}
        break
    else
        BOOL_G  ${modUS}_V_replyB=${replyB}
        print -v replyS -f "%s:  { %s }" --  ${selfS}  ${replyS}
        STR_G   ${modUS}_V_replyS=${replyS};  fi
    return ${B_T}
}


STR_L   selfS=${modUS}_A_argsRead
# USAGE
#     eval ..._A_localArgvarsCreate
#     argnameL=( <arg_name>... );  eval <selfS>
#
# DESCRIPTION
#     Requires that all command-line args be in this format: "<argnameS>=<valueS>"
#     Reads command-line args into local vars. Name format for these vars: "arg_V_<argnameS>_S"
#     If a particular arg is not seen, its arg var will contain the value "UNDEF"
#
# NOTES
#     - must be used within a loop (e.g. "repeat 1; do")
#     - requires that ${errbaseI} be set
#     = requires that ${argcI} and ${argL} be set (via ..._A_localArgvarsCreate)
#     - updates ${errbaseI} and ${argindexI}
#     - sets errI and errS on error
#
# ERRORS
#     - Any of the required vars does not exist:  ( errbaseI  argnameL  argindexI  argcI  argL )
#     - A particular arg does not match the required format: "<argnameS>=<valueS>"
#     - A particular arg does not exist in argnameL
#     - 
#
STR_L   varnameS  evalS  localvars_SE
 
for varnameS in errB errI errS argnameS argevalS argS arglhsS argrhsS varnameS typeS; do
    evalS+=";  STR_L lvn_${varnameS}_S=${selfS}_V_${varnameS}"; done
eval ${evalS}
localvars_SE="BOOL_L ${selfS}_V_errB;  INT_L ${selfS}_V_errI"
for varnameS in errS argnameS argevalS argS arglhsS argrhsS varnameS typeS; do
    localvars_SE+=";  STR_L ${selfS}_V_${varnameS}="; done
 
STR_G   ${selfS}_SE='
    '"${localvars_SE}"' ;
    '"${(P)${:-${modUS}_A_localMatchvarsCreate_SE}}"'
    repeat 1; do  ;
        '${lvn_errB_S}'=${B_T};
        eval '${modUS}_F_retsReset' '${modS}';
        eval '${modUS}_A_argL_to_argL_S';
        for '${lvn_varnameS_S}' '${lvn_typeS_S}' in  errbaseI integer  argindexI integer  argcI integer  argL array  argnameL array; do
            if ! [[ -v ${'${lvn_varnameS_S}'} ]]; then
                '${lvn_errI_S}'=1;
                print -v '${lvn_errS_S}' -f "required var does not exist: \"%s\"" -- \
                    ${'${lvn_varnameS_S}'};  break 2;  fi;
            case ${(Pt)'${lvn_varnameS_S}'} in
                (${'${lvn_typeS_S}'}*) ;;
                (*)
                    print -v '${lvn_errS_S}' -f "incorrect type for required var: \"%s\";  varnameS=\"%s\"  typeS=\"%s\"" -- \
                        ${(Pt)'${lvn_varnameS_S}'}  ${'${lvn_varnameS_S}'}  ${'${lvn_typeS_S}'};  break 2 ;;  esac;  done;
        for '${lvn_argnameS_S}' in ${argnameL}; do  ;
            '${lvn_argevalS_S}'+=";  STR_L   arg_V_${'${lvn_argnameS_S}'}_S=UNDEF";  done;
        eval ${'${lvn_argevalS_S}'};  '${lvn_argevalS_S}'=;
 
        while [[ ${argindexI} -le ${argcI} ]]; do  ;
            '${lvn_argS_S}'=${argL[${argindexI}]};
            if ! [[ ${'${lvn_argS_S}'} =~ "=" ]]; then  ;
                '${lvn_errI_S}'=2;
                print -v '${lvn_errS_S}' -f "arg does not contain \"=\" sign: \"%s\";  argindexI=%d;  argL=( %s )" -- \
                    "${'${lvn_argS_S}'}"  ${argindexI}  "${argL_S}";  break;  fi;
            '${lvn_arglhsS_S}'=${'${lvn_argS_S}'%%=*}  '${lvn_argrhsS_S}'=${'${lvn_argS_S}'#*=};
            if ! (( $argnameL[(Ie)${'${lvn_arglhsS_S}'}] )); then  ;
                '${lvn_errI_S}'=3;
                print -v '${lvn_errS_S}' -f "arg not in  ( %s ): \"%s\";  argindexI=%d;  argL=( %s )" -- \
                    "${(o@)argnameL}"  "${'${lvn_arglhsS_S}'}"  ${argindexI}  ${argL_S};  break;  fi;
            print -v '${lvn_argevalS_S}' -f "%sarg_V_%s_S=%q;  " -- \
                "${'${lvn_argevalS_S}'}"  ${'${lvn_arglhsS_S}'}  ${'${lvn_argrhsS_S}'};
            argindexI+=1;  done;
        if [[ ${argindexI} -gt ${argcI} ]]; then
            eval ${'${lvn_argevalS_S}'};
            '${lvn_errB_S}'=${B_F};  fi;  done;
    if [[ ${'${lvn_errB_S}'} -ne ${B_F} ]]; then  ;
        if [[ ${'${lvn_errI_S}'} -eq 0 ]]; then  ;
            '${lvn_errI_S}'=${curerrI};
            print -v '${lvn_errS_S}' -f "call failed: { %s; errI=%d }" -- \
                ${'${modUS}_V_errS'}  ${'${modUS}_V_errI'};  fi;
        print -v errS -f "%s:  { %s;  errI=%d }" -- \
            '${selfS}'  ${'${lvn_errS_S}'}  ${'${lvn_errI_S}'};
        errI=${'${lvn_errI_S}'}  errB=${'${lvn_errB_S}'}  errS=${'${lvn_errS_S}'}
        break;  fi;
    errbaseI+=1;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}
evalS='unset'
for varnameS in errB errI errS argnameS argevalS argS arglhsS argrhsS varnameS typeS; do
    evalS+=" lvn_${varnameS}_S"; done
eval ${evalS}
unset  selfS  varnameS  evalS  localvars_SE


STR_L   selfS=${modUS}_F_cgRequireVarTypeRex
# USAGE
#     <selfS>
#         [printB=<printB>]
#         [callerS=<callerS>]
#         [varnameS=<varnameS>]
#         [errI=<errI>]
#         [errexistS=<errexistS>]
#         [errtypeS=<errtypeS>]
#         [errrexS=<errtypeS>]
#         [prependS=<prependS>]
#         [indentI=<indentI>]
#         [breakI=<breakI>]
#         [typeS=<typeS>]
#         [rexvarnameS=<rexvarnameS>]
#         [rexS=<rexS>]
#
# DESCRIPTION
#     Outputs code in ..._V_replyS that checks for the existence, potentially type of, and potentially regex match of, var <varnameS>.
#     Outputs the next usable error number in ..._V_replyI
#     If var is present, and is correct type (if type check requested), and matches regex (if regex check requested), generated code does nothing else.
#     If one of the error conditions is met, generated code will:
#         - Place a default error message into errS var (or the value of <errexistS>, <errtypeS>, or <errrexS> parameter, if given)
#         - Put the value of the parameter <errI>+<offset> into errI var
#         - Perform a "break <n>". The <n> comes from the <breakI> parameter, if given, else is 1.
#
function ${selfS}() {
    setopt  NO_LOCAL_LOOPS
    eval INTERNAL_FRAMEWORK_A_selfmodSetup
    eval ${modUS}_F_retsReset ${modS}
    STR_L   formatS  calleroutS  thisreS=UNDEF  curindentS=  indentS=
    INT_L   iI  inErrI  inBreakI  inIndentI  nexterrI=1
    BOOL_L  printB  varnotexistokB
    LIST_L  argnameL=( printB  varnotexistokB  callerS  varnameS  errI  errexistS  errtypeS  errrexS \
                       prependS  breakI  indentI  typeS  rexvarnameS  rexS )
 
    repeat 1; do
        eval ${modUS}_A_localErrvarsCreate
        eval ${modUS}_A_localMatchvarsCreate
        eval ${modUS}_A_localReplyvarsCreate
        eval ${modUS}_A_localArgvarsCreate
        eval ${modUS}_A_argsRead
        if [[ ${arg_V_callerS_S} = UNDEF ]]; then  arg_V_callerS_S=""
        else
            if [[ ${arg_V_callerS_S} =~ ${(P)${:-${modUS}_C_reIdentA_S}} ]]; then  print -v calleroutS -f "%s: " -- ${arg_V_callerS_S}
            else
                errI=$(( ${errbaseI} + 1 ))
                print -v errS -f "\"%s\" arg does not match \"%s\" regex (\"%s\"): \"%s\"" -- \
                      callerS  ${modUS}_C_reIdentA_S  ${(P)${:-${modUS}_C_reIdentA_S}}  "${arg_V_callerS_S}";  break;  fi;  fi
        if [[ ${arg_V_prependS_S} = UNDEF ]]; then  arg_V_prependS_S=""
        elif  [[ ${arg_V_prependS_S} = "" ]]; then  ;
        elif ! [[ ${arg_V_prependS_S} =~ ${(P)${:-${modUS}_C_reIdentA_S}} ]]; then
            errI=$(( ${errbaseI} + 2 ))
            print -v errS -f "\"%s\" arg does not match \"%s\" regex (\"%s\"): \"%s\"" -- \
                  prependS  ${modUS}_C_reIdentA_S  ${(P)${:-${modUS}_C_reIdentA_S}}  "${arg_V_prependS_S}";  break;  fi
        if [[ ${arg_V_varnameS_S} = UNDEF ]]; then
            errI=$(( ${errbaseI} + 3 ))
            print -v errS -f "missing required arg: \"%s\"" -- \
                  varnameS;  break;  fi
        if ! [[ ${arg_V_varnameS_S} =~ ${(P)${:-${modUS}_C_reIdentA_S}} ]]; then
            errI=$(( ${errbaseI} + 4 ))
            print -v errS -f "\"%s\" arg does not match \"%s\" regex (\"%s\"): \"%s\"" -- \
                  varnameS  ${modUS}_C_reIdentA_S  ${(P)${:-${modUS}_C_reIdentA_S}}  "${arg_V_varnameS_S}";  break;  fi
        if [[ ${arg_V_errI_S} = UNDEF ]]; then  arg_V_errI_S=1;   fi
        if ! [[ ${arg_V_errI_S} =~ ${(P)${:-${modUS}_C_reNumPosA_S}} ]]; then
            errI=$(( ${errbaseI} + 5 ))
            print -v errS -f "\"%s\" arg does not match \"%s\" regex (\"%s\"): \"%s\"" -- \
                  errI  ${modUS}_C_reNumPosA_S  ${(P)${:-${modUS}_C_reNumPosA_S}}  "${arg_V_errI_S}";  break;  fi
        inErrI=${arg_V_errI_S}
        if [[ ${arg_V_indentI_S} = UNDEF ]]; then  arg_V_indentI_S=0;   fi
        if ! [[ ${arg_V_indentI_S} =~ ${(P)${:-${modUS}_C_reNumNonnegA_S}} ]]; then
            errI=$(( ${errbaseI} + 6 ))
            print -v errS -f "\"%s\" arg does not match \"%s\" regex (\"%s\"): \"%s\"" -- \
                  indentI  ${modUS}_C_reNumNonnnegA_S  ${(P)${:-${modUS}_C_reNumNonnegA_S}}  "${arg_V_indentI_S}";  break;  fi
        inIndentI=${arg_V_indentI_S}
        if [[ ${inIndentI} -gt 0 ]]; then
            for iI in {1..${inIndentI}}; do  indentS+=" ";  done;  fi
        if [[ ${arg_V_breakI_S} = UNDEF ]]; then  arg_V_breakI_S=1;   fi
        if ! [[ ${arg_V_breakI_S} =~ ${(P)${:-${modUS}_C_reNumPosA_S}} ]]; then
            errI=$(( ${errbaseI} + 7 ))
            print -v errS -f "\"%s\" arg does not match \"%s\" regex (\"%s\"): \"%s\"" -- \
                  breakI  ${modUS}_C_reNumPosA_S  ${(P)${:-${modUS}_C_reNumPosA_S}}  "${arg_V_breakI_S}";  break;  fi
        inBreakI=${arg_V_breakI_S}
        if [[ ${arg_V_printB_S} = UNDEF ]]; then  arg_V_printB_S=F;  fi
        case X${arg_V_printB_S} in
            (XF) ;& (Xf) ;& (XFALSE) ;& (XFalse) ;& (Xfalse) ;& (X${B_F})  printB=${B_F} ;;
            (XT) ;& (Xt) ;& (XTRUE)  ;& (XTrue)  ;& (Xtrue)  ;& (X${B_T})  printB=${B_T} ;;
            (*)
                errI=$(( ${errbaseI} + 8 ))
                formatS="unknown value for \"%s\" arg: \"%s\"; must be in ["
                formatS+=" \"F\" \"f\" \"FALSE\" \"False\" \"false\" \"${B_F}\""
                formatS+=" \"T\" \"t\" \"TRUE\" \"True\" \"true\" \"${B_T}\" ]"
                print -v errS -f ${formatS} -- \
                      printB  ${arg_V_printB_S};  break ;;  esac
        if [[ ${arg_V_varnotexistokB_S} = UNDEF ]]; then  arg_V_varnotexistokB_S=F;  fi
        case X${arg_V_varnotexistokB_S} in
            (XF) ;& (Xf) ;& (XFALSE) ;& (XFalse) ;& (Xfalse) ;& (X${B_F})  varnotexistokB=${B_F} ;;
            (XT) ;& (Xt) ;& (XTRUE)  ;& (XTrue)  ;& (Xtrue)  ;& (X${B_T})  varnotexistokB=${B_T} ;;
            (*)
                errI=$(( ${errbaseI} + 9 ))
                formatS="unknown value for \"%s\" arg: \"%s\"; must be in ["
                formatS+=" \"F\" \"f\" \"FALSE\" \"False\" \"false\" \"${B_F}\""
                formatS+=" \"T\" \"t\" \"TRUE\" \"True\" \"true\" \"${B_T}\" ]"
                print -v errS -f ${formatS} -- \
                      varnotexistokB  ${arg_V_varnotexistokB_S};  break ;;  esac
        if [[ ${arg_V_typeS_S} != UNDEF ]]; then
            case "X${arg_V_typeS_S}" in
                (Xscalar) ;;
                (Xinteger) ;;
                (Xarray) ;;
                (Xassociation) ;;
                (Xlist) arg_V_typeS_S=array ;;
                (Xmap)  arg_V_typeS_S=association ;;
                (Xstr)  arg_V_typeS_S=scalar ;;
                (Xint)  arg_V_typeS_S=integer ;;
                (*)
                    errI=$(( ${errbaseI} + 10 ))
                    formatS="unknown value for \"%s\" arg: \"%s\"; must be in ["
                    formatS+="\"scalar\" \"integer\" \"array\" \"association\" \"list\" \"map\" \"str\" \"int\" ]"
                    print -v errS -f ${formatS} -- \
                          typeS  ${arg_V_typeS_S};  break ;;  esac;  fi
        if [[ ${#arg_V_errexistS_S} -eq 0 ]]; then
            errI=$(( ${errbaseI} + 11 ))
            print -v errS -f "\"%s\" arg is blank" -- \
                  errexistS;  break;  fi
        if [[ ${#arg_V_errtypeS_S} -eq 0 ]]; then
            errI=$(( ${errbaseI} + 12 ))
            print -v errS -f "\"%s\" arg is blank" -- \
                  errtypeS;  break;  fi
        if [[ ${arg_V_errexistS_S} = UNDEF ]]; then
            print -v arg_V_errexistS_S -f "\"%s\" var not defined" -- \
                  ${arg_V_varnameS_S};  fi
        if [[ ${arg_V_errtypeS_S} = UNDEF ]]; then
            print -v arg_V_errtypeS_S -f "invalid type for \"%s\" var;  must glob-match \"%s*\": \"%%s\"" -- \
                  ${arg_V_varnameS_S}  ${arg_V_typeS_S};  fi
        if [[ ${arg_V_errtypeS_S} = UNDEF ]]; then
            print -v arg_V_errtypeS_S -f "invalid type for \"%s\" var;  must glob-match \"%s*\": \"%%s\"" -- \
                  ${arg_V_varnameS_S}  ${arg_V_typeS_S};  fi
        if [[ ${arg_V_rexvarnameS_S} = '' ]]; then  arg_V_rexvarnameS_S=UNDEF;  fi
        if [[ ${arg_V_rexvarnameS_S} != UNDEF  &&  ${arg_V_rexS_S} != UNDEF ]]; then
            errI=$(( ${errbaseI} + 13 ))
            print -v errS -f "both \"%s\" and \"%s\" args are defined;  argL=( %s )" -- \
                  rexvarnameS  rexS  ${argL_S};  break;  fi
        if [[ ${arg_V_rexvarnameS_S} != UNDEF ]]; then
            if ! [[ ${arg_V_rexvarnameS_S} =~ ${(P)${:-${modUS}_C_reVarnameA_S}} ]]; then
                errI=$(( ${errbaseI} + 14 ))
                print -v errS -f "\"%s\" arg does not match \"%s\" regex (\"%s\"): \"%s\"" -- \
                      rexvarnameS  ${modUS}_C_reVarnameA_S  ${(P)${:-${modUS}_C_reVarnameA_S}}  "${arg_V_rexvarnameS_S}";  break;  fi
            if [[ ${(P)+arg_V_rexvarnameS_S} -eq 0 ]]; then
                errI=$(( ${errbaseI} + 15 ))
                print -v errS -f "var ref'd by \"%s\" arg does not exist: \"%s\"" -- \
                      rexvarnameS  ${arg_V_rexvarnameS_S};  break;  fi
            thisreS=${(P)arg_V_rexvarnameS_S}
            if [[ ${#thisreS} -eq 0 ]]; then
                errI=$(( ${errbaseI} + 16 ))
                print -v errS -f "var ref'd by \"%s\" arg is empty: \"%s\"" -- \
                      rexvarnameS  ${arg_V_rexvarnameS_S};  break;  fi
            eval ${modUS}_F_rexValid  \${thisreS}
            if [[ ${(P)${:-${modUS}_V_replyB}} -ne ${B_T} ]]; then
                errI=$(( ${errbaseI} + 17 ))
                print -v errS -f "var ref'd by \"%s\" arg (i.e. \"%s\") does not contain a valid regex: \"%s\";  %s" \
                      rexvarnameS  ${arg_V_rexvarnameS_S}  "${thisreS}"  ${(P)${:-${modUS}_V_errS}};  break;  fi
            if [[ ${arg_V_errrexS_S} = UNDEF ]]; then
                print -v arg_V_errrexS_S -f "\"%s\" var does not match \"%s\" regex (\"%s\"): \"%%s\"" -- \
                      ${arg_V_varnameS_S}  ${arg_V_rexvarnameS_S}  "${thisreS}";  fi
            print -v arg_V_errrexS_S -f "%s%s" --  ${calleroutS}  ${arg_V_errrexS_S};  fi
        if [[ ${arg_V_rexS_S} != UNDEF ]]; then
            thisreS=${(P)arg_V_rexS_S}
            if [[ ${#thisreS} -eq 0 ]]; then
                errI=$(( ${errbaseI} + 18 ))
                print -v errS -f "\"%s\" arg is empty" -- \
                      rexS;  break;  fi
            eval ${modUS}_F_rexValid  \${thisreS}
            if [[ ${(P)${:-${modUS}_V_replyB}} -ne ${B_T} ]]; then
                errI=$(( ${errbaseI} + 19 ))
                print -v errS -f "\"%s\" arg does not contain a valid regex: \"%s\";  %s" \
                      rexS  "${arg_V_rexS_S}"  ${(P)${:-${modUS}_V_errS}};  break;  fi
            if [[ ${arg_V_errrexS_S} = UNDEF ]]; then
                print -v arg_V_errrexS_S -f "\"%s\" var does not match in-line regex (\"%s\"): \"%%s\"" -- \
                      ${arg_V_varnameS_S}  z"${thisreS}";  fi
            print -v arg_V_errrexS_S -f "%s%s" --  ${calleroutS}  ${arg_V_errrexS_S};  fi
        print -v arg_V_errexistS_S -f "%s%s" --  ${calleroutS}  ${arg_V_errexistS_S}
        print -v arg_V_errtypeS_S -f "%s%s" --  ${calleroutS}  ${arg_V_errtypeS_S}
        nexterrI=${inErrI}
        if [[ ${varnotexistokB} -eq ${B_T} ]]; then
            print -v replyS -f '%s%sif [[ ${+%s} -eq 1 ]]; then  ;\n' -- \
                  "${replyS}"  "${curindentS}"  ${arg_V_varnameS_S}
            curindentS="${indentS}    "
        else
            print -v replyS -f '%s%sif [[ ${+%s} -eq 0 ]]; then  ;\n%s    %serrI=%d;%s    %serrS=%q;\n%s    break %d;\n%sfi;' -- \
                  "${replyS}"  "${curindentS}"  ${arg_V_varnameS_S}  "${curindentS}"  "${arg_V_prependS_S}"  ${nexterrI}  "${curindentS}" \
                   "${arg_V_prependS_S}"  ${arg_V_errexistS_S}  "${curindentS}"  ${inBreakI}  "${curindentS}"
            nexterrI+=1;  curindentS=${indentS};  fi
        if [[ ${arg_V_typeS_S} != UNDEF ]]; then
            formatS='%s\n%scase ${(t)%s} in\n%s    (%s*) ;;\n%s    (*)\n%s        %serrI=%d;\n%s        print -v %serrS -f '"%q"' --'
            formatS+='  ${(t)%s};  break %d ;;\n%sesac;\n'
            print -v replyS -f ${formatS} -- \
                  ${replyS}  "${curindentS}"  ${arg_V_varnameS_S}  "${curindentS}"  ${arg_V_typeS_S}  "${curindentS}"  "${curindentS}"  "${arg_V_prependS_S}"  ${nexterrI} \
                  "${curindentS}"  "${arg_V_prependS_S}"  ${arg_V_errtypeS_S}  ${arg_V_varnameS_S}  ${inBreakI}  "${curindentS}"
            nexterrI+=1;  fi
        if [[ ${thisreS} != UNDEF ]]; then
            formatS='%s\n%sif ! [[ ${%s} =~ %q ]]; then\n%s    %serrI=%d;\n%s    print -v %serrS -f '"%q"' --'
            formatS+='  "${%s}";  break %d;\n%sfi; \n'
            print -v replyS -f ${formatS} -- \
                  ${replyS}  "${curindentS}"  ${arg_V_varnameS_S}  "${thisreS}"  "${curindentS}"  "${arg_V_prependS_S}"  ${nexterrI} \
                  "${curindentS}"  "${arg_V_prependS_S}"  ${arg_V_errrexS_S}  ${arg_V_varnameS_S}  ${inBreakI}  "${curindentS}"
            nexterrI+=1;  fi
        if [[ ${varnotexistokB} -eq ${B_T} ]]; then
            print -v replyS -f '%s%sfi;\n' -- \
                  "${replyS}"  "${indentS}"
            curindentS=${indentS};  fi;  done
    if [[ ${errI} -ne 0 ]]; then
        errB=${B_T}
        print -v errS -f "%s: { %s;  argcI=%d  argL=( %s );  errI=%d }" -- \
              ${selfS}  ${errS}  ${argcI}  ${argL_S}  ${errI};  fi
    if [[ ${errI} -eq 0 ]]  &&  [[ ${printB} -eq ${B_T} ]]; then  print -f "%s" --  ${replyS};  fi
    eval "${modUS}_V_errB=\${errB}  ${modUS}_V_errS=\${errS}  ${modUS}_V_errI=\${errI}  ${modUS}_V_replyI=\${nexterrI}  ${modUS}_V_replyS=\${replyS};"
    if [[ ${errI} -eq 0 ]]; then  return ${B_T};  fi
    break
}


STR_L   selfS=${modUS}_F_arrayToStrR
# USAGE
#     <selfS>  [-P]  [-p]  [-a]  [-A]  [--]  <varnameS>
#
# NOTE
#     - Depended on by ..._A_catchFailure, so cannot use the "catch" aliases
#     - returns
#         (if error): ..._errB <- ${B_T};  rets:  ..._errI  ..._errS
#         (if not error): ..._errB <- ${B_F};  rets: ..._replyS
#         (if not error && "-A" presented): annotate ..._replyS with subscript nums
#         (if not error && "-P" presented): print ..._replyS
#
function ${selfS}() {
    eval INTERNAL_FRAMEWORK_A_selfmodSetup
    eval ${modUS}_F_retsReset ${modS}
    STR_L   varnameS  eltS  subeltS  sS=  sepS=
    INT_L   indexI
    BOOL_L  printB=${B_F}  annotateB=${B_F}
    LIST_L  contentL
 
    repeat 1; do
        eval ${modUS}_A_localErrvarsCreate;  errB=${B_T}
        indexI=1;  while [[ ${indexI} -le $# ]]; do
            eltS="${(P)indexI}"
            case X${eltS} in
                (X-P) printB=${B_T} ;;
                (X-p) printB=${B_F} ;;
                (X-A) annotateB=${B_T} ;;
                (X-a) annotateB=${B_F} ;;
                (X--) indexI+=1; break ;;
                (X-*)
                    errI=2;  print -v errS -f "unknown flag;  argcI=%d,  argS=\"%s\"" -- ${indexI} "${eltS}";  break ;;
                (*) break ;;  esac
            indexI+=1;  done
        if [[ ${indexI} -gt $#  || $(( $# - ${indexI} )) -gt 1 ]]; then
            errI=3;  print -v errS -f "non-flag arg count not 1: %d" -- $(( $# - ${indexI} ));  break;  fi;
        varnameS="${(P)indexI}"
        if [[ ${#varnameS} -eq 0 ]]; then
            errI=4;  print -v errS -f "\"%s\" arg is empty" --  varnameS;  break;  fi;
        if [[ ${(P)+varnameS} -eq 0 ]]; then
            errI=5;  print -v errS -f \
                "\"%s\" arg refers to nonexistent var: \"%s\"" --  varnameS  ${varnameS};  break;  fi;
        case ${(Pt)varnameS} in
            (array*)  ;;
            (*)
                errI=6;  print -v errS -f "\"%s\" arg refers to var not of array type: \"%s\";  typeS=\"%s\"" -- \
                    varnameS  ${varnameS}  ${(Pt)varnameS};  break ;;  esac
        contentL=( "${(P@)varnameS}" )
	if [[ ${annotateB} -eq ${B_F} ]]; then
            indexI=1
	    while [[ ${indexI} -le ${#contentL} ]]; do
		print -v sS -f "%s%s%s" -- \
		      "${sS}"  "${sepS}"  ${contentL[${indexI}]};  sepS="  ";  indexI+=1;  done
	else
            indexI=1
	    while [[ ${indexI} -le ${#contentL} ]]; do
		print -v sS -f "%s%s[%d]%s" -- \
		      "${sS}"  "${sepS}"  ${indexI}  ${contentL[${indexI}]};  sepS="  ";  indexI+=1;  done;  fi
        errB=${B_F};  done
    if [[ ${errB} -ne ${B_F} ]]; then
        if [[ ${errI} -eq 0 ]]; then
            errI=7;  errS=${(P)${:-${modUS}_V_errS}};  fi
        BOOL_G  ${modUS}_V_errB=${B_T}
        INT_G   ${modUS}_V_errI=${errI}
        print -v errS -f "%s:  { %s;  errI=%d }" --  ${selfS}  ${errS}  ${errI}
        STR_G   ${modUS}_V_errS=${errS}
    else
        STR_G ${modUS}_V_replyS=${sS}
        if [[ ${printB} -eq ${B_T} ]]; then  print -f "%s" --  ${sS};  fi;  fi
    return ${(P)${:-${modUS}_C_invertB_M[${(P)${:-${modUS}_V_errB}}]}}
}


STR_L   selfS=${modUS}_F_mapToStrR
# USAGE
#     <selfS>  [-P]  [-p]  [--]  <varnameS>
#
# NOTE
#     - returns
#         (if error): ..._errB <- ${B_T};  rets:  ..._errI  ..._errS
#         (if not error): ..._errB <- ${B_F};  rets: ..._replyS
#         (if not error && "-P" presented): print ..._replyS
#
function ${selfS}() {
    eval INTERNAL_FRAMEWORK_A_selfmodSetup
    eval ${modUS}_F_retsReset ${modS}
    STR_L   varnameS  eltS  subeltS  keyS  valueS  sS=  sepS=
    BOOL_L  printB=${B_F}  annotateB=${B_F}
    INT_L   indexI
 
    repeat 1; do
        eval ${modUS}_A_localErrvarsCreate;  errB=${B_T}
        indexI=1;  while [[ ${indexI} -le $# ]]; do
            eltS="${(P)indexI}"
            case X${eltS} in
                (X-P) printB=${B_T} ;;
                (X-p) printB=${B_F} ;;
                (X--) indexI+=1; break ;;
                (X-*)
                    errI=2;  print -v errS -f "unknown flag;  argcI=%d,  argS=\"%s\"" -- ${indexI} "${eltS}";  break ;;
                (*) break ;;  esac
            indexI+=1;  done
        if [[ ${indexI} -gt $#  || $(( $# - ${indexI} )) -gt 1 ]]; then
            errI=3;  print -v errS -f "non-flag arg count not 1: %d" -- $(( $# - ${indexI} ));  break;  fi;
        varnameS="${(P)indexI}"
        if [[ ${#varnameS} -eq 0 ]]; then
            errI=4;  print -v errS -f "\"%s\" arg is empty" --  varnameS;  break;  fi;
        if [[ ${(P)+varnameS} -eq 0 ]]; then
            errI=5;  print -v errS -f \
                "\"%s\" arg refers to nonexistent var: \"%s\"" --  varnameS  ${varnameS};  break;  fi;
        case ${(Pt)varnameS} in
            (association*)  ;;
            (*)
                errI=6;  print -v errS -f "\"%s\" arg refers to var not of map type: \"%s\";  typeS=\"%s\"" -- \
                    varnameS  ${varnameS}  ${(Pt)varnameS};  break ;;  esac
	for keyS in ${(Pko@)varnameS}; do
	    valueS="${(P)${:-${varnameS}[${keyS}]}}"
            print -v sS -f '%s%s[%s]%s' --  "${sS}"  "${sepS}"  "${keyS}"  "${valueS}";  sepS="  ";  done
        errB=${B_F};  done
    if [[ ${errB} -ne ${B_F} ]]; then
        if [[ ${errI} -eq 0 ]]; then
            errI=7;  errS=${(P)${:-${modUS}_V_errS}};  fi
        BOOL_G  ${modUS}_V_errB=${B_T}
        INT_G   ${modUS}_V_errI=${errI}
        print -v errS -f "%s:  { %s;  errI=%d }" --  ${selfS}  ${errS}  ${errI}
        STR_G   ${modUS}_V_errS=${errS}
    else
        STR_G ${modUS}_V_replyS=${sS}
        if [[ ${printB} -eq ${B_T} ]]; then  print -f "%s" --  ${sS};  fi;  fi
    return ${(P)${:-${modUS}_C_invertB_M[${(P)${:-${modUS}_V_errB}}]}}
}



# foundational aliases


STR_L   selfS=${modUS}_A_selfmodSetup
# USAGE
#     <selfS>
#
# NOTE
#     - Since callers in effect have no way of catching errors thrown by this alias,
#       it cannot use "break" to break out beyond its borders.
#
STR_G   ${selfS}_SE='
    STR_L   modS="'"${modS}"'"  modUS="'"${modUS}"'"  selfS=$0;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_aliasEntry
# USAGE
#     aliasnameS=<aliasnameS>  <selfS>
#
# NOTE
#     - Since callers in effect have no way of catching errors thrown by this alias,
#       it cannot use "break" to break out beyond its borders.
#
STR_G   ${selfS}_SE='
    : "'${selfS}': ${aliasnameS}";
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_aliasExit
# USAGE
#     aliasnameS=<aliasnameS>  <selfS>
#
# NOTE
#     - Since callers in effect have no way of catching errors thrown by this alias,
#       it cannot use "break" to break out beyond its borders.
#
STR_G   ${selfS}_SE='
    : "'${selfS}': \"${aliasnameS}\"";
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_aliasPrint
# USAGE
#     alias <aliasnameS> | <selfS>
#
STR_G   ${selfS}_SE='sed -e '\''s/\\n/\
/g'\''; print -f "\n\n";  '
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_cgRequireVarTypeRex
# USAGE
#     set (L|G) (selfS|selfxS) <varnameS> <typeS> <indentI> <rexvarnameS> <prependS>;  eval <selfS>
STR_G   ${selfS}_SE='
    STR_L   '${selfS}_V_selftypeS'=$2;
    STR_L   '${selfS}_V_selftypeS_P'=${(P)'${selfS}_V_selftypeS'};
    calleemodUS=${modUS}  calleeS=F_cgRequireVarTypeRex  selectorS=$3;
    ${calleemodUS}_${calleeS} \
        callerS=${'${selfS}_V_selftypeS_P'}  varnameS=$3  typeS=$4  errI=${(P)${:-${'${selfS}_V_selftypeS_P'}_V_nexterrI}}  prependS=$7 \
        indentI=$5  rexvarnameS=$6;
    eval STR_${1}   ${7}varcheck_${3}_SE=\${INTERNAL_FRAMEWORK_V_replyS};
    eval "${'${selfS}_V_selftypeS_P'}_V_nexterrI=\${INTERNAL_FRAMEWORK_V_replyI}";
    unset '${selfS}_V_selftypeS'  '${selfS}_V_selftypeS_P';
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_catchSetup
# USAGE
#     modUS=<modUS>  <selfS>
#
# NOTE
#     - Since callers in effect have no way of catching errors thrown by this alias,
#       it cannot use "break" to break out beyond its borders.
#
INT_L   ${selfS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    set L selfS modUS str 8 ${modUS}_C_reModUSnameA_S '';  eval ${modUS}_A_cgRequireVarTypeRex
    okB=${B_T};  done
if [[ ${okB} -ne ${B_T} ]]; then
    STR_L   errS
    print -v errS -f "ERROR: %s: while defining \"%s\": call to \"%s_%s\" for \"%s\" failed:  { %s;  errI=%d }" -- \
          ${modS}  ${selfS}  ${calleemodUS}  ${calleeS}  ${selectorS} \
          ${(P)${:-${calleemodUS}_V_errS}}  ${(P)${:-${calleemodUS}_V_errI}}
    print -f "%s\n" --  ${errS}
    exit 1;  fi
unset okB  calleemodUS  calleeS  selectorS

STR_G   ${selfS}_SE='
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasEntry;
    repeat 1; do  ;
        '"${(P)${:-${modUS}_A_retsReset_SE}}"' ;
        '"${(P)${:-${modUS}_A_localMatchvarsCreate_SE}}"' ;
        '"${(P)${:-${modUS}_A_localErrvarsCreate_SE}}"' ;
        '"${varcheck_modUS_SE}"' ;
        if ! alias "${modUS}_A_retsReset" 2>&1 >/dev/null; then  ;
            errI='$(( ${(P)${:-${selfS}_V_nexterrI}} + 0 ))';
            errS="\"${modUS}_A_retsReset\" alias not defined";  break;  fi;
        '"${(P)${:-${modUS}_A_localMatchvarsCreate_SE}}"' ;
        '"${(P)${:-${modUS}_A_localReplyvarsCreate_SE}}"' ;
        '"${(P)${:-${modUS}_A_localArgvarsCreate_SE}}"' ;
        eval ${:-${modUS}_A_retsReset};  done;
    if [[ ${errI} -ne 0 ]]; then  ;
        print -v errS -f "%s:  { %s;  errI=%d }";
        BOOL_G  '${modUS}_V_errB'=${B_T};
        INT_G   '${modUS}_V_errI'=${errI};
        STR_G   '${modUS}_V_errS'=${errS};
        print -f "ERROR: %s: %s\n" --  '${modUS}'  ${errS};
    else  ;
        INT_G   '${modUS}_V_replyI'='$(( ${(P)${:-${selfS}_V_nexterrI}} + 1 ))';  fi;
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}
unset  ${selfS}_V_nexterrI  varcheck_modUS_SE


STR_L   selfS=${modUS}_A_catchFailure
# USAGE
#     ..._A_catchSetup
#     <user_code>
#     <selfS>
#
# NOTE
#     - Depends on existence of and sensible value of $0, so must be used within a function, not an alias
#     - modUS _must_ be set to the calling module's value, else things will go horribly wrong
#
STR_G   ${selfS}_SE='
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasEntry;
    STR_L   '${selfS}_V_varnameS';
    BOOL_L  '${selfS}_V_errB'=${B_N};
    repeat 1; do  ;
        '${selfS}_V_errB'=${B_T};
        for '${selfS}_V_varnameS' in  modUS  errB  errI  errS  argL  argL_S  argindexI  ${modUS}_V_errS;  do  ;
            if [[ ${(P)+'${selfS}_V_varnameS'} -eq 0 ]]; then  ;
                INT_L   errI=50;  BOOL_L  errB=${B_T};  STR_L   errS="\"${'${selfS}_V_varnameS'}\" var does not exist";  break 2;  fi;  done;
        if [[ ${errI} -eq 0 ]]; then  ;
            if [[ ${(P)+${:-${modUS}_V_errI}} -eq 1 ]]; then  ;
                if [[ ${(P)${:-${modUS}_V_errI}} -ne 0 ]]; then  ;
                    if [[ ${(P)+${:-${modUS}_V_errS}} -eq 1 ]]; then  ;
                        errI=51;  errS=${(P)${:-${modUS}_V_errS}};  break;  fi;  fi;  fi;  fi;
        if [[ ${errS} = *@ARGCV* ]];   then  errS=${errS/@ARGCV/[ argcI=${argcI},  argL=( ${argL_S} ) ]};  fi;
        if [[ ${errS} = *@ARGC* ]];    then  errS=${errS/@ARGC/[ argcI=${argcI} ]};  fi;
        if [[ ${errS} = *@ARGV* ]];    then  errS=${errS/@ARGV/[ argL=( ${argL_S} ) ]};  fi;
        if [[ ${errS} = *@INDEX* ]];   then  errS=${errS/@INDEX/[ argindexI=${argindexI} ]};  fi;
        if [[ ${errS} = *@REQL\[* ]];  then  errS=${errS/@REQL\[/must be one of  \(};  fi;
        if [[ ${errS} = *@\]* ]];      then  errS=${errS/@\]/\)};  fi;
        '${selfS}_V_errB'=${B_F};  done;
    if [[ '${selfS}_V_errB' -ne ${B_F} ]]; then  ;
        print -v errS -f "%s:  { %s;  errI=%d }" --  $0  ${errS}  ${errI};
        BOOL_G  ${modUS}_V_errB=${B_T};
        INT_G   ${modUS}_V_errI=${errI};
        STR_G   ${modUS}_V_errS=${errS};  fi;
    unset   '${selfS}_V_varnameS'  '${selfS}_V_errB';
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_catchSuccess
# USAGE
#     ..._A_catchSetup
#     <user_code>
#     <selfS>
#
# NOTE
#     - Depends on existence of and sensible value of $0, so must be used within a function, not an alias
#
STR_G   ${selfS}_SE='
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasEntry;
    if [[ ${errB} -eq ${B_F} ]]; then  ;
        STR_L     '${selfS}_V_evalS'=;
        BOOL_G    ${modUS}_V_errB=${B_F};
        BOOL_G    ${modUS}_V_replyB=${replyB};
        INT_G     ${modUS}_V_replyI=${replyI};
        STR_G     ${modUS}_V_replyS=${replyS};
        FLOATF_G  ${modUS}_V_replyF=${replyF};
        FLOATE_G  ${modUS}_V_replyE=${replyE};
        '${selfS}_V_evalS'+="LIST_G    ${modUS}_V_replyL=( \"\${(@)replyL}\" ); ";
        if  [[ ${#replyM} -ne 0 ]]; then  '${selfS}_V_evalS'+="MAP_G     ${modUS}_V_replyM=( \"\${(kv@)replyM}\" ); ";
        else  '${selfS}_V_evalS'+="MAP_G     ${modUS}_V_replyM=( ); ";  fi;
        eval ${'${selfS}_V_evalS'};  unset '${selfS}_V_evalS';  fi;
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_catchReturn
# USAGE
#     ..._A_catchSetup
#     <user_code>
#     ..._A_catchAll
#     <selfS>
#
# NOTE
#     - Cannot use ..._A_aliasEntry / ..._A_aliasExit  since this is a one-liner that exits current context
#
STR_G   ${selfS}_SE='
    return ${'${modUS}_C_invertB_M'[${(P)${:-${modUS}_V_errB}}]};
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_catchAll
# USAGE
#     ..._A_catchSetup
#     <user_code>
#     <selfS>
#     ..._A_catchReturn
#
# NOTE
#     - Depends on existence of and sensible value of $0, so must be used within a function, not an alias
#
STR_G   ${selfS}_SE='
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasEntry;
    eval '${modUS}_A_catchSuccess';
    eval '${modUS}_A_catchFailure';
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_A_catchThenReturn
# USAGE
#     ..._A_catchSetup
#     <user_code>
#     <selfS>
#
# NOTE
#     - Depends on existence of and sensible value of $0, so must be used within a function, not an alias
#
STR_G   ${selfS}_SE='
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasEntry;
    eval '${modUS}_A_catchSuccess';
    eval '${modUS}_A_catchFailure';
    eval '${modUS}_A_catchReturn';
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}



unset  selfS



# global variables

BOOL_G  B_T=0  B_F=1  B_N=2
function { STR_L evalS="MAP_G  ${modUS}_C_invertB_M=( ${B_T} ${B_F}   ${B_F} ${B_T}   ${B_N} ${B_N} ); ";  eval ${evalS}; }
${modUS}_F_retsReset  ${modS}
MAP_G   ${modUS}_V_loadstateM
LIST_G  ${modUS}_V_loadstackL


# functions

STR_L   selfS=${modUS}_F_regexShow
# USAGE
#     <selfS>
#         [ -p | -P | (--print=(True|False)) ]
#         [ -a | -A | (--annotate=(True|False)) ]
#         [ -m | -M | (--namePrintable=(True|False)) ]
#         [ (-n | --namePrintable) <namePrintableS> ]
#         [ (-v | --value) <valueS> ]
#         [ (-T | --titleType) <titletypeS> ]     (titletypeS must be in {arg,A,opt,O,var,V,parm,P,field,F})
#         [ -- ]
#         <varnameS>
#
function ${selfS}() {
    eval INTERNAL_FRAMEWORK_A_selfmodSetup
    eval ${modUS}_A_catchSetup
    INT_L   indexincrI=1
    STR_L   varnameS  typeS  sepS  valueS=  namePrintableS=  typePrintableS=  titletypeS=arg
    BOOL_L  optPrintB=${B_F}  optAnnotateB=${B_F}  optMatchesB=${B_N}  optPrintValueB=${B_F}  doneB=${B_F}
 
    repeat 1; do
        errB=${B_T}
        while [[ ${argindexI} -le ${argcI}  &&  ${doneB} -eq ${B_F} ]]; do
            argS=${argL[${argindexI}]}
            case ${argS} in
                (-p) ;& (--print=F*)    optPrintB=${B_F}  ;;
                (-P) ;& (--print=T*)    optPrintB=${B_T}  ;;
                (-a) ;& (--annotate=F*) optAnnotateB=${B_F}  ;;
                (-A) ;& (--annotate=T*) optAnnotateB=${B_T}  ;;
                (-m) ;& (--matches=F*)  optMatchesB=${B_F}  ;;
                (-M) ;& (--matches=T*)  optMatchesB=${B_T}  ;;
                (-n) ;& (--namePrintable)
                    if [[ ${argindexI} -eq ${argcI} ]]; then
                        errI=1;  print -v errS -f "missing value for \"%s\" option;  @INDEX;  @ARGCV" --  ${argS};  break;  fi
                    argindexI+=1;  namePrintableS=${argL[${argindexI}]}
                    if [[ ${#namePrintableS} -eq 0 ]]; then
                        errI=2;  print -v errS -f "empty value for \"%s\" option;  @INDEX;  @ARGCV" --  ${argS};  break;  fi  ;;
                (-t) ;& (--typePrintable)
                    if [[ ${argindexI} -eq ${argcI} ]]; then
                        errI=3;  print -v errS -f "missing value for \"%s\" option;  @INDEX;  @ARGCV" --  ${argS};  break;  fi
                    argindexI+=1;  typePrintableS=${argL[${argindexI}]}
                    if [[ ${#typePrintableS} -eq 0 ]]; then
                        errI=4;  print -v errS -f "empty value for \"%s\" option;  @INDEX;  @ARGCV" --  ${argS};  break;  fi  ;;
                (-v) ;& (--value)
                    if [[ ${argindexI} -eq ${argcI} ]]; then
                        errI=5;  print -v errS -f "missing value for \"%s\" option;  @INDEX;  @ARGCV" --  ${argS};  break;  fi
                    argindexI+=1;  optPrintValueB=${B_T}  valueS=${argL[${argindexI}]}  ;;
                (-T) ;& (--titleType)
                    if [[ ${argindexI} -eq ${argcI} ]]; then
                        errI=6;  print -v errS -f "missing value for \"%s\" option;  @INDEX;  @ARGCV" --  ${argS};  break;  fi
                    argindexI+=1;  titletypeS=${argL[${argindexI}]}
                    case ${titletypeS} in
                        (arg)      ;;   (A) titletypeS=arg      ;;
                        (opt)      ;;   (O) titletypeS=opt      ;;
                        (var)      ;;   (V) titletypeS=var      ;;
                        (const)    ;;   (C) titletypeS=const    ;;
                        (parm)     ;;   (P) titletypeS=parm     ;;
                        (field)    ;;   (F) titletypeS=field    ;;
                        (subfield) ;;   (S) titletypeS=subfield ;;
                        (*)
                            errI=7;  print -v errS -f \
                                "bad value for \"%s\" option: \"%s\"; must be one of  ( arg opt var const parm field subfield );  @INDEX;  @ARGCV" -- \
                                ${argS}  ${titletypeS};  break ;;  esac
                    ;;
                (--) doneB=${B_T}  ;;
                (*)  doneB=${B_T}  indexincrI=0  ;;  esac
            argindexI+=${indexincrI};  done
        if [[ ${argindexI} -gt ${argcI} ]]; then
            errI=8;  print -v errS -f "missing \"%s\" value;  @INDEX;  @ARGCV" --  varnameS;  break;  fi
        if [[ ${argindexI} -lt ${argcI} ]]; then
            errI=9;  print -v errS -f "extra arg(s) found after \"%s\" value;  @INDEX;  @ARGCV" --  varnameS;  break;  fi
        varnameS=${argL[${argcI}]}
        if ! [[ ${varnameS} =~ ${INTERNAL_FRAMEWORK_C_reIdentA_S} ]]; then
            errI=10;  print -v errS -f "\"%s\" value does not match \"%s\" regex (\"%s\"): \"%s\";  @INDEX;  @ARGCV" -- \
                varnameS  ${modUS}_C_reIdentA_S  ${(P)${:-${modUS}_C_reIdentA_S}}  ${varnameS};  break;  fi
        typeS=scalar; eval ${modUS}_A_varRequireType
        replyS=  sepS=
        if [[ ${#namePrintableS} -ne 0 ]]; then
            print -v replyS -f "%s%s\"%s\"" --  "${replyS}"  "${sepS}"  ${namePrintableS};  sepS=" ";  fi
        case ${titletypeS} in
            (arg)       print -v replyS -f "%s%s%s" --  "${replyS}"  "${sepS}"  argument;   sepS=" " ;;
            (opt)       print -v replyS -f "%s%s%s" --  "${replyS}"  "${sepS}"  option;     sepS=" " ;;
            (var)       print -v replyS -f "%s%s%s" --  "${replyS}"  "${sepS}"  variable;   sepS=" " ;;
            (const)     print -v replyS -f "%s%s%s" --  "${replyS}"  "${sepS}"  constant;   sepS=" " ;;
            (parm)      print -v replyS -f "%s%s%s" --  "${replyS}"  "${sepS}"  parameter;  sepS=" " ;;  
            (field)     print -v replyS -f "%s%s%s" --  "${replyS}"  "${sepS}"  field;      sepS=" " ;;  
            (subfield)  print -v replyS -f "%s%s%s" --  "${replyS}"  "${sepS}"  subfield;   sepS=" " ;;  esac
        case ${optMatchesB} in
            (${B_N}) ;;
            (${B_T}) print -v replyS -f "%s%svalue matches" --  "${replyS}"  "${sepS}";  sepS=" " ;;
            (${B_F}) print -v replyS -f "%s%svalue does not match" --  "${replyS}"  "${sepS}";  sepS=" " ;;  esac
        if [[ ${optAnnotateB} -eq ${B_F} ]]; then
            print -v replyS -f "%s%sregex: \"%s\"" --  "${replyS}"  "${sepS}"  ${(P)varnameS}
        else
            print -v replyS -f "%s%s\"%s\" regex (\"%s\")" --  "${replyS}"  "${sepS}"  ${varnameS}  ${(P)varnameS};  fi
        if [[ ${optPrintValueB} -eq ${B_T} ]]; then
            print -v replyS -f "%s: \"%s\"" --  "${replyS}"  "${valueS}";  fi
        if [[ ${optPrintB} -eq ${B_T} ]]; then
            print -f "%s" --  "${replyS}";  fi
        errB=${B_F};  done
    eval ${modUS}_A_catchThenReturn
}


STR_L   selfS=${modUS}_F_makeNametocharVars
BOOL_G  ${selfS}_V_madeB=${B_F}
# USAGE
#     <selfS>
#
function ${selfS}() {
    eval INTERNAL_FRAMEWORK_A_selfmodSetup
    eval ${modUS}_A_catchSetup
    STR_L   evalS="STR_G   "  sepS=  nameS  charS  tmpS
    INT_L   resultI
 
    repeat 1; do
        errB=${B_T}
	if [[ ${(P)${:-${selfS}_V_madeB}} -ne ${B_T} ]]; then
            for nameS in ${(Pko)${:-${modUS}_CI_nametocharM}}; do
		charS=${(P)${:-${modUS}_CI_nametocharM\[${nameS}\]}}
		print -v tmpS -f "%sC%sS=%q  %sS=%q  char%sS=%q" -- \
		      "${sepS}"  ${nameS} ${charS}  ${nameS} ${charS}  ${(C)nameS} ${charS}
		evalS+=${tmpS};   sepS="    ";  done
            eval ${evalS}; resultI=$?
            if [[ ${resultI} -ne 0 ]]; then
		errI=1;  print -v errS -f "eval of \"evalS\" var failed: %d;  \"%s\"" --  ${resultI}  ${evalS};  break;  fi
	    eval "${selfS}_V_madeB=\${B_T}";  fi
        errB=${B_F};  done
    eval ${modUS}_A_catchThenReturn
}


STR_L   selfS=${modUS}_F_main
# USAGE
#     modS=<modnameS>  <selfS>
#
function ${selfS}() {
    eval INTERNAL_FRAMEWORK_A_selfmodSetup
    eval ${modUS}_A_catchSetup
    STR_L   loaddecisionS=UNDEF  loadstateS=UNDEF
    STR_L   evalS=  formatS=
 
    repeat 1; do
        eval ${modUS}_F_makeNametocharVars
        if ! [[ -v ${modUS}_V_loadstateM ]]; then  loaddecisionS=yes
        elif ! [[ -v ${modUS}_V_loadstateM[${modUS}] ]]; then  loaddecisionS=yes
        else
            loaddecisionS=no
            loadstateS=${(P)${:-${modUS}_V_loadstateM[${modUS}]}}
            case X${loadstateS} in
                (Xloaded) ;;
                (Xloading) ;&
                (Xfailed)
                    formatS+="inappropriate loadstate encountered on module load attempt; "
                    formatS+="modS=\"%s\";  loadstateS=\"%s\";  loadstackL=( %s )"
                    errI=1;  print -v errS -f ${formatS} -- \
                        ${modS}  ${loadstateS} \
                        "$(${(P)${:-${modUS}_F_arrayToStrR}} -P -A --  ${modUS}_V_loadstackL)" ;;
                (X*)
                    formatS+="unknown loadstate encountered on module load attempt; "
                    formatS+="modS=\"%s\";  loadstateS=\"%s\";  loadstackL=( %s )"
                    errI=2;  print -v errS -f ${formatS} -- \
                        ${modS}  ${loadstateS} \
                        "$(${(P)${:-${modUS}_F_arrayToStrR}} -P -A --  ${modUS}_V_loadstackL)" ;;  esac;  fi
        if [[ ${loaddecisionS} = yes ]]; then
            BOOL_G  B_T=0  B_F=1  B_N=2
            INT_G   ${modUS}_V_errB=${B_F}
            INT_G   ${modUS}_V_errI=0
            INT_G   ${modUS}_V_replyI=0
            STR_G   ${modUS}_V_errS=
            STR_G   ${modUS}_V_replyS=
            evalS+="MAP_G   ${modUS}_C_invertB_M=( ${B_T} ${B_F}   ${B_F} ${B_T}   ${B_N} ${B_N} );  "
            evalS+="MAP_G   ${modUS}_V_loadstateM=( );  "
            evalS+="LIST_G  ${modUS}_V_loadstackL=( );  "
            eval ${evalS}
            evalS=
            evalS+="${modUS}_V_loadstateM[${modUS}]=loading;  "
            evalS+="${modUS}_V_loadstackL+=( ${modUS} );  "
            eval ${evalS}
            evalS=
            evalS+="${modUS}_V_loadstateM[${modUS}]=loaded; "
            evalS+="${modUS}_V_loadstackL[-1]=( ); "
            eval ${evalS}; fi
        errI=0;  done;
    eval ${modUS}_A_catchThenReturn
}


STR_L   selfS=${modUS}_F_modCacheWrite
# USAGE
#     MEZXDIR=<mezxdirS>  <selfS> \
#         [(-m | --mod[ule]) <modS>]  \
#         [(-t | --tag) <tagS>...] \
#         [(-d | --depend[ency]) <modS>...] \
#         [(-i | --include>) <typeS> <itemS>...] \
#         [(-x | --exc[lude]) <typeS> <itemS>...] \
#         [--]
#
# NOTE
#     at least one "-m" or "-i" is required
function ${selfS}() {
    eval INTERNAL_FRAMEWORK_A_selfmodSetup
    eval ${modUS}_A_catchSetup
    STR_L   argmodS=UNDEF  evalS=  argmodUS  tagS=UNDEF  tagUS  varnameS  typeS \
	    cachedirS  cachepathS  boilerplatedirS  boilerplatepathS \
	    lineS  funcnameS  sS  sepS  eltS  subeltS  itemS keyS  valueS \
	    reS  re2S  depmodS  eltMatchedS
    STR_L   boilerplatefileS="mezx-startup-v1.5.zsh"
    INT_L   indexI
    BOOL_L  resultB  namecheckB  foundExclB
    LIST_L  argdepL=( )  functionL=( )  includeA_L=( )  includeV_L=( )  includeF_L=( )  excludeA_L=( )  excludeV_L=( )  excludeF_L=( )
    MAP_L   aliastypeM=( )  writtenM=( )
    MAP_L   aliastypetosignifierM=( "local" " "  "global" " -g" )
    MAP_L   reBookendM
 
    repeat 1; do
        indexI=1  sepS=  resultB=${B_T}  errB=${B_T}
        eval ${modUS}_F_makeNametocharVars;  resultB=$?;  if [[ ${resultB} -ne ${B_T} ]]; then break;  fi
        reBookendM=(
            preA   "${CcaretS}${CplS}${CbslS}${CqsS}${CbsrS}${CmqS}${CprS}${CplS}"
            postA  "${CprS}${CplS}${CbslS}${CqsS}${CbsrS}${CmqS}${CprS}=${CplS}${CdotS}${CstarS}${CprS}${CdlrS}"
            preC   "${CcaretS}${CplS}${CbslS}${CqsS}${CbsrS}${CmqS}${CprS}${CplS}"
            postC  "${CprS}${CplS}${CbslS}${CqsS}${CbsrS}${CmqS}${CprS}=${CplS}${CdotS}${CstarS}${CprS}${CdlrS}"
            preV   "${CcaretS}${CplS}${CbslS}${CqsS}${CbsrS}${CmqS}${CprS}${CplS}"
            postV  "${CprS}${CplS}${CbslS}${CqsS}${CbsrS}${CmqS}${CprS}=${CplS}${CdotS}${CstarS}${CprS}${CdlrS}"
            preF   "${CcaretS}${CplS}${CbslS}${CqsS}${CbsrS}${CmqS}${CprS}${CplS}"
            postF  "${CprS}${CplS}${CprS}${CspS}${CbslS}${CplS}${CbsrS}${CbslS}${CprS}${CbsrS}${CplS}${CspS}${CprS}${CbslS}${CbclS}${CbsrS}${CdlrS}"
        )
        while [[ ${indexI} -le ${argcI} ]]; do
            eltS=${(P)indexI}
            if [[ ${#eltS} -eq 0 ]]; then
                errI=1;  print -v errS -f "empty arg encountered;  @INDEX;  @ARGCV";  break 2;  fi
            if [[ X${eltS[1]} != X- ]]; then
                errI=2;  print -v errS -f "value encountered where flag expected: \"%s\";  @INDEX;  @ARGCV" -- \
                    ${eltS};  break 2;  fi
            case X${eltS} in
                (X-m) ;&
                (X--mod) ;&
                (X--module)
                    if [[ ${indexI} -eq ${argcI} ]]; then
                        errI=3;  print -v errS -f "\"%s\" flag requires value;  @INDEX;  @ARGCV" -- \
                            ${eltS};  break 2;  fi
                    if [[ ${argmodS} != UNDEF ]]; then
                        errI=4;  print -v errS -f "\"%s\" flag may occur only once;  @INDEX;  @ARGCV" -- \
                            ${eltS};  break 2;  fi
                    indexI+=1;  argmodS=${(P)indexI}
                    if ! [[ ${argmodS} =~ ${(P)${:-${modUS}_C_reModnameA_S}} ]]; then
                        errI=5;  print -v errS -f "\"%s\" flag value does not match \"%s\" regex (\"%s\"): \"%s\"" -- \
                            modS  ${modUS}_C_reModnameA_S  ${(P)${:-${modUS}_C_reModnameA_S}}  ${eltS};  break 2;  fi
                    argmodUS=${(U)argmodS//\//_}
                    includeV_L+=( "${argmodUS}_[PVC]_[^\'=]*" )
                    includeV_L+=( "${argmodUS}_[VC][DI]_[^\'=]*" )
                    includeA_L+=( "${argmodUS}_A_[^\'=]*" )
                    includeF_L+=( "${argmodUS}_F_[^\' ]*" )
                    indexI+=1
                    ;;
                (X-t) ;&
                (X--tag)
                    if [[ ${indexI} -eq ${argcI} ]]; then
                        errI=3;  print -v errS -f "\"%s\" flag requires value;  @INDEX;  @ARGCV" -- \
                            ${eltS};  break 2;  fi
                    if [[ ${tagS} != UNDEF ]]; then
                        errI=4;  print -v errS -f "\"%s\" flag may occur only once;  @INDEX;  @ARGCV" -- \
                            ${eltS};  break 2;  fi
                    indexI+=1;  tagS=${(P)indexI}
                    if ! [[ ${tagS} =~ ${(P)${:-${modUS}_C_reIdentA_S}} ]]; then
                        errI=5;  print -v errS -f "\"%s\" flag value does not match \"%s\" regex (\"%s\"): \"%s\"" -- \
                            tagS  ${modUS}_C_reIdentA_S  ${(P)${:-${modUS}_C_reIdentA_S}}  ${tagS};  break 2;  fi
                    tagUS=${(U)tagS//\//_}
                    indexI+=1
                    ;;
                (X-d) ;&
                (X--depend) ;&
                (X--dependency)
                    if [[ ${indexI} -eq ${argcI} ]]; then
                        errI=19;  print -v errS -f "\"%s\" flag requires value;  @INDEX;  @ARGCV" -- \
                            ${eltS};  break 2;  fi
                    indexI+=1
                    while [[ ${indexI} -le ${argcI} ]]; do
                        eval "subeltS=\"${(P)indexI}\""
                        case X${subeltS} in
                            (X--) indexI+=1;  break ;;
                            (X-*) break ;;  esac
                        if ! [[ ${subeltS} =~ ${(P)${:-${modUS}_C_reModnameA_S}} ]]; then
                            errI=20;  print -v errS -f "\"%s\" flag value does not match \"%s\" regex (\"%s\"): \"%s\"" -- \
                                ${eltS}  ${modUS}_C_reModnameA_S  ${(P)${:-${modUS}_C_reModnameA_S}}  ${subeltS};  break 2;  fi
                        argdepL+=( ${subeltS} );  indexI+=1;  done
                    ;;
                (X-i) ;&
                (X--inc) ;&
                (X--include) ;&
                (X-x) ;&
                (X--exc) ;&
                (X--exclude)
                    if (( ${indexI} + 1 >= ${argcI} )); then
                        errI=6;  print -v errS -f "\"%s\" flag requires type and value(s) args;  @INDEX;  @ARGCV" -- \
                            ${eltS};  break 2;  fi
                    indexI+=1;  typeS=${(P)indexI}
                    case X${typeS} in
                        (Xalias) ;;
                        (Xfunc) ;;
                        (Xvar) ;;
                        (*)
                            errI=7;  print -v errS -f "unknown \"typeS\" value given for \"%s\" flag: \"%s\";  @INDEX;  @ARGCV" -- \
                            ${eltS}  ${typeS};  break 2 ;; esac
                    indexI+=1
                    while [[ ${indexI} -le ${argcI} ]]; do
                        eval "subeltS=\"${(P)indexI}\""
                        case X${subeltS} in
                            (X--) indexI+=1;  break ;;
                            (X-*) break ;;  esac
                        if   [[ ${eltS[2]} = i || ${eltS[3]} = i ]]; then
                            evalS+="${sepS}include${(U)typeS[1]}_L+=( \"${subeltS}\" )";  sepS="; "
                        elif [[ ${eltS[2]} = x || ${eltS[3]} = e ]]; then
                            evalS+="${sepS}exclude${(U)typeS[1]}_L+=( \"${subeltS}\" )";  sepS="; "
                        else
                            errI=8;  print -v errS -f "unknown flag: \"%s\";  @INDEX;  @ARGCV" -- \
                                ${eltS};  break 2;  fi
                        indexI+=1;  done
                    ;;
                (X-*)
                    errI=9;  print -v errS -f "unknown flag: \"%s\";  @INDEX;  @ARGCV" -- \
                        ${eltS};  break 2 ;;
                (*)
                    errI=10;  print -v errS -f "non-flag encountered where flag expected: \"%s\";  @INDEX;  @ARGCV" -- \
                        ${eltS};  break 2 ;;  esac;  done
        eval ${evalS}
        if [[ ${argmodS} = UNDEF ]]; then
            if (( ${#includeV_L} == 0  &&  ${#includeA_L} == 0  &&  ${#includeF_L} == 0 )); then
                errI=11;  print -v errS -f "either/both of  ( --module  --include )  must be supplied;  @ARGCV" -- \
                    "$(${:-${modUS}_F_arrayToStrR} -P -A -- argL)";  break;  fi;  fi
        varnameS=MEZXDIR  namecheckB=${B_F} typeS=scalar;  eval ${modUS}_A_varRequireType
        if ! [[ -d ${MEZXDIR} ]]; then
            errI=12;  print -v errS -f "MEZXDIR var does not refer to existing dir: \"%s\"" -- \
                ${MEZXDIR};  break;  fi
        boilerplatedirS=${MEZXDIR}/internal/boilerplate
        if ! [[ -d ${boilerplatedirS} ]]; then
            errI=13;  print -v errS -f "MEZX boilerplate dir does not exist: \"%s\"" -- \
                ${boilerplatedirS};  break;  fi
        boilerplatepathS=${boilerplatedirS}/${boilerplatefileS}
        if [[ ! -f ${boilerplatepathS} ]]; then
            errI=14;  print -v errS -f "MEZX boilerplate file does not exist: \"%s\"" -- \
                ${boilerplatepathS};  break;  fi
        cachedirS=${MEZXDIR}/cache
        if ! [[ -d ${cachedirS} ]]; then
            errI=15;  print -v errS -f "MEZX cache dir does not exist: \"%s\"" -- \
                ${cachedirS};  break;  fi
        cachepathS=${cachedirS}/${argmodUS}.cache.zsh
	if [[ ${tagS} != UNDEF ]]; then
            cachepathS=${cachedirS}/${argmodUS}-${tagUS}.cache.zsh;  fi
        if [[ -f ${cachepathS} ]]; then
            if ! rm -f ${cachepathS}; then
                errI=16;  print -v errS -f "failed to remove cache file: \"%s\"" -- \
                    ${cachepathS};  break;  fi;  fi
        if ! touch ${cachepathS}; then
            errI=17;  print -v errS -f "failed to touch/create cache file: \"%s\"" -- \
                ${cachepathS};  break;  fi
        print -f "#!/bin/zsh\n\n\n" >> ${cachepathS}
        if ! cat ${boilerplatepathS} >> ${cachepathS}; then
            errI=18;  print -v errS -f "failed to clone boilerplate file (\"%s\") into cache file: \"%s\"" -- \
                ${boilerplatepathS}  ${cachepathS};  break;  fi
        print -f "\n# dependencies\n\n" >>${cachepathS}
        sS=  sepS=
        for eltS in ${argdepL}; do
            sS+=${sepS}${eltS};  sepS="  ";  done
        if [[ ${#argdepL} -eq 0 ]]; then
            print -f "typeset +g -a  modL=(  %s )\n\n\n" --  ${sS} >>${cachepathS}
        else
	    print -f "typeset +g -a  modL=(  %s );  INTERNAL_FRAMEWORK_A_loadDependencies\n\n\n" --  ${sS} >>${cachepathS};  fi
        print -f "# constants and variables\n\n" >>${cachepathS}
        writtenM=( )
	eval "BOOL_G  ${modUS}_F_makeNametocharVars_V_madeB=${B_F}"
        set | while read -r lineS; do
            : "lineS=${lineS}"
            for eltS in ${includeV_L}; do
                print -v reS -f "%s%s%s" --  ${reBookendM[preV]}  ${eltS}  ${reBookendM[postV]}
                if [[ ${lineS} =~ ${reS} ]]; then
                    foundExclB=${B_F}
                    eltMatchedS=${match[2]}
                    if  [[ ${eltMatchedS} =~ '^([A-Za-z_][A-Za-z0-9_]*)=.*$' ]]; then
                        eltMatchedS=${match[1]};  fi
                    for subeltS in ${excludeV_L}; do
                        re2S=${reBookendM[preV]}${subeltS}${reBookendM[postV]}
                        if [[ ${lineS} =~ ${re2S} ]]; then
                            foundExclB=${B_T};  break;  fi;  done
                    if [[ ${foundExclB} -eq ${B_F} ]]  &&  ! [[ -v "writtenM[${eltMatchedS}]" ]]; then
                        writtenM[${eltMatchedS}]=1;
			if [[ ${(Pt)eltMatchedS} =~ '^array' ]]; then
			    print -f "typeset -g -a %s=( )\n" >>${cachepathS} -- ${eltMatchedS}
			    for itemS in "${(P@)eltMatchedS}"; do
				print -f "%s+=( %q )\n" -- \
				      ${eltMatchedS}  ${itemS} >>${cachepathS}; done
			elif [[ ${(Pt)eltMatchedS} =~ '^association' ]]; then
			    print -f "typeset -g -A %s=( )\n" >>${cachepathS} -- ${eltMatchedS}
			    for keyS in "${(Pko@)eltMatchedS}"; do
				if [[ ${keyS} = '' ]]; then
				    continue; fi
				print -v varnameS -f "%s[%s]" --  ${eltMatchedS}  ${keyS}
				valueS=${${varnameS}}
				print -f "%s=%q\n" >>${cachepathS} -- \
				      ${varnameS}  ${(P)varnameS};  done
			else
                            typeset -p ${eltMatchedS} >>${cachepathS};  fi;  fi;  fi;  done;  done
        print -f "\n\n# aliases\n\n" >>${cachepathS}
        writtenM=( )
        alias | while read -r lineS; do
            : "lineS=${lineS}"
            for eltS in ${includeA_L}; do
                print -v reS -f "%s%s%s" --  ${reBookendM[preA]}  ${eltS}  ${reBookendM[postA]}
                if [[ ${lineS} =~ ${reS} ]]; then
                    foundExclB=${B_F}
                    for subeltS in ${excludeA_L}; do
                        print -v re2S -f "%s%s%s" --  ${reBookendM[preA]}  ${subeltS}  ${reBookendM[postA]}
                        if [[ ${lineS} =~ ${re2S} ]]; then
                            foundExclB=${B_T};  break;  fi;  done
                    if [[ ${foundExclB} -eq ${B_F} ]]; then
                        aliastypeM[${match[2]}]=local;  fi;  fi;  done;  done
        alias -g | while read -r lineS; do
            : "lineS=${lineS}"
            for eltS in ${includeA_L}; do
                print -v reS -f "%s%s%s" --  ${reBookendM[preA]}  ${eltS}  ${reBookendM[postA]}
                if [[ ${lineS} =~ ${reS} ]]; then
                    foundExclB=${B_F}
                    for subeltS in ${excludeA_L}; do
                        print -v re2S -f "%s%s%s" --  ${reBookendM[preA]}  ${subeltS}  ${reBookendM[postA]}
                        if [[ ${lineS} =~ ${re2S} ]]; then
                            foundExclB=${B_T};  break;  fi;  done
                    if [[ ${foundExclB} -eq ${B_F} ]]; then
                        aliastypeM[${match[2]}]=global;  fi;  fi;  done;  done
        alias | while read -r lineS; do
            : "lineS=${lineS}"
            for eltS in ${includeA_L}; do
                print -v reS -f "%s%s%s" --  ${reBookendM[preA]}  ${eltS}  ${reBookendM[postA]}
                if [[ ${lineS} =~ ${reS} ]]; then
                    if [[ -v "aliastypeM[${match[2]}]" ]]  &&  ! [[ -v "writtenM[${match[2]}]" ]]; then
                        writtenM[${match[2]}]=1
                        print -f "alias%s %s%s%s=%s\n" -- \
                              "${aliastypetosignifierM[${aliastypeM[${match[2]}]}]}" \
                              "${match[1]}"  ${match[2]}  "${match[3]}"  ${match[4]}  >>${cachepathS};  fi;  fi;  done;  done
        print -f "\n\n# functions\n\n" >>${cachepathS}
        functions | while read -r lineS; do
            : "lineS=${lineS}"
            for eltS in ${includeF_L}; do
                print -v reS -f "%s%s%s" --  ${reBookendM[preF]}  ${eltS}  ${reBookendM[postF]}
                if [[ ${lineS} =~ ${reS} ]]; then
                    foundExclB=${B_F}
                    for subeltS in ${excludeF_L}; do
                        print -v re2S -f "%s%s%s" --  ${reBookendM[preF]}  ${subeltS}  ${reBookendM[postF]}
                        if [[ ${lineS} =~ ${re2S} ]]; then
                            foundExclB=${B_T};  break;  fi;  done
                    if [[ ${foundExclB} -eq ${B_F} ]]; then
                        funcnameS=${match[2]};
                        print -f "function " >>${cachepathS}
                        functions ${funcnameS} >>${cachepathS}
                        print "" >>${cachepathS};  fi;  fi;  done;  done
        errB=${B_F};  break;  done
    eval ${modUS}_A_catchThenReturn
}
unset selfS


STR_L   selfS=${modUS}_F_cgCheckargc
# USAGE
#     <selfS>  [errI=<errI>]  [argcReqI=<argcReqI>]  [argcMinI=<argcMinI>]  [argcMaxI=<argcMaxI>]  [breakI=<breakI>]  [indentI=<indentI>]
#
function ${selfS}() {
    setopt  NO_LOCAL_LOOPS
    eval INTERNAL_FRAMEWORK_A_selfmodSetup
    eval ${modUS}_A_localErrvarsCreate
    eval ${modUS}_A_localMatchvarsCreate
    eval ${modUS}_A_localArgvarsCreate
    eval ${modUS}_A_localReplyvarsCreate
    STR_L   nameS  valueS  formatS=  indentS=
    INT_L   iI
    LIST_L  argnameL=( errI  argcReqI  argcMinI  argcMaxI  breakI  indentI )
 
    repeat 1; do
        errB=${B_T}
        eval ${modUS}_A_argsRead
        for nameS in ${argnameL}; do
            eval valueS=\${arg_V_${nameS}_S}
            if [[ ${valueS} != UNDEF ]]; then
                if ! [[ ${valueS} =~ ${(P)${:-${modUS}_C_reNumNonnegA_S}} ]]; then
                    errI=$(( ${errbaseI} + 0 ))
                    print -v errS -f "\"%s\" arg does not match \"%s\" regex (\"%s\"): \"%s\"" -- \
                          nameS  ${modUS}_C_reNumNonnegA_S  ${(P)${:-${modUS}_C_reNumNonnegA_S}}  ${valueS}
                    break 2;  fi;  fi;  done
        if [[ ${arg_V_errI_S} = UNDEF ]]; then  arg_V_errI_S=1;  fi
        if [[ ${arg_V_breakI_S} = UNDEF ]]; then  arg_V_breakI_S=1;  fi
        if [[ ${arg_V_indentI_S} = UNDEF ]]; then  arg_V_indentI_S=0;  fi
        if [[ ${arg_V_breakI_S} -lt 1  ||  ${arg_V_breakI_S} -gt 99 ]]; then
            errI=$(( ${errbaseI} + 1 ))
            print -v errS -f "\"%s\" arg value not in  { 1..99 }: %d" -- \
                  breakI  ${arg_V_breakI_S};  break;  fi;
        if [[ ${arg_V_errI_S} -lt 1 ]]; then  ;
            errI=$(( ${errbaseI} + 2 ))
            print -v errS -f "\"%s\" arg value less than 1: %s" -- \
                  errI  ${arg_V_errI_S};  break;  fi;
        if [[ ${arg_V_argcReqI_S} != UNDEF ]]  &&  [[ ${arg_V_argcMinI_S} != UNDEF  ||  ${arg_V_argcMaxI_S} != UNDEF ]]; then  ;
            errI=$(( ${errbaseI} + 3 ))
            print -v errS -f "\"%s\" arg defined, but one or more of  [ \"%s\" \"%s\" ]  args is defined;  argL=( %s )" -- \
                  argcReqI  argcMinI  argcMaxI  ${argL_S};  break;  fi;
        if [[ ${arg_V_argcReqI_S} = UNDEF ]]  &&  [[ ${arg_V_argcMinI_S} = UNDEF  ||  ${arg_V_argcMaxI_S} = UNDEF ]]; then  ;
            errI=$(( ${errbaseI} + 4 ))
            print -v errS -f "\"%s\" arg not defined, but one or more of  [ \"%s\" \"%s\" ]  args not defined;  argL=( %s )" -- \
                  argcReqI  argcMinI  argcMaxI  ${argL_S};  break;  fi;
        if [[ ${arg_V_argcReqI_S} = UNDEF ]]  &&  [[ ${arg_V_argcMinI_S} > ${arg_V_argcMaxI_S} ]]; then
            errI=$(( ${errbaseI} + 5 ))
            print -v errS -f "\"%s\" arg value (%s)  greater than \"%s\" arg value (%s)" -- \
                  argcMinI  ${arg_V_argcMinI_S}  argcMaxI  ${arg_V_argcMaxI_S};  break;  fi;
        if [[ ${arg_V_indentI_S} -gt 0 ]]; then
            for iI in {1..${arg_V_indentI_S}}; do  indentS+=" ";  done;  fi
        if [[ ${arg_V_argcReqI_S} != UNDEF ]]; then
            formatS+='if [[ ${argcI} -ne %d ]]; then  ; \n'
            formatS+='%s    curerrI=1;  eval INTERNAL_FRAMEWORK_A_argL_to_argL_S; \n'
            formatS+='%s    errI=%d; \n'
            formatS+='%s    print -v errS -f "argcI value not %d: %%d;  argL=( %%s )" --\\\n'
            formatS+='%s        ${argcI}  ${argL_S}; \n'
            formatS+='%s    break %d; \n'
            formatS+='%s    fi;\n'
            print -v replyS -f ${formatS} -- \
                  ${arg_V_argcReqI_S} \
                  "${indentS}"  \
                  "${indentS}"  ${arg_V_errI_S} \
                  "${indentS}"  ${arg_V_argcReqI_S} \
                  "${indentS}"  \
                  "${indentS}"  ${arg_V_breakI_S} \
                  "${indentS}"
        else
            formatS+='if [[ ${argcI} < %d  ||  ${argcI} > %d ]]; then  ; \n'
            formatS+='%s    curerrI=1;  eval INTERNAL_FRAMEWORK_A_argL_to_argL_S; \n'
            formatS+='%s    errI=%d; \n'
            formatS+='%s    print -v errS -f "argcI value not in  { %d..%d }: %%d;  argL=( %%s )" --\\\n'
            formatS+='%s        ${argcI}  ${argL_S}; \n'
            formatS+='%s    break %d; \n'
            formatS+='%s    fi; \n'
            print -v replyS -f ${formatS} -- \
                  ${arg_V_argcMinI_S}  ${arg_V_argcMaxI_S} \
                  "${indentS}"  \
                  "${indentS}"  ${arg_V_errI_S} \
                  "${indentS}"  ${arg_V_argcMinI_S}  ${arg_V_argcMaxI_S} \
                  "${indentS}"  \
                  "${indentS}"  ${arg_V_breakI_S} \
                  "${indentS}"
        fi
        errB=${B_F};  done
    if [[ ${errB} -ne ${B_F} ]]; then
        print -v errS -f "%s: { %s;  errI=%d }" -- \
              ${selfS}  ${errS}  ${errI}
        eval "${modUS}_V_errB=\${errB}  ${modUS}_V_errI=\${errI}  ${modUS}_V_errS=\${errS}; "
        break;  fi
    eval "${modUS}_V_errB=\${errB}  ${modUS}_V_replyS=\${replyS}  ${modUS}_V_replyI=\$(( \${arg_V_errI_S} + 1 )); "
    return ${B_T}
}


STR_L   selfS=${modUS}_F_fileDateOrdered
# USAGE
#     <selfS>  <filepathA_S>  <filepathB_S>
#
INT_G   ${selfS}_V_nexterrI=1
STR_L   calleemodUS  calleeS  selectorS
BOOL_L  okB=${B_F}
repeat 1; do
    calleemodUS=${modUS}  calleeS=F_cgCheckargc  selectorS="arg count"
    eval ${calleemodUS}_${calleeS}  errI=${(P)${:-${selfS}_V_nexterrI}}  argcReqI=2  indentI=8
    STR_G   ${selfS}_V_checkargcSE=${(P)${:-${modUS}_V_replyS}}
    INT_G   ${selfS}_V_nexterrI=${(P)${:-${modUS}_V_replyI}}
    okB=${B_T};  done
if [[ ${okB} -ne ${B_T} ]]; then
    STR_L   errS
    print -v errS -f "ERROR: %s: while defining \"%s\": call to \"%s_%s\" for \"%s\" failed:  { %s;  errI=%d }" -- \
          ${modS}  ${selfS}  ${calleemodUS}  ${calleeS}  ${selectorS} \
          ${(P)${:-${calleemodUS}_V_errS}}  ${(P)${:-${calleemodUS}_V_errI}}
    print -f "%s\n" --  ${errS}
    exit 1;  fi
unset calleemodUS  calleeS  selectorS  okB
 
function ${selfS}() {
    eval INTERNAL_FRAMEWORK_A_selfmodSetup
    eval ${modUS}_A_catchSetup
    STR_L   filepathA_S  filepathB_S
    BOOL_L  replyB=${B_N}
    INT_L   baseerrI=${(P)${:-${selfS}_V_nexterrI}}
 
    repeat 1; do
        errB=${B_T}
        eval ${(P)${:-${selfS}_V_checkargcSE}}
        filepathA_S=$1  filepathB_S=$2
        if [[ ${#filepathA_S} -eq 0 ]]; then
            errI=$(( ${baseerrI} + 0 ))
            print -v errS -f "\"filepathA_S\" arg is empty";  break;  fi
        if [[ ${#filepathB_S} -eq 0 ]]; then
            errI=$(( ${baseerrI} + 1 ))
            print -v errS -f "\"filepathB_S\" arg is empty";  break;  fi
        if [[ ${filepathA_S} = ${filepathB_S} ]]; then
            errI=$(( ${baseerrI} + 2 ))
            print -v errS -f "arg values of \"filepathA_S\" and \"filepathB_S\" are identical: \"%s\"" -- ${filepathA_S};  break;  fi
        if ! [[ -f ${filepathA_S} ]]; then
            errI=$(( ${baseerrI} + 3 ))
            print -v errS -f "\"filepathA_S\" arg does not refer to an existing file: \"%s\"" -- ${filepathA_S};  break;  fi
        if ! [[ -f ${filepathB_S} ]]; then
            errI=$(( ${baseerrI} + 4 ))
            print -v errS -f "\"filepathB_S\" does not refer to an existing file: \"%s\"" -- ${filepathB_S};  break;  fi
        if [[ ${filepathA_S} -ot ${filepathB_S} ]]; then  replyB=${B_T};  else replyB=${B_F};  fi
        errB=${B_F};  done
    eval ${modUS}_A_catchThenReturn
}


STR_L   selfS=${modUS}_F_fileReadToList
# USAGE
#     <selfS>  <filepathS>
#
INT_G   ${selfS}_V_nexterrI=1
STR_L   calleemodUS  calleeS  selectorS
BOOL_L  okB=${B_F}
repeat 1; do
    calleemodUS=${modUS}  calleeS=F_cgCheckargc  selectorS="arg count"
    eval ${calleemodUS}_${calleeS}  errI=${(P)${:-${selfS}_V_nexterrI}}  argcReqI=1  indentI=8
    STR_G   ${selfS}_V_checkargcSE=${(P)${:-${modUS}_V_replyS}}
    INT_G   ${selfS}_V_nexterrI=${(P)${:-${modUS}_V_replyI}}
    okB=${B_T};  done
if [[ ${okB} -ne ${B_T} ]]; then
    STR_L   errS
    print -v errS -f "ERROR: %s: while defining \"%s\": call to \"%s_%s\" for \"%s\" failed:  { %s;  errI=%d }" -- \
          ${modS}  ${selfS}  ${calleemodUS}  ${calleeS}  ${selectorS} \
          ${(P)${:-${calleemodUS}_V_errS}}  ${(P)${:-${calleemodUS}_V_errI}}
    print -f "%s\n" --  ${errS}
    exit 1;  fi
unset calleemodUS  calleeS  selectorS  okB
 
function ${selfS}() {
    eval INTERNAL_FRAMEWORK_A_selfmodSetup
    eval ${modUS}_A_catchSetup
    STR_L   filepathS  sS
    INT_L   baseerrI=${(P)${:-${selfS}_V_nexterrI}}
 
    repeat 1; do
        errB=${B_T}
        eval ${(P)${:-${selfS}_V_checkargcSE}}
        filepathS=$1
        if [[ ${#filepathS} -eq 0 ]]; then
            errI=$(( ${baseerrI} + 0 ))
            print -v errS -f '"%s" arg is empty' -- \
		filepathS;  break;  fi
        if ! [[ -f ${filepathS}  &&  -r ${filepathS} ]]; then
            errI=$(( ${baseerrI} + 1 ))
            print -v errS -f '"%s" arg does not refer to extant/readable file: "%s"' -- \
		  filepathS  ${filepathS};  break;  fi
	cat ${filepathS} | while read sS; do
	    replyL+=( ${sS} );  done
        errB=${B_F};  done
    eval ${modUS}_A_catchThenReturn
}


# aliases


STR_L   selfS=${modUS}_A_listDouble
# USAGE
#     <selfS> <list>
#
# DESCRIPTION
#     Each item in the list will appear twice, in order, in the output variable. So
#     e.g. "INTERNAL_FRAMEWORK_A_listDouble aa bb cc" will result the following contents of
#     INTERNAL_FRAMEWORK_A_listDouble_V_replyL: ( aa aa bb bb cc cc )
#
# NOTE
#   It is critically important that this alias depends on no other functions or aliases.
#   This alias MUST end immediately after the function-closing brace; it will fail if there is a NL before the end quote.
#   Cannot use the standard ..._A_aliasEntry and ..._A_aliasExit aliases, because it's in effect a one-liner.
#
STR_G   ${selfS}_SE='
    function {
        STR_L   sS;
        LIST_G  '${selfS}_V_replyL'=();
 
        for sS in $@; do  ;
            '${selfS}_V_replyL'+=( ${sS} ${sS} );  done;
    } '
alias ${selfS}=${(P)${:-${selfS}_SE}}
unset selfS


STR_L   selfxS=${modUS}_A_localVarnamesMake
# USAGE
#     selfS=<aliasnameS>  varnameL=( <varname1> ... )  [nametypeS={local|global}]  <selfxS>
#
# NOTE
#     cannot use anon function here due to need to create vars in caller context
#
INT_L   ${selfxS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    STR_L   reLocalOrGlobalA_S='^(local|global)$'
    set L selfxS selfS str 8 ${modUS}_C_reIdentA_S '';  eval ${modUS}_A_cgRequireVarTypeRex
    set L selfxS varnameL list 8 '' '';  eval ${modUS}_A_cgRequireVarTypeRex
    set L selfxS nametypeS str 8 reLocalOrGlobalA_S '';  eval ${modUS}_A_cgRequireVarTypeRex
    unset reLocalOrGlobalA_S
    okB=${B_T};  done
if [[ ${okB} -ne ${B_T} ]]; then
    STR_L   errS
    print -v errS -f "ERROR: %s: while defining \"%s\": call to \"%s_%s\" for \"%s\" failed:  { %s;  errI=%d }" -- \
          ${modS}  ${selfxS}  ${calleemodUS}  ${calleeS}  ${selectorS} \
          ${(P)${:-${calleemodUS}_V_errS}}  ${(P)${:-${calleemodUS}_V_errI}}
    print -f "%s\n" --  ${errS}
    exit 1;  fi
unset okB  calleemodUS  calleeS  selectorS
 
STR_G   ${selfxS}_SE='
    STR_L   aliasnameS="'${selfxS}'";  '${modUS}_A_aliasEntry';
    STR_L  '${selfxS}_errS';
    INT_L  '${selfxS}_errI';
    STR_L  '${selfxS}_varnameS'  '${selfxS}_evalS'  '${selfxS}_prependS'=;
    LIST_L '${selfxS}_trueVarnameL';
 
    repeat 1; do ;
        '"${varcheck_selfS_SE}"' ;
        '"${varcheck_varnameL_SE}"' ;
        '${selfxS}_trueVarnameL'=( ${(us/ /)${:-${(@)varnameL} errI errS}} );
        '"${varcheck_nametypeS_SE}"' ;
        if [[ ${+nametypeS} -eq 1 ]]; then  ;
            if [[ ${nametypeS} = global ]]; then  ;
                print -v '${selfxS}_prependS' -f "%s" -- ${selfS}_V_;  fi;  fi;
        '${modUS}_A_listDouble' ${(@)'${selfxS}_trueVarnameL'};
        print -v '${selfxS}_evalS' -f "  lvn_%s_S=${'${selfxS}_prependS'}%s" -- \
            "${(@)'${modUS}_A_listDouble'_V_replyL}";
        unset '${modUS}_A_listDouble_V_replyL';
        '${selfxS}_evalS'="STR_L ${'${selfxS}_evalS'}";
        STR_G   '${modUS}_V_replyS'=${'${selfxS}_evalS'};
        eval ${'${selfxS}_evalS'};  done;
    if [[ ${'${selfxS}_errI'} -ne 0 ]]; then ;
        BOOL_G '${modUS}_V_errB'=${B_T};
        INT_G  '${modUS}_V_errI'=${'${selfxS}_errI'};
        STR_G  '${modUS}_V_errS'=${'${selfxS}_errS'};
        unset  '${selfxS}_errI'  '${selfxS}_errS'  '${selfxS}_varnameS'  '${selfxS}_evalS' \
            '${selfxS}_trueVarnameL';
        STR_L   aliasnameS="'${selfxS}'";  '${modUS}_A_aliasExit';
        : "'${selfxS}' EXIT (error)";
        break; fi;
    unset  '${selfxS}_errI'  '${selfxS}_errS'  '${selfxS}_varnameS'  '${selfxS}_evalS' \
        '${selfxS}_trueVarnameL';
    STR_L   aliasnameS="'${selfxS}'";  '${modUS}_A_aliasExit';
    : "'${selfxS}' EXIT (ok)";
'
alias ${selfxS}=${(P)${:-${selfxS}_SE}}
unset  selfxS  ${selfxS}_V_nexterrI  varcheck_selfS_SE  varcheck_varnameL_SE  varcheck_nametypeS_SE


STR_L   selfxS=${modUS}_A_localVarnamesDestroy
# USAGE
#     selfS=<aliasnameS>  varnameL=( <varname1> ... )  [nametypeS={local|global}]  <selfxS>
#
# NOTE
#     cannot use anon function here due to need to remove vars from caller context
#
INT_L   ${selfxS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    STR_L   reLocalOrGlobalA_S='^(local|global)$'
    set L selfxS selfS str 8 ${modUS}_C_reIdentA_S '';  eval ${modUS}_A_cgRequireVarTypeRex
    set L selfxS varnameL list 8 '' '';  eval ${modUS}_A_cgRequireVarTypeRex
    set L selfxS nametypeS str 8 reLocalOrGlobalA_S '';  eval ${modUS}_A_cgRequireVarTypeRex
    unset reLocalOrGlobalA_S
    okB=${B_T};  done
if [[ ${okB} -ne ${B_T} ]]; then
    STR_L   errS
    print -v errS -f "ERROR: %s: while defining \"%s\": call to \"%s_%s\" for \"%s\" failed:  { %s;  errI=%d }" -- \
          ${modS}  ${selfxS}  ${calleemodUS}  ${calleeS}  ${selectorS} \
          ${(P)${:-${calleemodUS}_V_errS}}  ${(P)${:-${calleemodUS}_V_errI}}
    print -f "%s\n" --  ${errS}
    exit 1;  fi
unset okB  calleemodUS  calleeS  selectorS
 
STR_G   ${selfxS}_SE='
    STR_L   aliasnameS="'${selfxS}'";  '${modUS}'_A_aliasEntry;
    INT_L  '${selfxS}_errI';
    STR_L  '${selfxS}_errS';
    STR_L  '${selfxS}_varnameS'  '${selfxS}_evalS'  '${selfxS}_prependS'=;
    LIST_L '${selfxS}_trueVarnameL';
 
    repeat 1; do ;
        '"${varcheck_selfS_SE}"' ;
        '"${varcheck_varnameL_SE}"' ;
        '"${varcheck_nametypeS_SE}"' ;
        if [[ ${+nametypeS} -eq 1 ]]; then  ;
            if [[ ${nametypeS} = global ]]; then  ;
                print -v '${selfxS}_prependS' -f "%s_V_" -- ${selfS};  fi;  fi;
        '${selfxS}'_trueVarnameL=( ${(us/ /)${:-${(@)varnameL} errI errS}} );
        print -v '${selfxS}'_evalS -f " lvn_%s_S" --  ${'${selfxS}'_trueVarnameL};
        '${selfxS}'_evalS="unset${'${selfxS}'_evalS}; ";
        STR_G  '${modUS}_V_replyS'=${'${selfxS}'_evalS};
        eval ${'${selfxS}'_evalS};  done;
    if [[ ${'${selfxS}'_errI} -ne 0 ]]; then ;
        BOOL_G '${modUS}_V_errB'=${B_T};
        INT_G  '${modUS}_V_errI'=${'${selfxS}'_errI};
        STR_G  '${modUS}_V_errS'=${'${selfxS}'_errS};
        unset '${selfxS}'_errI  '${selfxS}'_errS  '${selfxS}'_varnameS  '${selfxS}'_evalS \
            '${selfxS}'_trueVarnameL;
        STR_L   aliasnameS="'${selfxS}'";  '${modUS}'_A_aliasExit;
        : "'${selfxS}' EXIT (error)";
        break; fi;
    unset '${selfxS}'_errI  '${selfxS}'_errS  '${selfxS}'_varnameS  '${selfxS}'_evalS \
        '${selfxS}'_trueVarnameL;
    STR_L   aliasnameS="'${selfxS}'";  '${modUS}'_A_aliasExit;
    : "'${selfxS}' EXIT (ok)";
'
alias ${selfxS}=${(P)${:-${selfxS}_SE}}
unset  selfxS  ${selfxS}_V_nexterrI  varcheck_selfS_SE  varcheck_varnameL_SE  varcheck_nametypeS_SE


STR_L   selfxS=${modUS}_A_localVarsMake
# USAGE
#     selfS=<aliasnameS>  varnameL=( <nameS> ... )  [nametypeS={local|global}]  [printB=${B_[FT]}]  <selfxS>
#
# NOTE
#     This one can--and does--use anon function, since it doesn't actually create vars in caller context.
#     Instead, it creates output in global context that is then evaluated in caller context.
#
INT_L   ${selfxS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    STR_L   reLocalOrGlobalA_S='^(local|global)$'
    set L selfxS selfS str 12 ${modUS}_C_reIdentA_S '';  eval ${modUS}_A_cgRequireVarTypeRex
    set L selfxS varnameL list 12 '' '';  eval ${modUS}_A_cgRequireVarTypeRex
    set L selfxS nametypeS str 12 reLocalOrGlobalA_S '';  eval ${modUS}_A_cgRequireVarTypeRex
    unset reLocalOrGlobalA_S
    okB=${B_T};  done
if [[ ${okB} -ne ${B_T} ]]; then
    STR_L   errS
    print -v errS -f "ERROR: %s: while defining \"%s\": call to \"%s_%s\" for \"%s\" failed:  { %s;  errI=%d }" -- \
          ${modS}  ${selfxS}  ${calleemodUS}  ${calleeS}  ${selectorS} \
          ${(P)${:-${calleemodUS}_V_errS}}  ${(P)${:-${calleemodUS}_V_errI}}
    print -f "%s\n" --  ${errS}
    exit 1;  fi
unset okB  calleemodUS  calleeS  selectorS
 
STR_G   ${selfxS}_SE='
    STR_L   aliasnameS="'${selfxS}'";  '${modUS}'_A_aliasEntry;
    function {
        setopt  NO_LOCAL_LOOPS  LOCAL_OPTIONS;
        STR_L   varnameS  typeS  summaryS;
        STR_L   prependS=;
        MAP_L   varlistM;
 
        repeat 1; do ;
            '"${(P)${:-${modUS}_A_localErrvarsCreate_SE}}"'
            '"${(P)${:-${modUS}_A_localMatchvarsCreate_SE}}"'
            '"${varcheck_selfS_SE}"' ;
            '"${varcheck_varnameL_SE}"' ;
            '"${varcheck_nametypeS_SE}"' ;
            if [[ ${+nametypeS} -eq 1 ]]; then  ;
                if [[ ${nametypeS} = global ]]; then  ;
                    print -v prependS -f "%s_V_" -- ${selfS};  fi;  fi;
            for varnameS in ${(@)varnameL} errI errS; do  ;
                if ! [[ ${varnameS} =~ ${'${modUS}_C_reVarnameA_S'} ]]; then  ;
                    print -v errS -f "\"%s\" var value (from \"%s\" arg) does not match \"%s\" regex (\"%s\"): \"%s\"" -- \
                        varnameS  varnameL  '${modUS}_reVarnameA_S'  ${'${modUS}_reVarnameA_S'}  ${varnameS};
                    errI=7;  break;  fi;  done;
            varlistM=();
            for typeS in ${(k)'${modUS}_C_initToTypenameM'}; do  varlistM[${typeS}]=;  done;
            for varnameS in ${(@)varnameL} errI errS; do  ;
                varlistM[${varnameS[-1]}]+=" ${varnameS}";  done;
            summaryS=;
            for typeS in ${(ko)'${modUS}_C_initToTypenameM'}; do  ;
                if [[ ${#varlistM[${typeS}]} -gt 0 ]]; then  ;
                    summaryS+="${'${modUS}_C_initToTypenameM'[${typeS}]}_L";
                    for varnameS in ${(u)${(s/ /)varlistM[${typeS}]}}; do  ;
                        summaryS+=" ${prependS}${varnameS}=${'${modUS}_C_initToStartvalueM'[${typeS}]}";  done;
                    summaryS+=";  ";  fi;  done;
            STR_G   '${modUS}_V_replyS'=${summaryS};
            if [[ -v printB ]]; then  ;
                if [[ ${printB} -eq ${B_T} ]]; then  ;
                    print -f "%s" -- "${summaryS}";  fi;
            else  print -f "%s" -- "${summaryS}";  fi;  done;
        if [[ ${errI} -ne 0 ]]; then ;
            BOOL_G  '${modUS}_V_errB'=${B_T};
            INT_G   '${modUS}_V_errI'=${errI};
            STR_G   '${modUS}_V_errS'=${errS};
            STR_L   aliasnameS="'${selfxS}'";  '${modUS}'_A_aliasExit;
            : "'${selfxS}' EXIT (error)";
            break;
        else  ;
            INT_G   '${modUS}_V_replyI'='$(( ${(P)${:-${selfS}_V_nexterrI}} + 1 ))';  fi; 

    }
    STR_L   aliasnameS="'${selfxS}'";  '${modUS}'_A_aliasExit;
    : "'${selfxS}' EXIT (ok)";
'
alias ${selfxS}=${(P)${:-${selfxS}_SE}}
unset  selfxS  ${selfxS}_V_nexterrI  varcheck_selfS_SE  varcheck_varnameL_SE  varcheck_nametypeS_SE


STR_L   selfxS=${modUS}_A_localVarsDestroy
# USAGE
#     selfS=<aliasnameS>  varnameL=( <nameS> ... )  [nametypeS={local|global}]  <selfxS>
#
INT_L   ${selfxS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    STR_L   reLocalOrGlobalA_S='^(local|global)$'
    set L selfxS selfS str 12 ${modUS}_C_reIdentA_S '';  eval ${modUS}_A_cgRequireVarTypeRex
    set L selfxS varnameL list 12 '' '';  eval ${modUS}_A_cgRequireVarTypeRex
    set L selfxS nametypeS str 12 reLocalOrGlobalA_S '';  eval ${modUS}_A_cgRequireVarTypeRex
    unset reLocalOrGlobalA_S
    okB=${B_T};  done
if [[ ${okB} -ne ${B_T} ]]; then
    STR_L   errS
    print -v errS -f "ERROR: %s: while defining \"%s\": call to \"%s_%s\" for \"%s\" failed:  { %s;  errI=%d }" -- \
          ${modS}  ${selfxS}  ${calleemodUS}  ${calleeS}  ${selectorS} \
          ${(P)${:-${calleemodUS}_V_errS}}  ${(P)${:-${calleemodUS}_V_errI}}
    print -f "%s\n" --  ${errS}
    exit 1;  fi
unset okB  calleemodUS  calleeS  selectorS
 
STR_G   ${selfxS}_SE='
    STR_L   aliasnameS="'${selfxS}'";  '${modUS}'_A_aliasEntry;
    function {
        setopt  NO_LOCAL_LOOPS  LOCAL_OPTIONS;
        STR_L   varnameS  formatS  evalS;
        STR_L   prependS=;
 
        repeat 1; do ;
            '"${(P)${:-${modUS}_A_localErrvarsCreate_SE}}"'
            '"${(P)${:-${modUS}_A_localMatchvarsCreate_SE}}"'
            '"${varcheck_selfS_SE}"' ;
            '"${varcheck_varnameL_SE}"' ;
            '"${varcheck_nametypeS_SE}"' ;
            if [[ ${+nametypeS} -eq 1 ]]; then  ;
                if [[ ${nametypeS} = global ]]; then  ;
                    print -v prependS -f "%s_V_" -- ${selfS};  fi;  fi;
            formatS=" ${prependS}%s";
            print -v evalS -f ${formatS} --  ${(@)varnameL}  errI  errS;
            evalS="unset${evalS}; ";
            STR_G  '${modUS}_V_replyS'=${evalS};
            print -f "%s" --  ${evalS};  done;
        if [[ ${errI} -ne 0 ]]; then ;
            BOOL_G '${modUS}_V_errB'=${B_T};
            INT_G  '${modUS}_V_errI'=${errI};
            STR_G  '${modUS}_V_errS'=${errS};
            STR_L   aliasnameS="'${selfxS}'";  '${modUS}'_A_aliasExit;
            : "'${selfxS}' EXIT (error)";
            break;  fi;
    }
    STR_L   aliasnameS="'${selfxS}'";  '${modUS}'_A_aliasExit;
    : "'${selfxS}' EXIT (ok)";
'
alias ${selfxS}=${(P)${:-${selfxS}_SE}}
unset  selfxS  ${selfxS}_V_nexterrI  varcheck_selfS_SE  varcheck_varnameL_SE  varcheck_nametypeS_SE


STR_L   selfS=${modUS}_A_varRequireType
# USAGE
#     varnameS=<varname>  [typeS=<type>]  [namecheckB=<${B_T}|${B_F}>]  <selfS>
#
INT_L   ${selfS}_V_nexterrI=1
BOOL_L  okB=${B_F}
BOOL_L  printB=${B_T}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    calleemodUS=${modUS}  calleeS=A_localVarnamesMake  selectorS="local vars"
    STR_L   nametypeS=local
    LIST_L  varnameL=( targetTypeS headS nameL )
    eval ${calleemodUS}_${calleeS}
    eval "${selfS}_V_nexterrI=\${${modUS}_V_replyI}"
 
    calleemodUS=${modUS}  calleeS=F_cgRequireVarTypeRex  selectorS=varnameS
    ${calleemodUS}_${calleeS} \
        callerS=${selfS} varnameS=${selectorS} typeS=str errI=${(P)${:-${selfS}_V_nexterrI}} \
        indentI=16
    STR_L   varcheck_${selectorS}_nonamecheck_SE=${(P)${:-${modUS}_V_replyS}}
    eval "${selfS}_V_nexterrI=\${${modUS}_V_replyI}"
 
    calleemodUS=${modUS}  calleeS=F_cgRequireVarTypeRex  selectorS=namecheckB
    ${calleemodUS}_${calleeS} \
        callerS=${selfS} varnameS=${selectorS} typeS=integer errI=${(P)${:-${selfS}_V_nexterrI}} \
        indentI=12  varnotexistokB=T
    STR_L   varcheck_${selectorS}_SE=${(P)${:-${modUS}_V_replyS}}
    eval "${selfS}_V_nexterrI=\${${modUS}_V_replyI}"
 
    STR_L   reTypeS='^(scalar|integer|float|array|association)$'
    set L selfS varnameS str 16 ${modUS}_C_reVarnameA_S '';  eval ${modUS}_A_cgRequireVarTypeRex
    set L selfS typeS str 12 reTypeS '';  eval ${modUS}_A_cgRequireVarTypeRex
    unset  reTypeS
 
    okB=${B_T};  done
if [[ ${okB} -ne ${B_T} ]]; then
    STR_L   errS
    print -v errS -f "ERROR: %s: while defining \"%s\": call to \"%s_%s\" for \"%s\" failed:  { %s;  errI=%d }" -- \
          ${modS}  ${selfS}  ${calleemodUS}  ${calleeS}  ${selectorS} \
          ${(P)${:-${calleemodUS}_V_errS}}  ${(P)${:-${calleemodUS}_V_errI}}
    print -f "%s\n" --  ${errS}
    exit 1;  fi
unset okB  calleemodUS  calleeS  selectorS
 
STR_G   ${selfS}_SE='
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasEntry;
    : '${selfS}' ENTRY;
    function {
        setopt  NO_LOCAL_LOOPS  LOCAL_OPTIONS;
        '"${(P)${:-${modUS}_A_localErrvarsCreate_SE}}"'
        '"${(P)${:-${modUS}_A_localMatchvarsCreate_SE}}"'
        '"$(eval ${modUS}_A_localVarsMake)"' ;
        repeat 1; do ;
            '"${varcheck_namecheckB_SE}"' ;
            if [[ -v namecheckB ]]  &&  [[ ${namecheckB} = ${B_F} ]]; then ;
                '"${varcheck_varnameS_nonamecheck_SE}"' ;
            else  ;
                '"${varcheck_varnameS_SE}"' ;  fi;
            '"${varcheck_typeS_SE}"' ;
            if [[ ${(P)+varnameS} -eq 0 ]]; then  ;
                errI='$(( ${(P)${:-${selfS}_V_nexterrI}} + 0 ))';
                print -v errS -f "^varnameS not defined; varnameS=\"%s\"" --  ${varnameS};  break;  fi;
            if [[ ${+typeS} -ne 0 ]]; then  ;
                targetTypeS=${(Pt)varnameS};
                if [[ ${targetTypeS} =~ "^[A-Za-z0-9]+[-][A-Za-z0-9]+$" ]]; then  ;
                    nameL=( ${(s:-:)${targetTypeS}} );
                    headS=${nameL[1]};  fi;
                if [[ ${typeS} != ${targetTypeS}  &&  ${typeS} != ${headS} ]]; then ;
                    errI='$(( ${(P)${:-${selfS}_V_nexterrI}} + 1 ))';
                    print -v errS -f "var not of required type: varnameS=\"%s\"  typeS=\"%s\"  actualtypeS=\"%s\"" -- \
                        ${varnameS}  ${typeS}  ${(Pt)varnameS};  break;  fi;
            fi;  done;
        if [[ ${errI} -ne 0 ]]; then ;
            print -v errS -f "%s:  { %s;  errI=%d }" --  '${selfS}'  ${errS}  ${errI};
            BOOL_G '${modUS}_V_errB'=${B_T};
            INT_G  '${modUS}_V_errI'=${errI};
            STR_G  '${modUS}_V_errS'=${errS};
            STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
            : "'${selfS}' EXIT (error)";
            break;  fi;
    }
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
    : "'${selfS}' EXIT (ok)";
'
alias ${selfS}=${(P)${:-${selfS}_SE}}
eval ${modUS}_A_localVarnamesDestroy
unset  selfS  nametypeS  varnameL  varcheck_namecheckB_SE  varcheck_varnameS_nonamecheck_SE  varcheck_varnameS_SE  varcheck_typeS_SE


STR_L   selfS=${modUS}_A_defStart
# USAGE
#     modS=<modnameS>  <selfS>
#
# NOTE
#     cannot use anon function here due to need to create incomplete conditional clause
#
STR_L   nametypeS=global
BOOL_L  printB=${B_T}
LIST_L  varnameL=( loadstateS loaddecisionS formatS modUS )
eval ${modUS}_A_localVarnamesMake
STR_G   ${selfS}_SE='
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasEntry;
    '"$(eval ${modUS}_A_localVarsMake)"' ;
    '${lvn_loadstateS_S}'=UNDEF  '${lvn_loaddecisionS_S}'=no;
    repeat 1; do ;
        varnameS=modS typeS=scalar '${modUS}_A_varRequireType';
        varnameS='${modUS}_V_loadstateM' typeS=association '${modUS}_A_varRequireType';
        varnameS='${modUS}_V_loadstackL' typeS=array '${modUS}_A_varRequireType';
        '${lvn_modUS_S}'=${(U)modS//\//_};
 
        if [[ -v "'${modUS}_V_loadstateM'[${'${lvn_modUS_S}'}]" ]]; then ;
            '${lvn_loadstateS_S}'=${'${modUS}_V_loadstateM'[${'${lvn_modUS_S}'}]}; fi;
        case X${'${lvn_loadstateS_S}'} in
            (XUNDEF)   '${lvn_loaddecisionS_S}'=yes  ;;
            (Xloaded)  ;;
            (Xloading) ;&
            (Xfailed)  ;
                '${lvn_formatS_S}'="inappropriate loadstate encountered on module load attempt; ";
                '${lvn_formatS_S}'+="modS=\"%s\";  modUS=\"%s\";  loadstateS=\"%s\";  loadstackL=( %s )";
                '${lvn_errI_S}'=7;  print -v '${lvn_errS_S}' -f ${'${lvn_formatS_S}'} -- \
                    ${modS}  ${'${lvn_modUS_S}'}  ${'${lvn_loadstateS_S}'} \
                    "$('${modUS}_F_arrayToStrR' -P -A -- '${modUS}_V_loadstackL')"  ;;
            (X*)
                '${lvn_formatS_S}'="unknown loadstate encountered on module load attempt; ";
                '${lvn_formatS_S}'+="modS=\"%s\";  modUS=\"%s\";  loadstateS=\"%s\";  loadstackL=( %s )";
                '${lvn_errI_S}'=8;  print -v '${lvn_errS_S}' -f ${'${lvn_formatS_S}'} -- \
                    ${modS}  ${'${lvn_modUS_S}'}  ${'${lvn_loadstateS_S}'} \
                    "$('${modUS}_F_arrayToStrR' -P -A -- '${modUS}_V_loadstackL')"  ;;
        esac;  done;
    if [[ ${'${modUS}_V_errB'} -ne ${B_F} ]]; then
        STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
        print -f "ERROR: '${selfS}':  { %s;  errI=%d }\n" -- ${'${modUS}_V_errS'} ${'${modUS}_V_errI'};
        : "'${selfS}' EXIT (error)";  exit 1;  fi;
    if [[ ${'${lvn_errI_S}'} -ne 0 ]]; then ;
        STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
        print -f "ERROR: '${selfS}':  { %s;  errI=%d }\n" -- ${'${lvn_errS_S}'} ${'${lvn_errI_S}'};
        : "'${selfS}' EXIT (error)";  exit 1;  fi;
    if [[ ${'${lvn_loaddecisionS_S}'} = no ]]; then ;
        '"$(eval ${modUS}_A_localVarsDestroy)"' ;
        STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
        : "'${selfS}' EXIT \(ok - noload\)";
    else ;
        '${modUS}_V_loadstateM'[${'${lvn_modUS_S}'}]=loading;
        '${modUS}_V_loadstackL'+=( ${'${lvn_modUS_S}'} );
        '"$(eval ${modUS}_A_localVarsDestroy)"' ;
        STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
        : "'${selfS}' EXIT \(ok - load\)";
'
alias ${selfS}=${(P)${:-${selfS}_SE}}
eval ${modUS}_A_localVarnamesDestroy
unset  selfS  nametypeS  varnameL


STR_L   selfS=${modUS}_A_defEnd
# USAGE
#     modS=<modnameS>  <selfS>
#
# NOTE
#     cannot use anon function here due to need to resolve the incomplete conditional clause created by defStart
#
STR_L   nametypeS=global
BOOL_L  printB=${B_T}
LIST_L  varnameL=( modUS )
eval ${modUS}_A_localVarnamesMake
STR_G   ${selfS}_SE='
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasEntry;
    INT_L '${selfS}_V_resultI'=$?;
    '"$(eval ${modUS}_A_localVarsMake)"' ;
    '"${(P)${:-${modUS}_A_localMatchvarsCreate_SE}}"'
    repeat 1; do  ;
        varnameS=modS  typeS=scalar  '${modUS}_A_varRequireType';
        if [[ ${#modS} -eq 0 ]]; then ;
            print -v '${lvn_errS_S}' -f "\"%s\" var is empty;  loadstackL=( %s )" -- \
                modS  "$('${modUS}_F_arrayToStrR' -P -A -- '${modUS}_V_loadstackL')";
            '${lvn_errI_S}'=2; break; fi;
        if [[ ${'${selfS}_V_resultI'} -ne 0 ]]; then ;
            print -v '${lvn_errS_S}' \
                -f "nonzero pre-existing exit code value encountered:  exitI=%d;  modS=\"%s\";  loadstackL=( %s )" -- \
                ${'${selfS}_V_resultI'}  ${modS}  "$('${modUS}_F_arrayToStrR' -P -A -- '${modUS}_V_loadstackL')";
            unset '${selfS}_V_resultI';
            '${lvn_errI_S}'=3; break; fi;
        if ! [[ ${modS} =~ ${'${modUS}_C_reModnameA_S'} ]]; then ;
            print -v '${lvn_errS_S}' -f "\"%s\" var value does not match \"%s\" regex (\"%s\"): \"%s\";  loadstackL=( %s )" -- \
                modS  '${modUS}_C_reModnameA_S'  ${'${modUS}_C_reModnameA_S'}  ${modS} \
                "$('${modUS}_F_arrayToStrR' -P -A -- '${modUS}_V_loadstackL')";
            '${lvn_errI_S}'=4; break; fi;
        unset '${selfS}_V_resultI';
        '${lvn_modUS_S}'=${(U)modS//\//_};
        if [[ ${'${modUS}_V_loadstackL'[${#'${modUS}_V_loadstackL'}]} != ${'${lvn_modUS_S}'} ]]; then ;
            print -v '${lvn_errS_S}' -f "modS value did not match loadstack: modS=\"%s\";  modUS=\"%s\";  loadstackL=( %s )" -- \
                ${modS}  ${'${lvn_modUS_S}'}  "$('${modUS}_F_arrayToStrR' -P -A -- '${modUS}_V_loadstackL')";
            '${lvn_errI_S}'=5; break; fi;  done;
    if [[ ${'${lvn_errI_S}'} -ne 0 ]]; then ;
        print -v '${lvn_errS_S}' -f "%s:  { %s;  errI=%d }" -- '${selfS}' ${'${lvn_errS_S}'} ${'${lvn_errI_S}'};
        BOOL_G '${modUS}_V_errB'=${B_T};
        INT_G  '${modUS}_V_errI'=${'${lvn_errI_S}'};
        STR_G  '${modUS}_V_errS'=${'${lvn_errS_S}'};
        '"$(eval ${modUS}_A_localVarsDestroy)"' ;
        STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
        : "'${selfS}' EXIT (error)";
    else ;
        '${modUS}_V_loadstateM'[${'${lvn_modUS_S}'}]=loaded;
        '${modUS}_V_loadstackL'[${#'${modUS}_V_loadstackL'}]=( );
        '"$(eval ${modUS}_A_localVarsDestroy)"' ;
        STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
        : "'${selfS}' EXIT (ok)";  fi;
fi;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}
eval ${modUS}_A_localVarnamesDestroy
unset  selfS  nametypeS  varnameL


STR_L   selfS=${modUS}_A_modRequire
# USAGE
#     MEZXDIR=<mezxdirS> modL=( <mod1> <mod2> .... <modN> )  <selfS>
#
STR_G   ${selfS}_SE='
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasEntry;
    '${modUS}_F_modRequire' ;
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
    : "'${selfS}' EXIT (ok)";
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


STR_L   selfS=${modUS}_F_modRequire
# USAGE
#     MEZXDIR=<mezxdirS> modL=( <mod1> <mod2> .... <modN> )  <selfS>
#
INT_L   ${selfS}_V_nexterrI=1
BOOL_L  okB=${B_F}
STR_L   calleemodUS  calleeS  selectorS
repeat 1; do
    calleemodUS=${modUS}  calleeS=A_localVarsMake  selectorS="local vars"
    STR_L   nametypeS=local
    BOOL_L  printB=${B_F}
    LIST_L  varnameL=( indexI resultI formatS varnameS typeS modpathS modcachedpathS loadedB myModL baseErrI funcmodS funcmodUS versionS  versionUS versionpathS )
    INT_L   printB=${B_F}
    eval ${calleemodUS}_${calleeS}
    STR_G   ${selfS}_C_localVarsMake_SE=${(P)${:-${modUS}_V_replyS}}
    eval "${selfS}_V_nexterrI=\${${modUS}_V_replyI}"
 
    set G selfS MEZXDIR str 8 '' ${selfS}_C_;  eval ${modUS}_A_cgRequireVarTypeRex
    set G selfS modL list 8 '' ${selfS}_C_;  eval ${modUS}_A_cgRequireVarTypeRex
 
    okB=${B_T};  done
if [[ ${okB} -ne ${B_T} ]]; then
    STR_L   errS
    print -v errS -f "ERROR: %s: while defining \"%s\": call to \"%s_%s\" for \"%s\" failed:  { %s;  errI=%d }" -- \
          ${modS}  ${selfS}  ${calleemodUS}  ${calleeS}  ${selectorS} \
          ${(P)${:-${calleemodUS}_V_errS}}  ${(P)${:-${calleemodUS}_V_errI}}
    print -f "%s\n" --  ${errS}
    exit 1;  fi
unset okB  calleemodUS  calleeS  selectorS
 
function ${selfS}() {
    setopt  NO_LOCAL_LOOPS  LOCAL_OPTIONS;
    eval INTERNAL_FRAMEWORK_A_selfmodSetup
    eval "${${:-${modUS}_A_localErrvarsCreate}}"
    eval "${${:-${modUS}_A_localMatchvarsCreate}}"
    eval ${(P)${:-${selfS}_C_localVarsMake_SE}}
 
    funcmodS=${modS}  funcmodUS=${modUS}  loadedB=${B_F}  baseErrI=${(P)${:-${selfS}_V_nexterrI}}
    repeat 1;  do  ;
        eval ${(P)${:-${selfS}_C_varcheck_MEZXDIR_SE}}
        eval ${(P)${:-${selfS}_C_varcheck_modL_SE}}
        myModL=( "${(@)modL[*]}" )
        if ! [[ -d ${MEZXDIR} ]]; then
            errI=$(( ${baseErrI} + 0 ))
            print -v errS -f "\"%s\" var value does not refer to existing directory: \"%s\"" -- \
                MEZXDIR  ${MEZXDIR};  break;  fi
        if [[ ${#myModL} -ne 0 ]]; then
            for indexI in {1..${#myModL}};  do
                modS=${myModL[${indexI}]}
                if [[ ${#modS} -eq 0 ]]; then
                    errI=$(( ${baseErrI} + 1 ))
                    print -v errS -f "\"%s\" var element is empty;  modL=( %s );  indexI=%d;  loadstackL=( %s )" -- \
                        modL  "$( ${:-${funcmodUS}_F_arrayToStrR} -P -A --  myModL )"  \
                        ${indexI} "$( ${:-${funcmodUS}_F_arrayToStrR} -P -A --  ${funcmodUS}_V_loadstackL )"
                    break 2;  fi;  done;  fi;
        if [[ ${#myModL} -ne 0 ]]; then ;
            for indexI in {1..${#myModL}}; do ;
                modS=${myModL[${indexI}]};
                modpathS="${MEZXDIR}/${modS}.zsh";
		if [[ ${modS} =~ '^(.*)[:]('${INTERNAL_FRAMEWORK_C_reIdentF_S}')$' ]]; then
		    modpathS="${MEZXDIR}/${match[1]}.zsh"
		elif [[ ${modS} =~ '^(.*)[:]('${INTERNAL_FRAMEWORK_C_rePathnameF_S}')$' ]]; then
		    modpathS=${match[1]};  fi
                if ! [[ -f ${modpathS} ]]; then ;
                    errI=$(( ${baseErrI} + 2 ))
                    print -v errS \
                        -f "module not found: \"%s\" (\"%s\");  modL=( %s );  indexI=%d;  loadstackL=( %s )" -- \
                        ${modS}  ${modpathS} \
                        "$( ${:-${funcmodUS}_F_arrayToStrR} -P -A --  myModL) " \
                        ${indexI} \
                        "$( ${:-${funcmodUS}_F_arrayToStrR} -P -A --  ${funcmodUS}_V_loadstackL )"
                    break 2;  fi;  done;  fi
        if [[ ${#myModL} -ne 0 ]]; then
            for indexI in {1..${#myModL}}; do
                modS=${myModL[${indexI}]}
		modUS=${(U)modS//\//_}
                modpathS="${MEZXDIR}/${modS}.zsh"
                modcachedpathS="${MEZXDIR}/cache/${modUS}.cache.zsh"
		if [[ ${modS} =~ '^(.*)[:]('${INTERNAL_FRAMEWORK_C_reIdentF_S}')$' ]]; then
		    modS=${match[1]}
		    versionS=${match[2]}
                    modpathS="${MEZXDIR}/${modS}.zsh"
		    modUS=${(U)modS//\//_}  versionUS=${(U)versionS}
		    modcachedpathS="${MEZXDIR}/cache/${modUS}-${versionUS}.cache.zsh"
		elif [[ ${modS} =~ '^(.*)[:]('${INTERNAL_FRAMEWORK_C_rePathnameF_S}')$' ]]; then
		    modS=${match[1]}
		    modcachedpathS=${match[2]}
                    modpathS="${MEZXDIR}/${modS}.zsh"
		    modUS=${(U)modS//\//_};  fi
                #print -f "INFO: %s: loading \"%s\"\n" --  ${selfS}  ${modS}
                if [[ -f ${modcachedpathS} ]]; then
                    ${:-${funcmodUS}_F_fileDateOrdered}  ${modpathS}  ${modcachedpathS}
                    if [[ ${(P)${:-${funcmodUS}_V_errB}} -ne ${B_F} ]]; then  ;
                        errI=$(( ${baseErrI} + 3 ))
                        print -v errS -f "call to \"%s\" failed:  { %s;  errI=%d }" -- \
                            ${funcmodUS}_F_fileDateOrdered  "${(P)${:-${funcmodUS}_V_errS}}"  ${(P)${:-${funcmodUS}_V_errI}};  break 2;  fi;
                    if [[ ${(P)${:-${funcmodUS}_V_replyB}} -eq ${B_T} ]]; then  ;
                        . ${modcachedpathS};  resultI=$?;
                        if [[ ${resultI} -ne 0 ]]; then ;
                            formatS="module load from cache failed: \"%s\" (\"%s\");  resultI=%d;  modL=( %s );  ";
                            formatS+="indexI=%d;  loadstackL=( %s )";
                            errI=$(( ${baseErrI} + 4 ))
                            print -v errS -f ${formatS} -- \
                                ${modS}  ${modcachedpathS}  ${resultI} \
                                "$( ${:-${funcmodUS}_F_arrayToStrR} -P -A --  myModL )" \
                                ${indexI} \
                                "$( ${:-${funcmodUS}_F_arrayToStrR} -P -A --  ${funcmodUS}_V_loadstackL )";  break 2;  fi;
                        if functions ${modUS}_F_init >/dev/null; then  ;
                            eval ${modUS}_F_init;  resultI=$?;
                            if [[ ${resultI} -ne 0 ]]; then ;
                                errI=$(( ${baseErrI} + 5 ))
                                formatS="module initialization failed (call to \"%s\"):  { %s;  resultI=%d };  "
                                    formatS+="modL=( %s );  indexI=%d;  loadstackL=( %s )";
                                print -v errS -f ${formatS} -- \
                                    ${modUS}_F_init  "${(P)${:-${modUS}_V_errS}}"  ${resultI} \
                                    "$( ${:-${funcmodUS}_F_arrayToStrR}  -P -A --  myModL )" \
                                    ${indexI} \
                                    "$( ${:-${funcmodUS}_F_arrayToStrR}  -P -A --  ${funcmodUS}_V_loadstackL )";  break 2;  fi;  fi;
                        loadedB=${B_T};
                    else  ;
                        formatS="loadable module file is outdated:  modS=\"%s\",  modpathS=\"%s\",   modcachedpathS=\"%s\";  ";
                        formatS+="modL=( %s );  indexI=%d;  loadstackL=( %s )";
                        errI=$(( ${baseErrI} + 6 ))
                        print -v errS -f ${formatS} -- \
                            ${modS}  ${modpathS}  ${modcachedpathS} \
                            "$( ${:-${funcmodUS}_F_arrayToStrR}  -P -A -- myModL )" \
                            ${indexI} \
                            "$( ${:-${funcmodUS}_F_arrayToStrR}  -P -A --  ${funcmodUS}_V_loadstackL )";  break 2;  fi;
                else  ;
                    formatS="loadable module file does not exist;  modS=\"%s\",  modpathS=\"%s\",   modcachedpathS=\"%s\";  ";
                    formatS+="modL=( %s );  indexI=%d;  loadstackL=( %s )";
                    errI=$(( ${baseErrI} + 7 ))
                    print -v errS -f ${formatS} -- \
                        ${modS}  ${modpathS}  ${modcachedpathS} \
                        "$( ${:-${funcmodUS}_F_arrayToStrR}  -P -A -- myModL )" \
                        ${indexI} \
                        "$( ${:-${funcmodUS}_F_arrayToStrR}  -P -A --  ${funcmodUS}_V_loadstackL )";  break 2;  fi;
                if [[ ${loadedB} -ne ${B_T} ]]; then  ;
                    formatS="loadable module file not found: \"%s\";  modpathS=\"%s\",  modcachedpathS=\"%s\";  ";
                    formatS+="modL=( %s );  indexI=%d;  loadstackL=( %s )";
                    errI=$(( ${baseErrI} + 8 ))
                    print -v errS -f ${formatS} -- \
                        ${modS}  ${modpathS}  ${modcachedpathS} \
                        "$( ${:-${funcmodUS}_F_arrayToStrR}  -P -A -- modL )" \
                        ${indexI} \
                        "$( ${:-${funcmodUS}_F_arrayToStrR}  -P -A --  ${funcmodUS}_V_loadstackL )";  break 2;  fi;
            done;  fi;  done;
    if [[ ${errI} -ne 0 ]]; then
        INT_G   ${funcmodUS}_V_errB=${B_T}
        print -v errS -f "%s:  { %s;  errI=%d }" -- ${selfS}  "${errS}"  ${errI}
        STR_G   ${funcmodUS}_V_errS=${errS};  fi
    if [[ ${(P)${:-${funcmodUS}_V_errB}} -eq ${B_T} ]]; then
        STR_L   aliasnameS=${selfS};  eval ${funcmodUS}_A_aliasExit
        : "${selfS} EXIT (error)";  break;  fi;
}
unset  selfS  nametypeS  varnameL


STR_L   selfS=${modUS}_A_callIt
# USAGE
#     set <errI> <modS> <classS> <nameS> [<preS>] [<postS>];  <selfS>
#
STR_L   nametypeS=global
BOOL_L  printB=${B_T}
LIST_L  varnameL=( errbaseI modS classS nameS preS postS argL combinedS evalS resultI errI errS errB sS )
eval ${modUS}_A_localVarnamesMake
STR_G   ${selfS}_SE='
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasEntry;
    '"$(eval ${modUS}_A_localVarsMake)"' ; 
    repeat 1; do  ;
        '${lvn_errB_S}'=${B_T};
        '${lvn_argL_S}'=( "${@}" );
        if [[ $# -gt 0 ]]; then  '${lvn_errbaseI_S}'=$1;  fi;
        if [[ $# -lt 4 || $# -gt 6 ]]; then  ;
            '${lvn_errI_S}'=$(( ${'${lvn_errbaseI_S}'} + 0 ));
            print -v '${lvn_errS_S}' -f "argcI not in {4..6}: %d" -- $#;  break;  fi;
        '${lvn_errbaseI_S}'=$1  '${lvn_modS_S}'=$2  '${lvn_classS_S}'=$3  '${lvn_sS_S}'=$4;
        '${lvn_preS_S}'=${5-}  '${lvn_postS_S}'=${6-};
        '${lvn_combinedS_S}'="${(U)'${lvn_modS_S}'}_${(U)'${lvn_classS_S}'}_${'${lvn_sS_S}'}";
        '${lvn_evalS_S}'="${'${lvn_preS_S}'-} ${'${lvn_combinedS_S}'} ${'${lvn_postS_S}'-} ";
        eval ${'${lvn_evalS_S}'};  '${lvn_resultI_S}'=$?;
        if [[ ${'${lvn_resultI_S}'} -ne 0 ]]; then  ;
            '${lvn_errI_S}'=$(( ${'${lvn_errbaseI_S}'} + 1 ));
            print -v '${lvn_errS_S}' -f "eval failed: %d; evalS=\"%s\"" -- \
                 ${'${lvn_resultI_S}'}  ${'${lvn_evalS_S}'};  break;  fi;
        '${lvn_errB_S}'=${B_F};  done;
    if [[ ${'${lvn_errB_S}'} -ne ${B_F} ]]; then  ;
        if [[ ${'${lvn_errI_S}'} -eq 0 ]]; then  ;
            '${lvn_errI_S}'=$(( ${'${lvn_errbaseI_S}'} + 2 ));
            '${lvn_errS_S}'=${'${modUS}_V_errS'};  fi;
        print -v '${lvn_errS_S}' -f "%s:  { %s;  errI=%d }" --  '${selfS}'  ${'${lvn_errS_S}'}  ${'${lvn_errI_S}'};
        BOOL_G  '${modUS}_V_errB'=${B_T};
        INT_G   '${modUS}_V_errI'=${'${lvn_errI_S}'};
        STR_G   '${modUS}_V_errS'=${'${lvn_errS_S}'};
        '${modUS}_F_arrayToStrR' -p -A -- '${lvn_argL_S}';
        '"$(eval ${modUS}_A_localVarsDestroy)"'; 
        STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
        : "'${selfS}' EXIT (error) - $*";  break;  fi;
    '"$(eval ${modUS}_A_localVarsDestroy)"'; 
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
    : "'${selfS}' EXIT (ok) - $*";
'
alias ${selfS}=${(P)${:-${selfS}_SE}}
eval ${modUS}_A_localVarnamesDestroy
unset  selfS  nametypeS  varnameL


STR_L   nametypeS=global
BOOL_L  printB=${B_T}
LIST_L  varnameL=( errB errI errS )
STR_L   selfS=${modUS}_A_loadDependencies
eval ${modUS}_A_localVarnamesMake
STR_G   ${selfS}_SE='
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasEntry;
    '"$(eval ${modUS}_A_localVarsMake)"' ;
    repeat 1; do  ;
        '${lvn_errB_S}'=${B_T}  '${lvn_errI_S}'=1;  INTERNAL_FRAMEWORK_A_modRequire;
        '${lvn_errI_S}'=0  '${lvn_errB_S}'=${B_F};  done;
    if [[ ${'${lvn_errB_S}'} -ne ${B_F} ]]; then  ;
        '${lvn_errS_S}'=${INTERNAL_FRAMEWORK_V_errS};
        print -f "ERROR: %s: failed to load dependencies:  { %s };  errI=%d;  modL=( %s )" -- \
            "$0"  "${'${lvn_errS_S}'}"  ${'${lvn_errI_S}'}  "$(INTERNAL_FRAMEWORK_F_arrayToStrR -P -A -- modL)";
        exit 1;  fi;
    : '"$(eval ${modUS}_A_localVarsDestroy)"' ;
    STR_L   aliasnameS="'${selfS}'";  '${modUS}'_A_aliasExit;
'
alias ${selfS}=${(P)${:-${selfS}_SE}}


eval ${modUS}_A_localErrvarsCreate
STR_L   funcnameS

repeat 1; do
    errB=${B_T}
    eval ${modUS}_V_errB=${B_F}
    eval ${modUS}_F_main
    if [[ ${(P)${:-${modUS}_V_errB}} -eq ${B_T} ]]; then
        errI=1;  errS=${(P)${:-${modUS}_V_errS}};  break;  fi
    MAP_L   saved_loadstateM=( ${(kvP)${:-${modUS}_V_loadstateM}} )
    LIST_L  saved_loadstackL=( ${(@P)${:-${modUS}_V_loadstackL}} )
    eval "MAP_G   ${modUS}_V_loadstateM=( ${modUS} loaded )"
    eval "LIST_G  ${modUS}_V_loadstackL=( )"

    funcnameS=${modUS}_F_modCacheWrite;  eval ${funcnameS} \
         --module ${modS} \
         --include alias \
             'BOOL_L${CorS}INT_L${CorS}FLOATE_L${CorS}FLOATF_L${CorS}LIST_L${CorS}MAP_L${CorS}STR_L' \
             'BOOL_G${CorS}INT_G${CorS}FLOATE_G${CorS}FLOATF_G${CorS}LIST_G${CorS}MAP_G${CorS}STR_G' \
             'LOCAL${CorS}GLOBAL' \
         --include var \
             'B_T${CorS}B_F${CorS}B_N' \
             ${modUS}'_${CdotS}${CstarS}_SE' \
             ${modUS}'_F_${CparenoS}${CbsoS}a-zA-Z0-9_${CbscS}${CparencS}${CreoneormoreS}_${CbsoS}CV${CbscS}_${CdotS}${CstarS}'
    if [[ ${(P)${:-${modUS}_V_errB}} -eq ${B_T} ]]; then
        errI=2;  errS=${(P)${:-${modUS}_V_errS}};  break;  fi
    eval "MAP_G   ${modUS}_V_loadstateM=( ${(kv)saved_loadstateM} )"
    eval "LIST_G  ${modUS}_V_loadstackL=( ${saved_loadstackL} )"
    errB=${B_F};  done
if [[ ${errB} -ne ${B_F} ]]; then
    print -v errS -f "%s:  { %s;  errI=%d }" --  ${modS}  ${errS}  ${errI}
    print -f "%s\n" --  ${errS};  exit 1;  fi
true
