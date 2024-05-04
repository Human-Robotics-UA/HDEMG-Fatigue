# HD-EMG Fatigue proportional estimation
This repository stores all the code implemented for my master's thesis in Artificial Intelligence, including the HD-EMG Fatigue experimental setup, preprocessing and proportional estimation via various AI models.

## 📥Download data
In order to work with the original HD-EMG data obtained and preprocessed, this Google Drive folder must be cloned: 
https://drive.google.com/drive/folders/1kRsAC32kRw5VUpvQzqezt9Unv489gPIW?usp=sharing

## 📈Preprocess data

The data preprocessing phase, stored in the `Preprocessing` folder, is mainly divided in two steps: **experiment division** of the original recorded data in order to obtain the 4 runs segmented, and MAV, RMS and MNF **feature extraction** of these signals.

###  Experiment Division
In this step, each user HD-EMG and Force data is separated accordingly to the four trials/runs made.

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

### Feature extraction

In this step, for each of the HD-EMG experimental runs, three features are extracted: Mean Absolute Value (MAV), Root Mean Square (RMS), and Mean Frequency (MNF). These features provide insights into the muscle activity and can be used for further analysis and modeling.

The tasks performed for feature extraction are described below:

- **MAV Computation**: Mean Absolute Value (MAV) is obtained for each channel of the HD-EMG signal. First, the signal is rectified by taking the absolute value, then a linear envelope is computed using moving average filter smoothing.

- **MNF Computation**: Mean Frequency (MNF) is computed for each channel of the HD-EMG signal using the Power Spectral Density (PSD) obtained from the periodogram. The signal is divided into windows, and for each window, the PSD is computed and used to calculate the MNF. 

- **RMS Computation**: Root Mean Square (RMS) is computed for each channel of the rectified HD-EMG signal. The signal is divided into windows, and for each window, the RMS is computed. 

These feature extraction processes are repeated for each experimental run of each user, resulting in its corresponding CSV files that contain feature matrices of MAV, RMS, and MNF values.

## 🛠️Models

## 📏Results

