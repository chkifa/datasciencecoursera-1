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
#############################  plot 2  ######################################
#############################################################################

# plot Global_active_power vs. datetime

# Open graphic device png. Its default size is 480x480, same as project 
# requirement.
png("plot2.png")

# type = "l" idicates this is a line graph
plot(data$datetime, as.numeric(data$Global_active_power),"l", 
     main = "", ylab="Global Active Power (kilowatts)",xlab="")

# Turn off graphic device
dev.off()