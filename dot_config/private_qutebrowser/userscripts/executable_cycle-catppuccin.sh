#!/bin/sh
# Cycle catppuccin flavor: mocha -> macchiato -> frappe -> latte -> mocha.
# Writes the new flavor to the state file, then asks qutebrowser to re-source
# config.py (which reads the state file) via the QUTE_FIFO command channel.
#
# Re-sourcing config.py re-applies the whole theme, including colors.webpage.bg
# and the injected webpage-background stylesheet (catppuccin-webpage-bg.css,
# registered via content.user_stylesheets). qutebrowser re-injects user
# stylesheets into all open tabs whenever content.user_stylesheets is (re)set,
# so already-open pages get the new background immediately — no reload needed.
# The color values live in config.py (_dark_tints); this script only persists
# which flavor is active.
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
    # Write both commands in a single open: separate `>` redirects would
    # truncate a regular file (and depend on the reader staying open on a
    # FIFO), risking the config-source being lost.
    {
        printf 'config-source\n'
        printf 'message-info "Catppuccin: %s"\n' "$next"
    } > "$QUTE_FIFO"
fi
