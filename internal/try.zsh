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

STR_L   modS=internal/try
STR_L   modUS=${(U)modS//\//_}
INTERNAL_FRAMEWORK_A_defStart
LIST_L  modL=( internal/rex  internal/codegen/framework );

repeat 1; do
    INTERNAL_FRAMEWORK_A_localErrvarsCreate;  errB=${B_T}
    INTERNAL_FRAMEWORK_A_loadDependencies
    INTERNAL_FRAMEWORK_A_retsReset
    eval INTERNAL_CODEGEN_FRAMEWORK_A_selfCodegen
    eval INTERNAL_CODEGEN_FRAMEWORK_A_stateReset
    unset codeL thiscodeL
    INTERNAL_FRAMEWORK_F_modCacheWrite \
	--module ${modS} \
	--depend  internal/rex  internal/codegen/framework \
	--include alias \
            "${modUS}_[A-Za-z0-9][A-Za-z0-9_]*" \
            "${modUS}_[A-Za-z0-9][A-Za-z0-9_]*\{" \
            "\}${modUS}_[A-Za-z0-9][A-Za-z0-9_]*" \
            "\}${modUS}_[A-Za-z0-9][A-Za-z0-9_]*\{"
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
eval "LIST_G  ${modUS}_V_stateS_L=( )"
eval "LIST_G  ${modUS}_V_prependL=( TRY_ _ )"
eval "MAP_G   ${modUS}_V_extantcodeM=( )"
INT_G   ${modUS}_V_depthI=0

eval "LIST_G  ${modUS}_P_stateS_L=( )"
STR_G   ${modUS}_P_stateS=
STR_G   ${modUS}_P_errS=

#CODEGEN_EXEC{
INTERNAL_FRAMEWORK_A_localErrvarsCreate
STR_L   basenameS  preS  postS  nameS  namelongS  sS  sepS
STR_L   qs_S="'"
LIST_L  codeL=( )  thiscodeL=( )  extantcodeL=( )
STR_L   modS=internal/try
STR_L   modUS=${(U)modS//\//_}
MAP_L   writtenM=( )
errB=${B_T}


# macros used via text inclusion

STR_L   selfS=${modUS}_V_AI_breakOnErrorSet
STR_G   ${selfS}='
    : "'${selfS}' START";
    if [[ ${'${modUS}_V_errB'} -eq ${B_T} ]]; then  break;  fi;
    : "'${selfS}' END";
'
unset selfS


STR_L   selfS=${modUS}_V_AI_failOnBad_V_stateS
STR_G   ${selfS}='
    : "'${selfS}' START";
    if [[ ${+'${modUS}_V_stateS'} -eq 0 ]]; then  ;
        '${modUS}_V_errB'=${B_T}  '${modUS}_V_errI'=6;
        '${modUS}_V_errS'="\"'${selfS}'\": INTERNAL ERROR: \"'${modUS}_V_stateS'\" var not defined";  break;  fi;
    case ${(t)'${modUS}_V_stateS'} in
        (scalar*) ;;
        (*)
            '${modUS}_V_errB'=${B_T}  '${modUS}_V_errI'=3;
            '${modUS}_V_errS'="\"'${selfS}'\": INTERNAL ERROR: \"'${modUS}_V_stateS'\" type not scalar*: \"${(t)'${modUS}_V_stateS'}\"";  break;
            ;;  esac;
    : "'${selfS}' END";
'
unset selfS


STR_L   selfS=${modUS}_V_AI_failOnBad_P_stateS
STR_G   ${selfS}='
    : "'${selfS}' START";
    if [[ ${+'${modUS}_P_stateS'} -eq 0 ]]; then  ;
        '${modUS}_V_errB'=${B_T}  '${modUS}_V_errI'=6;
        '${modUS}_V_errS'="\"'${selfS}'\": INTERNAL ERROR: \"'${modUS}_P_stateS'\" var not defined";  break;  fi;
    case ${(t)'${modUS}_P_stateS'} in
        (scalar*) ;;
        (*)
            '${modUS}_V_errB'=${B_T}  '${modUS}_V_errI'=3;
            '${modUS}_V_errS'="\"'${selfS}'\": INTERNAL ERROR: \"'${modUS}_P_stateS'\" type not scalar*: \"${(t)'${modUS}_V_stateS'}\"";  break;
            ;;  esac;
    : "'${selfS}' END";
'
unset selfS


STR_L   selfS=${modUS}_V_AI_failOnBad_P_errI
STR_G   ${selfS}='
    : "'${selfS}' START";
    if [[ ${+'${modUS}_P_errI'} -eq 0 ]]; then  ;
        '${modUS}_V_errB'=${B_T}  '${modUS}_V_errI'=6;
        '${modUS}_V_errS'="\"'${selfS}'\": INTERNAL ERROR: \"'${modUS}_P_errI'\" var not defined";  break;  fi;
    case ${(t)'${modUS}_P_errI'} in
        (scalar*) ;;
        (integer*) ;;
        (*)
            '${modUS}_V_errB'=${B_T}  '${modUS}_V_errI'=3;
            '${modUS}_V_errS'="\"'${selfS}'\": INTERNAL ERROR: \"'${modUS}_P_errI'\" type not scalar* or |integer*: \"${(t)'${modUS}_V_errI'}\"";  break;
            ;;  esac;
    : "'${selfS}' END";
'
unset selfS


STR_L   selfS=${modUS}_V_AI_failOnBad_P_errS
STR_G   ${selfS}='
    : "'${selfS}' START";
    if [[ ${+'${modUS}_P_errS'} -eq 0 ]]; then  ;
        '${modUS}_V_errB'=${B_T}  '${modUS}_V_errS'=6;
        '${modUS}_V_errS'="\"'${selfS}'\": INTERNAL ERROR: \"'${modUS}_P_errS'\" var not defined";  break;  fi;
    case ${(t)'${modUS}_P_errS'} in
        (scalar*) ;;
        (*)
            '${modUS}_V_errB'=${B_T}  '${modUS}_V_errI'=3;
            '${modUS}_V_errS'="\"'${selfS}'\": INTERNAL ERROR: \"'${modUS}_P_errS'\" type not scalar* or |integer*: \"${(t)'${modUS}_V_errS'}\"";  break;
            ;;  esac;
    : "'${selfS}' END";
'
unset selfS


STR_L   selfS=${modUS}_V_AI_failOnBad_V_stateS_L
STR_G   ${selfS}='
    : "'${selfS}' START";
    if [[ ${+'${modUS}_V_stateS_L'} -eq 0 ]]; then  ;
        '${modUS}_V_errB'=${B_T}  '${modUS}_V_errI'=6;
        '${modUS}_V_errS'="\"'${selfS}'\": INTERNAL ERROR: \"'${modUS}_V_stateS_L'\" var not defined";  break;  fi;
    case ${(t)'${modUS}_V_stateS_L'} in
        (array*) ;;
        (*)
            '${modUS}_V_errB'=${B_T}  '${modUS}_V_errI'=3;
            '${modUS}_V_errS'="\"'${selfS}'\": INTERNAL ERROR: \"'${modUS}_V_stateS_L'\" type not array*: \"${(t)'${modUS}_V_stateS_L'}\"";  break;
            ;;  esac;
    : "'${selfS}' END";
'
unset selfS


STR_L   selfS=${modUS}_V_AI_failOnBad_P_stateS_L
STR_G   ${selfS}='
    : "'${selfS}' START";
    if [[ ${+'${modUS}_P_stateS_L'} -eq 0 ]]; then  ;
        '${modUS}_V_errB'=${B_T}  '${modUS}_V_errI'=6;
        '${modUS}_V_errS'="\"'${selfS}'\": INTERNAL ERROR: \"'${modUS}_P_stateS_L'\" var not defined";  break;  fi;
    case ${(t)'${modUS}_P_stateS_L'} in
        (array*) ;;
        (*)
            '${modUS}_V_errB'=${B_T}  '${modUS}_V_errI'=3;
            '${modUS}_V_errS'="\"'${selfS}'\": INTERNAL ERROR: \"'${modUS}_P_stateS_L'\" type not array*: \"${(t)'${modUS}_P_stateS_L'}\"";  break;
            ;;  esac;
    : "'${selfS}' END";
'
unset selfS


STR_L   selfS=${modUS}_V_AI_failOnEmpty_V_stateS_L
STR_G   ${selfS}='
    : "'${selfS}' START";
    '"${(P)${:-${modUS}_V_AI_failOnBad_V_stateS_L}}"' ;
    if [[ ${#'${modUS}_V_stateS_L'} -eq 0 ]]; then  ;
        '${modUS}_V_errB'=${B_T}  '${modUS}_V_errI'=1;
        '${modUS}_V_errS'="\"'${selfS}'\": INTERNAL ERROR: empty state stack";  break;  fi;
    : "'${selfS}' END";
'
unset selfS


STR_L   selfS=${modUS}_V_AI_failOnEmpty_P_stateS_L
STR_G   ${selfS}='
    : "'${selfS}' START";
    '"${(P)${:-${modUS}_V_AI_failOnBad_P_stateS_L}}"' ;
    if [[ ${#'${modUS}_P_stateS_L'} -eq 0 ]]; then  ;
        '${modUS}_V_errB'=${B_T}  '${modUS}_V_errI'=1;
        '${modUS}_V_errS'="\"'${selfS}'\": INTERNAL ERROR: empty state stack";  break;  fi;
    : "'${selfS}' END";
'
unset selfS


STR_L   selfS=${modUS}_V_AI_failOnStateAbsent
STR_L   scrubS='unset  '${selfS}_V_stateS'  '${selfS}_V_errS'  '${selfS}_V_foundB';  '
STR_G   ${selfS}='
    : "'${selfS}' START";
    STR_L   '${selfS}_V_stateS';
    STR_L   '${selfS}_V_errS'="current state not in req list";
    BOOL_L  '${selfS}_V_foundB'=${B_F};
    
    repeat 1; do  ;
        '"${(P)${:-${modUS}_V_AI_failOnEmpty_V_stateS_L}}"';
        '"${(P)${:-${modUS}_V_AI_failOnEmpty_P_stateS_L}}"';  done;
    if [[ ${'${modUS}_V_errB'} -ne ${B_F} ]]; then  ;
        print -v '${modUS}_V_errS' -f "%s: subcall failed:  { %s }" --  '${selfS}'  "${'${modUS}_V_errS'}";  '"${scrubS}"';  break;  fi; 
    if [[ ${+'${modUS}_P_errS'} -eq 1 ]]; then  ;
        case ${(t)'${modUS}_P_errS'} in
            (scalar*) ;;
            (*)
                '${modUS}_V_errB'=${B_T}  '${modUS}_V_errI'=4;
                '${modUS}_V_errS'="\"'${selfS}'\": INTERNAL ERROR: \"'${modUS}_P_errS'\" type not scalar*: \"${(t)'${modUS}_P_errS'}\"";  '"${scrubS}"';  break;
                ;;  esac;
        '${selfS}_V_errS'=${'${modUS}_P_errS'};  fi;
    for '${selfS}_V_stateS' in ${(@)'${modUS}_P_stateS_L'}; do  ;
        if [[ ${'${selfS}_V_stateS'} = ${'${modUS}_V_stateS_L'[${#'${modUS}_V_stateS_L'}]} ]]; then  '${selfS}_V_foundB'=${B_T};  break;  fi;  done;
    if [[ ${'${selfS}_V_foundB'} -ne ${B_T} ]]; then
        '${modUS}_V_errB'=${B_T}  '${modUS}_V_errI'=5;
        '${modUS}_V_errS'="'${selfS}': ${'${selfS}_V_errS'}: ${'${modUS}_V_stateS_L'[${#'${modUS}_V_stateS_L'}]};  ";
        '${modUS}_V_errS'+="'${modUS}_P_stateS_L'=( ${(@)'${modUS}_P_stateS_L'} )";  '"${scrubS}"';  break;  fi;
    '"${scrubS}"';
    : "'${selfS}' END";
'
unset selfS  scrubS


STR_L   selfS=${modUS}_V_AI_failOnStatePresent
STR_L   scrubS='unset  '${selfS}_V_stateS'  '${selfS}_V_errS'  '${selfS}_V_foundB';  '
STR_G   ${selfS}='
    : "'${selfS}' START";
    STR_L   '${selfS}_V_stateS';
    STR_L   '${selfS}_V_errS'="current state not in req list";
    BOOL_L  '${selfS}_V_foundB'=${B_F};
    
    repeat 1; do  ;
        '"${(P)${:-${modUS}_V_AI_failOnEmpty_V_stateS_L}}"';
        '"${(P)${:-${modUS}_V_AI_failOnEmpty_P_stateS_L}}"';  done;
    if [[ ${'${modUS}_V_errB'} -ne ${B_F} ]]; then  ;
        print -v '${modUS}_V_errS' -f "%s: subcall failed:  { %s }" --  '${selfS}'  "${'${modUS}_V_errS'}";  '"${scrubS}"';  break;  fi; 
    if [[ ${+'${modUS}_P_errS'} -eq 1 ]]; then  ;
        case ${(t)'${modUS}_P_errS'} in
            (scalar*) ;;
            (*)
                '${modUS}_V_errB'=${B_T}  '${modUS}_V_errI'=8;
                '${modUS}_V_errS'="\"'${selfS}'\": INTERNAL ERROR: \"'${modUS}_P_errS'\" type not scalar*: \"${(t)'${modUS}_P_errS'}\"";  '"${scrubS}"';  break;
                ;;  esac;
        '${selfS}_V_errS'=${'${modUS}_P_errS'};  fi;
    for '${selfS}_V_stateS' in ${(@)'${modUS}_P_stateS_L'}; do  ;
        if [[ ${'${selfS}_V_stateS'} = ${'${modUS}_V_stateS_L'[${#'${modUS}_V_stateS_L'}]} ]]; then  '${selfS}_V_foundB'=${B_T};  break;  fi;  done;
    if [[ ${'${selfS}_V_foundB'} -ne ${B_F} ]]; then
        '${modUS}_V_errB'=${B_T}  '${modUS}_V_errI'=9;
        '${modUS}_V_errS'="'${selfS}': ${'${selfS}_V_errS'}: ${'${modUS}_V_stateS_L'[${#'${modUS}_V_stateS_L'}]};  ";
        '${modUS}_V_errS'+="'${modUS}_P_stateS_L'=( ${(@)'${modUS}_P_stateS_L'} )";  '"${scrubS}"';  break;  fi;
    '"${scrubS}"';
    : "'${selfS}' END";
'
unset selfS  scrubS


STR_L   selfS=${modUS}_V_AI_statePush
STR_G   ${selfS}='
    : "'${selfS}' START";
    repeat 1; do  ;
        '"${(P)${:-${modUS}_V_AI_failOnBad_V_stateS_L}}"';
        '"${(P)${:-${modUS}_V_AI_failOnBad_P_stateS}}"';  done; 
    if [[ ${'${modUS}_V_errB'} -ne ${B_F} ]]; then  ;
        print -v '${modUS}_V_errS' -f "%s: subcall failed:  { %s }" --  '${selfS}'  "${'${modUS}_V_errS'}";  break;  fi; 
    '${modUS}_V_stateS_L'+=( ${'${modUS}_P_stateS'} );
    : "'${selfS}' END";
'
unset selfS


STR_L   selfS=${modUS}_V_AI_statePop
STR_G   ${selfS}='
    : "'${selfS}' START";
    repeat 1; do  ;
        '"${(P)${:-${modUS}_V_AI_failOnEmpty_V_stateS_L}}"';  done; 
    if [[ ${'${modUS}_V_errB'} -ne ${B_F} ]]; then  ;
        print -v '${modUS}_V_errS' -f "%s: subcall failed:  { %s }" --  '"${selfS}"'  "${'${modUS}_V_errS'}";  break;  fi; 
    '${modUS}_V_replyS'=${'${modUS}_V_stateS_L'[${#'${modUS}_V_stateS_L'}]};
    '${modUS}_V_stateS_L'[${#'${modUS}_V_stateS_L'}]=( );
    : "'${selfS}' END";
'
unset selfS


STR_L   selfS=${modUS}_V_AI_stateGet
STR_G   ${selfS}='
    : "'${selfS}' START";
    repeat 1; do  ;
        '"${(P)${:-${modUS}_V_AI_failOnEmpty_V_stateS_L}}"';  done; 
    if [[ ${'${modUS}_V_errB'} -ne ${B_F} ]]; then  ;
        print -v '${modUS}_V_errS' -f "%s: subcall failed:  { %s }" --  '${selfS}'  "${'${modUS}_V_errS'}";  break;  fi; 
    '${modUS}_V_replyS'=${'${modUS}_V_stateS_L'[${#'${modUS}_V_stateS_L'}]};
    : "'${selfS}' END";
'
unset selfS


STR_L   selfS=${modUS}_V_AI_stateReplace
STR_G   ${selfS}='
    : "'${selfS}' START";
    repeat 1; do  ;
        '"${(P)${:-${modUS}_V_AI_failOnBad_V_stateS_L}}"';
        '"${(P)${:-${modUS}_V_AI_failOnBad_P_stateS}}"';  done; 
    if [[ ${'${modUS}_V_errB'} -ne ${B_F} ]]; then  ;
        print -v '${modUS}_V_errS' -f "%s: subcall failed:  { %s }" --  '${selfS}'  "${'${modUS}_V_errS'}";  break;  fi; 
    '${modUS}_V_stateS_L'[${#'${modUS}_V_stateS_L'}]=${'${modUS}_P_stateS'};
    : "'${selfS}' END";
'
unset selfS


STR_L   selfS=${modUS}_V_AI_errorSet
STR_G   ${selfS}='
    : "'${selfS}' START";
    repeat 1; do  ;
        '"${(P)${:-${modUS}_V_AI_failOnBad_P_errI}}"';
        '"${(P)${:-${modUS}_V_AI_failOnBad_P_errS}}"';  done; 
    '${modUS}_V_errB'=${B_T}  '${modUS}_V_errI'=${'${selfS}_P_errI'}  '${modUS}_V_errS'=${'${selfS}_P_errS'};
    : "'${selfS}' END";
'
unset selfS


LIST_G  nameL=( TRY TRY_ THROW CATCH CATCH_ CATCH_FINALLY NOCATCH NOCATCH_FINALLY FINALLY FINALLY_ NOFINALLY )
MAP_G   codeM=(
    'TRY{'  '
    '"${(P)${:-${modUS}_V_AI_breakOnErrorSet}}"';
    repeat 1; do; 
        repeat 1; do; 
            repeat 1; do; 
                repeat 1; do;
                    '${modUS}_P_stateS'=TRY;  '"${(P)${:-${modUS}_V_AI_statePush}}"';
                    : "user TRY code below";
'

    '}TRY'  '
        done; 
    '"${(P)${:-${modUS}_V_AI_breakOnErrorSet}}"'; 
    '"${(P)${:-${modUS}_V_AI_failOnEmpty_V_stateS_L}}"'; 
    '${modUS}_P_stateS_L'=( FINALLY NOFINALLY );  '"${(P)${:-${modUS}_V_AI_failOnStateAbsent}}"'; 
    '"${(P)${:-${modUS}_V_AI_statePop}}"'; 
    '${modUS}_P_stateS_L'=( UNCAUGHT );  '${modUS}_P_errS'="uncaught throw seen in \"}TRY\"";  '"${(P)${:-${modUS}_V_AI_failOnStatePresent}}"'; 
    '${modUS}_P_stateS_L'=( CATCH CAUGHT NOCATCH );  '"${(P)${:-${modUS}_V_AI_failOnStateAbsent}}"'; 
    '"${(P)${:-${modUS}_V_AI_statePop}}"'; 
    '${modUS}_P_stateS_L'=( TRY );  '"${(P)${:-${modUS}_V_AI_failOnStateAbsent}}"'; 
    '"${(P)${:-${modUS}_V_AI_statePop}}"'; 
'

    '}TRY_'  '
                    done;  done;  done;
        '"${(P)${:-${modUS}_V_AI_breakOnErrorSet}}"';
        '${modUS}_P_stateS_L'=( THROW ); '${modUS}_P_errS'="uncaught throw seen in \"}TRY_\"";  '"${(P)${:-${modUS}_V_AI_failOnStatePresent}}"';
        '${modUS}_P_stateS_L'=( TRY );  '"${(P)${:-${modUS}_V_AI_failOnStateAbsent}}"'; 
        '"${(P)${:-${modUS}_V_AI_statePop}}"';
        done;
'

    'THROW'  '
                    '"${(P)${:-${modUS}_V_AI_breakOnErrorSet}}"';
                    '${modUS}_P_stateS_L'=( TRY );  '"${(P)${:-${modUS}_V_AI_failOnStateAbsent}}"';
                    '${modUS}_P_stateS'=THROW;  '"${(P)${:-${modUS}_V_AI_statePush}}"';
                    break;
'

    'CATCH{'  '
                    done;
                '"${(P)${:-${modUS}_V_AI_breakOnErrorSet}}"'; 
                '"${(P)${:-${modUS}_V_AI_failOnEmpty_V_stateS_L}}"'; 
                '${modUS}_P_stateS_L'=( TRY THROW );   '"${(P)${:-${modUS}_V_AI_failOnStateAbsent}}"'; 
                '"${(P)${:-${modUS}_V_AI_stateGet}}"'; 
                if [[ ${'${modUS}_V_replyS'} = TRY ]]; then  ;
                    '${modUS}_P_stateS'=CATCH;  '"${(P)${:-${modUS}_V_AI_statePush}}"';  break;  fi;
                '${modUS}_P_stateS'=CAUGHT;  '"${(P)${:-${modUS}_V_AI_stateReplace}}"'; 
                : "user CATCH code below"; 
'

    '}CATCH'  '
                done; 
            '"${(P)${:-${modUS}_V_AI_breakOnErrorSet}}"'; 
            '"${(P)${:-${modUS}_V_AI_failOnEmpty_V_stateS_L}}"'; 
            '${modUS}_P_stateS_L'=( CATCH CAUGHT );  '"${(P)${:-${modUS}_V_AI_failOnStateAbsent}}"'; 
'

    '}CATCH{' '
    '${modUS}_A_CATCH'{; 
'

    '}CATCH_'  '
                done;  done;  done; 
    '"${(P)${:-${modUS}_V_AI_breakOnErrorSet}}"'; 
    '"${(P)${:-${modUS}_V_AI_failOnEmpty_V_stateS_L}}"'; 
    '${modUS}_P_stateS_L'=( CATCH CAUGHT );  '"${(P)${:-${modUS}_V_AI_failOnStateAbsent}}"'; 
    '"${(P)${:-${modUS}_V_AI_statePop}}"';
    '${modUS}_P_stateS_L'=( TRY );  '"${(P)${:-${modUS}_V_AI_failOnStateAbsent}}"'; 
    '"${(P)${:-${modUS}_V_AI_statePop}}"';
'

    'NOCATCH'  '
                    done;
                '"${(P)${:-${modUS}_V_AI_breakOnErrorSet}}"'; 
                '"${(P)${:-${modUS}_V_AI_failOnEmpty_V_stateS_L}}"'; 
                '${modUS}_P_stateS_L'=( TRY THROW );   '"${(P)${:-${modUS}_V_AI_failOnStateAbsent}}"'; 
                done; 
            '"${(P)${:-${modUS}_V_AI_breakOnErrorSet}}"'; 
            '"${(P)${:-${modUS}_V_AI_failOnEmpty_V_stateS_L}}"'; 
            '${modUS}_P_stateS_L'=( TRY THROW );  '"${(P)${:-${modUS}_V_AI_failOnStateAbsent}}"'; 
            '"${(P)${:-${modUS}_V_AI_stateGet}}"';
            if [[ ${'${modUS}_V_replyS'} = TRY ]]; then  '${modUS}_P_stateS'=NOCATCH;  '"${(P)${:-${modUS}_V_AI_statePush}}"';
            else '${modUS}_P_stateS'=UNCAUGHT;  '"${(P)${:-${modUS}_V_AI_stateReplace}}"'; fi; 
'

    'FINALLY{'  '
            '"${(P)${:-${modUS}_V_AI_breakOnErrorSet}}"';
            '"${(P)${:-${modUS}_V_AI_failOnEmpty_V_stateS_L}}"';
            '${modUS}_P_stateS_L'=( CATCH CAUGHT NOCATCH UNCAUGHT );  '"${(P)${:-${modUS}_V_AI_failOnStateAbsent}}"';
            '${modUS}_P_stateS'=FINALLY;  '"${(P)${:-${modUS}_V_AI_statePush}}"'; 
            : "user FINALLY code below"; 
'

    '}CATCH_FINALLY{'  '
    }'${modUS}_A_CATCH';
    '${modUS}_A_FINALLY'{; 
'

    '}NOCATCH_FINALLY{'  '
    '${modUS}_A_FINALLY'{; 
'

    '}FINALLY'  '
            done; 
        '"${(P)${:-${modUS}_V_AI_breakOnErrorSet}}"'; 
        '"${(P)${:-${modUS}_V_AI_failOnEmpty_V_stateS_L}}"'; 
        '${modUS}_P_stateS_L'=( FINALLY );  '"${(P)${:-${modUS}_V_AI_failOnStateAbsent}}"'; 
'

    '}FINALLY_'  '
            done;  done; 
    '"${(P)${:-${modUS}_V_AI_breakOnErrorSet}}"'; 
    '"${(P)${:-${modUS}_V_AI_failOnEmpty_V_stateS_L}}"'; 
    '${modUS}_P_stateS_L'=( FINALLY );  '"${(P)${:-${modUS}_V_AI_failOnStateAbsent}}"'; 
    '"${(P)${:-${modUS}_V_AI_statePop}}"';
    '${modUS}_P_stateS_L'=( UNCAUGHT ); '${modUS}_P_errS'="uncaught throw seen in \"}FINALLY_\"";  '"${(P)${:-${modUS}_V_AI_failOnStatePresent}}"';
    '${modUS}_P_stateS_L'=( CATCH CAUGHT NOCATCH );  '"${(P)${:-${modUS}_V_AI_failOnStateAbsent}}"'; 
    '"${(P)${:-${modUS}_V_AI_statePop}}"';
    '${modUS}_P_stateS_L'=( TRY );  '"${(P)${:-${modUS}_V_AI_failOnStateAbsent}}"'; 
    '"${(P)${:-${modUS}_V_AI_statePop}}"';
'

    'NOFINALLY'  '
            done; 
        '"${(P)${:-${modUS}_V_AI_breakOnErrorSet}}"'; 
        '"${(P)${:-${modUS}_V_AI_failOnEmpty_V_stateS_L}}"'; 
        '${modUS}_P_stateS_L'=( CATCH CAUGHT NOCATCH UNCAUGHT );  '"${(P)${:-${modUS}_V_AI_failOnStateAbsent}}"'; 
        '${modUS}_P_stateS'=NOFINALLY;  '"${(P)${:-${modUS}_V_AI_statePush}}"'; 
'
)


repeat 1; do
    for basenameS in ${nameL}; do
        for preS postS in  "" ""   "" "{"   "}" ""   "}" "{"; do
            nameS=${preS}${basenameS}${postS}
            if [[ -v "codeM[${nameS}]" ]]; then
                if ! [[ -v "writtenM[${nameS}]" ]]; then
                    writtenM["${nameS}"]=1
                    namelongS=${preS}${modUS}_A_${basenameS}${postS}
                    extantcodeL+=( ${nameS} )
                    thiscodeL=(
                        'alias -g "'${namelongS}'"='${qs_S}' ; '
                        '    : "START TRY_TYPE=\"'${nameS}'\"  (depth)=${#'${modUS}_V_stateS_L'}" ; '
                        '    '${codeM[${nameS}]}
                        '    : "END TRY_TYPE=\"'${nameS}'\"  (depth)=${#'${modUS}_V_stateS_L'}" ; '
                        ${qs_S}'; '
                        ''
                    )
                    codeL+=( "${(@)thiscodeL}" )
                fi;  fi;  done;  done
    sS=  sepS=
    for nameS in ${(@)extantcodeL}; do
        sS+="${sepS}\"${nameS}\" 1";  sepS="  ";  done
    sS="MAP_G   ${modUS}_V_extantcodeM=( ${sS} ); "
    codeL+=( ${sS} )
    
    INTERNAL_CODEGEN_FRAMEWORK_F_codeListAdd  codeL
    errB=${B_F};  break;  done
if [[ ${errB} -ne ${B_F} ]]; then
    print -f "ERROR: %s:  { %s;  errI=%d }\n" --  $0  ${errS}  ${errI};  exit 1;  fi
unset basenameS  preS  postS  nameS  codeM  qs_S  codeL  thiscodeL
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
#     creates aliases for INTERNAL_TRY_A_... aliases, e.g. "TRY_TRY{" and "_TRY{" are both aliased to "INTERNAL_TRY_A_TRY{"
#
# USAGE
#     ..._F_abbrevsCreate
#
function ${modUS}_F_abbrevsCreate() {
    INTERNAL_TRY_A_selfmodSetup
    INTERNAL_FRAMEWORK_A_localErrvarsCreate
    INTERNAL_FRAMEWORK_A_localMatchvarsCreate
    STR_L   nameS  preS  postS  basenameS  prependS  reNameS='^([\}])?([^\{]+)([\{])?'
    LIST_L  prependL
    prependL=( "${(@P)${:-${modUS}_V_prependL}}" )
    
    errB=${B_T}
    repeat 1; do
        INTERNAL_FRAMEWORK_A_retsReset
        if ! [[ -v ${modUS}_V_extantcodeM ]]; then
            errI=1;  print -v errS -f "\"%s\" var does not exist" -- ${modUS}_V_extantcodeM;  break;  fi
        for nameS in ${(koP)${:-${modUS}_V_extantcodeM}}; do
            [[ ${nameS} =~ ${reNameS} ]]
            preS=${match[1]}  basenameS=${match[2]}  postS=${match[3]}
            for prependS in "${(@)prependL}"; do
                alias -g "${preS}${prependS}${basenameS}${postS}"="${preS}${modUS}_A_${basenameS}${postS}";  done
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
    INTERNAL_TRY_A_selfmodSetup
    INTERNAL_FRAMEWORK_A_localErrvarsCreate
    INTERNAL_FRAMEWORK_A_retsReset
    INT_L   resultI
    
    eval ${modUS}_F_abbrevsCreate;  resultI=$?
    if [[ ${resultI} -ne ${B_T} ]]; then
        errI=1;  print -v errS -f "%s:  { %s;  errI=%d }" --  $0  ${(P)${:-${modUS}_V_errS}}  ${errI}
        BOOL_G  ${modUS}_errB=${B_T}
        INT_G   ${modUS}_errI=${errI}
        STR_G   ${modUS}_errS=${errS}
        return ${B_F};  fi
    return ${B_T}
}


#}CODEGEN_ACTIVE
fi
true
