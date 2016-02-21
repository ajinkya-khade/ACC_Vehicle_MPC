% Readme                                   
% This file contains brief instructions regarding how to use the code.                                    
%                                    
% Author : Ajinkya Khade, askhade@ncsu.edu                                   

About the Project - 
--------------------
This project was submitted as the course project for ECE 726 - Advanced Feedback Control  in Fall 2015 at NC State University, Raleigh, NC, USA.                                   
Course URL - http://engineeringonline.ncsu.edu/onlinecourses/coursehomepages/FALL-2015/ECE726.html

The formal report for this project has also been uploaded as 'ECE 726 - Project Report - Redacted'. Some sensitive personal information has been redacted.                                   
The project was primarily based on the work presented in -
L. Bageshwar, L. Garrard and R. Rajamani "Model predictive control of transitional maneuvers for adaptive cruise control vehicles", IEEE Trans. Veh. Technol., vol. 53, no. 5, pp.1573 -1585 2004                                   
Please check the report for other references.

This project designs an MPC controller for Transitional Maneeuvers of Adaptive Cruise Control Vehicles. It also simulates the performance  of the controller in various test cases, the details and results of which have been explained in the report.

Notation and Problem Formulation - 
----------------------------------
The problem formulation and notation used in the code (for various matrices) is consistent with that used in the project report. Please refer to the report for further details or clarification.

System Requirements - 
----------------------
You need to have the MATLAB Optimization Toolbox installed in order to run this program.

Input Parameters - 
--------------------
All the parameters to be tuned or varied are in the 'setup.m' file. This file also contains the initial conditions used for generating the plots presented in the ECE 726 Project Report. To reproduce the results of the report, uncomment the input paraameters specific to that case in the setup file.

Running the Code - 
-------------------
Run the file named 'wrapper.m'.

Description of Files - 
-----------------------
A brief description of the task completed by each file has been provided in the respective files.

Extra Files -
-------------- 
There are a few auxiliary files which haven't been activated by default in the main code, but might provide valuable insight in some cases. 
These are - 

plotCost.m      - This file plots the cost function output accros the entire simulation time.                                   
plotAbsolute.m  - This file plots the absolute position and velocity of ACC and target vehicle.  
                                   
To activate these, uncomment the corresponding line in the 'wrapper.m' file.
