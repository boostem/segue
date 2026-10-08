# Design

## Goal
segue is a small, engine-agnostic C17 library for adaptive game music. It
quantizes state changes and layer fades to musical boundaries (beat, bar or
N bars), with sample accuracy and real-time-safe rendering.

## Motivation
Existing options are:
- proprietary: FMOD, Wwise, Elias
- engine-specific: Godot's AudioStreamInteractive
- written in C++: OAML

No small C library targets raylib, SDL or LÖVE projects.

## Scope (v0.1)
- State transitions quantized to beat or bar, with transition segments and
  stingers
- Layers per state, with gain ramps and equal-power crossfades
- A tempo map with drift-free boundary computation
- A lock-free command queue between the game thread and the audio thread
- A text format for describing the music
- WAV input

**Out of scope for v0.1:** time-stretching, resampling, streaming, compressed
formats and native audio backends. These are listed under stretch goals in
`docs/ROADMAP.md`.

## Decisions
- **Language and build:** C17, built with CMake through `build.sh`.
- **Device I/O:** miniaudio 0.11.25, vendored. The library itself doesn't
  depend on an audio device; it renders offline for tests.
- **Time:** represented as an integer frame count (`uint64_t`).
- **Builds and tests:** debug builds use ASan and UBSan. Tests run without an
  audio device.
- **Platforms:** developed on CachyOS (PipeWire). CI runs on Ubuntu and macOS.
- **License:** TBD.

## Code ownership
The maintainer writes `src/`, `include/` and `tools/`. AI tooling may write
tests and build/CI boilerplate.

The rules are in `CLAUDE.md`. Deny rules in `.claude/settings.json` enforce
them for file edits. Shell writes are covered only by the instructions in
`CLAUDE.md`.

## See also
- Milestones and testing: `docs/ROADMAP.md`
- References: `docs/RESOURCES.md`
