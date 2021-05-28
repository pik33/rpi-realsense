#!/usr/bin/bash
gcc -I/home/pi/librealsense/include -o testlib testlib.c library.o -lSDL2 -L/home/pi/librealsense/build -lrealsense2 -lm 
