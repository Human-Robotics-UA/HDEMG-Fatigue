# HD-EMG proportional muscular fatigue  estimation
This repository stores all the code implemented for my master's thesis in Artificial Intelligence, including the HD-EMG Fatigue experimental setup, preprocessing and proportional estimation via various AI models.

## 📥Data acquisition

In order to put into action the experiment protocol, the following files were developed:

- `Manual_Trigger.ino`: This file contains Arduino code that initializes a trigger pin and listens for a command from a serial connection. When the command is received, it activates the trigger pin, sending a signal to an external device. This code includes a timer to ensure the trigger signal is sent at a specified interval.

- `main_own_v4_force_and_trigger.py`: It establishes a serial connection with the  OptoForce USB Sensor, continousy reading force data. This force data is stored in the `data1.csv` file. Additionally, the script monitors trigger events by detecting changes in the length of a text file (`data2.txt`) and logs these events alongside the force data. 

- `show_Force.py`: It is used for creating a dynamic plot that updates in real-time as new force data is recorded in the `data1.csv` file. The plot displays the total force values over time, along with a reference line representing the maximum force recorded during the experiment. Additionally, it includes a dashed line indicating 40% of the MVC, providing a visual reference for force thresholds. 

- `show_Trigger.py`: Similar to the previous file, it creates an animated plot that updates dynamically as trigger events are logged in the `data1.csv` file. The plot displays the trigger events over time, represented by red dots, and each dot means that a trigger event was detected during the experiment. 

It is worth noting that the HD-EMG data recording is made in the **OTBiolab+** software, where the trigger received from the Arduino board is configured as the *Aux Acceleration* channel.

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

These feature extraction processes are repeated for each experimental run of each user, resulting in its corresponding `.csv` files that contain feature matrices of MAV, RMS, and MNF values.

## 🛠️Models

This folder stores all the *Google Colab* notebooks built in `.ipynb` format, each of these corresponding to a different model implementation. The models developed are the following:

- **Linear Regression (LR)**: The model training works in the standard CPU, except the k-fold cross validation with all the subjects that works with the NVIDIA A100 GPU, as it provides 40 GB of RAM to store all the HD-EMG data from accross all the subjects.

- **Feed-forward Neural Network (FFNN)**: The model training works in Tesla T4 GPU provided by *Google Colab*, except the k-fold cross validation with all the subjects, because all the input, output data and model architecture overflows all the RAM memory available.

- **CNN + LSTM + Transformer Encoder (CLT)**: This model is inspired on the paper '[Dynamic Muscle Fatigue State Recognition Based on Deep Learning Fusion Model](https://ieeexplore.ieee.org/abstract/document/10233862)', but only the LSTM module was finally used. The model training works in Tesla T4 GPU provided by *Google Colab*, except the k-fold cross validation with all the subjects that works with the NVIDIA A100 GPU.

For all of these model, input and output data combinations, the following experiments are developed and carried out:

- **Using a single experiment run**: In the case of LR, the split of train and test datasets follows an 80-20 ratio, while in FFNN and CLT follows a 70-15-15 ratio due to the need of a validation dataset for the early stopping technique.

- **Training with experiment runs 2-3 and testing with experiment run 4**: In the case of FFNN and CLT, the train dataset consisting of the experiment runs 2 and 3 is also subdivided in training dataset and validation dataset following an 80-20 ratio.

- **K-fold Cross Validation intra-subject**:
  - **Two experiment runs as training data and the remaining experiment run as testing data**: In the case of FFNN and CLT, the train dataset consisting of two experiment runs is also subdivided in training dataset and validation dataset following an 80-20 ratio.

  - **All the experiment runs combined**: In the case of FFNN and CLT, the train dataset consisting of two folds is also subdivided in training dataset and validation dataset following an 80-20 ratio.

