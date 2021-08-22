# script to plot built-in PCH in R
# script will plot all of them and add number

# initial plot
# using floor of sequence value of x, and modulo value for y
plot(x=floor(seq(0,99,1)/10),
     y=seq(0,99,1) %% 10,
     pch=seq(0,99,1),
     xlab='', # no x label
     xaxt='n', # no x axis
     ylab='', # no y label
     yaxt='n', # no y axis
     main='First 100 PCH in R', # title
     bty='n' # no border box
     )

par(xpd=T) # allow adding text outside of the plot border

text(x=floor(seq(0,99,1)/10)+0.3, # x offset location by 0.3
     y=seq(0,99,1) %% 10, # same y location as plot
     labels=seq(0,99,1) # numbers as labels
     )