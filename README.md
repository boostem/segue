# segue

Adaptive game music in C.

segue schedules music changes on musical boundaries. It switches states on the
next bar, fades layers in on the beat, and quantizes stingers to the grid. It
is a small, engine-agnostic C17 library for projects built on raylib, SDL or
LÖVE.

Status: pre-release. See [docs/ROADMAP.md](docs/ROADMAP.md).

## Building

Requires a C compiler, CMake 3.20+ and make. Dependencies are vendored.

    ./build.sh            # debug build (ASan + UBSan) and tests
    ./build.sh play       # run segue_play
    ./build.sh release    # optimized build
    ./build.sh install    # install to ~/.local (override with PREFIX=)
    ./build.sh uninstall
    ./build.sh format     # requires clang-format
    ./build.sh clean

If a tool is missing, `build.sh` prints the install command for the detected
package manager and offers to run it.

## Layout

    include/segue/   public header
    src/             library
    tools/           segue_play, command-line player
    tests/           tests
    third_party/     miniaudio (device I/O)
    assets/loops/    local audio assets (gitignored)
    docs/            roadmap and references

## AI usage

Library and tool code (`src/`, `include/`, `tools/`) is written by hand. AI
assistants may:

- write tests and build/CI boilerplate
- explain concepts
- review code

They do not write library code. The rules for Claude Code are in
[CLAUDE.md](CLAUDE.md) and enforced by `.claude/settings.json`.

## License

TBD. miniaudio is public domain or MIT-0; see `third_party/miniaudio/LICENSE`.
