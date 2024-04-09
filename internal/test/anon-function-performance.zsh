#!/bin/zsh


alias ANON_A_NOTHING='
    ;
'

alias ANON_A_NO='
    iI+=1;
'

alias ANON_A_YES='
    { 
        iI+=1;
    }
'

alias ANON_A_YES_TYPESET_LOCAL='
    { 
        typeset +g -i iI=12;
        iI+=1;
    }
'

alias ANON_A_YES_STATED_LOCAL='
    { 
        integer iI=12;
        iI+=1;
    }
'


typeset +g -i iI=0
echo "empty statements"
time (
  for iI in {1..1000000}; do
    ;
    ;
    ;
    ;
    ;
    ;
    ;
    ;
    ;
    ;
  done
)

typeset +g -i iI=0
echo "alias without content"
time (
  for iI in {1..1000000}; do
    ANON_A_NOTHING
    ANON_A_NOTHING
    ANON_A_NOTHING
    ANON_A_NOTHING
    ANON_A_NOTHING
    ANON_A_NOTHING
    ANON_A_NOTHING
    ANON_A_NOTHING
    ANON_A_NOTHING
    ANON_A_NOTHING
  done
)

typeset +g -i iI=0
echo "global content, no anon function"
time (
  for iI in {1..1000000}; do
    ANON_A_NO
    ANON_A_NO
    ANON_A_NO
    ANON_A_NO
    ANON_A_NO
    ANON_A_NO
    ANON_A_NO
    ANON_A_NO
    ANON_A_NO
    ANON_A_NO
  done
)

typeset +g -i iI=0
echo "global content, anon function"
time (
  for iI in {1..1000000}; do
    ANON_A_YES
    ANON_A_YES
    ANON_A_YES
    ANON_A_YES
    ANON_A_YES
    ANON_A_YES
    ANON_A_YES
    ANON_A_YES
    ANON_A_YES
    ANON_A_YES
  done
)


typeset +g -i iI=0
echo "anon function w/ typeset local; count=100k"
time (
  for iI in {1..100000}; do
    ANON_A_YES_TYPESET_LOCAL
    ANON_A_YES_TYPESET_LOCAL
    ANON_A_YES_TYPESET_LOCAL
    ANON_A_YES_TYPESET_LOCAL
    ANON_A_YES_TYPESET_LOCAL
    ANON_A_YES_TYPESET_LOCAL
    ANON_A_YES_TYPESET_LOCAL
    ANON_A_YES_TYPESET_LOCAL
    ANON_A_YES_TYPESET_LOCAL
    ANON_A_YES_TYPESET_LOCAL
  done
)


typeset +g -i iI=0
echo "anon function w/ local statement; count=100k"
time (
  for iI in {1..100000}; do
    ANON_A_YES_STATED_LOCAL
    ANON_A_YES_STATED_LOCAL
    ANON_A_YES_STATED_LOCAL
    ANON_A_YES_STATED_LOCAL
    ANON_A_YES_STATED_LOCAL
    ANON_A_YES_STATED_LOCAL
    ANON_A_YES_STATED_LOCAL
    ANON_A_YES_STATED_LOCAL
    ANON_A_YES_STATED_LOCAL
    ANON_A_YES_STATED_LOCAL
  done
)


: 'RESULTS: 

zsh ./internal/anon-function-performance.zsh

empty statements
( for iI in {1..1000000}; do; ; done; )  0.89s user 0.02s system 99% cpu 0.916 total

alias without content
( for iI in {1..1000000}; do; ; done; )  1.29s user 0.03s system 77% cpu 1.711 total

global content, no anon function
( for iI in {1..1000000}; do; iI+=1 ; iI+=1 ; iI+=1 ; iI+=1 ; iI+=1 ; iI+=1 ;   7.13s user 0.05s system 90% cpu 7.972 total

global content, anon function
( for iI in {1..1000000}; do; { iI+=1 ; }; { iI+=1 ; }; { iI+=1 ; }; { iI+=1 }  8.25s user 0.04s system 99% cpu 8.303 total

anon function w/ typeset local; count=100k
( for iI in {1..100000}; do; { typeset +g -i iI=12 ; iI+=1 ; }; { typeset +g    8.34s user 1.94s system 99% cpu 10.313 total

anon function w/ local statement; count=100k
( for iI in {1..100000}; do; { integer iI=12 ; iI+=1 ; }; { integer iI=12 ; i   8.23s user 2.10s system 99% cpu 10.373 total
'