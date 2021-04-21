# AnalysisFunction

Analysis Function provides scripts to analyze electrophysiological data recorded with the HEKA system: the FALCON patch clamp system which combines the application of mechanical stimuli with self-sensing cantilever (Patch Clamp folder) and the two electrode voltage clamp system (TEVC folder). 

## TEVC data

Selectivity Study:

### DAY 0: harvest:
- harvest oocytes
- prepare injection mix and keep at -80C
	- my data are in folder /Users/Fechner/Box Sync/Fechner/TEVC-GoodmanlabBOX/Project-STFX/InjectionMixesSTFX
	- examples excel sheets for injections are in the ExampleExcelSheets folder
	- adjust comments to prepare for how many recordings and which conditions to do

### DAY 1: inject oocytes
- inject oocytes and keep at 18C in L-15 + 300 uM Amilroide

### DAY 4 to 7: recordings
- for selectivity measurements I always use the following sequences: 
	- monitor the cell with ContRamp1550 until it’s stable [Protocol Fig 1A](https://rupress.org/jgp/article/153/4/e202012655/211847/DEG-ENaC-ASIC-channels-vary-in-their-sensitivity).
	- use pgf 10ContStep, which is a combination of 10x ContRamp1550 and 3x STEPSens (Steps are similar to protocol Fig 1A, but have steps instead of ramps)
	- monitor the cell with ContRamp1550, switch solutions and monitor until it’s stable in new solutions
	- use pgf 10ContStep 
	- and the end: use ContRamp1550, switch back to NaGluSel solution, switch to 300 uM amiloride, and wash with NaGluSel solution (This last use of the protocol ContRamp1550 (or sometimes used at the beginning) with the switch to amiloride is used to measure the amplitude of the current at -85 mV and to determine the quality of the recording.  this step will be used to estemina)

### Analysis of Data with Matlab

#### Selectivity Data:

Enter Meta Data

- Amplitude analysis amiloride sensitive current: Enter ContRamp1550 of amiloride block data into excel spreadsheet (only works 1 file/series per cell). They are located in the Box Folder: /Users/Fechner/Box Sync/Fechner/TEVC-GoodmanlabBOX/Project-STFX/MetaDataSTFX/MetaDelta and are called TEVCMetaSTFX111.xlsx – replace STFX111 with the current frog number. Enter last series before switching to a new solutions (the matlab code will analyze this number and the previous 2 series for replicate of 3) 
- Enter the series numbers for the 3 STEPSens replicates in TEVCMetaSTFX112-Selectivity.xlsx (replace STFX112 with current frog number) Meta data sheet found here: /Users/Fechner/Box Sync/Fechner/TEVC-GoodmanlabBOX/Project-STFX/MetaDataSTFX
- example meta data for the analysis on frog STFX112 are found in the folder ExampleExcelSheets



Analysis of Selectivity Data:

Enter Meta Data
