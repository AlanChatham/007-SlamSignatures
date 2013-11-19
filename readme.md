007-Slam Signatures

Brooke Matson, Alan Chatham, Robert Emanuele, and Sonja Mongar

This piece uses a laser mounted to a fan motor, so it draws little circles with the laser. This is then reflected off a mirror attached to a spring attached to a speaker, then slam poetry is played over the speaker.

There are two parts to this - VideoLayer is a Processing sketch that takes in a video, and outputs a big TIFF image of the frames layered on each other. To use that, take a video of the laser against a wall with whatever sound you'd like, then feed that video into the VideoLayer sketch, and it will give you an image similar to the ones in this folder.

SlamSignatures is a live version, where you point a webcam at the area that the laser is reflecting onto, then it layers the frames of the live video in realtime. We're using a cheap logitech webcam - model C270 - it's pretty great, but it's really important to install the Logitech drivers and run it on a PC to get the full 30fps framerate. Also, the tools to adjust the zoom and position and color settings of the webcam in software are super helpful, so I might recommend you use the same.

For our installation, we made some prints of the poems from VideoLayer, then live-projected SlamSignatures across 3 walls of a room.