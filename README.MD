# gmlibsmacker - a libsmacker extension for Game Maker
A somewhat crude usage of the *libsmacker* code to leverage the ability to play Smacker `.smk` files within GM. 
As the demo files indicate, the idea is for you to open a file, leverage the extension to load an audio buffer and blit a video frame onto a surface. Play sound, blit new frames at a pace determined by your programming skill and the given metadata info from the extension (ie intended framerate), and presto.

## Tested Videos
So far testing has been limited due to time constraints and code/repo cleanup/etc, but **SimTunes** and **Total Annihilation**'s .smk/.zrb videos have been confirmed to work in early builds.

## Demos
The *demo* folder includes a GMS 1.4.9999 gmx project and a modern GM (as of time of writing 2024.2) project. 
These feature the 32-bit and 64-bit versions of the DLL respectively.

## Why did you program the functions old-school? Why is there no .gmez/.yymps etc?
I **am** old-school. Pull requests (and links to apps to make new-school less tedious) welcome.