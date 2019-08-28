#!/bin/bash

echo "
Starting Jupyter Lab 

Exit with CTRL+D
"
case "$1" in 
  debug) 
    bash
  ;; 

      *)
    julia /app/start_notebook.jl
    jupyter lab --ip=0.0.0.0 
  ;;
esac 

