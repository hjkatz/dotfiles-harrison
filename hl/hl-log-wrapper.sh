#!/usr/bin/env bash
# logger - wrapper around hl with keyword highlighting for error-related terms

set -euo pipefail

# Default keywords to highlight (case-insensitive, with word boundaries)
KEYWORDS="${HL_KEYWORDS:-\berror\b|\bfail\b|\bfailure\b|\bexception\b|\bcritical\b|\bpanic\b|\bfatal\b}"

# Help message
usage() {
    cat <<EOF
Usage: logger [OPTIONS] [FILE...]

Wrapper around hl with additional keyword highlighting for error-related terms.

OPTIONS:
    -k, --keywords PATTERN  Custom keyword pattern to highlight (default: error|fail|failure|exception|critical|panic|fatal)
    -h, --help              Show this help message

ENVIRONMENT:
    HL_KEYWORDS             Override default keywords pattern

EXAMPLES:
    $ cat app.log | logger
    $ logger app.log
    $ logger -k "timeout|retry|error" app.log
    $ tail -f app.log | logger

NOTES:
    - All hl options are passed through (e.g., --level, --filter, --theme)
    - Keyword highlighting uses grep with case-insensitive matching
    - Set HL_KEYWORDS environment variable for persistent custom keywords
EOF
    exit 0
}

# Parse arguments
CONFIG_PATH="${DOTFILES}/hl/config.yaml"
THEME_PATH="${DOTFILES}/hl/theme.yaml"
HL_ARGS=(
    --config="$CONFIG_PATH"
    --color=always
    --theme="$THEME_PATH"
    --paging=never
)
FILES=()

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        -k|--keywords)
            KEYWORDS="$2"
            shift 2
            ;;
        -*)
            # Pass through to hl
            HL_ARGS+=("$1")
            if [[ $# -gt 1 ]] && [[ ! "$2" =~ ^- ]]; then
                HL_ARGS+=("$2")
                shift
            fi
            shift
            ;;
        *)
            FILES+=("$1")
            shift
            ;;
    esac
done

# ANSI color codes for [RAW] formatting
RAW_BRACKET='\033[0;38;2;63;93;127m'  # Same as level brackets
RAW_LABEL='\033[1;37m'                 # Bold white
RAW_MESSAGE='\033[1;38;2;212;175;55m'  # Bold gold
RESET='\033[0m'

# Process raw lines: add [RAW] prefix to lines without level indicators
process_raw_lines() {
    awk -v bracket="$RAW_BRACKET" -v label="$RAW_LABEL" -v msg="$RAW_MESSAGE" -v reset="$RESET" '
    {
        # Check if line has level indicator pattern like [INF], [ERR], etc.
        # Look for the pattern: [...][level][...]
        if ($0 ~ /\[.*\]/) {
            # Has level indicator, print as-is
            print
            fflush()
        } else if (length($0) > 0) {
            # Raw line - prepend [RAW] with formatting
            printf "%s[%s%sRAW%s%s]%s %s%s%s\n", bracket, reset, label, reset, bracket, reset, msg, $0, reset
            fflush()
        } else {
            # Empty line, print as-is
            print
            fflush()
        }
    }'
}

# Run hl and highlight keywords
# Use rg --passthru and --line-buffered to preserve hl colors and avoid hanging in pipes
if [[ ${#FILES[@]} -eq 0 ]]; then
    # Read from stdin
    if [[ ${#HL_ARGS[@]} -eq 0 ]]; then
        hl | process_raw_lines | rg --passthru --line-buffered --color=always -i "$KEYWORDS"
    else
        hl "${HL_ARGS[@]}" | process_raw_lines | rg --passthru --line-buffered --color=always -i "$KEYWORDS"
    fi
else
    # Read from files
    if [[ ${#HL_ARGS[@]} -eq 0 ]]; then
        hl "${FILES[@]}" | process_raw_lines | rg --passthru --line-buffered --color=always -i "$KEYWORDS"
    else
        hl "${HL_ARGS[@]}" "${FILES[@]}" | process_raw_lines | rg --passthru --line-buffered --color=always -i "$KEYWORDS"
    fi
fi
