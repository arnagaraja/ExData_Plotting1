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

# Create plot 1

png(filename = "plot1.png", width = 480, height = 480)
hist(power$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", 
     main = "Global Active Power")
dev.off()
