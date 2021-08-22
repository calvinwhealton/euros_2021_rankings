# script to create a plot of Euros 2021 rankings
# comparing men's and women's national teams

# library for a custom pch
library(png)

# reading in csv with data
# data is csv file of FIFA national team rankings
# from early August, 2021
# only nations with men's teams in Euros 2020 are included
df <- read.csv('/Users/calvinwhealton/Documents/GitHub/euros_2021_rankings/fifa_national_team_rankings.csv',
               header=T)

# calculating ranges for men's and women's teams
men_range <- range(df$Men.s.National.Team)
women_range <- range(df$Women.s.National.Team)

# printing results to console
# results show that the women's ranking has 
# ~2x range of men's ranking
(men_range)
(women_range)

# setting plot to save as a pch file
# height and width chosen based on ranges
# checked the output file to make sure
# axes were on the same scale, or close to it
# required some manual adjustment of the height/width parameters
png(filename='/Users/calvinwhealton/Documents/GitHub/euros_2021_rankings/fifa_euro_plot.png'
    ,width=round(women_range[2]/15,2)
    ,height=round(men_range[2]/11.5,2)
    ,units='in'
    ,res=300)

par(mar=c(5,5,5,5)) # plot margins

# setting up the base scatter plot
# used \ to get the "'" in titles
plot(x=NA
     ,y=NA
     ,ylab=expression('Men\'s Ranking')
     ,xlab=expression('Women\'s Ranking')
     ,main='Euros 2021 FIFA Nations\nMen\'s vs Women\'s National Teams'
     ,xlim=rev(women_range) # reverse axes to rank 1 is top right
     ,ylim=rev(men_range) # reverse axes to rank 1 is top right
     ,las=1 # rotate vertical axis labels to be horizontal
     ,xaxt='n' # no default x axis
     ,yaxt='n' # no default y axis
)

# adding axes
axis(side=1, at=c(1,seq(10,women_range[2],10)),las=1)
axis(side=2, at=c(1,seq(10,men_range[2],12)),las=1)

# adding a gray background to the plot
# many flgs have a white portion that would disappear otherwise
rect(xleft=par('usr')[1],xright=par('usr')[2]
     ,ybottom=par('usr')[3],ytop=par('usr')[4]
     ,col='lightgray')

# setting approximate "area" for each country flag
# will be used in adjusting plotting symbol sizes
flag_area <- 25

# looping over all the rankings
for(i in 1:nrow(df)){
  # read in the image and set it to a variable
  img <- readPNG(paste('/Users/calvinwhealton/Documents/GitHub/euros_2021_rankings/flags/',df$Country[i],'.png',sep=''))
  
  # doing some math to make sure flags appear
  # with approximately correct aspect ratio
  # and similar size
  # area = dx*dy = (dy^2)*(aspect_ratio)
  # dy = sqrt(area/aspect_ratio)
  # dx = sqrt(area*aspect_ratio)
  dy <- sqrt(flag_area/df$Aspect.Ratio[i])
  dx <- sqrt(flag_area*df$Aspect.Ratio[i])
  
  # plot the png image as a raster
  # need the image and coordinates
  # men's team on y axis, women's team on x axis
  rasterImage(image=img
              ,ytop=df$Men.s.National.Team[i]+dy/2
              ,ybottom=df$Men.s.National.Team[i]-dy/2
              ,xleft=df$Women.s.National.Team[i]-dx/2
              ,xright=df$Women.s.National.Team[i]+dx/2)
}

# adding a text correlation
# using linear correlation of ranks, not rank correlation
correl <- round(cor(df$Men.s.National.Team,df$Women.s.National.Team),2)

# adding text notation for correlation
text(x=women_range[2]-20,
     y=men_range[1]+10,
     labels = bquote(paste(," Linear Corr. (",rho,") = ",.(correl),sep=""))
     )

# close file
dev.off()