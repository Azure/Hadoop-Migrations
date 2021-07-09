#!/bin/sh

find main -name '*.bicep' -print -exec cat {} \; | grep /modules/
