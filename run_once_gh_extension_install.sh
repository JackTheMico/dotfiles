#!/bin/bash

check_extensions=`gh extension list`
echo "gh extension list result: $check_extensions"
nostr="no installed extensions found"

if
