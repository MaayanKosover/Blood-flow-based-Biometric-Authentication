# Blood-flow-based-Biometric-Authentication

# A Brief Summary
Run BioAuthenticationDatabase or BioAuthenticationVideos to start the program

```
by Ariel Dar and Maayan Kosover
```
- **Project Goal**

Collecting signals reflecting blood-flow at the fingertip using a cellular phone
camera and flash. The blood-flow signals will be used to establish a unique
personal blood-flow signature, that would then be used just a like a
fingerprint for biometric authentication.

- **Chosen Solution**

We used 2 types of databases: the first one is a database of 42 PPG signals, and the
second is from 7 videos of fingertips which we took using our phones. We will refer
to them as PPG database and video database.
The difference in the classification algorithm between the 2 types is only in the pre-
processing stage.

- **Pre Processing:**

For the PPG database, we extracted from each 8 minutes long signal 2
different 20 seconds long segments. Each segment went through a 3rd order
Butterworth band pass filter with cutoff frequencies of 0.5Hz-5Hz.

For the video database, we extracted from each video the red channel, and
calculated the mean for each frame. Those means represent the PPG signals.
Each signal went through a smoothing process.

From this point on, both databases went through the same process.

The derivatives of the PPG signals were calculated. The derivatives were
divided into segments of 1 cycle each, with the peak at the center.

- **Acquire DCT:**

From those 1 cycle long segments the auto-correlation of length M was calculated.
We used half of the auto-correlation coefficients. Then the DCT was Calculated, and
we used C DCT coefficients.


- **Acquire PCA:**

First we calculated the eigen vectors of the database, then we selected
numOfVectors amount of those vectors and multiplied them with the
database. That result was the PCA matrix.


- **Classification Using SVM:**

We chose 4 cycles for a training set, and 2 for a test set. Once we had a train set, we
could build an SVM model and train it. The SVM model is actually multiple SVM
models: for each subject, a model was trained against all other subjects.
We tested the models with the test set: for each subject we found the likelihood it
matches a certain label, and the maximum was selected.
The way to test our results was success rate in percentages.
We performed the SVM classification on 3 options: DCT coefficients, PCA coefficients
and a combination of DCT and PCA coefficients.

For our final run, we went through multiple hyper-parameters, and saved the results
in a table. The parameters are: the number of DCT coefficients selected, the number
of PCA coefficients selected, and for the PPG database the number of subjects
selected.


The Best results for the 3 options were for the combination of PCA and DCT
coefficients. The results varied between different selections of segments in the stage
where we chose cycles.


