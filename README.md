# Double-Fitting
This is one method for analyzing Statistic Resolution in fluorescent microscopy. Related Concept can be seen at papar:
"Quantifying image resolution non-uniformity (IRNU) in super-resolution optical microscopy"
Version 0.0.1, Produced by M.T. Lee on 2020.12
## matlab code
### For simple using -- How to start
There is matlab file started by __AMainStartHere.m__. Recommend using matlab R2019 or above version to run the code. 
In  __AMainStartHere.m__   
* __input__:
1. path of the image that needs analysis
2. pixel size (nm)
3. threshold for data clearing (value from 0 to 1, corresponding to fitgoodness)
4. threshold for skeleton thinning (there is recommend setting, however, the value depends)

* __output__:
If measure Statistic Resolution by calculating each structure, you can get output:
1. Map2Static : Record all raw data
2. ResultforStarVeri: Record all stastic data 
[GdTruthFWHM, frame, MeanMap, StdMap, __ZhixinMinMap__, ZhixinMaxMap, CalNum, __Meanff__, __Stdff__] 
among them __ZhixinMinMap__, __Meanff__, __Stdff__ is mostly used corresponding to __R-mini__, __R-mean__  and the variation of distribution  
Generaly, these 3 parameters are enough. if you want to know the rest parameter that help recording the statistic value, see "For advanced using or re-program" below.    
3. FWHMapRendered: the final local image

If you want to calculate Statistic Resolution by faster method, block the image, and each region's R-mean can be get through AMainStartHere.m either (output):
1. GlobalFWHM : Record all raw data
2. GlobalR: Record the structure width, but this version emit this calculation
3. result: Record fitting result, not used for common user

### For advanced using or re-program -- How to use the code
* __Function Structure__
The code is build by following structure (list not include original matlab function):
AMainStartHere: Main for simple using
	DoubelFitting: (Main Algorithm)
		DenoiseFunc: Denoise the image
		Normalized: Normalize image Intensity
		Grad202012: Get the gradient
		skeleton: Extract skeleton of structure
		FWHM202012: First fitting of every location
		FromList2Image: Rebuild the image
		StaRegin1: Calculate the confidence interval
		RawResultMerge: Showing the Local Resolution for visualization

	SubGlobalWithout: Analyze average resolution of sub region (optional)
		DenoiseFunc: Denoise the image
		LM_Wo: Least Square method not considering influence of structure width 
		LS_Wo: Fitting model
		df_LS_Wo: Gradient based on fitting model

	Others:
		ShowFitProcess: Visualizing calculation on each structer. Noting if you want to show the process, choose a small image with relatively less structure for time costing of screen refreshes.
			MiPicLine
			MixShow
			freezeColors
		TwoStructFit202012: Calculating FWHM and distance changes when two structers adjacent
			createFit

* __Parameter Description__
	For user's, normally, parameters __ZhixinMinMap__,  __Meanff__, __Stdff__ are enough. But for further research, we provide redundant output parameters. All paramters meaning states here:
		GdTruthFWHM:	Ground Truth of FWHM when needs verification (not necessary). If you want to record it, then input the value. For convinient and compatible, we transfer it out. At __AMainStartHere.m__, we set it to 0. 
		frame:			frame of your calculate image when needs verification (not necessary). If you want to record it, then input the value. For convinient and compatible, we transfer it out. At __AMainStartHere.m__, we set it to 0. 
		MeanMap:		The sample mean. This is directly calulated from sample not from the distribution. 
		StdMap:			The sample variance. This is directly calulated from sample not from the distribution. 
		ZhixinMinMap:	R-mini, default is 2 times of Stdff.
		ZhixinMaxMap:	The maximal resolution under confidence interval.
		CalNum:			All calculated value numbers after clearing.
		Meanff:			R-mean. This is distribution mean.
		Stdff:			The variance of distribution.
