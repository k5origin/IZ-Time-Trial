# IZ-Time-Trial

BASED ON Pringus Simple Race Script - https://forum.fivem.net/t/release-pringus-simple-race-script/96876

This is a resource script for the FiveM FXServer. This script lets you create a course for players to race against the clock.

The race courses can be customized by changing the array of checkpoints. So far, only a handful tracks are supported. Checkpoints can also be added or removed. 

My Contributions:
- Added the ability to abandon a race before finishing
- Changed the timer to display minutes and seconds
- Fixed a bug that caused certain sound effects to become louder with after each race
- Added the ability to have more than one course (Originally hardcoded to use an array of checkpoints that make one course)
- Now keeps the player's vehicle in place during the countdown, with the ability to rev their engine during the countdown for proper launches
- Created a workaround to fix a crash after finishing a race
- Added the ability to mark checkpoints as sections or laps:
	- Section checkpoints show the player the time it took to complete the section
	- Lap checkpoints show the player the time it took to complete the race so far while restarting the race and the timer without another countdown
- Added warp checkpoints that teleport a player to a different area of the map. 
- In an emergency situation, players can teleport back the last checkpoint they passed
- Added the option for server synchronization

Installation:
Place __resource.lua and client.lua into the resources/IZ-Time-Trial folder. 
add "start IZ-Time-Trial" to the server.cfg

When the track is ready, approach the marker in any vehicle and press UP to initiate a race. Note, if FXServer is already running, changes can be applied real time by restarting the resource.

