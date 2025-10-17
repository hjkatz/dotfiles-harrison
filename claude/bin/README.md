# Claude's Personal Tools

This directory contains scripts and binaries that Claude uses across different projects and workflows.

## Purpose

These tools help Claude:
- Avoid repeating complex bash operations
- Maintain consistent approaches to common tasks
- Build reusable utilities over time
- Share common patterns between different projects

## Tool Index

<!-- Keep this list sorted alphabetically -->
<!-- Format: - `tool-name` - Brief description -->

*No tools yet. Tools will be added as they're created.*

## Tool Header Template

Every tool should start with this header format:

```bash
#!/usr/bin/env bash
# Purpose: <one-line description of what this tool does>
# Usage: <tool-name> [args]
# Args:
#   arg1 - description of first argument
#   arg2 - description of second argument (if applicable)
# Output: <what this tool prints or returns>

set -euo pipefail

# Implementation goes here
```

## Guidelines

### When to Create a Tool

- **DO** create a tool when:
  - You've done the same operation 2+ times
  - Complex bash is needed repeatedly
  - A pattern emerges in your workflows
  - Harrison suggests creating one
  - It would help future tasks

- **DON'T** create a tool when:
  - It's too specific to one case
  - A simple inline bash command suffices
  - The operation is rarely needed
  - It can't be generalized

### Tool Naming Conventions

- Use lowercase with hyphens: `check-status`, `list-files`
- Prefer verb-noun format: `parse-logs`, `find-pattern`
- Be descriptive but concise
- Avoid abbreviations unless obvious

### Best Practices

1. **Keep tools focused** - One tool should do one job well
2. **Document thoroughly** - Headers are mandatory
3. **Test before committing** - Ensure tools work as expected
4. **Handle errors gracefully** - Use `set -euo pipefail`
5. **Make tools composable** - Follow UNIX philosophy
6. **Update this README** - Add new tools to the index

## Usage

Tools can be called directly:

```bash
$DOTFILES/claude/bin/tool-name [args]
```

Or if `$DOTFILES/claude/bin` is in your PATH:

```bash
tool-name [args]
```

## Maintenance

- Tools should be reviewed periodically for relevance
- Deprecated tools should be documented before removal
- Major changes should be discussed with Harrison
- Keep the tool index current

## See Also

- Process documentation: `/Users/harrison.katz/.dotfiles-harrison/claude/claude_tools_management.dot`
- Style guide: `/Users/harrison.katz/.dotfiles-harrison/claude/style_guide.dot`
