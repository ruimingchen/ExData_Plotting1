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

# Plot
png("plot2.png",width=480, height=480)
plot(sub.df$Date_time,sub.df$Global_active_power, type="l", xlab="Datetime", ylab="Global Active Power")
dev.off()