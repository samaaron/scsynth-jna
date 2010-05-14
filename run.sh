#!/bin/sh

mvn compile
mvn package
mvn exec:java -Dexec.mainClass="supercollider.ScSynth"
