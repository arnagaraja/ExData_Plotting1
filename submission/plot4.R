library(dplyr)

# Read in the data
# Get the column names from the first line of the file
colNames <- names(read.table("household_power_consumption.txt", sep = ";", header = TRUE, nrows = 1))

# Construct a data frame for just the dates of interest. Will skip the first 
# 66637 rows and only count 2880 rows 
power <- read.table("household_power_consumption.txt", header = FALSE, sep = ";", 
                    stringsAsFactors = FALSE, skip = 66637, nrow = 2880)

# Set the names of the data table
names(power) <- colNames

# Conver to tibble in order to make column manipulation easy
power <- tbl_df(power)

# Combine dates and times into a single column
datetimeCol <- as.POSIXct(strptime(paste(power$Date, power$Time), format = "%d/%m/%Y %H:%M:%S"))
power <- mutate(power, Date = datetimeCol, Time = NULL)
power <- rename(power, datetime = Date)

# Create plot 4

png(filename = "plot4.png", width = 480, height = 480)

# Set the window
par(mfrow = c(2,2))

# 1st plot
with(power, plot(datetime, Global_active_power, type = "l", 
                 ylab = "Global Active Power (kilowatts)", xlab = ""))

# 2nd plot
with(power, plot(datetime, Voltage, type = "l"))

# 3rd plot
with(power, plot(datetime, Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = ""))
with(power, lines(datetime, Sub_metering_2, col = "red"))
with(power, lines(datetime, Sub_metering_3, col = "blue"))
legend("topright", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd = c(1,1,1))

# 4th plot
with(power, plot(datetime, Global_reactive_power, type = "l"))

dev.off()
