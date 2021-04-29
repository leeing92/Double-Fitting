# Double-Fitting
This is one method for analyzing Statistic Resolution. Related Concept can be seen at papar:
"Quantifying image resolution non-uniformity (IRNU) in super-resolution optical microscopy"
Version 0.0.1, Produced by M.T. Lee
## For simply using -- How to start
### matlab
There is matlab file started by <font color=#FF0000>  AMainStartHere.m </font> , recommend using matlab R2019 or above version to run the code. 
In <font color=#FF0000>  __AMainStartHere.m__ </font>   you should input:
1. path of the image that needs analysis;
2. pixel size (nm);
3. threshold for data clearing (value from 0 to 1, corresponding to fitgoodness)
4. threshold for skeleton thinning (there is recommend setting, however, the value depends)

If measure Statistic Resolution by calculating each structure
output:
1. Map2Static : Record all raw data
2. ResultforStarVeri: Record all stastic data 
[GdTruthFWHM;frame;MeanMap;StdMap;<font color=#FF0000> ZhixinMinMap</font>;ZhixinMaxMap;CalNum;<font color=#FF0000> Meanff</font>;<font color=#FF0000> Stdff</font>] among them ZhixinMinMap,Meanff,Stdff is mostly used     
3. FWHMapRendered: the final local image

If Measure Statistic Resolution by calculating structure by global method



## For advanced using or re-program -- How to use the code
