#############################################################################
######    Load and process data        ######################################
#############################################################################


# Load household_power_consumption.txt into table four_year_data. Columns are 
# read in as characters and "?"s are converted to NAs. Columns are given names
# as pecified in header.

four_year_data <- read.table("household_power_consumption.txt",header=T,sep=";",
                             colClasses="character",na.strings="?",
                             col.names=c(
                                     "Date","Time","Global_active_power",
                                     "Global_reactive_power","Voltage",
                                     "Global_intensity","Sub_metering_1",
                                     "Sub_metering_2","Sub_metering_3"))

# Extract data on the dates 1/2/2007 and 2/2/2007. Function subset also drops 
# all rows that contain NAs

data <- subset(four_year_data, (Date=="1/2/2007")|(Date=="2/2/2007") )

# concatenate date and time in character, convert it to POSIXlt class and make it
# a new column datetime for data
data$datetime <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")


#############################################################################
#############################  plot 4  ######################################
#############################################################################

# Open graphic device png. Its default size is 480x480, same as project 
# requirement.
png("plot4.png")

# partition the plot into a 2x2 frame for 4 sub plots 
par(mfrow = c(2, 2))

# sub plot 1

# line type graph of Global_active_power vs. datetime
plot(data$datetime,as.numeric(data$Global_active_power),"l", 
     ylab="Global Active Power",xlab="")


# sub plot 2

# line type graph of Voltage vs. datetime
plot(data$datetime, as.numeric(data$Voltage),"l", 
     xlab = "datetime", ylab="Voltage")




#sub plot 3

# sub plot 3 contains 3 graphs: Submetering_1 vs. datetime, Submetering_1 vs. datetime
# and Submetering_3 vs. datetime. The plot function starts the plot and plots
# a line graph of Submetering_1 vs. datetime. To add the graphs of Submetering_2 
# vs. datetime and Submetering_3 vs. datetime in the same plot, use points function.

plot(data$datetime, as.numeric(data$Sub_metering_1), "l", 
     ylab="Energy sub metering", xlab="",col ="black")
points(data$datetime, as.numeric(data$Sub_metering_2),"l",col="red")
points(data$datetime, as.numeric(data$Sub_metering_3),"l",col="blue")

# bty = "n" indicates the legend's box type is none and
# cex = 0.8 indicates  text and symbols in the legend should be scaled to 80% 
# smaller relative to the default
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c("black","red","blue"),
       lwd=1,cex=0.8,bty = "n")




#sub plot 4

# Line type graph of Global_reactive_power vs. datetime. 

# First the plot is created without y axis (yaxt = "n" indicates this) as the 
# default y tick mark labels don't match those of the reference plot. Next y 
# axis is created seperately  using the axis function. The default x tick mark 
# positions and labels happen to match those of the reference plot, so there's 
# no need to create x axis seperatedly.
plot(data$datetime, as.numeric(data$Global_reactive_power),"l", 
     xlab = "datetime", ylab="Global_reactive_power", yaxt = "n")

# tick mark positions on y axis
y <-c(0.0,0.1,0.2,0.3, 0.4, 0.5)

# tick mark labels on y axis
ylabels=c("0.0","0.1","0.2","0.3","0.4","0.5")

# create y axis with tick marks at y and labels being ylabels 
axis(2, at=y,labels= ylabels, col.axis="black", las=0,lwd=1,font=2,font.lab=2)

# After completing all 4 sub plots, turn off graphical device
dev.off()

