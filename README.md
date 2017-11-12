# traveled-gps-distance-lua-script
A lua script that tracks the total GPS distance a model has traveled. Distance traveled can be viewed in a telemetry sensor named "TRAV" or from the telemetry screen installed as part of this lua script.

# Installation
- If your arm siwtch is not on channel #5 (aux channel #1) you will need to modify the configuration values at the top of the script so that the channel matches up. (The reason for this is that the behaviour of the script is that arm switch resets the total distance every time the model is armed)
- Place the script in the /scripts/telemetry of the SD card and set up a telemetry screen of type script attaching the TRAV script to it. Long pressing the page button from the home screen will display the new screen.
- Once the script is running it creates a new telemetry sensor "TRAV" which is used to track the total distance traveled and can then be used for audio call outs etc..

# Notes
- No reset functionality for the distance has been implemented as yet. May need to reboot the transmitter to reset.
- This script only works with the GPS location sent via crossfire at the moment, FrSky sends the location in a different sensor format.

