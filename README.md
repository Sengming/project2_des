# project2_des
CPA Side Channel Analysis to break DES Encryption


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
DATA
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
The CSVs are extracted in the CSVs folders. Add the number of traces you want to read here.



@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
CODE - MATLAB
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

The code is stored in the following folders
1) dataproc - functions that convert CSVs to .mat files and extract the plaintext/cyphertext pairs into binary.
2) testing - The testing and debugging functions. The testing of DES implementations and other debugging code is here.
3) library - tools and functions used by other part of code is here.
4) keygues - contains the code that rerives the key from the power trace and plaintext/cyphertext pairs.



@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
RUNNING
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


run 'main.m'.





@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
OUTPUT
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


The results are stored in 'results' as .fig and .pdf files. The data is stored as .mat files in folder 'matfiles'


