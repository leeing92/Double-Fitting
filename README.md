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
* __Function Structure__  <br/>
The code is build by following structure (list not include original matlab function):  
1. AMainStartHere: Main for simple using <br/>
&emsp;&emsp;	DoubelFitting: (Main Algorithm) <br/>
&emsp;&emsp;	DenoiseFunc: Denoise the image  <br/>
&emsp;&emsp;	Normalized: Normalize image Intensity <br/>
&emsp;&emsp;	Grad202012: Get the gradient  <br/>
&emsp;&emsp;	skeleton: Extract skeleton of structure  <br/>
&emsp;&emsp;	FWHM202012: First fitting of every location  <br/>
&emsp;&emsp;	FromList2Image: Rebuild the image  <br/>
&emsp;&emsp;	StaRegin1: Calculate the confidence interval  <br/>
&emsp;&emsp;	RawResultMerge: Showing the Local Resolution for visualization  

2. SubGlobalWithout: Analyze average resolution of sub region (optional)  <br/>
&emsp;&emsp;	DenoiseFunc: Denoise the image  <br/>
&emsp;&emsp;	LM_Wo: Least Square method not considering influence of structure width  <br/>
&emsp;&emsp;	LS_Wo: Fitting model  <br/>
&emsp;&emsp;	df_LS_Wo: Gradient based on fitting model  

3. Others:  <br/>
&emsp;	ShowFitProcess: Visualizing calculation on each structer. Noting if you want to show the process, choose a small image with relatively less structure for time costing of screen refreshes.  <br/>
&emsp;&emsp;	MiPicLine  <br/>
&emsp;&emsp;	MixShow  <br/>
&emsp;&emsp;	freezeColors  <br/>
&emsp;	 TwoStructFit202012: Calculating FWHM and distance changes when two structers adjacent  <br/>
&emsp;&emsp;	createFit
&nbsp;

* __Parameter Description__  <br/>
&emsp;	For user's, normally, parameters __ZhixinMinMap__,  __Meanff__, __Stdff__ are enough. But for further research, we provide redundant output parameters. All paramters meaning states here:  <br/>
&emsp;&emsp;		GdTruthFWHM:	Ground Truth of FWHM when needs verification (not necessary). If you want to record it, then input the value. For convinient and compatible, we transfer it out. At __AMainStartHere.m__, we set it to 0.   <br/>
&emsp;&emsp;		frame:			frame of your calculate image when needs verification (not necessary). If you want to record it, then input the value. For convinient and compatible, we transfer it out. At __AMainStartHere.m__, we set it to 0.   <br/>
&emsp;&emsp;		MeanMap:		The sample mean. This is directly calulated from sample not from the distribution.   <br/>
&emsp;&emsp;		StdMap:			The sample variance. This is directly calulated from sample not from the distribution.  <br/>
&emsp;&emsp;		ZhixinMinMap:	R-mini, default is 2 times of Stdff. <br/>
&emsp;&emsp;		ZhixinMaxMap:	The maximal resolution under confidence interval. <br/>
&emsp;&emsp;		CalNum:			All calculated value numbers after clearing. <br/>
&emsp;&emsp;		Meanff:			R-mean. This is distribution mean. <br/>
&emsp;&emsp;		Stdff:			The variance of distribution. <br/>
