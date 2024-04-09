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
    if [[ ${exitI} -ne 0 ]]; then exit ${exit};  fi
}
unset selfpathS
# }MEZX_startup v1.3


LIST_L  modL=( internal/try );  INTERNAL_FRAMEWORK_A_loadDependencies
STR_L   modS=test_try_v2
STR_L   modUS=${(U)modS//\//_}
STR_L   parentmodS=internal/try
STR_L   parentmodUS=${(U)parentmodS//\//_}
INTERNAL_FRAMEWORK_A_defStart


STR_L   selfS=${modUS}_A_selfmodSetup
alias ${selfS}='
    STR_L   modS="'${modS}'"  modUS="'${modUS}'";
'


alias ${modUS}_A_funcEnd='
    if (( ${'${parentmodUS}'_V_errB} == ${B_T} )); then ;
        print -f "ERROR: %s:  { %s;  errI=%d }\n" -- \
            $0  ${'${parentmodUS}_V_errS'}  ${'${parentmodUS}_V_errI'}; fi;
    STR_L   modS='${parentmodS}';  INTERNAL_FRAMEWORK_A_retsReset;
'


for nameS printB in \
        'INTERNAL_TRY_A_TRY{' ${B_F} \
        '}INTERNAL_TRY_A_TRY' ${B_F} \
        '}INTERNAL_TRY_A_TRY_' ${B_F} \
        'INTERNAL_TRY_A_THROW' ${B_F} \
        'INTERNAL_TRY_A_CATCH{' ${B_F} \
        '}INTERNAL_TRY_A_CATCH' ${B_F} \
        '}INTERNAL_TRY_A_CATCH_' ${B_F} \
        '}INTERNAL_TRY_A_CATCH{' ${B_F} \
        'INTERNAL_TRY_A_NOCATCH' ${B_F} \
        'INTERNAL_TRY_A_FINALLY{' ${B_F} \
        '}INTERNAL_TRY_A_FINALLY' ${B_F} \
        '}INTERNAL_TRY_A_FINALLY_' ${B_F} \
        'INTERNAL_TRY_A_NOFINALLY' ${B_F} \
        '_CATCH{' ${B_F} \
        '}_CATCH' ${B_F} \
        '}_CATCH_' ${B_F} \
        '}_CATCH{' ${B_F} \
        '_NOCATCH' ${B_F} \
        '_THROW' ${B_F} \
        '}INTERNAL_TRY_A_FINALLY{' ${B_F} \
        '}_FINALLY{' ${B_F} \
        '}_FINALLY_' ${B_F} \
        '_NOFINALLY' ${B_F} \
        ; do
    if [[ ${printB} -eq ${B_T} ]]; then
	print "** ALIAS definition for \"${nameS}\" **"
	alias ${nameS} | INTERNAL_FRAMEWORK_A_aliasPrint;  fi;  done
   

function ${modUS}_try_null_try_() {
    eval TEST_TRY_V2_A_selfmodSetup
    
    zero;  repeat 1; do
	print -f "\nINFO: %s: should show nothing interesting\n" --  $0;  ps
	_TRY{
	    print "INFO: in _TRY{";  ps
            INT_L   xI=3
	}_TRY_
	print "INFO: after }_TRY_";  ps
    done
    print "INFO: after enclosing loop";  ps
    eval ${modUS}_A_funcEnd
}


function ${modUS}_try_throw_try_() {
    eval TEST_TRY_V2_A_selfmodSetup
    
    zero;  repeat 1; do
	print -f "\nINFO: %s: should show uncaught _THROW being automatically caught by the framework...\n" --  $0;  ps
	_TRY{
	    print "INFO: in _TRY{, before _THROW";  ps
            _THROW
	    print "ERROR: in _TRY{ after _THROW; this line should never be seen";  ps
	}_TRY_
	print "INFO: after }_TRY_";  ps
    done
    print "INFO: after enclosing loop";  ps
    eval ${modUS}_A_funcEnd
}


function ${modUS}_try_catch_nofinally_try() {
    eval TEST_TRY_V2_A_selfmodSetup
    
    zero;  repeat 1; do
	print -f "\nINFO: %s: _TRY without _THROW should show nothing from _CATCH...\n" --  $0;  ps
	_TRY{
            print "INFO: in _TRY{; no _THROW here";  ps
            _CATCH{
		print "ERROR: in _CATCH{, but there is no _THROW, so this line should never be seen";  ps
            }_CATCH
            print "INFO: in _TRY{, after }_CATCH, before _NOFINALLY";  ps
	    _NOFINALLY
            print "INFO: in _TRY{, after _NOFINALLY";  ps
	}_TRY
	print "INFO: after }_TRY";  ps
    done
    print "INFO: after enclosing loop";  ps
    eval ${modUS}_A_funcEnd
}


function ${modUS}_try_catch_() {
    eval TEST_TRY_V2_A_selfmodSetup
    
    zero;  repeat 1; do
	print -f "\nINFO: %s: _TRY without _THROW shows nothing from _CATCH...\n" --  $0;  ps
	_TRY{
            print "INFO: in _TRY{; no _THROW here";  ps
	}_CATCH{
            print "ERROR: in }_CATCH{; no _THROW, so this line should never be seen";  ps
	}_CATCH_
	print "INFO: after }_CATCH_";  ps
    done
    print "INFO: after enclosing loop";  ps
    eval ${modUS}_A_funcEnd
}


function ${modUS}_try_throw_catch_() {
    eval TEST_TRY_V2_A_selfmodSetup
    
    zero;  repeat 1; do
	print -f "\nINFO: %s: shows _THROW being caught by _CATCH...\n" --  $0;  ps
	_TRY{
            print "INFO: in _TRY{, before _THROW";  ps
            _THROW
            print "ERROR: in _TRY{, after _THROW; this line should never be seen";  ps
	}_CATCH{
            print "INFO: in }_CATCH{: _THROW has been caught";  ps
	}_CATCH_
	print "INFO: after }_CATCH_";  ps
    done
    print "INFO: after enclosing loop";  ps
    eval ${modUS}_A_funcEnd
}


function ${modUS}_try_throw_catch_nofinally_try() {
    eval TEST_TRY_V2_A_selfmodSetup
    
    zero;  repeat 1; do
	print -f "\nINFO: %s: should show _TRY, _CATCH...\n" --  $0;  ps
	_TRY{
            print "INFO: in _TRY{, before _THROW";  ps
            _THROW
            print "ERROR: in _TRY{ after _THROW; this line should never be seen";  ps
            _CATCH{
		print "INFO: in _CATCH{: _THROW has been caught";  ps
            }_CATCH
	    print "INFO: after }_CATCH, before _NOFINALLY";  ps
            _NOFINALLY
	    print "INFO: after _NOFINALLY";  ps
	}_TRY
	print "INFO: after }_TRY";  ps
    done
    print "INFO: after enclosing loop";  ps
    eval ${modUS}_A_funcEnd
}


function ${modUS}_try_throw_nocatch_nofinally_try() {
    eval TEST_TRY_V2_A_selfmodSetup
    
    zero;  repeat 1; do
	print -f "\nINFO: %s: should show _TRY, then uncaught _THROW being caught by the framework...\n" --  $0;  ps
	_TRY{
            print "INFO: in _TRY{, before _THROW";  ps
            _THROW
            print "ERROR: in _TRY{, after _THROW; this line should never be seen";  ps
            _NOCATCH
            print "INFO: in _TRY{, after _NOCATCH, before _NOFINALLY";  ps
            _NOFINALLY
            print "INFO: in _TRY{, after _NOFINALLY";  ps
	}_TRY
	print "INFO: after }_TRY";  ps
    done
    print "INFO: after enclosing loop";  ps
    eval ${modUS}_A_funcEnd
}


function ${modUS}_try_throw_nocatch_finally_try() {
    eval TEST_TRY_V2_A_selfmodSetup
    
    zero;  repeat 1; do
	print -f "\nINFO: %s: should show _TRY, _FINALLY, then uncaught _THROW being caught by the framework...\n" --  $0;  ps
	_TRY{
            print "INFO: in _TRY{, before _THROW";  ps
            _THROW
            print "ERROR: in _TRY{, after _THROW; this line should never be seen";  ps
            _NOCATCH
            print "INFO: in _TRY{, after _NOCATCH, before _NOFINALLY";  ps
            _FINALLY{
		print "INFO: in _FINALLY{";  ps
	    }_FINALLY
            print "INFO: in _TRY{, after }_FINALLY";  ps
	}_TRY
	print "INFO: after }_TRY";  ps
    done
    print "INFO: after enclosing loop";  ps
    eval ${modUS}_A_funcEnd
}


function ${modUS}_try_throw_catch_finally_() {
    eval TEST_TRY_V2_A_selfmodSetup
    
    zero;  repeat 1; do
	print -f "\nINFO: %s: should show _TRY, _THROW being caught, _FINALLY executing...\n" --  $0;  ps
	_TRY{
            print "INFO: in _TRY{, before _THROW";  ps
            _THROW
            print "ERROR: in _TRY after _THROW; this line should never be seen";  ps
	}_CATCH{
            print "INFO: in ..._CATCH: _THROW has been caught";  ps
	}_CATCH_FINALLY{
            print "INFO: in ..._FINALLY";  ps
	}_FINALLY_
	print "INFO: after ..._FINALLY_";  ps
    done
    print "INFO: after enclosing loop";  ps
    eval ${modUS}_A_funcEnd
}


function ${modUS}_try_throw_nocatch_finally_() {
    eval TEST_TRY_V2_A_selfmodSetup
    
    zero;  repeat 1; do
	print -f "\nINFO: %s: should show _TRY, then _FINALLY, then _THROW being caught by the framework...\n" --  $0;  ps
	_TRY{
            print "INFO: in _TRY{, before _THROW";  ps
            _THROW
            print "ERROR: in _TRY{ after _THROW; this line should never be seen";  ps
	    _NOCATCH
	    print "INFO: in _TRY{ after _NOCATCH; this line will always be seen";  ps
	}_NOCATCH_FINALLY{
            print "INFO: in ..._FINALLY";  ps
	}_FINALLY_
	print "INFO: after ..._FINALLY_";  ps
    done
    print "INFO: after enclosing loop";  ps
    eval ${modUS}_A_funcEnd
}


function ${modUS}_try_try_throw_nocatch_finally_nocatch_finally_() {
    eval TEST_TRY_V2_A_selfmodSetup
    
    zero;  repeat 1; do
	print -f "\nINFO: %s: should show _TRY, then _FINALLY, then _THROW being caught by the framework...\n" --  $0;  ps
	_TRY{
            print "INFO: in _TRY{ (1), before _TRY (2)";  ps
	    _TRY{
		print "INFO: in _TRY{ (2), before _THROW";  ps
		_THROW
		print "ERROR: in _TRY{ (2) after _THROW; this line should never be seen";  ps
		_NOCATCH
		print "INFO: in _TRY{ (2) after _NOCATCH; this line will always be seen";  ps
	    }_NOCATCH_FINALLY{
		print "INFO: in _TRY{ (2) ..._FINALLY";  ps
	    }_FINALLY_
	    print "INFO: in _TRY{ (1), after _TRY{ (2) ..._FINALLY_, before _TRY{ (1) _NOCATCH";  ps
	    _NOCATCH
	    print "INFO: in _TRY{ (1) after _NOCATCH; this line will always be seen";  ps
	}_NOCATCH_FINALLY{
            print "INFO: in _TRY{ (1) ..._FINALLY";  ps
	}_FINALLY_
	print "INFO: after _TRY (1) ..._FINALLY_";  ps
    done
    print "INFO: after enclosing loop";  ps
    eval ${modUS}_A_funcEnd
}


function ${modUS}_try_try_nocatch_finally_throw_nocatch_finally_() {
    eval TEST_TRY_V2_A_selfmodSetup
    
    zero;  repeat 1; do
	print -f "\nINFO: %s: should show _TRY, then _FINALLY, then _THROW being caught by the framework...\n" --  $0;  ps
	_TRY{
            print "INFO: in _TRY{ (1), before _TRY (2)";  ps
	    _TRY{
		print "INFO: in _TRY{ (2); no _THROW here";  ps
		_NOCATCH
		print "INFO: in _TRY{ (2) after _NOCATCH; this line will always be seen";  ps
	    }_NOCATCH_FINALLY{
		print "INFO: in _TRY{ (2) ..._FINALLY";  ps
	    }_FINALLY_
	    print "INFO: in _TRY{ (1), after _TRY{ (2) ..._FINALLY_, before _TRY{ (1) _THROW";  ps
	    _THROW
	    print "ERROR: in _TRY{ (1), after _THROW, before _NOCATCH; this line should never be seen";  ps
	    _NOCATCH
	    print "INFO: in _TRY{ (1) after _NOCATCH; this line will always be seen";  ps
	}_NOCATCH_FINALLY{
            print "INFO: in _TRY{ (1) ..._FINALLY";  ps
	}_FINALLY_
	print "INFO: after _TRY (1) ..._FINALLY_";  ps
    done
    print "INFO: after enclosing loop";  ps
    eval ${modUS}_A_funcEnd
}


function ps() {
    INTERNAL_FRAMEWORK_F_arrayToStrR -A INTERNAL_TRY_V_stateS_L;
    print -f "INFO:     stateS_L=( %s )\n" -- ${INTERNAL_FRAMEWORK_V_replyS}
}


function zero() {
    INTERNAL_TRY_V_stateS_L=()
}


${modUS}_try_null_try_
${modUS}_try_throw_try_
${modUS}_try_catch_nofinally_try
${modUS}_try_catch_
${modUS}_try_throw_catch_
${modUS}_try_throw_catch_nofinally_try
${modUS}_try_throw_nocatch_nofinally_try
${modUS}_try_throw_nocatch_finally_try
${modUS}_try_throw_catch_finally_
${modUS}_try_throw_nocatch_finally_
${modUS}_try_try_throw_nocatch_finally_nocatch_finally_
${modUS}_try_try_nocatch_finally_throw_nocatch_finally_

INTERNAL_FRAMEWORK_A_defEnd
