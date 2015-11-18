# rvm-parser
Parsing RVM and MOP specifications using K framework

## build
+ Install [K](http://www.kframework.org/) (version 4)
+ kompile:
  + for rvm: ```kompile —syntax-module RVM-SYNTAX path/to/project/src/rvm/rvm-syntax.k```
  + for mop: ```kompile —syntax-module MOP-SYNTAX path/to/project/src/mop/mop-syntax.k```

## run
+ kast:
  + for rvm: ```kast -s RVM path/to/spec.rvm```
  + for mop: ```kast -s MOP path/to/spec.mop```
