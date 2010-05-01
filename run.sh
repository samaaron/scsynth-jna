#!/bin/sh

cp libscsynth_jna.so src/main/resources/supercollider/scsynth/linux/x86/
mvn exec:java -Dexec.mainClass="supercollider.ScSynth"
