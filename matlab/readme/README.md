# ECE-6254
UAV Tracking Application
Version 1.0

--------------------------------------------------------------------------------------
- Overview
--------------------------------------------------------------------------------------
ECE 6254: Statistical Machine Learning

Project Members
Benjamin Sullins - bensullins1@gmail.com
  GTID: 903232988


Graduate Distance Learning Students
School of Electrical and Computer Engineering 
Georgia Instiute of Technology 
--------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------
- This README section walks the user through the execution of the program.
--------------------------------------------------------------------------------------
- Code Exection:
--------------------------------------------------------------------------------------
  1) Open Matlab (Development - Matlab 2010a)
  2) Change directory "cd" to the .\FinalProject\matlab\gui folder location.
  3) Open UavTracking.m
  4) Run UavTracking.m
  5) A GUI will open. A corresponding README button is available for further
      instructions.
      
  [GUI README Instructions]
  6)  Select a background image from the Benchmark Radio buttons
      a) This button loads the background image into the local directory.
      b) The "Browse Images" button allows for custom backgrounds.
      c) The "Synthetic" check box generates PSD equivalents for selected
         images.

  7) Select a target image from the Target Type Radio buttons
      a) This button loads a target image into the local directory.

  8) Select a motion type from the Target Motion Class Radio buttons.
  
  9) Modify the Target Motion Parameters as needed.
  
  10) Press the "Generate Scene" button.
      a) This button generates the image decks for the tracking simulator.
      b) Example output images are presented to the user once pressed.
  
  11) Select between the "Standard" or "Extended" kalman filter types
      through the Kalman Filter Radio buttons.
  
  12) Press the "Start Tracking" button to begin the simulation.
  
  13) Press the "Stop Tracking" button to end the simulation.

