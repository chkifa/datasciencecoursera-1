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
#############################  plot 3  ######################################
#############################################################################

# Open graphic device png. Its default size is 480x480, same as project 
# requirement.
png("plot3.png")

# plot 3 contains 3 graphs: Submetering_1 vs. datetime, Submetering_1 vs. datetime
# and Submetering_3 vs. datetime. The plot function starts the plot and plots
# a line graph of Submetering_1 vs. datetime. To add the graphs of Submetering_2 
# vs. datetime and Submetering_3 vs. datetime in the same plot, use points function.

plot(data$datetime,as.numeric(data$Sub_metering_1),"l", main = "",
     ylab="Energy sub metering",xlab="",col="black")
points(data$datetime,as.numeric(data$Sub_metering_2),"l",col="red")
points(data$datetime,as.numeric(data$Sub_metering_3),"l",col="blue")
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
       col = c("black","red","blue"),lwd=3)

# Turn off graphic device
dev.off()

