# download file

fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileurl, destfile = "./exdata%2Fdata%2Fhousehold_power_consumption.zip", method = "curl")
unzip("./exdata%2Fdata%2Fhousehold_power_consumption.zip")

# read selected rows of file

HHpower_cons <- read.csv("./household_power_consumption.txt", header = TRUE, sep = ";")
library(dplyr)
power_feb1n2_2007 <- as_tibble(HHpower_cons)
power_feb1_2007 <- power_feb1n2_2007 %>% filter(Date == "1/2/2007")
power_feb2_2007 <- power_feb1n2_2007 %>% filter(Date == "2/2/2007")
pow_feb1n2 <- bind_rows(power_feb1_2007, power_feb2_2007)

# modify data class for line plot

library(lubridate)
pow_feb1n2d <- pow_feb1n2 %>% mutate(Date = dmy(Date), Time = hms(Time))
pow_feb1n2d <- pow_feb1n2d %>% mutate(Global_active_power = as.numeric(Global_active_power))
pow_feb1n2dt <- pow_feb1n2d %>% mutate(Daytime = Date + Time) 
with(pow_feb1n2dt, plot.default(Daytime, Global_active_power, type = "l", xlab = "", ylab = paste("Global Active Power [kilowatts]")))

# create png file

dev.copy(png, file = "plot2.png")
dev.off()
