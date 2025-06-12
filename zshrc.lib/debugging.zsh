# debugging

# where should we store our debug information
# Note: This is exported here instead of zshrc.lib/globals.zsh because of the ordering of source files in zshrc
export GLOBALS__DEBUGGING_PATH="/tmp/.dotfiles-harrison-debugging"

if [[ "$ENABLE_DEBUGGING" == true ]]; then
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>$GLOBALS__DEBUGGING_PATH
    setopt xtrace prompt_subst
fi

# turn off the debugging in exit-tasks.zsh

function zsh_debug () {
    if [[ "$ENABLE_DEBUGGING" != true ]] ; then
        color_echo red "Debugging was not enabled for this session!"
        return 1
    fi

    if [[ ! -f "$GLOBALS__DEBUGGING_PATH" ]] ; then
        color_echo red "Debugging information was not saved to the debugging path '$GLOBALS__DEBUGGING_PATH'!"
        return 1
    fi

    # set the default timing threshold (configurable)
    timing_threshold="${1:-10}"
    
    # validate timing threshold is numeric
    if ! [[ "$timing_threshold" =~ ^[0-9]+$ ]]; then
        color_echo red "Invalid timing threshold: '$timing_threshold'. Using default of 10ms."
        timing_threshold="10"
    fi

    # get the starting time
    debugging_start_time=`head -n 1 $GLOBALS__DEBUGGING_PATH | awk '{print $1}'`

    # print out the first line for consistency
    first_line=`head -n 1 $GLOBALS__DEBUGGING_PATH`
    first_section=`echo $first_line | awk '{print $2}' | cut -f1 -d:`
    color_echo green "$first_line"

    # for recording the timing
    previous_section_start_time="$debugging_start_time"
    previous_section="$first_section"
    previous_line="$first_line"

    # read each line
    while read line ; do
        current_section=`echo $line | awk '{print $2}' | cut -f1 -d:`

        # skip any line that doesn't match our debugging pattern (improved regex)
        if ! echo "$line" | grep -q -E '^[0-9]+\s.*:[0-9]+>' ; then
            continue
        fi

        # skip sections that are the same
        if [[ $current_section == $previous_section ]] ; then
            previous_line="$line"
            continue
        fi

        # find the timing of the previous section to now
        current_section_start_time=`echo $line | awk '{print $1}'`
        
        # ensure timestamps are numeric
        if ! [[ "$current_section_start_time" =~ ^[0-9]+$ ]] || ! [[ "$previous_section_start_time" =~ ^[0-9]+$ ]]; then
            continue
        fi
        
        timing=$(( $current_section_start_time - $previous_section_start_time ))

        if [[ $timing -gt $timing_threshold ]] ; then
            # trim the lines to print
            trim_previous_line=`echo $previous_line | cut -c1-120`
            trim_line=`echo $line | cut -c1-120`
            
            # print timing and lines with duration info
            color_echo yellow "Duration: ${timing}ms"
            color_echo red "$trim_previous_line (took ${timing}ms)"
            color_echo green "$trim_line"
        fi

        # update the previous vars
        previous_section_start_time="$current_section_start_time"
        previous_section="$current_section"
        previous_line="$line"
    done < $GLOBALS__DEBUGGING_PATH

    # print the total time
    debugging_end_time=`echo $previous_line | awk '{print $1}'`
    
    # ensure timestamps are numeric for total calculation
    if [[ "$debugging_end_time" =~ ^[0-9]+$ ]] && [[ "$debugging_start_time" =~ ^[0-9]+$ ]]; then
        total_time=$(( $debugging_end_time - $debugging_start_time ))
    else
        total_time=0
    fi
    color_echo yellow "Total Time: ${total_time}ms"
    
    # provide optimization suggestions
    if [[ $total_time -gt 1000 ]]; then
        color_echo red "🐌 Slow startup detected (>${total_time}ms). Consider optimizing:"
        color_echo yellow "  - Review plugin loading order"
        color_echo yellow "  - Check for network-dependent operations" 
        color_echo yellow "  - Consider lazy loading for heavy plugins"
        echo
        color_echo cyan "💡 Run 'zsh_debug_claude' for AI-powered analysis and specific suggestions!"
    elif [[ $total_time -gt 500 ]]; then
        color_echo yellow "⚠️  Moderate startup time (${total_time}ms). Could be optimized."
        color_echo cyan "💡 Run 'zsh_debug_claude' for detailed analysis and suggestions."
    else
        color_echo green "⚡ Fast startup time (${total_time}ms)!"
    fi
}

# Quick debug summary without full trace
function zsh_debug_summary() {
    if [[ "$ENABLE_DEBUGGING" != true ]] ; then
        color_echo red "Debugging was not enabled for this session!"
        return 1
    fi

    if [[ ! -f "$GLOBALS__DEBUGGING_PATH" ]] ; then
        color_echo red "Debugging information was not saved!"
        return 1
    fi

    # get timing info
    local start_time=$(head -n 1 "$GLOBALS__DEBUGGING_PATH" | awk '{print $1}')
    local end_time=$(tail -n 1 "$GLOBALS__DEBUGGING_PATH" | awk '{print $1}')
    local total_time=$(( end_time - start_time ))
    local line_count=$(wc -l < "$GLOBALS__DEBUGGING_PATH")
    
    color_echo blue "📊 Debug Summary:"
    echo "  Total startup time: ${total_time}ms"
    echo "  Debug lines logged: $line_count"
    echo "  Debug file: $GLOBALS__DEBUGGING_PATH"
    
    # show top slow sections
    echo
    color_echo blue "🔍 Slowest sections:"
    awk '{print $1, $2}' "$GLOBALS__DEBUGGING_PATH" | \
    awk 'NR>1 {print prev_time, prev_section, ($1-prev_time)} {prev_time=$1; prev_section=$2}' | \
    sort -k3 -nr | head -5 | \
    while read start section timing; do
        echo "  ${section}: ${timing}ms"
    done
}

# AI-powered debugging analysis with specific suggestions
function zsh_debug_claude() {
    if [[ "$ENABLE_DEBUGGING" != true ]] ; then
        color_echo red "Debugging was not enabled for this session!"
        color_echo yellow "Enable debugging by setting ENABLE_DEBUGGING=true in your zshrc"
        return 1
    fi

    if [[ ! -f "$GLOBALS__DEBUGGING_PATH" ]] ; then
        color_echo red "Debugging information was not saved!"
        return 1
    fi

    color_echo blue "🤖 Claude Debug Analysis"
    echo "========================================"

    # Calculate timing info
    local start_time=$(head -n 1 "$GLOBALS__DEBUGGING_PATH" | awk '{print $1}')
    local end_time=$(tail -n 1 "$GLOBALS__DEBUGGING_PATH" | awk '{print $1}')
    local total_time=$(( end_time - start_time ))
    
    color_echo green "📊 Performance Overview:"
    echo "  Total startup time: ${total_time}ms"
    
    # Performance rating
    if [[ $total_time -lt 300 ]]; then
        color_echo green "  Rating: ⚡ Excellent (sub-300ms)"
    elif [[ $total_time -lt 500 ]]; then
        color_echo yellow "  Rating: ✅ Good (300-500ms)"
    elif [[ $total_time -lt 1000 ]]; then
        color_echo yellow "  Rating: ⚠️  Moderate (500ms-1s)"
    else
        color_echo red "  Rating: 🐌 Slow (>1s) - Needs optimization"
    fi
    
    echo
    color_echo blue "🔍 Detailed Analysis:"
    
    # Analyze top slowest sections with intelligent suggestions
    local slow_sections=$(awk '{print $1, $2}' "$GLOBALS__DEBUGGING_PATH" | \
        awk 'NR>1 {print prev_time, prev_section, ($1-prev_time)} {prev_time=$1; prev_section=$2}' | \
        sort -k3 -nr | head -10)
    
    echo "$slow_sections" | while IFS= read -r line; do
        local start section timing
        read start section timing <<< "$line"
        
        if [[ $timing -gt 50 ]]; then
            color_echo red "🚨 SLOW: ${section} (${timing}ms)"
            
            # Provide specific suggestions based on section name
            case "$section" in
                *"plugin"*|*"Plugin"*)
                    color_echo cyan "   💡 Plugin loading detected. Suggestions:"
                    color_echo white "      • Consider lazy loading: defer non-essential plugins"
                    color_echo white "      • Check if plugin uses network calls during load"
                    color_echo white "      • Move heavy plugins to on-demand loading"
                    ;;
                *"completion"*|*"compinit"*)
                    color_echo cyan "   💡 Completion system slowdown. Suggestions:"
                    color_echo white "      • Enable completion caching (already done ✅)"
                    color_echo white "      • Reduce completion search paths"
                    color_echo white "      • Check for slow completion functions"
                    ;;
                *"git"*|*"Git"*)
                    color_echo cyan "   💡 Git operation detected. Suggestions:"
                    color_echo white "      • Check if git commands are running during startup"
                    color_echo white "      • Consider async git status updates"
                    color_echo white "      • Verify git repo integrity (run 'git fsck')"
                    ;;
                *"update"*|*"Update"*)
                    color_echo cyan "   💡 Update process detected. Suggestions:"
                    color_echo white "      • Move update checks to background process"
                    color_echo white "      • Increase update check interval"
                    color_echo white "      • Consider async updates"
                    ;;
                *"network"*|*"curl"*|*"wget"*|*"ping"*)
                    color_echo cyan "   💡 Network operation detected. Suggestions:"
                    color_echo white "      • Move network checks to background"
                    color_echo white "      • Add network connectivity checks before slow operations"
                    color_echo white "      • Cache network-dependent results"
                    ;;
                *"templater"*|*"template"*)
                    color_echo cyan "   💡 Template processing detected. Suggestions:"
                    color_echo white "      • Cache compiled templates"
                    color_echo white "      • Only recompile when templates change"
                    color_echo white "      • Consider pre-compiling templates"
                    ;;
                *)
                    color_echo cyan "   💡 General optimization suggestions:"
                    color_echo white "      • Profile this section: $section"
                    color_echo white "      • Check for file I/O operations"
                    color_echo white "      • Look for external command calls"
                    ;;
            esac
            echo
        elif [[ $timing -gt 20 ]]; then
            color_echo yellow "⚠️  MODERATE: ${section} (${timing}ms)"
        fi
    done
    
    echo
    color_echo blue "🎯 Top Recommendations:"
    
    # Overall recommendations based on timing
    if [[ $total_time -gt 1000 ]]; then
        color_echo red "🚨 CRITICAL: Startup >1s requires immediate attention"
        color_echo white "   1. Run 'zsh_debug 20' to see all slow operations"
        color_echo white "   2. Focus on sections >100ms first"
        color_echo white "   3. Consider disabling non-essential plugins temporarily"
        color_echo white "   4. Check for network dependencies in startup"
    elif [[ $total_time -gt 500 ]]; then
        color_echo yellow "⚠️  OPTIMIZATION: Target sub-500ms startup"
        color_echo white "   1. Focus on sections >50ms"
        color_echo white "   2. Enable lazy loading for heavy features"
        color_echo white "   3. Cache expensive operations"
    else
        color_echo green "✅ GOOD: Consider micro-optimizations only"
        color_echo white "   1. Monitor for regressions"
        color_echo white "   2. Document current performance baseline"
    fi
    
    echo
    color_echo blue "📚 Next Steps:"
    color_echo white "   • Run 'zsh_debug_summary' for quick overview"
    color_echo white "   • Use 'zsh_debug [threshold]' for detailed timing"
    color_echo white "   • Set ENABLE_DEBUGGING=false when not profiling"
    color_echo white "   • Benchmark before/after making changes"
    
    echo
    color_echo green "Analysis complete! 🤖✨"
}
