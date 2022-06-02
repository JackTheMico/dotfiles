#!/bin/bash

check_extensions=`gh extension list`
echo "gh extension list result: $check_extensions"
nostr="no installed extensions found"

if [[ "$check_extensions" == "$nostr" ]]; then
  echo "No extensions found. Installing..."
  gh extension install mislav/gh-branch
  gh extension install gennaro-tedesco/gh-s
  gh extension install k1LoW/gh-grep
  gh extension install markdown-preview
  gh extension install gennaro-tedesco/gh-f
  gh extension install meiji163/gh-notify
  gh extension install rnorth/gh-combine-prs
  gh extension install dlvhdr/gh-dash
  echo "Extensions installed."
else
  gh extension upgrade mislav/gh-branch
  gh extension upgrade gennaro-tedesco/gh-s
  gh extension upgrade k1LoW/gh-grep
  gh extension upgrade markdown-preview
  gh extension upgrade gennaro-tedesco/gh-f
  gh extension upgrade meiji163/gh-notify
  gh extension upgrade rnorth/gh-combine-prs
  gh extension upgrade dlvhdr/gh-dash
  echo "Extensions upgraded."
