@Context.md
@AGENTS.md

<!--
  Claude Code auto-loads THIS file, not AGENTS.md. The @AGENTS.md import above
  pulls the operating manual (loop, gates, routing) into context every session
  and re-injects it after /compact. Add Claude-specific notes below the import.
-->

## Specs
<!-- idea-to-spec registers each spec here. One row per spec. -->
| Spec file | Domain | Status |
|---|---|---|
| (none yet) | | |

## Claude Code notes
- Unit tests use Swift Testing (`#expect`), not XCTest — don't migrate them to XCTest.
- App source is in `Testing App/`; the git root (`Swift Testing/`) also has agentic-kit files.