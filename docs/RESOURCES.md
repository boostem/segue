# References

## Audio callbacks (M1)
- [miniaudio manual](https://miniaud.io/docs/manual/index.html): §1
  "Introduction" and §1.1 "Low Level API". The same text is at the top of
  `third_party/miniaudio/miniaudio.h`.
- Ross Bencina,
  ["Real-time audio programming 101: time waits for nothing"](http://www.rossbencina.com/code/real-time-audio-programming-101-time-waits-for-nothing)
- [C11 atomics (cppreference)](https://en.cppreference.com/w/c/atomic)

## WAV format (M2)
- Craig Sapp,
  ["WAVE PCM soundfile format"](https://web.archive.org/web/2024/http://soundfile.sapp.org/doc/WaveFormat/)
  (archived copy)
- Peter Kabal,
  ["Audio File Format Specifications: WAVE"](https://www.mmsp.ece.mcgill.ca/Documents/AudioFormats/WAVE/WAVE.html)
- Microsoft,
  [WAVEFORMATEXTENSIBLE](https://learn.microsoft.com/en-us/windows/win32/api/mmreg/ns-mmreg-waveformatextensible)

## Musical time (M3)
- David Goldberg,
  ["What Every Computer Scientist Should Know About Floating-Point Arithmetic"](https://docs.oracle.com/cd/E19957-01/806-3568/ncg_goldberg.html)
- Standard MIDI File specification: the Set Tempo meta event (FF 51 03)

## Mixing (M4)
- Julius O. Smith III, [online books (CCRMA)](https://ccrma.stanford.edu/~jos/)
- [musicdsp.org](https://www.musicdsp.org/): see the entries on denormals and
  parameter smoothing

## Adaptive music (M5)
- [FMOD Studio documentation](https://www.fmod.com/docs): transitions,
  quantization, parameters
- Audiokinetic Wwise documentation: Interactive Music
- Winifred Phillips, *A Composer's Guide to Game Music* (MIT Press, 2014)
- [OAML](https://github.com/oamldev/oaml)

## Concurrency (M6)
- Jeff Preshing,
  ["An Introduction to Lock-Free Programming"](https://preshing.com/20120612/an-introduction-to-lock-free-programming/)
- Jeff Preshing,
  ["Acquire and Release Semantics"](https://preshing.com/20120913/acquire-and-release-semantics/)
- Timur Doumler, "Using Locks in Real-Time Audio Processing, Safely"
  (ADC 2020)
- [ThreadSanitizer](https://clang.llvm.org/docs/ThreadSanitizer.html)

## Parsing (M7)
- Robert Nystrom, *Crafting Interpreters*:
  [Scanning](https://craftinginterpreters.com/scanning.html) and
  [Parsing Expressions](https://craftinginterpreters.com/parsing-expressions.html)
- [libFuzzer](https://llvm.org/docs/LibFuzzer.html)

## Packaging (M8)
- Arch Wiki: [PKGBUILD](https://wiki.archlinux.org/title/PKGBUILD),
  [Creating packages](https://wiki.archlinux.org/title/Creating_packages),
  [AUR submission guidelines](https://wiki.archlinux.org/title/AUR_submission_guidelines)
- [raylib cheatsheet](https://www.raylib.com/cheatsheet/cheatsheet.html)

## Testing
- Will Wilson, "Testing Distributed Systems w/ Deterministic Simulation"
  (Strange Loop 2014)
- [TigerBeetle VOPR](https://github.com/tigerbeetle/tigerbeetle/blob/main/docs/internals/vopr.md)

## Stretch goals
- W. Verhelst and M. Roelands, "An overlap-add technique based on waveform
  similarity (WSOLA) for high quality time-scale modification of speech"
  (ICASSP 1993)
- [Signalsmith Stretch](https://github.com/Signalsmith-Audio/signalsmith-stretch)
- Olli Niemitalo,
  ["Polynomial Interpolators for High-Quality Resampling of Oversampled Audio"](http://yehar.com/blog/wp-content/uploads/2009/08/deip.pdf)
