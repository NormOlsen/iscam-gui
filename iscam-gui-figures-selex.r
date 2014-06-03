#**********************************************************************************
# ss-explore-figures-selex.r
# This file contains the code for plotting selectivity values SS outputs using the
# infrastructure provided with ss-explore.
#
# Author            : Chris Grandin
# Development Date  : October 2013
# Current version   : 1.0
#**********************************************************************************

plotSelex <- function(plotNum    = 1,         # Plot code number
                   png        = .PNG,      # TRUE/FALSE for PNG image output
                   fileText   = "Default", # Name of the file if png==TRUE
                   plotMCMC   = FALSE,     # TRUE/FALSE to plot MCMC output
                   ci         = NULL,      # confidence interval in % (0-100)
                   multiple   = FALSE,     # TRUE/FALSE to plot sensitivity cases
                   sensGroup  = 1,         # Sensitivity group to plot if multiple==TRUE
                   index      = 1         # Gear index to plot 
                   ){

  # plotNum must be one of:
  #1 logistic selectivity - age or length based will be detected automatically
 	## 1  Length-based selectivity in end year by fleet
  	## 2  Age-based selectivity in end year by fleet
  # 3  Selectivity at length time-varying surface
  # 4  Selectivity at length time-varying contour
  # 5  Retention at length time-varying surface
  # 6  Retention at length time-varying surface
  # 7  Discard mortality time-varying surface
  # 8  Discard mortality time-varying contour
  # 9  Selectivity, retention, and discard mortality at length in ending year
  # 10 NOT USED
  # 11 Selectivity at age time-varying surface
  # 12 Selectivity at age time-varying contour
  # 13 Selectivity at age in ending year if time-varying
  # 14 Selectivity at age in ending year if NOT time-varying
  # 15 NOT USED
  # 16 NOT USED
  # 17 NOT USED
  # 18 NOT USED
  # 19 NOT USED
  # 20 NOT USED
  # 21 Selectivity at age and length contour with overlaid growth curve
  # 22 Selectivity with uncertainty if requested at end of control file

  if(plotNum < 1   ||
     plotNum > 22  ||
     plotNum == 10 ||
     plotNum == 15 ||
     plotNum == 16 ||
     plotNum == 17 ||
     plotNum == 18 ||
     plotNum == 19 ||
     plotNum == 20
     ){
    return(FALSE)
  }
  val      <- getWinVal()
  scenario <- val$entryScenario
  currFuncName <- getCurrFunc()
  isMCMC   <- op[[scenario]]$inputs$log$isMCMC
  figDir   <- op[[scenario]]$names$figDir
  out      <- op[[scenario]]$outputs$mpd
  res          <- val$entryResolution
  width        <- val$entryWidth
  height       <- val$entryHeight
  resScreen    <- val$entryResolutionScreen
  widthScreen  <- val$entryWidthScreen
  heightScreen <- val$entryHeightScreen

  filenameRaw  <- paste0(op[[scenario]]$names$scenario,"_",fileText,".png")
  filename     <- file.path(figDir,filenameRaw)
  if(png){
    graphics.off()
    png(filename,res=res,width=width,height=height,units=units)
  }else{
    windows(width=widthScreen,height=heightScreen)
  }
  if(isMCMC){
   # plot mcmc model runs
  }else{
    # plot mpd model runs
  }

  if(plotNum==1)  plotLogisticSel(scenario, index)
  if(plotNum>=2)  cat("No Plot Yet -- Coming Soon!!\n")


  #SSplotSelex(out,
 #             plot     = TRUE,
#              print    = FALSE,
#              subplot  = plotNum,
#              pheight  = height,
#              pwidth   = width,
 #             punits   = units,
#              res      = res,
#              verbose  =!silent)
  if(png){
    cat(.PROJECT_NAME,"->",currFuncName,"Wrote figure to disk: ",filename,"\n\n",sep="")
    dev.off()
  }
  return(TRUE)
}

 #Currently only implemented for seltypes 1,6 and 11 (estimated logistic age-based, fixed logistic age-based, or estimated logistic length-based)
 plotLogisticSel	<-	function(scenario, index){
 	aflag <- 0 #flag to set age or length
 	ngear <-  op[[scenario]]$inputs$data$ngear
	if(index <= ngear)
	{
	
		selType <-   op[[scenario]]$inputs$control$sel[1,index]
		if(selType==1 || selType ==6)  {aflag <-1} 
		else if(selType==11) {aflag <- 2 }

		Age <- op[[scenario]]$output$mpd$age
		Len <- op[[scenario]]$output$mpd$la

		if(aflag > 0){
			logselData <-  op[[scenario]]$output$mpd$log_sel
			logselData <- logselData[which(logselData[,1]==index),4:ncol(logselData)]
			
			selData <- exp(logselData)
			selData <- selData[nrow(selData),]
			
                     	if(aflag==2) Xlab="Length-at-Age"
			if(aflag==1) Xlab="Age"
                       
		       if(aflag==1) plot(Age, selData, type="l", xlab=Xlab, ylab="Proportion", lwd=2, col="blue", las=1, main=paste("Gear",index))	     #, ylim=c(0,1)
	               if(aflag==2) plot(Len, selData, type="l", xlab=Xlab, ylab="Proportion", lwd=2, col="blue", las=1, main=paste("Gear",index))

			 }else cat("Plot not currently implemented for the type of selectivity used for this gear\n") 
   	     }else cat(paste("WARNING: Gear index exceeds the number of gears. Choose gear between 1 and", ngear,"\n"))
   	}
