#!/usr/bin/bash
gcc -I/home/pi/librealsense/include -o main main.c -lSDL2 -L/home/pi/librealsense/build -lrealsense2 -lm 
