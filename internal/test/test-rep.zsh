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


LIST_L  modL=( internal/rep );  INTERNAL_FRAMEWORK_A_loadDependencies
STR_L   modS=test_rep
STR_L   modUS=${(U)modS//\//_}
STR_L   parentmodS=internal/rep
STR_L   parentmodUS=${(U)parentmodS//\//_}
INTERNAL_FRAMEWORK_A_defStart


STR_L   selfS=${modUS}_A_selfmodSetup
alias ${selfS}='
    STR_L   modS="'${modS}'"  modUS="'${modUS}'";
'


alias ${modUS}_A_funcEnd='
    if (( ${'${parentmodUS}'_V_errB} == ${B_T} )); then ;
        print -f "ERROR: '${parentmodUS}'_V_errS=%s;  '${parentmodUS}'_V_errI=%d\n" --  ${'${parentmodUS}'_V_errS}  ${'${parentmodUS}'_V_errI}; fi;
    STR_L   modS='${parentmodS}';  INTERNAL_FRAMEWORK_A_retsReset;
'


function ${modUS}_forever() {
    INT_L   xI=0
    eval TEST_REP_A_selfmodSetup
    
    print -f "\nINFO: %s: should count {1..10};  EXIT when \"\$xI -eq 10\"\n" --  $0
    REP_FOREVER{
        xI+=1
	print -f "INFO: %s: xI=%d\n" --  $0  ${xI}
	if [[ ${xI} -eq 10 ]]; then  REP_EXIT;  fi
    }REP_FOREVER
    eval ${modUS}_A_funcEnd
}


function ${modUS}_once() {
    INT_L   xI=0
    eval TEST_REP_A_selfmodSetup
    
    print -f "\nINFO: %s: should print a single line\n" --  $0
    REP_ONCE{
	print -f "INFO: %s: this is a line\n" --  $0
    }REP_ONCE
    eval ${modUS}_A_funcEnd
}


function ${modUS}_while() {
    INT_L   xI=1
    STR_L   REP_P_condS='xI -lt 6'
    eval TEST_REP_A_selfmodSetup
    
    print -f "\nINFO: %s: should count {1..5};  REP_P_condS=\"%s\"\n" --  $0  ${REP_P_condS}
    REP_WHILE{
	print -f "INFO: %s: xI=%d\n" --  $0  ${xI}
	xI+=1
        if [[ $xI -gt 10 ]]; then REP_EXIT; fi
    }REP_WHILE
    eval ${modUS}_A_funcEnd
}


function ${modUS}_until() {
    INT_L   xI=8
    STR_L   REP_P_condS='xI -le 1'
    eval TEST_REP_A_selfmodSetup
    
    print -f "\nINFO: %s: should count {8..2};  REP_P_condS=\"%s\"\n" --  $0  ${REP_P_condS}
    REP_UNTIL{
	print -f "INFO: %s: xI=%d\n" --  $0  ${xI}
	xI+=-1
    }REP_UNTIL
    eval ${modUS}_A_funcEnd
}


function ${modUS}_n() {
    INT_L   xI=0
    INT_L   REP_P_nI=5
    eval TEST_REP_A_selfmodSetup
    
    print -f "\nINFO: %s: wants to repeat 5x (but will fail after rep 1);  REP_P_NI=%d\n" --  $0  ${REP_P_nI}
    REP_N{
        xI+=1
	print -f "INFO: %s: xI=%d\n" --  $0  ${xI}
    }REP_N_UNTIL
    eval ${modUS}_A_funcEnd
}


function ${modUS}_forever_exit() {
    INT_L   xI=0
    eval TEST_REP_A_selfmodSetup
    
    print -f "\nINFO: %s: FOREVER, but EXIT after 2 iterations\n" --  $0
    REP_FOREVER{
        xI+=1
	print -f "INFO: %s: xI=%d\n" --  $0  ${xI}
	if [[ ${xI} -eq 2 ]]; then REP_EXIT; fi
    }REP_FOREVER
    eval ${modUS}_A_funcEnd
}


function ${modUS}_forever_end() {
    INT_L   xI=0
    eval TEST_REP_A_selfmodSetup
    
    print -f "\nINFO: %s: FOREVER, but using END;  EXIT after 4 iterations\n" --  $0
    REP_FOREVER{
        xI+=1
	print -f "INFO: %s: xI=%d\n" --  $0  ${xI}
	if [[ xI -eq 4 ]]; then REP_EXIT; fi
    }REP_END
    eval ${modUS}_A_funcEnd
}


function ${modUS}_forever_next() {
    INT_L   xI=0
    eval TEST_REP_A_selfmodSetup
    
    print -f "\nINFO: %s: FOREVER, but using NEXT every other iteration;  EXIT after 8 iterations\n" --  $0
    REP_FOREVER{
        xI+=1
	if (( xI % 2 == 1 )); then REP_NEXT; fi
	print -f "INFO: %s: xI=%d\n" --  $0  ${xI}
	if (( xI >= 8 )); then REP_EXIT; fi
    }REP_FOREVER
    eval ${modUS}_A_funcEnd
}


function ${modUS}_forever_with_until_closure() {
    INT_L   xI=0
    eval TEST_REP_A_selfmodSetup
    
    print -f "\nINFO: %s: wants to repeat FOREVER, but will fail after rep 1, due to mismatched closure\n" --  $0
    REP_FOREVER{
        xI+=1
	print -f "INFO: %s: xI=%d\n" --  $0  ${xI}
    }REP_UNTIL
    eval ${modUS}_A_funcEnd
}


function ${modUS}_n_then_until() {
    INT_L   xI=0
    INT_L   REP_P_nI=5
    STR_L   REP_P_condS='xI -ge 8'
    eval TEST_REP_A_selfmodSetup
    
    
    print -f "\nINFO: %s: REP_P_nI=%d;  REP_P_condS=\"%s\";  EXIT when xI=10 (failsafe)\n" --  $0  ${REP_P_nI}  ${REP_P_condS}
    REP_N_THEN_UNTIL{
        xI+=1
	print -f "INFO: %s: xI=%d\n" --  $0  ${xI}
	if (( xI == 10 )); then REP_EXIT; fi  # failsafe
    }REP_N_THEN_UNTIL
    eval ${modUS}_A_funcEnd
}


function ${modUS}_n_in_n() {
    INT_L xI=0  yI=0
    INT_L REP_P_nI
    eval TEST_REP_A_selfmodSetup
    
    print -f "\nINFO: %s: REP_P_nI=5\n" --  $0
    REP_P_nI=5  REP_N{
        xI+=1;  print -f "INFO: %s: xI=%d\n" --  $0  ${xI}
	yI=0
	print -f "INFO: %s: (inner) REP_P_nI=3\n" --  $0
	REP_P_nI=3  REP_N{
	    yI+=1;  print -f "INFO: %s: xI=%d;  yI=%d\n" --  $0  ${xI}  ${yI}
	}REP_N
    }REP_N
    eval ${modUS}_A_funcEnd
}


function ${modUS}_n_in_n_while() {
    INT_L xI=0  yI=0
    INT_L REP_P_nI
    STR_L REP_P_condS='xI -lt 7'
    eval TEST_REP_A_selfmodSetup
    
    print -f "\nINFO: %s: REP_P_nI=5;  REP_P_condS=\"%s\"\n" --  $0  ${REP_P_condS}
    REP_P_nI=8  REP_N_WHILE{
        xI+=1;  print -f "INFO: %s: xI=%d\n" --  $0  ${xI}
	yI=0;  REP_P_nI=${xI}  
	print -f "INFO: %s: (inner) REP_P_nI=%d\n" --  $0  ${REP_P_nI}
	REP_N{  yI+=1;  print -f "INFO: %s: xI=%d; yI=%d\n" --  $0  ${xI}  ${yI}  }REP_N
    }REP_N_WHILE
    eval ${modUS}_A_funcEnd
}


function ${modUS}_n_then_while() {
    INT_L   xI=0
    INT_L   REP_P_nI=5
    STR_L   REP_P_condS='xI -lt 9'
    eval TEST_REP_A_selfmodSetup
    
    print -f "\nINFO: %s: REP_P_nI=%d  REP_P_condS=%s\n" --  $0  ${REP_P_nI}  ${REP_P_condS}
    REP_N_THEN_WHILE{
        xI+=1
	print -f "INFO: %s: xI=%d\n" --  $0  ${xI}
    }REP_N_THEN_WHILE
    eval ${modUS}_A_funcEnd
}


function ${modUS}_n_then_until() {
    INT_L   xI=0
    INT_L   REP_P_nI=4
    STR_L   REP_P_condS='xI -gt 6'
    eval TEST_REP_A_selfmodSetup
    
    print -f "\nINFO: %s: REP_P_nI=%d  REP_P_condS=%s\n" --  $0  ${REP_P_nI}  ${REP_P_condS}
    REP_N_THEN_UNTIL{
        xI+=1
	print -f "INFO: %s: xI=%d\n" --  $0  ${xI}
    }REP_N_THEN_UNTIL
    eval ${modUS}_A_funcEnd
}


function ${modUS}_n_while() {
    INT_L   xI=0
    INT_L   REP_P_nI=7
    STR_L   REP_P_condS='xI -lt 5'
    eval TEST_REP_A_selfmodSetup
    
    print -f "\nINFO: %s: REP_P_nI=%d  REP_P_condS=%s\n" --  $0  ${REP_P_nI}  ${REP_P_condS}
    REP_N_WHILE{
        xI+=1
	print -f "INFO: %s: xI=%d\n" --  $0  ${xI}
    }REP_N_WHILE
    eval ${modUS}_A_funcEnd
}


function ${modUS}_n_until() {
    INT_L   xI=0
    INT_L   REP_P_nI=8
    STR_L   REP_P_condS='xI -gt 5'
    eval TEST_REP_A_selfmodSetup
    
    print -f "\nINFO: %s: REP_P_nI=%d  REP_P_condS=%s\n" --  $0  ${REP_P_nI}  ${REP_P_condS}
    REP_N_UNTIL{
        xI+=1
	print -f "INFO: %s: xI=%d\n" --  $0  ${xI}
    }REP_N_UNTIL
    eval ${modUS}_A_funcEnd
}


function ${modUS}_twice() {
    INT_L   xI=0
    eval TEST_REP_A_selfmodSetup
    
    print -f "\nINFO: %s\n"
    REP_TWICE{
        xI+=1
	print -f "INFO: %s: xI=%d\n" --  $0  ${xI}
    }REP_TWICE
    eval ${modUS}_A_funcEnd
}


function ${modUS}_thrice() {
    INT_L   xI=0
    eval TEST_REP_A_selfmodSetup
    
    print -f "\nINFO: %s\n"
    REP_THRICE{
        xI+=1
	print -f "INFO: %s: xI=%d\n" --  $0  ${xI}
    }REP_THRICE
    eval ${modUS}_A_funcEnd
}


function ${modUS}_forever_short() {
    INT_L   xI=0
    eval TEST_REP_A_selfmodSetup
    
    print -f "\nINFO: %s: should count {1..10};  EXIT when \"\$xI -eq 10\"\n" --  $0
    _FOREVER{
        xI+=1
	print -f "INFO: %s: xI=%d\n" --  $0  ${xI}
	if [[ ${xI} -eq 10 ]]; then  _EXIT;  fi
    }_FOREVER
    eval ${modUS}_A_funcEnd
}


${modUS}_forever
${modUS}_while
${modUS}_until
${modUS}_n
${modUS}_forever_exit
${modUS}_forever_end
${modUS}_forever_next
${modUS}_forever_with_until_closure
${modUS}_n_then_until
${modUS}_n_in_n
${modUS}_n_in_n_while
${modUS}_n_then_while
${modUS}_n_then_until
${modUS}_n_while
${modUS}_n_until
${modUS}_once
${modUS}_twice
${modUS}_thrice
${modUS}_forever_short


INTERNAL_FRAMEWORK_A_defEnd
