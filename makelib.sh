#!/usr/bin/bash
gcc -c -I/home/pi/librealsense/include -o library.o library.c  -L/home/pi/librealsense/build -lrealsense2 -lm 
