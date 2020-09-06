# download file

fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileurl, destfile = "./exdata%2Fdata%2Fhousehold_power_consumption.zip", method = "curl")
unzip("./exdata%2Fdata%2Fhousehold_power_consumption.zip")

# read selected rows of file

HHpower_cons <- read.csv("./household_power_consumption.txt", header = TRUE, sep = ";")
library(dplyr)
power_feb1n2_2007 <- tbl_df(HHpower_cons)
power_feb1_2007 <- power_feb1n2_2007 %>% filter(Date == "1/2/2007")
power_feb2_2007 <- power_feb1n2_2007 %>% filter(Date == "2/2/2007")
pow_feb1n2 <- bind_rows(power_feb1_2007, power_feb2_2007)

# modify data class for histogram

library(lubridate)
pow_feb1n2d <- mutate(pow_feb1n2, Date = dmy(pow_feb1n2$Date), Time = hms(pow_feb1n2$Time))
pow_feb1n2d <- mutate(pow_feb1n2d, Global_active_power = as.numeric(Global_active_power))
hist(pow_feb1n2d$Global_active_power, breaks = 12, col = "red", main = paste("Global Active Power"), xlab = paste("Global Active Power [kilowatts]"))

# create png file

dev.copy(png, file = "plot1.png")
dev.off()

