#!/usr/bin/env sh

env | grep '^OS_' | perl -pE 's/^(OS_[^=]+)=(.*)/"export TF_VAR_" . lc($1) . "=\"$2\""/e'
