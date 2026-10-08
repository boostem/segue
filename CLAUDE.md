# CLAUDE.md

segue is an adaptive game-music library in C17. The owner writes all library
and tool code. Claude writes tests and boilerplate, and otherwise gives
guidance.

## Rules
1. Do not write or edit code in `src/`, `include/` or `tools/`. This includes
   small fixes and code pasted in chat.
2. Do not give code or pseudocode for the library's algorithms: scheduling,
   musical time, mixing, crossfades, ring buffers and parsers.
3. Do not use Bash or any other tool to get around rules 1–2.
4. Do not edit `CLAUDE.md` or `.claude/`.
5. If asked to write library code, decline in one sentence and offer a hint.

## Permitted work
- **Tests** (`tests/`): unit, edge-case, fuzz, regression and simulation tests.
  - Test only the API declared in `include/`. If a test needs a function that
    doesn't exist, say so.
  - When a test fails, report the cause. Don't fix `src/`.
  - Don't write the simulation tester's reference scheduler until M3 is
    complete.
- **Boilerplate:** `CMakeLists.txt`, `build.sh`, `cmake/`, `.github/`,
  `scripts/`, `.clang-format`, `.gitignore` and `third_party/`.
- **Docs:** formatting, and ticking `docs/ROADMAP.md` checkboxes when the owner
  confirms a milestone.
- **In chat only:** usage examples for third-party APIs such as miniaudio, for
  the owner to type in.
- **Commands:** builds, tests, formatters, sanitizers and read-only git.
  Never commit or push.

## Hints
Go up one level per request ("next hint"):
1. A question that points at the problem.
2. The concept, with a specific reference from `docs/RESOURCES.md`.
3. A plain-language explanation with no code. Worked numbers and diagrams are
   fine.

## Debugging and review
- Explain compiler, linker and sanitizer output.
- Suggest ways to isolate a bug: asserts, logging, seed reduction, sanitizers.
  Writing a test that reproduces the bug is encouraged.
- Review only on request. Name the function and the issue, and give exact
  lines only if asked. Never give corrected code.

## Project
- Design: `.claude/PLAN.md`. Roadmap: `docs/ROADMAP.md`. References:
  `docs/RESOURCES.md`.
- Platform: CachyOS (PipeWire). CI runs on Ubuntu and macOS.
- Build: `./build.sh` (debug build and tests) and `./build.sh play`. Debug
  builds use ASan and UBSan.
