# Clear current workspace
rm(list = ls())

# Create and set current working directory
dir <- "~/ExData_Plotting1"
if(!file.exists(dir)){
  dir.create(file.path(dir))
}
setwd(dir)

# Donwload data file (if it does not exist)
zipfile <- "exdata_data_household_power_consumption.zip"
if(!file.exists(zipfile)) {
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url, zipfile)
}

# Read data file
raw.df <- read.csv(unz(zipfile, "household_power_consumption.txt"), header=TRUE, sep=";", na.strings="?")

# Subset 2007-02-01 and 2007-02-02 data
sub.df<- raw.df[as.Date(raw.df[,1], "%d/%m/%Y") == as.Date('2007-02-01') | as.Date(raw.df[,1], "%d/%m/%Y") == as.Date('2007-02-02'),]

# Add a column of Date_time (with Date and Time converted to datetime format)
Date_time<-strptime(paste(sub.df$Date,sub.df$Time, sep=" "),"%d/%m/%Y %H:%M:%S")
sub.df<-cbind(sub.df,Date_time)

# Convert data frame to data table
library(data.table)
sub.dt <- data.table(sub.df)

# Construct the plotting data
sub_metering_1.dt <- sub.dt[, c("Sub_metering_1","Date_time"), with=FALSE]
sub_metering_1.dt[,Sub_meeting_no:=1]
setnames(sub_metering_1.dt, c("Sub_meeting_energy", "Date_time","Sub_meeting_no"))
sub_metering_2.dt <- sub.dt[, c("Sub_metering_2","Date_time"), with=FALSE]
sub_metering_2.dt[,Sub_meeting_no:=2]
setnames(sub_metering_2.dt, c("Sub_meeting_energy", "Date_time","Sub_meeting_no"))
sub_metering_3.dt <- sub.dt[, c("Sub_metering_3","Date_time"), with=FALSE]
sub_metering_3.dt[,Sub_meeting_no:=3]
setnames(sub_metering_3.dt, c("Sub_meeting_energy", "Date_time","Sub_meeting_no"))
sub_meeting.dt <- rbind(sub_metering_1.dt, sub_metering_2.dt, sub_metering_3.dt)

# Plot
png("plot4.png",width=480, height=480)
par(mfcol=c(2,2))
#plot4_1: plot2
plot(sub.df$Date_time,sub.df$Global_active_power, type="l", xlab="Datetime", ylab="Global Active Power (kilowatts)")
#plot4_2: plot3
with(sub_meeting.dt, plot(Date_time,Sub_meeting_energy, xlab="Datetime", ylab="Energy sub meeting", type="n"))
with(subset(sub_meeting.dt, Sub_meeting_no == 1), lines(Date_time,Sub_meeting_energy, col='black'))
with(subset(sub_meeting.dt, Sub_meeting_no == 2), lines(Date_time,Sub_meeting_energy, col='red'))
with(subset(sub_meeting.dt, Sub_meeting_no == 3), lines(Date_time,Sub_meeting_energy, col='blue'))
legend("topright", pch=c(NA,NA,NA), lwd=1, col=c("black","red","blue"),legend=c("Sub_meeting_1","Sub_meeting_2","Sub_meeting_3"))
#plot4_3
plot(sub.df$Date_time,sub.df$Voltage, type="l", xlab="Datetime", ylab="Voltage")
#plot4_4
plot(sub.df$Date_time,sub.df$Global_reactive_power, type="l", xlab="Datetime", ylab="Global Reactive Power (kilowatts)")
dev.off()