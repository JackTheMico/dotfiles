#!/bin/sh
# Cycle catppuccin flavor: mocha -> macchiato -> frappe -> latte -> mocha.
# Writes the new flavor to the state file, then asks qutebrowser to re-source
# config.py (which reads the state file) via the QUTE_FIFO command channel.
state="${QUTE_CONFIG_DIR:-$HOME/.config/qutebrowser}/catppuccin-flavor"
cur=$(cat "$state" 2>/dev/null || echo mocha)
case "$cur" in
    mocha)     next=macchiato ;;
    macchiato) next=frappe ;;
    frappe)    next=latte ;;
    latte|*)   next=mocha ;;   # unknown/garbage state -> back to mocha
esac
printf '%s\n' "$next" > "$state"
if [ -n "$QUTE_FIFO" ]; then
    printf 'config-source\n' > "$QUTE_FIFO"
    printf 'message-info "Catppuccin: %s"\n' "$next" > "$QUTE_FIFO"
fi
