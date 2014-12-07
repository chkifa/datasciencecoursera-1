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
#############################  plot 1  ######################################
#############################################################################

# plot 1 is the histogram of Global_active_power. First the histogram is 
# created without y axis (yaxt = "n" specifies this) as the default y 
# tick mark labels don't match those of the reference plot. Next y axis is  
# created seperately using the axis function. The default x tick mark 
# positions and labels happen to match those of the reference plot, so there's 
# no need to create x axis seperatedly.

# Open graphic device png. Its default size is 480x480, same as project 
# requirement.

png("plot1.png")

hist(as.numeric(data$Global_active_power),col="red",breaks = 12, main ="Global Active Power", 
     xlab="Global Active Power (kilowatts)", yaxt = "n", font = 2, font.lab = 2)

# tick mark positions on y axis
y <-c(0,200,400,600,800,1000,1200)

# tick mark labels on y axis
ylabels=c("0","200","400","600","800","1000","1200")

# create y axis with tick marks at y and labels being ylabels 
axis(2, at=y,labels= ylabels, col.axis="black", las=0,lwd=1,font=2,font.lab=2)

# Turn off graphic device
dev.off()
