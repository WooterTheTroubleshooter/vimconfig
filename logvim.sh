#!/bin/bash
vim -w ~/.vimlog "$@"; echo $'\n' >> ~/.vimlog
