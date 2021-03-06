plotAttenuation <- function(atten, rangeX=NULL, rangeY=NULL, bootstrapK=NULL,regionsVector=NULL,mc_samples=NULL){
  
  
  minSD  <- 10^atten$minSD
  maxSD  <- 10^atten$maxSD
  
  minPPV <- atten$Intercept*minSD^(atten$slope)
  maxPPV <- atten$Intercept*maxSD^(atten$slope)
  
  minPPV95 <- atten$Intercept95*minSD^(atten$slope)
  maxPPV95 <- atten$Intercept95*maxSD^(atten$slope)
  
  if (!is.null(bootstrapK)){
    minPPVboot <- bootstrapK*minSD^(atten$slope)
    maxPPVboot <- bootstrapK*maxSD^(atten$slope)
  }
  
  dev.new()
  layout(matrix(c(1,2)), heights=c(11,1))  # put legend on bottom 1/8th of the chart
  plot(x    = atten$SD, 
       y    = atten$PPV, 
       xlab = "SD", 
       ylab = "PPV", 
       main = "Attenuation", 
       pch  = 16, log="yx", 
        xlim = rangeX, 
       ylim = rangeY
  )
  # TODO the calculation of the 95% needs to be fixed
  if (!is.null(mc_samples)){
    mean_mcmc = mean(mc_samples[,1])
    # se_mcmc = sd(mc_samples[,1])/sqrt(length(mc_samples[,1]))
    se_mcmc = sum((mc_samples[,1]-mean(mc_samples[,1]))^2/length(mc_samples[,1]))
    #se_mcmc = sigma(mc_samples[,1])
    
    Intercept95_mcmc = 10^(se_mcmc*1.645+mean(mc_samples[,1]))
    minPPV95_mcmc <- Intercept95_mcmc*minSD^(atten$slope)
    maxPPV95mcmc <- Intercept95_mcmc*maxSD^(atten$slope)
    
    print(Intercept95_mcmc)
    print(mean_mcmc)
    
    for (i in 1:95){
      #curve(10^(mc_samples[i,1]+mc_samples[i,2])*x,add=T,col="Grey")
      abline(mc_samples[i,1],mc_samples[i,2],col="Grey")
    }
    lines(x=c(minSD,maxSD), y=c(minPPV95_mcmc,maxPPV95mcmc), col="Orange", lwd=2)
    
  }
  points(x    = atten$SD, 
         y    = atten$PPV,col="Blue",pch=16)
  
  # Put axis lines along x and y coordinates
  abline(h   = c( seq( 1, 9, 1 ), seq( 10, 90, 10 ), seq( 100, 1000, 100 ) ),lty = 3,col = colors()[ 440 ] )
  abline(v   = c( seq( 1, 9, 1 ), seq( 10, 90, 10 ), seq( 100, 1000, 100 ) ),lty = 3,col = colors()[ 440 ] )
  #mtext(paste("Control point interpolation ")) #paste("Multilevel B-Spline smoothing method with h value of ", h.value)
  
  lines(x=c(minSD,maxSD), y=c(minPPV,maxPPV), lty=2, lwd=2)
  lines(x=c(minSD,maxSD), y=c(minPPV95,maxPPV95), col="Red", lwd=2)

  if (!is.null(bootstrapK)){
    lines(x=c(minSD,maxSD), y=c(minPPVboot,maxPPVboot), col="blue", lwd=2)
    
  }
  
  if (!is.null(regionsVector)){
    abline(v=regionsVector, lty=1)
    
  }
  legend("topright", bty="n", legend=paste(expression("R^2:"),  format(summary(atten$bestFitLine)$adj.r.squared, digits=2), "\n",
                                           "K (95%):",format(atten$Intercept95, digits=5),"\n",
                                           "K (50%):",format(atten$Intercept, digits=5),"\n", 
                                           "Beta:", format(atten$slope, digits=4)))
  par(mar=c(0, 0, 0, 0))
  plot.new()
  legend('center','groups',c("50% line","95% Line", "Vibr. Records"),
         lty=c(2,1,NA), lwd=c(2,2,2),pch = c(NA,NA,16),ncol=3,col=c("black","red","black"), bty = "n")
  

}