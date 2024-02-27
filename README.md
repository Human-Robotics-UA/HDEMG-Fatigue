# HD-EMG Fatigue estimation
This repository stores all the code implemented for the HD-EMG Fatigue experimental setup and estimation.

## Experiment Division
All the MATLAB code uploaded corresponds to the experiment division task, where each user HD-EMG and Force data is separated accordingly to the four trials/runs made.

The tasks performed by each file are described below:

- `ReadEMGData.m`: Reads all the experiment recordings for the user specificed, grouping them by concatenation and plotting them if it's specified.
  - **Input parameters**: User identification code (e.g. `'H0XXB0101'`), doPlot flag (*True* if plotting desired, *False* otherwise), experiments extensions (e.g. `'_1.mat'`). The number of possible experiments is 1, 2 or 3, in order to group all different user recordings.
  - **Output parameters**: HD-EMG, Trigger and Time combined data for all the user experiments. 
    
- `ReadForceData.m`: Reads the Force sensor recording for the user specified, transforming the timestamps to seconds using the sampling frequency in order to get the same scale as the HD-EMG Time data.
  - **Input parameters**: User identification code (e.g. `'H0XXB0101'`).
  - **Output parameters**: Force, Trigger and Time values converted to seconds for the corresponding user. 
    
- `divideExperiments.m`: Segments the experiments based on triggers obtained from both EMG and Force data, removing the ascending and descending Force slopes until reaching 40% of MVC Force, and dividing the corresponding HD-EMG data accordingly.
  - **Input parameters**: HD-EMG and its corresponding Trigger and Time data, as well as the Force and its corresponding Trigger and Time data.
  - **Output parameters**: MATLAB cell arrays containing the divided HD-EMG and Force runs, along with their respective Time data after cutting.
    
- `main_experiment_division.m`: reads HD-EMG and Force data for a specific user and divides the data into separate experimental runs using the auxiliary functions defined in the previous files, plots the results and lastly saves the experimental runs in `.mat` and `.csv` files.
