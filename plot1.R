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

# Plot histogram
png("plot1.png",width=480, height=480)
hist(sub.df$Global_active_power,col='red', main="Global Active Power", xlab="Global Active Power (kilowatts)",xlim=c(0,6))
dev.off()