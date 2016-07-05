# Spout_to_RasbPi_to_LED
A series of processing sketches that allow you to stream video your PC to a Raspberry Pi and display the video on LED's connected to your Raspberry Pi

![alt tag](http://imgur.com/tQobUVb)

<iframe src="https://player.vimeo.com/video/173333338" width="640" height="360" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
<p><a href="https://vimeo.com/173333338">TORUS | Visual Music Installation</a> from <a href="https://vimeo.com/ridwann">Ridwan Nasruddin</a> on <a href="https://vimeo.com">Vimeo</a>.</p>

# Spout Reciever Fade Candy
- Mostly for testing directly from PC to FadeCandy
Recieves images from any Spout-able application, samples pixels from it and sends those to a FadeCandy

#Spout Reciever OSC
- Running on PC connected to Rasp with ethernet
Recieves images from any Spout-able application and sends them over OSC to any client which will then hopefully have some LEDs and a FadeCandy to display these images.
By pressing the right mouse button you can specify which Spout source to use. This source has to be created first, this seems to be a Spout issue.
Using the positions.txt file you can specify the points it has to analyse. These have to range from 0.0 to 1.0 and seperated with a ','. These number specify the relative position of the points based on the size of the current window.
You can adjust the size of the analysis by clicking and dragging the mouse. To move the analysis use the arrow buttons. Use m to mirror the whole analysis and press r to reset the positions.

#OSC Reciever FadeCandy
- Auto runs on Raspberry Pi connected to FadeCandy
Recieves OSC messages from "Spout Reciever OSC" application and transforms them into FadeCandy language
