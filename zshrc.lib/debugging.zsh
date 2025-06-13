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
        color_echo red "❌ Debugging was not enabled for this session!"
        echo "   Enable with: export ENABLE_DEBUGGING=true"
        return 1
    fi

    if [[ ! -f "$GLOBALS__DEBUGGING_PATH" ]] ; then
        color_echo red "❌ Debugging information was not saved to '$GLOBALS__DEBUGGING_PATH'!"
        return 1
    fi

    # Set the default timing threshold (configurable)
    timing_threshold="${1:-10}"

    # Validate timing threshold is numeric
    if ! [[ "$timing_threshold" =~ ^[0-9]+$ ]]; then
        color_echo red "❌ Invalid timing threshold: '$timing_threshold'. Using default of 10ms."
        timing_threshold="10"
    fi

    color_echo white "──── ⏱️ Shell Startup Performance Analysis ────"
    echo "   Threshold:  ${timing_threshold}ms (showing operations slower than this)"
    echo "   Debug file: $GLOBALS__DEBUGGING_PATH"
    echo

    # Get the starting time
    debugging_start_time=`head -n 1 $GLOBALS__DEBUGGING_PATH | awk '{print $1}'`

    # Print out the first line for consistency
    first_line=`head -n 1 $GLOBALS__DEBUGGING_PATH`
    first_section=`echo $first_line | awk '{print $2}' | cut -f1 -d:`
    echo "🚀 Starting: $first_line"
    echo

    # For recording the timing
    previous_section_start_time="$debugging_start_time"
    previous_section="$first_section"
    previous_line="$first_line"

    # Use awk for much faster processing of large debug files
    awk -v threshold="$timing_threshold" '
    BEGIN {
        prev_time = 0;
        prev_section = "";
        prev_line = "";
        first_line = 1;
    }

    /^[0-9]+ .*:[0-9]+>/ {
        current_time = $1;
        current_section = $2;
        gsub(/:.*/, "", current_section);

        if (current_time !~ /^[0-9]+$/) {
            next;
        }

        # Initialize with first valid timestamp
        if (first_line) {
            prev_time = current_time;
            prev_section = current_section;
            prev_line = $0;
            first_line = 0;
            next;
        }

        if (current_section == prev_section) {
            prev_time = current_time;
            prev_line = $0;
            next;
        }

        timing = current_time - prev_time;

        if (timing > threshold) {
            prev_display = substr(prev_line, 1, 120);
            curr_display = substr($0, 1, 120);

            # Color-code timing based on severity
            if (timing > 500) {
                timing_icon = "🔴";
                duration_color = "\033[31m";  # Red for >500ms
            } else if (timing > 50) {
                timing_icon = "🟡";
                duration_color = "\033[33m";  # Yellow for >50ms
            } else {
                timing_icon = "🟢";
                duration_color = "\033[32m";  # Green for moderate
            }

            printf duration_color timing_icon " %4dms\033[0m : %s\n", timing, prev_display;
            print "";
        }

        prev_time = current_time;
        prev_section = current_section;
        prev_line = $0;
    }
    ' "$GLOBALS__DEBUGGING_PATH"

    # Calculate total time using the last line of the debug file
    debugging_end_time=$(tail -n 1 "$GLOBALS__DEBUGGING_PATH" | awk '{print $1}')

    # ensure timestamps are numeric for total calculation
    if [[ "$debugging_end_time" =~ ^[0-9]+$ ]] && [[ "$debugging_start_time" =~ ^[0-9]+$ ]]; then
        total_time=$(( $debugging_end_time - $debugging_start_time ))
    else
        total_time=0
    fi
    color_echo white "──── 📈 Performance Summary ────"

    # Get debug info for integration
    local line_count=$(wc -l < "$GLOBALS__DEBUGGING_PATH")

    # Performance rating with visual indicators
    if [[ $total_time -lt 300 ]]; then
        color_echo green "⚡ Overall Rating: EXCELLENT (${total_time}ms)"
    elif [[ $total_time -lt 500 ]]; then
        color_echo green "✅ Overall Rating: GOOD (${total_time}ms)"
    elif [[ $total_time -lt 1000 ]]; then
        color_echo yellow "⚠️ Overall Rating: MODERATE (${total_time}ms)"
    else
        color_echo red "🐌 Overall Rating: SLOW (${total_time}ms)"
    fi

    echo "   Debug lines: $line_count operations traced"
    echo

    color_echo white "🏆 Top 5 Slowest Operations:"
    # Show top slow sections
    awk '{print $1, $2}' "$GLOBALS__DEBUGGING_PATH" | \
    awk 'NR>1 {print prev_time, prev_section, ($1-prev_time)} {prev_time=$1; prev_section=$2}' | \
    sort -k3 -nr | head -5 | \
    while read start section timing; do
        if [[ $timing -gt 500 ]]; then
            printf "   \033[31m🔴 %4dms : %s\033[0m\n" $timing $(basename $section)
        elif [[ $timing -gt 50 ]]; then
            printf "   \033[33m🟡 %4dms : %s\033[0m\n" $timing $(basename $section)
        else
            printf "   \033[32m🟢 %4dms : %s\033[0m\n" $timing $(basename $section)
        fi
    done

    echo
    color_echo white "💡 Next Steps:"
    if [[ $total_time -gt 1000 ]]; then
        echo "   • Focus on operations >100ms first"
        echo "   • Review plugin loading order"
        echo "   • Check for network-dependent operations"
        echo "   • Consider lazy loading for heavy plugins"
    elif [[ $total_time -gt 500 ]]; then
        echo "   • Focus on operations >50ms"
        echo "   • Enable lazy loading for heavy features"
        echo "   • Cache expensive operations"
    fi
    echo "   • zsh_debug_claude  → AI-powered analysis with specific suggestions"
    echo "   • zsh_debug_summary → Quick overview of slowest operations"
    echo "   • zsh_debug [ms]    → Custom detailed analysis (default 10ms)"
}

# Quick debug summary without full trace
function zsh_debug_summary() {
    if [[ "$ENABLE_DEBUGGING" != true ]] ; then
        color_echo red "❌ Debugging was not enabled for this session!"
        return 1
    fi

    if [[ ! -f "$GLOBALS__DEBUGGING_PATH" ]] ; then
        color_echo red "❌ Debugging information was not saved!"
        return 1
    fi

    color_echo white "──── 📊 Quick Debug Summary ────"

    # Get timing info
    local start_time=$(head -n 1 "$GLOBALS__DEBUGGING_PATH" | awk '{print $1}')
    local end_time=$(tail -n 1 "$GLOBALS__DEBUGGING_PATH" | awk '{print $1}')
    local total_time=$(( end_time - start_time ))
    local line_count=$(wc -l < "$GLOBALS__DEBUGGING_PATH")

    # Performance rating
    local rating_icon
    local rating_color
    if [[ $total_time -lt 300 ]]; then
        rating_icon="⚡"; rating_color="green"
    elif [[ $total_time -lt 500 ]]; then
        rating_icon="✅"; rating_color="green"
    elif [[ $total_time -lt 1000 ]]; then
        rating_icon="⚠️ "; rating_color="yellow"
    else
        rating_icon="🐌"; rating_color="red"
    fi

    color_echo white "🎯 Overview:"
    color_echo $rating_color "   Performance   : $rating_icon ${total_time}ms total startup time"
    echo "   Debug lines: $line_count operations traced"
    echo "   Debug file:  $GLOBALS__DEBUGGING_PATH"

    echo
    color_echo white "🏆 Top 5 Slowest Operations:"

    # Show top slow sections with better formatting
    awk '{print $1, $2}' "$GLOBALS__DEBUGGING_PATH" | \
    awk 'NR>1 {print prev_time, prev_section, ($1-prev_time)} {prev_time=$1; prev_section=$2}' | \
    sort -k3 -nr | head -5 | \
    while read start section timing; do
        if [[ $timing -gt 100 ]]; then
            printf "   \033[31m🔴 %4dms : %s\033[0m\n" $timing $(basename $section)
        elif [[ $timing -gt 50 ]]; then
            printf "   \033[33m🟡 %4dms : %s\033[0m\n" $timing $(basename $section)
        else
            printf "   \033[32m🟢 %4dms : %s\033[0m\n" $timing $(basename $section)
        fi
    done

    echo
    echo "💡 Run 'zsh_debug' for detailed analysis or 'zsh_debug_claude' for AI insights"
}

# AI-powered debugging analysis with specific suggestions
function zsh_debug_claude() {
    if [[ "$ENABLE_DEBUGGING" != true ]] ; then
        color_echo red "❌ Debugging was not enabled for this session!"
        echo "   Enable debugging by setting ENABLE_DEBUGGING=true in your zshrc"
        return 1
    fi

    if [[ ! -f "$GLOBALS__DEBUGGING_PATH" ]] ; then
        color_echo red "❌ Debugging information was not saved!"
        return 1
    fi

    # Function to generate the analysis
    _generate_analysis() {

    color_echo white "──── 🤖 Claude AI Performance Analysis ────"

    # Calculate timing info
    local start_time=$(head -n 1 "$GLOBALS__DEBUGGING_PATH" | awk '{print $1}')
    local end_time=$(tail -n 1 "$GLOBALS__DEBUGGING_PATH" | awk '{print $1}')
    local total_time=$(( end_time - start_time ))

    echo
    color_echo white "📊 Performance Overview:"
    echo "   Total startup time : ${total_time}ms"

    # Performance rating with better formatting
    if [[ $total_time -lt 300 ]]; then
        color_echo green "   Rating             : ⚡ Excellent (sub-300ms)"
        echo "   Status             : Outstanding performance! Keep monitoring for regressions."
    elif [[ $total_time -lt 500 ]]; then
        color_echo green "   Rating             : ✅ Good (300-500ms)"
        echo "   Status             : Good performance with room for minor improvements."
    elif [[ $total_time -lt 1000 ]]; then
        color_echo yellow "   Rating             : ⚠️ Moderate (500ms-1s)"
        echo "   Status             : Noticeable startup delay - optimization recommended."
    else
        color_echo red "   Rating             : 🐌 Slow (>1s)"
        echo "   Status             : CRITICAL - Requires immediate optimization attention."
    fi

    echo
    color_echo white "🔍 Detailed Timing Analysis:"

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
                    color_echo white "    • Consider lazy loading: defer non-essential plugins"
                    color_echo white "    • Check if plugin uses network calls during load"
                    color_echo white "    • Move heavy plugins to on-demand loading"
                    ;;
                *"completion"*|*"compinit"*)
                    color_echo cyan "   💡 Completion system slowdown. Suggestions:"
                    color_echo white "    • Enable completion caching (already done ✅)"
                    color_echo white "    • Reduce completion search paths"
                    color_echo white "    • Check for slow completion functions"
                    ;;
                *"git"*|*"Git"*)
                    color_echo cyan "   💡 Git operation detected. Suggestions:"
                    color_echo white "    • Check if git commands are running during startup"
                    color_echo white "    • Consider async git status updates"
                    color_echo white "    • Verify git repo integrity (run 'git fsck')"
                    ;;
                *"update"*|*"Update"*)
                    color_echo cyan "   💡 Update process detected. Suggestions:"
                    color_echo white "    • Move update checks to background process"
                    color_echo white "    • Increase update check interval"
                    color_echo white "    • Consider async updates"
                    ;;
                *"network"*|*"curl"*|*"wget"*|*"ping"*)
                    color_echo cyan "   💡 Network operation detected. Suggestions:"
                    color_echo white "    • Move network checks to background"
                    color_echo white "    • Add network connectivity checks before slow operations"
                    color_echo white "    • Cache network-dependent results"
                    ;;
                *"templater"*|*"template"*)
                    color_echo cyan "   💡 Template processing detected. Suggestions:"
                    color_echo white "    • Cache compiled templates"
                    color_echo white "    • Only recompile when templates change"
                    color_echo white "    • Consider pre-compiling templates"
                    ;;
                *)
                    color_echo cyan "   💡 General optimization suggestions:"
                    color_echo white "    • Profile this section: $section"
                    color_echo white "    • Check for file I/O operations"
                    color_echo white "    • Look for external command calls"
                    ;;
            esac
            echo
        elif [[ $timing -gt 20 ]]; then
            color_echo yellow "⚠️ MODERATE: ${section} (${timing}ms)"
        fi
    done


    echo
    color_echo white "🎯 Recommendations:"

    # Overall recommendations based on timing with priority levels
    if [[ $total_time -gt 1000 ]]; then
        color_echo red "🚨 CRITICAL: Startup >1s requires immediate attention"
        echo "   • Run 'zsh_debug 20' to see all slow operations"
        echo "   • Focus on sections >100ms first"
        echo "   • Disable non-essential plugins temporarily"
        echo "   • Check for network dependencies in startup"
    elif [[ $total_time -gt 500 ]]; then
        color_echo yellow "⚠️ MODERATE: Target sub-500ms startup"
        echo "   • Focus on sections >50ms"
        echo "   • Enable lazy loading for heavy features"
        echo "   • Cache expensive operations"
    fi

    echo
    color_echo white "📚 Available Tools:"
    echo "   • zsh_debug_summary       → Quick overview with top slowdowns"
    echo "   • zsh_debug [ms]          → Detailed timing (default 10ms)"
    echo "   • resource_with_debugging → Fresh analysis session"
    }

    # Generate and display the analysis
    local analysis_output=$(_generate_analysis)
    echo "$analysis_output"

    # Ask if user wants to launch Claude
    echo
    if ask "Launch Claude to optimize these issues?" ; then
        # Prepare the prompt for Claude
        local claude_prompt="I've run a performance analysis on my zsh startup. Please help me optimize it based on this analysis:

$analysis_output

Please:
1. Review the slow operations identified above
2. Provide specific code changes to optimize the slowest parts
3. Focus on the AI suggestions provided for each slow section
4. Give me the exact file edits needed to improve startup performance
5. Prioritize changes that will have the biggest impact

My dotfiles are located at: $DOTFILES"

        echo
        color_echo yellow "🚀 Launching Claude with optimization request..."
        echo

        # Launch Claude with the analysis and prompt
        echo "$claude_prompt" | claude
    fi
}
