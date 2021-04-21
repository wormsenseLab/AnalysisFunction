# AnalysisFunction

Analysis Function provides scripts to analyze electrophysiological data recorded with the HEKA system: the FALCON patch clamp system which combines the application of mechanical stimuli with self-sensing cantilever (Patch Clamp folder) and the two electrode voltage clamp system (TEVC folder). 

## TEVC data

Selectivity Study:

DAY 0: harvest:
-	harvest oocytes
-	prepare injection mix and keep at -80C
	my data are in folder /Users/Fechner/Box Sync/Fechner/TEVC-GoodmanlabBOX/Project-STFX/InjectionMixesSTFX
	examples excel sheets in github Folder
	adjust comments to prepare for how many recordings and which conditions to do

DAY 1: inject oocytes
-	inject oocytes and keep at 18C in L-15 + 300 uM Amilroide

DAY 4 to 7: recordings
-	for selectivity measurements I always use the following sequencs
-	monitor the cell with ContRamp1550 until it’s stable
-	use pgf 10ContStep, which is a combination of 10x ContRamp1550 and 3x STEPSens
-	monitor the cell with ContRamp1550, switch solutions and monitor until it’s stable in new solutions
-	use pgf 10ContStep 
-	and the end: use ContRamp1550, switch back to NaGluSel solution, switch to 300 uM amiloride, and wash with NaGluSel solution

The last use of the protocol ContRamp1550 (or sometimes used at the beginning) with the switch to amiloride is used to measure the amplitude of the current at -85 mV and to determine the quality of the recording.  

Analysis of Selectivity Data:

Enter Meta Data
