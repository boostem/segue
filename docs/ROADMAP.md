# Roadmap

## Core problems
1. **Sample-accurate musical time.** Changes land on the exact frame of a beat
   or bar boundary. That holds for fractional bar lengths, tempo changes and
   long sessions, with no drift.
2. **Click-free mixing.** Smoothed gain, equal-power crossfades, and no
   discontinuities.
3. **Real-time safety.** The audio callback never allocates, locks, performs
   I/O or waits on the game thread.

## Milestones

- [ ] **M0: Scaffold.** `./build.sh` and `./build.sh play` succeed.

- [ ] **M1: Bar-quantized switch.** In `tools/segue_play.c`:
  - Load two 4-bar loops with `ma_decoder`. At 120 BPM and 48 kHz, one bar is
    96,000 frames; export settings are in `assets/loops/README.md`.
  - Play loop A. Pressing Enter sets an atomic flag.
  - The callback switches to B on the next bar line, splitting the buffer when
    the boundary falls inside it.
  - Topics: frames vs. samples, interleaving, the callback model, `stdatomic.h`.
  - Done when: switches always land on the bar line, and the rule for a
    request that arrives just before a boundary is defined and documented.

- [ ] **M2: WAV I/O.** A RIFF/WAVE reader and a float32 writer. They replace
  `ma_decoder`.
  - The reader skips unknown chunks and converts 16-bit int, 24-bit int and
    32-bit float PCM to float32.
  - Topics: little-endian byte order, chunk padding, WAVE_FORMAT_EXTENSIBLE.
  - Done when: a round trip is exact, Ableton exports load, and malformed
    input returns errors.

- [ ] **M3: Musical clock.** A `uint64_t` frame clock, exact computation of the
  next beat, bar or N-bar boundary, and a tempo map.
  - Topics: floating-point drift, consistent rounding, overflow bounds.
  - Done when: at 127 BPM / 44.1 kHz, the 100,000th bar boundary computed step
    by step equals the direct computation, and boundaries stay exact across
    tempo changes.

- [ ] **M4: Offline renderer and mixer.** A render function that needs no audio
  device, with per-state layers, gain ramps, equal-power crossfades and fades
  on start and stop.
  - Topics: zipper noise, crossfade curves, headroom, denormals.
  - Done when: a scripted sequence renders to WAV, and the no-click invariant
    passes.

- [ ] **M5: States, transitions, stingers.**
  - Per-transition quantization: immediate, beat, bar, N bars or end of loop.
  - Optional transition segments.
  - Beat-quantized stingers.
  - A documented policy for overlapping requests.
  - Done when: the simulation tester runs for 10 minutes without failure.

- [ ] **M6: Real-time safety.** Game-thread API calls enqueue commands, and the
  audio thread drains them through a lock-free SPSC ring buffer built on C11
  atomics. Render never allocates, locks or performs I/O.
  - Topics: acquire/release ordering, false sharing, priority inversion.
  - Done when: TSan is clean under concurrent stress, and the allocation
    tripwire never fires.

- [ ] **M7: Music description format.** A text format (for example
  `level1.music`) that declares tempo, states, layers and transitions. The
  lexer and parser are hand-written and report errors as `line:col`.
  - Done when: errors point to the correct location, and the parser survives
    fuzzing.

- [ ] **M8: v0.1.**
  - Clean up the public header and add a usage section to the README.
  - Build a raylib demo: entering a zone triggers the combat state, and low
    health brings in a drum layer.
  - Tag `v0.1.0` and publish a PKGBUILD to the AUR.

## Stretch goals
- Tempo-matched transitions between different BPMs, using WSOLA
  time-stretching
- Sample-rate conversion (polynomial interpolators, windowed sinc)
- Streaming from disk on a loader thread, with lock-free buffer handoff
- Native ALSA and PipeWire backends behind a backend interface
- SIMD mixing, verified against the scalar path
- An intensity parameter (0–1) that drives several layers, quantized to beats
- Command recording and deterministic offline replay

## Testing

The main tool is deterministic simulation testing. A seeded generator issues
random operations to both the engine and a reference model, and their results
are compared after every step.

- **Operations:** SET_STATE, SET_LAYER, STINGER, SET_TEMPO and RENDER (with a
  random block size from 1 to 4096).
- **Reference scheduler:** a slow model that is obviously correct. It advances
  one frame at a time with exact integer arithmetic and logs when each change
  should occur.
- **Reproducibility:** `--seed`, `--seqid` and `--duration`. A failure prints
  the command to rerun it.
- **Fault injection:** a failing allocator and a failing file reader on the
  load paths, plus a tripwire allocator that aborts if called during render.
- **Regressions:** each failing seed becomes a permanent test in
  `tests/regressions/`.
- **CI:** runs `segue_simtest --duration 60` on Linux and macOS with ASan and
  UBSan.

### Invariants
1. **Boundary:** every change starts on the frame the reference predicts.
2. **Block-size invariance:** output is bit-identical whatever the render block
   sizes.
3. **Determinism:** the same seed produces the same output.
4. **No clicks:** with smooth inputs, |x[n] − x[n−1]| stays below a threshold
   across transitions.
5. **Equal power:** gA² + gB² ≈ 1 during crossfades.
6. **Real-time:** no allocation during render, and TSan is clean.
7. **Liveness:** every request takes effect by its next eligible boundary.

### Self-describing test signals
Each sample of a test loop encodes the loop id and frame index as an exact
integer, for example `id * 1,000,000 + frame`; float32 represents integers
exactly up to 2²⁴. With one layer at unity gain, the output shows exactly which
loop and frame played at each sample. These signals are used only in offline
tests.

### Fuzzing
Run libFuzzer (`clang -fsanitize=fuzzer,address`) on the WAV and `.music`
parsers. On CachyOS, install it with `sudo pacman -S --needed clang`.
