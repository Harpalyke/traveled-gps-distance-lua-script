# traveled-gps-distance-lua-script
A lua script that tracks the total GPS distance a model has traveled

# Installation
Place the script in the /scripts/tellemetry of the SD card and set up a telemetry screen of type script attaching the TRAV script to it. Long pressing the page button from the home screen will display the new screen.
Once the script is running it creates a new telemetry sensor "TRAV" which is used to track the total distance traveled and can then be used for audio call outs etc..

# Notes
- No reset functionality for the distance has been implemented as yet. May need to reboot the transmitter to reset.
- This script only works with the GPS location sent via crossfire at the moment, FrSky sends the location in a different sensor format.

