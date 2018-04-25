# IZ-Time-Trials

BASED ON Pringus Simple Race Script - https://forum.fivem.net/t/release-pringus-simple-race-script/96876

This is a resource script for the FiveM FXServer.

The race courses can be customized by changing the array of checkpoints. So far, only two tracks are supported. Checkpoints can also be added or removed. 

My Contributions:
- Added the ability to abandon a race before finishing
- Changed the timer to display minutes and seconds
- Added the ability to have more than one course (Originally hardcoded to use an array of checkpoints that make one course)
- Now keeps the player's vehicle in place during the countdown
- Created a workaround to fix a crash after finishing a race

This script lets you create a course for players to race against the clock.

Installation:
Place __resource.lua and client.lua into the resources/IZ-Time-Trial folder. 
add "start IZ-Time-Trial" to the server.cfg

When the track is ready, restart the resource approach the marker in any vehicle and press UP to initiate a race.

