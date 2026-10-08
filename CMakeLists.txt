cmake_minimum_required(VERSION 3.20)
project(segue VERSION 0.0.1 LANGUAGES C)

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type" FORCE)
endif()

#############################################
# Flags for our own code (never third_party/)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  set(SEGUE_SANITIZE_DEFAULT ON)
else()
  set(SEGUE_SANITIZE_DEFAULT OFF)
endif()
option(SEGUE_SANITIZE "Build with AddressSanitizer + UndefinedBehaviorSanitizer" ${SEGUE_SANITIZE_DEFAULT})

add_library(segue_flags INTERFACE)
target_compile_options(segue_flags INTERFACE -Wall -Wextra -Wpedantic -Wshadow)
if(SEGUE_SANITIZE)
  target_compile_options(segue_flags INTERFACE -fsanitize=address,undefined -fno-omit-frame-pointer)
  target_link_options(segue_flags INTERFACE -fsanitize=address,undefined)
endif()

#############################################
# miniaudio: audio device I/O only

find_package(Threads REQUIRED)

add_library(miniaudio STATIC third_party/miniaudio/miniaudio.c)
target_include_directories(miniaudio SYSTEM PUBLIC third_party/miniaudio)
target_link_libraries(miniaudio PUBLIC Threads::Threads)
if(APPLE)
  target_link_libraries(miniaudio PUBLIC
    "-framework CoreFoundation" "-framework CoreAudio" "-framework AudioToolbox")
elseif(UNIX)
  target_link_libraries(miniaudio PUBLIC m ${CMAKE_DL_LIBS})
endif()

#############################################
# segue: the library

add_library(segue STATIC src/segue.c)
target_include_directories(segue PUBLIC include)
target_link_libraries(segue PRIVATE segue_flags)

#############################################
# Tools

add_executable(segue_play tools/segue_play.c)
target_link_libraries(segue_play PRIVATE segue miniaudio segue_flags)

#############################################
# Tests: offline only, no audio device

enable_testing()

add_executable(segue_tests tests/test_main.c)
target_link_libraries(segue_tests PRIVATE segue segue_flags)
add_test(NAME segue_tests COMMAND segue_tests)

#############################################
# Install: ./build.sh install

include(GNUInstallDirs)
install(TARGETS segue ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
install(TARGETS segue_play RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
