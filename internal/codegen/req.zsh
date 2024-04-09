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

STR_L   modS=internal/codegen/req
STR_L   modUS=${(U)modS//\//_}
INTERNAL_FRAMEWORK_A_defStart
LIST_L  modL=( )  INTERNAL_FRAMEWORK_A_loadDependencies


# global variables

INTERNAL_FRAMEWORK_A_retsReset
LIST_G  ${modUS}_V_codeL
STR_G   ${modUS}_V_codeS
INT_G   ${modUS}_V_errnoInternalI
INT_G   ${modUS}_V_errnoI
BOOL_G  ${modUS}_V_preparedB=${B_F}


# module code

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


# USAGE
#     <self>  [-p] [-P] [-x] [-X] [-i] [-I] [-E <errbaseI>] [-M <modS>] [-V <varnameS>] [-H <varheaderS>] [-S <selectorS>]...
#
# DESCRIPTION
#     Generates code that checks variables for existence and content. Generated code creates *errI and *errS variables
#     if necessary and, on error. sets them on error and then executes a "break" statement.
#
# ARG
#     -P/-p: print out result, or not. optional. default: -P
#     -X/-x: exit on failure, or not. optional. default: -X
#     -I/-i: increment error number starting at base, or use fixed error number. optional. default: -I
#     -E <errBaseI>: set base error #. optional. default: 1
#     -M <moduleS>: module name. required.
#     -V <varnameS>: var name to which generated code will refer. required.
#     -H <varheaderS>: invariant text to be prepended to varnames for "errI", "errS", and "errB" by generated code.
#        optional. default: ""
#     -S <selectorS>: selection describing a condition the var must meet. optional.
#
# NOTE
#     If no "-S <selectorS>" option is presented, no code will be generated.
#
#     <selectorS> format is: [<varnameS>]:<sense>:<selector>[:<s3>[:<s4>]]
#         <varnameS>: name of var to which to apply selector. If blank, use varnameS supplied with -V option.
#         <sense>:  ( is | not )
#         <selector>:  ( defined | type | value | length )
#             for selector==
#                 defined: s3 and s4 must not be defined
#                 type: s3 is <typeComparator>, s4 is <typeValue>
#                     <typeComparator>:  ( EQT | IN )
#                     <typeValue>:  ( B | I | S | F | E | L | M )
#                 value: s3 is <valueComparator>, s4 is <valueValue>
#                     <valueComparator>:
#                         ( LT | LE | EQ | NE | GE | GT | IN | RANGE | EQ0 | EQ1 | EQS | NES | INS |
#                           TB | FB | NB | EQB | NEB )
#                     for <valueComparator> in  ( EQ0 EQ1 TB FB NB ), s4 must not be defined; for all others,
#                         s4 must be defined
#                 length: s3 is <lengthComparator>, s4 is <lengthValue>
#                     <lengthComparator>:  ( LT | LE | EQ | NE | GE | GT | EQ0 | RANGE )
#                     for <lengthComparator> in  ( EQ0 ), s4 must not be defined; for all others, s4 must be defined
#
function ${modUS}_F_varReqsE() {
    INT_L   inErrI
    STR_L   inModS=UNDEF  inVarnameS=UNDEF  inVarheaderS=UNDEF  curVarnameS
    STR_L   thisVarnameS  thisSenseS  thisSelectorS  thisS3S  thisS4S
    STR_L   resultS=
    LIST_L  inSelectedL=()
    INT_L   indexI
    STR_L   eltS  subeltS  subeltValueS listS  potlDqS  potlDqQS  dORsS  inL_S  formatS \
        subformatS  subformat2S  tmpS  senseSymbolS
    LIST_L  resultL
    INT_L   optPrintB=${B_T}  optExitB=${B_T}  optIncrErrB=${B_T}
    INT_L   errBaseI=1  errAddedI=0  errCurI
    LIST_L  selectorSenseL=( is not )  selectorMainL=( defined type value length )  selectorDefinedL=( ) \
        selectorTypeL=( EQT IN )  selectorValueL=( LT LE EQ NE GE GT IN RANGE EQ0 EQ1 EQS NES INS TB FB NB EQB NEB )  \
        selectorTypenameL=( B I S F E L M )  selectorLengthL=( LT LE EQ NE GE GT EQ0 RANGE )  selectedL=( )
    LIST_L  selectionL  inL
    MAP_L   zshTypenameM  zshTypenameRevM  isnotInvertM  senseSymbolInvertM  comparatorM
    
    INTERNAL_FRAMEWORK_A_localErrvarsCreate
    INTERNAL_FRAMEWORK_A_localMatchvarsCreate
    INTERNAL_FRAMEWORK_A_localArgvarsCreate
    INTERNAL_CODEGEN_REQ_A_selfmodSetup
    zshTypenameM=( B integer  I integer  S scalar  F float  E float  L array  M association )
    zshTypenameRevM=( integer B,I  scalar S  float E,F  array L  association M )
    isnotInvertM=( is "not " not "" )
    senseSymbolInvertM=( "" "! " "! " "" )
    comparatorM=(
        EQT "=~"
        LT -lt  LE -le  EQ -eq  NE -ne  GE -ge  GT -gt  IN NA  RANGE NA  EQ0 NA  EQ1 NA
        EQS "="  NES "!="  INS NA
        TB NA  FB NA  NB NA  EQB -eq  NEB -ne
    )
    
    while true; do
        errB=${B_T}
        eval INTERNAL_FRAMEWORK_A_retsReset
        indexI=1;  while [[ ${indexI} -le $# ]]; do
            eltS=${(P)indexI}
            if [[ ${#eltS} -eq 0 ]]; then
                errI=1;  print -v errS -f "invalid arg: empty string;  @ARGCV" -- ;  break;  fi
            case X${eltS} in
                (X-P) optPrintB=${B_T} ;;
                (X-p) optPrintB=${B_F} ;;
                (X-X) optExitB=${B_T} ;;
                (X-x) optExitB=${B_F} ;;
                (X-I) optIncrErrB=${B_T} ;;
                (X-i) optIncrErrB=${B_F} ;;
                (X--) indexI+=1; break ;;
                (X-E)
                    if [[ ${indexI} -eq $# ]]; then
                        errI=2;  print -v errS -f "-E flag without value;  @ARGCV" -- ;  break;  fi
                    indexI+=1
                    eltS=${(P)indexI}
                    if [[ ${#eltS} -eq 0 ]]; then
                        errI=3;  print -v errS -f "-E flag with empty value;  @ARGCV" -- ;  break;  fi
                    if ! [[ ${eltS} =~ '^[1-9][0-9]*$' ]]; then
                        errI=4;  print -v errS -f "-E value not positive int: %s;  @ARGCV" -- \
                            ${eltS};  break;  fi
                    if [[ ${eltS} -gt 127 ]]; then
                        errI=5;  print -v errS -f "-E value not in {1..127}: %d;  @ARGCV" -- \
                            ${eltS};  break;  fi
                    errBaseI=${eltS} ;;
                (X-M)
                    if [[ ${indexI} -eq $# ]]; then
                        errI=6;  print -v errS -f "-M flag without value;  @ARGCV" -- ;  break;  fi
                    indexI+=1
                    eltS=${(P)indexI}
                    if [[ ${#eltS} -eq 0 ]]; then
                        errI=7;  print -v errS -f "-M flag with empty value;  @ARGCV" -- ;  break;  fi
                    if ! [[ ${eltS} =~ ${INTERNAL_FRAMEWORK_C_reModnameA_S} ]]; then
                        errI=8;  print -v errS -f "-M flag value does not match regex \"%s\" (\"%s\"): %s;  @ARGCV" -- \
                            INTERNAL_FRAMEWORK_C_reModnameA_S  ${INTERNAL_FRAMEWORK_C_reModnameA_S}  ${eltS};  break;  fi
                    inModS=${eltS} ;;
                (X-V)
                    if [[ ${indexI} -eq $# ]]; then
                        errI=9;  print -v errS -f "-V flag without value;  @ARGCV" -- ;  break;  fi
                    indexI+=1
                    eltS=${(P)indexI}
                    if [[ ${#eltS} -eq 0 ]]; then
                        errI=10;  print -v errS -f "-V flag with empty value;  @ARGCV" -- ;  break;  fi
                    if ! [[ ${eltS} =~ ${INTERNAL_FRAMEWORK_C_reVarnameA_S} ]]; then
                        errI=11;  print -v errS -f "-V flag value does not match regex \"%s\" (\"%s\"): %s;  @ARGCV" -- \
                            INTERNAL_FRAMEWORK_C_reVarnameA_S ${INTERNAL_FRAMEWORK_C_reVarnameA_S}  ${eltS};  break;  fi
                    inVarnameS=${eltS} ;;
                (X-H)
                    if [[ ${indexI} -eq $# ]]; then
                        errI=12;  print -v errS -f "-H flag without value;  @ARGCV" -- ;  break;  fi
                    indexI+=1
                    eltS=${(P)indexI}
                    if [[ ${#eltS} -eq 0 ]]; then
                        errI=13;  print -v errS -f "-H flag with empty value;  @ARGCV" -- ;  break;  fi
                    if ! [[ ${eltS} =~ ${INTERNAL_FRAMEWORK_C_reIdentA_S} ]]; then
                        errI=14;  print -v errS -f "-H flag value does not match regex \"%s\" (\"%s\"): %s;  @ARGCV" -- \
                            INTERNAL_FRAMEWORK_C_reIdentA_S  ${INTERNAL_FRAMEWORK_C_reIdentA_S}  ${eltS} ;  break;  fi
                    inVarheaderS=${eltS} ;;
                (X-S)
                    if [[ ${indexI} -eq $# ]]; then
                        errI=15;  print -v errS -f "-S flag without value;  @ARGCV" -- ;  break;  fi
                    indexI+=1
                    eltS=${(P)indexI}
                    if [[ ${#eltS} -eq 0 ]]; then
                        errI=16;  print -v errS -f "-S flag with empty value;  @ARGCV" -- ;  break;  fi
                    selectionL=( "${(s/:/)eltS}" )
                    if [[ ${#selectionL} -lt 3  ||  ${#selectionL} -gt 5 ]]; then
                        errI=17;  print -v errS -f "invalid arg count for -S flag value: %d;  required: {3..5};  @ARGCV" -- \
                            ${#selectionL};  break;  fi
                    thisVarnameS=${selectionL[1]}  thisSenseS=${selectionL[2]}  thisSelectorS=${selectionL[3]}
                    thisS3S=UNDEF  thisS4S=UNDEF
                    if [[ ${#selectionL} -ge 4 ]]; then  thisS3S=${selectionL[4]};  fi
                    if [[ ${#selectionL} -ge 5 ]]; then  thisS4S=${selectionL[5]};  fi
                    if [[ ${#thisVarnameS} -eq 0  &&  X${inVarnameS} = XUNDEF ]]; then
                        errI=18; print -v errS -f \
                            "no value provided for -S <selector>[varnameS];  value required when -V option not present;  @ARGCV" --
                        break;  fi
                    if [[ ${#thisVarnameS} -eq 0 ]]; then  thisVarnameS=${inVarnameS};  fi
                    if ! [[ ${thisVarnameS} =~ ${INTERNAL_FRAMEWORK_C_reVarnameA_S} ]]; then
                        errI=19;  print -v errS -f \
                            "-S <selector> varnameS field does not match regex \"%s\" (\"%s\"): %s;  @ARGCV" -- \
                            INTERNAL_FRAMEWORK_C_reVarnameA_S  ${INTERNAL_FRAMEWORK_C_reVarnameA_S}  ${thisVarnameS};  break;  fi
                    case X${thisSenseS} in
                        (Xis) ;;
                        (Xnot) ;;
                        (X*)
                            errI=20;  print -v errS -f "unknown -S <selector>[senseS]: %s;  @REQL[ %s @];  @ARGCV" -- \
                                ${thisSenseS}  ${(@)selectorSenseL};  break ;;  esac
                    case X${thisSelectorS} in
                        (Xdefined)
                            if [[ ${#selectionL} -gt 3 ]]; then
                                errI=21;  print -v errS -f "-S ...:defined has subargs: %s;  @ARGCV" -- \
                                    ${eltS};  break;  fi ;;
                        (Xtype)
                            if [[ ${#selectionL} -ne 5 ]]; then
                                errI=22;  print -v errS -f "-S (type): bad subarg count: %d;  required: 5;  @ARGCV" -- \
                                    ${#selectionL};  break;  fi
                            if ! (( ${selectorTypeL[(Ie)${thisS3S}]} )); then
                                errI=23;  print -v errS -f "-S (type): bad comparator: %s; @REQL[ %s @];  @ARGCV" -- \
                                    ${thisS3S}  "${(@)selectorTypeL}";  break;  fi
                            if [[ ${thisS3S} != IN ]]; then
                                if ! (( ${selectorTypenameL[(Ie)${thisS4S}]} )); then
                                    errI=24;  print -v errS -f "-S (type): bad typename: %s;  @REQL[ %s @];  @ARGCV" -- \
                                        ${thisS4S}  "${(@)selectorTypenameL}";  break;  fi
                            else
                                inL=( ${(s/,/)thisS4S} )
                                for subeltS in "${(@)inL}"; do
                                    if ! (( ${selectorTypenameL[(Ie)${subeltS}]} )); then
                                        errI=25;  
                                        print -v errS -f "-S (type): bad typename: %s;  @REQL[ %s @];  @ARGCV" -- \
                                            ${subeltS}  "${(@)selectorTypenameL}";  break 2;  fi;  done;  fi ;;
                        (Xvalue)
                            if [[ ${#selectionL} -eq 4 ]]  &&  \
                                [[ ${thisS3S} = EQ0 || ${thisS3S} = EQ1 || \
                                     ${thisS3S} = TB || ${thisS3S} = FB || ${thisS3S} = NB ]]; then  ;
                            elif [[ ${#selectionL} -eq 4 ]]; then
                                errI=26; formatS="-S (value): bad subarg count: %d;  required: 5, unless -S <selectorL>[S3S] "
				formatS+="is one of  ( EQ0 EQ1 TB FB NB );  @ARGCV"
                                print -v errS -f ${formatS} --  ${#selectionL};  break
                            elif [[ ${#selectionL} -ne 5 ]]; then
                                errI=27;  print -v errS -f "-S <selector>: bad subarg count: %d;  required: 5;  @ARGCV" -- \
                                    ${#selectionL};  break;  fi
                            if ! (( ${selectorValueL[(Ie)${thisS3S}]} )); then
                                errI=28;  print -v errS -f "-S (value): bad comparator: %s;  @REQL[ %s @];  @ARGCV" -- \
                                    ${thisS3S}  "${(@)selectorValueL}";  break;  fi
                            if [[ ${thisS3S} = RANGE ]]; then
                                inL=( ${(s/../)thisS4S} )
                                if [[ ${#inL} -ne 2 ]]; then
                                    errI=29;  print -v errS -f "-S (value): range has only one element: %s;  @ARGCV" -- \
                                        ${thisS4S};  break;  fi
                                if ! [[ ${inL[1]} =~ '^[0-9]+$'  &&  ${inL[2]} =~ '^[0-9]+$' ]]; then
                                    errI=30;  print -v errS -f "-S (value): range element(s) are not non-neg ints: %s;  @ARGCV" -- \
                                        ${thisS4S};  break;  fi
                                if [[ ${inL[1]} -gt ${inL[2]} ]]; then
                                    errI=31;  print -v errS \
                                        -f "-S (value): elements in range do not monotonically increase: %s;  @ARGCV" -- \
                                        ${thisS4S};  break;  fi;  fi
                            ;;
                        (Xlength)
                            if [[ ${#selectionL} -ne 5 ]]; then
                                errI=32;  print -v errS -f "-S <selector:length>: bad subarg count: %d;  required: 5;  @ARGCV" -- \
                                    ${#selectionL};  break;  fi
                            if ! (( ${selectorValueL[(Ie)${thisS3S}]} )); then
                                errI=33;  print -v errS -f "-S (length): bad comparator: %s;  @REQL[ %s @];  @ARGCV" -- \
                                    ${thisS3S}  "${(@)selectorLengthL}";  break;  fi
                            errI=34;  print -v errS -f "-S (length): not yet supported;  @ARGCV" -- ;  break
                            ;;
                        
                        (X*)
                            errI=35;  print -v errS -f "-S: bad selector: %s;  @REQL[ %s @];  @ARGCV" -- \
                                ${thisSelectorS}  "${(@)selectorMainL}";  break;;  esac
                    selectedL+=( ${eltS} )  ;;
                (X-*)
                    errI=36;  print -v errS -f "unknown flag: %s;  @ARGCV" --  "${eltS}";  break ;;
                (X*) break ;;  esac
            indexI+=1;  done
        if [[ ${errI} -ne 0 ]]; then  break;  fi
        if (( indexI < ($# + 1) )); then
            errI=37;  print -v errS -f "excess arg(s) found;  @ARGCV" -- ;  break;  fi
        if [[ X${inModS} = XUNDEF ]]; then
            errI=38;   print -v errS -f "-M option is required;  @ARGV";  break;  fi
        if [[ X${inVarheaderS} = XUNDEF ]]; then  inVarheaderS=;  fi
        resultL=( )
        resultL+=( 'if [[ ${+'${inVarheaderS}'errS} -eq 0 ]]; then STR_L   '${inVarheaderS}'errS=; fi; '  \
                   'if [[ ${+'${inVarheaderS}'errI} -eq 0 ]]; then INT_L   '${inVarheaderS}'errI=0; fi; ' )
        for eltS in ${selectedL}; do
            selectionL=( "${(s/:/)eltS}" )
            thisVarnameS=${selectionL[1]}  thisSenseS=${selectionL[2]} thisSelectorS=${selectionL[3]}
            thisS3S=UNDEF  thisS4S=UNDEF
            if [[ ${#selectionL} -ge 4 ]]; then  thisS3S=${selectionL[4]};  fi
            if [[ ${#selectionL} -ge 5 ]]; then  thisS4S=${selectionL[5]};  fi
            if [[ ${#thisVarnameS} -eq 0 ]]; then  thisVarnameS=${inVarnameS};  fi
            senseSymbolS=
            if [[ ${thisSenseS} = not ]]; then senseSymbolS="! "; fi
            errCurI=$(( errBaseI + errAddedI ))
            if [[ ${optIncrErrB} -eq ${B_T} ]]; then
                errAddedI+=1;  fi
            case ${thisSelectorS} in
                (defined)
                    print -v resultS \
                        -f 'if %s[[ ${+%s} -eq 1 ]]; then ;  %serrI=%d;  %serrS="var \"%s\" %sdefined"; break; fi; ' -- \
                        "${senseSymbolInvertM[${senseSymbolS}]}"  ${thisVarnameS}  "${inVarheaderS}"  ${errCurI} \
                        "${inVarheaderS}"  ${thisVarnameS}  "${isnotInvertM[${thisSenseS}]}"  ;;
                (type)
                    if [[ ${comparatorM[${thisS3S}]} != NA ]]; then
                        formatS='if %s[[ ${(t)%s} %s "^%s.*$" ]]; then ;  %serrI=%d;  '
                        formatS+='print -v %serrS -f "var \"%s\" %stype %s (%s*): %%s" -- ${(t)%s}; break; fi;  '
                        print -v resultS -f ${formatS} -- \
                            "${senseSymbolInvertM[${senseSymbolS}]}" \
                            ${thisVarnameS}  ${comparatorM[${thisS3S}]}  ${zshTypenameM[${thisS4S}]} \
                            "${inVarheaderS}"  ${errCurI} \
                            "${inVarheaderS}"  ${thisVarnameS}  "${isnotInvertM[${thisSenseS}]}" \
                            ${thisS4S}  ${zshTypenameM[${thisS4S}]} \
                            ${thisVarnameS}
                        if [[ ${thisS4S} = B ]]; then
                            formatS='%sif  [[ ${%s} -lt 0 || ${%s} -gt 2 ]]; then ;  %serrI=%d;  '
                            formatS+='print -v %serrS -f "var \"%s\" not in range for type B (integer*)  {0..2}: %%s; " '
                            formatS+='-- ${%s};  break;  fi; '
                            print -v resultS -f ${formatS} -- \
                                ${resultS}  ${thisVarnameS}  ${thisVarnameS}  "${inVarheaderS}"  ${errCurI} \
                                "${inVarheaderS}"  ${thisVarnameS}  ${thisVarnameS};  fi
                    elif [[ ${thisS3S} =~ '^(IN|INS)$' ]]; then
                        inL=( ${(s/,/)thisS4S} )
                        print -v inL_S -f "%q  " -- "${(@)inL}"
                        formatS='if %s[[ %%s ]]; then ;  %serrI=%d;  STR_L __MEZX__typenamesS=;  case ${(t)%s} in  %%s ;  '
                        formatS+='esac;  print -v %serrS -f "var \"%s\" type %sIN  ( %s): %%%%s (%%%%s)" -- '
                        formatS+='${(t)%s} ${__MEZX__typenamesS};  unset __MEZX__typenamesS;  '
                        print -v formatS -f ${formatS} -- \
                            "${senseSymbolInvertM[${senseSymbolS}]}"  "${inVarheaderS}"  ${errCurI}  ${thisVarnameS} \
                            "${inVarheaderS}"  ${thisVarnameS}  "${isnotInvertM[${thisSenseS}]}"  ${inL_S}  ${thisVarnameS}
                        subformatS=  sepS=
                        for subeltS in ${(@)inL}; do
                            print -v tmpS -f '${(t)%s} =~ "^%s.*$"' -- \
                                  ${thisVarnameS}  ${zshTypenameM[${subeltS}]}
                            subformatS+="${sepS}${tmpS}"
                            sepS='  ||  ';  done
                        subformat2S=  sepS=
                        for subeltS subeltValueS in ${(kv)zshTypenameRevM}; do
                            print -v tmpS -f '(%s*) __MEZX__typenamesS="%s"' --  ${subeltS}  ${subeltValueS}
                            subformat2S+="${sepS}${tmpS}"
                            sepS='  ;;  ';  done
                        subformat2S+=${sepS}
                        print -v resultS -f ${formatS} --  ${subformatS}  ${subformat2S}; fi;  ;;
                (value)
                    case ${thisS3S} in
                        (EQS) ;&  (NES) ;&  (INS) potlDqS='"'  potlDqQS='\"'  dORsS=s ;;
                        (*)  potlDqS=  potlDqQS=  dORsS=d ;;  esac
                    if [[ ${comparatorM[${thisS3S}]} != NA ]]; then
                        formatS='if %s[[ ${%s} %s %s%s%s ]]; then ;  %serrI=%d;  '
                        formatS+='print -v %serrS -f "var \"%s\" %s%s %s%s%s: %%%s" -- %s${%s}%s; break; fi; '
                        print -v resultS -f ${formatS} -- \
                            "${senseSymbolInvertM[${senseSymbolS}]}" \
                            ${thisVarnameS}  ${comparatorM[${thisS3S}]}  "${potlDqS}"  ${thisS4S} "${potlDqS}" \
                            "${inVarheaderS}"  ${errCurI}  "${inVarheaderS}"  ${thisVarnameS} \
                            "${isnotInvertM[${thisSenseS}]}" ${thisS3S}  "${potlDqQS}"  ${thisS4S}  "${potlDqQS}" \
                            ${dORsS} "${potlDqQS}"  ${thisVarnameS}  "${potlDqQS}"
                    elif [[ ${thisS3S} =~ '^EQ[01]$' ]]; then
                        formatS='if %s[[ ${%s} -eq %d ]]; then ;  %serrI=%d;  '
                        formatS+='print -v %serrS -f "var \"%s\" %s%s: %%s" -- ${%s}; break; fi; '
                        print -v resultS -f ${formatS} -- \
                            "${senseSymbolInvertM[${senseSymbolS}]}"  ${thisVarnameS}  ${thisS3S[3]} \
                            "${inVarheaderS}"  ${errCurI} "${inVarheaderS}"  ${thisVarnameS} \
                            "${isnotInvertM[${thisSenseS}]}"  ${thisS3S}  ${thisVarnameS}
                    elif [[ ${thisS3S} =~ '^(T|F|N)B$' ]]; then
                        formatS='if %s[[ ${%s} -eq ${B_%s} ]]; then ;  %serrI=%d;  '
                        formatS+='print -v %serrS -f "var \"%s\" %s%s (%%s): %%s" --  %s  ${%s};  break;  fi; '
                        print -v resultS -f ${formatS} -- \
                            "${senseSymbolInvertM[${senseSymbolS}]}"  ${thisVarnameS}  ${thisS3S[1]} \
                            "${inVarheaderS}"  ${errCurI} \
                            "${inVarheaderS}"  ${thisVarnameS}  "${isnotInvertM[${thisSenseS}]}" \
                            '\${B_'${thisS3S[1]}'}'  '${B_'${thisS3S[1]}'}'  ${thisVarnameS}
                    elif [[ ${thisS3S} =~ '^(IN|INS)$' ]]; then
                        inL=( ${(s/,/)thisS4S} )
                        print -v inL_S -f "%q  " -- "${(@)inL}"
                        formatS='if %s()(( $@[(Ie)${%s}] )) %s; then ;  %serrI=%d;  '
                        formatS+='print -v %serrS -f "var \"%s\" %s IN  ( %s): %%s" -- ${%s}; break; fi; '
                        print -v resultS -f ${formatS} -- \
                            "${senseSymbolInvertM[${senseSymbolS}]}"  ${thisVarnameS}  ${inL_S} \
                            "${inVarheaderS}"  ${errCurI}  "${inVarheaderS}" \
                            ${thisVarnameS}  "${isnotInvertM[${thisSenseS}]}" ${inL_S}  ${thisVarnameS}
                    elif [[ ${thisS3S} = RANGE ]]; then
                        inL=( ${(s/../)thisS4S} )
                        formatS='if %s[[ ${%s} -ge %s && ${%s} -le %s ]]; then ;  %serrI=%d;  '
                        formatS+='print -v %serrS -f "var \"%s\" %sin %s {%s}: %%s" --  ${%s};  break;  fi; '
                        print -v resultS -f ${formatS} -- \
                            "${senseSymbolInvertM[${senseSymbolS}]}" \
                            ${thisVarnameS}  ${inL[1]} \
                            ${thisVarnameS}  ${inL[2]} "${inVarheaderS}"  ${errCurI}  "${inVarheaderS}" \
                            ${thisVarnameS}  "${isnotInvertM[${thisSenseS}]}"  ${thisS3S}  ${thisS4S} \
                            ${thisVarnameS};  fi  ;;
                (length)
                    ;;
            esac
            resultL+=( ${resultS} )
        done
        resultS=${(j:        :)resultL}
        break; done
    if [[ ${errI} -ne 0 ]]; then
	INTERNAL_FRAMEWORK_F_arrayToStrR -A argL
	argL_S=${INTERNAL_FRAMEWORK_V_replyS}
        INT_G   ${modUS}_V_errB=${B_T}
        INT_G   ${modUS}_V_errI=${errI}
	if [[ ${errS} = *@ARGCV* ]];   then  errS=${errS/@ARGCV/[ argcI=${argcI},  argL=( ${argL_S} ) ]};  fi;
	if [[ ${errS} = *@ARGC* ]];    then  errS=${errS/@ARGC/[ argcI=${argcI} ]};  fi;
	if [[ ${errS} = *@ARGV* ]];    then  errS=${errS/@ARGV/[ argL=( ${argL_S} ) ]};  fi;
	if [[ ${errS} = *@INDEX* ]];   then  errS=${errS/@INDEX/[ indexI=${indexI} ]};  fi;
	if [[ ${errS} = *@REQL\[* ]];  then  errS=${errS/@REQL\[/must be one of  \(};  fi;
	if [[ ${errS} = *@\]* ]];      then  errS=${errS/@\]/\)};  fi;
        print -v errS -f "%s:  { %s;  errI=%d }" --  $0  ${errS}  ${errI}
        STR_G   ${modUS}_V_errS=${errS}
        if [[ ${optExitB} -eq ${B_T} ]]; then  print -f "ERROR: %s\n" --  ${errS};  exit 1;  fi
    else
        STR_G  ${modUS}_V_replyS=${resultS}
        STR_G  ${modUS}_V_replyI=$(( errCurI + 1 ))
        if [[ ${optPrintB} -eq ${B_T} ]]; then  print -f "%s" --  ${resultS};  fi;  fi
    return ${INTERNAL_FRAMEWORK_C_invertB_M[${(P)${:-${modUS}_V_errB}}]}
}


INTERNAL_FRAMEWORK_A_defEnd
INTERNAL_FRAMEWORK_F_modCacheWrite --module internal/codegen/req
