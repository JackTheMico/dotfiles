#!/bin/bash

echo "gh extension list result: $check_extensions"
gh extension upgrade mislav/gh-branch
check_extensions=$?
if [[ $check_extensions == 1 ]]; then
  echo "No extensions found. Installing..."
  gh extension install mislav/gh-branch
  gh extension install gennaro-tedesco/gh-s
  gh extension install k1LoW/gh-grep
  gh extension install yusukebe/gh-markdown-preview
  gh extension install gennaro-tedesco/gh-f
  gh extension install meiji163/gh-notify
  gh extension install rnorth/gh-combine-prs
  gh extension install dlvhdr/gh-dash
  echo "Extensions installed."
else
  gh extension upgrade mislav/gh-branch
  gh extension upgrade gennaro-tedesco/gh-s
  gh extension upgrade k1LoW/gh-grep
  gh extension upgrade yusukebe/gh-markdown-preview
  gh extension upgrade gennaro-tedesco/gh-f
  gh extension upgrade meiji163/gh-notify
  gh extension upgrade rnorth/gh-combine-prs
  gh extension upgrade dlvhdr/gh-dash
  echo $?
  echo "Extensions upgraded."
fi
