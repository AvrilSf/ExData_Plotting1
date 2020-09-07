# download file

fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileurl, destfile = "./exdata%2Fdata%2Fhousehold_power_consumption.zip", 
              method = "curl")
unzip("./exdata%2Fdata%2Fhousehold_power_consumption.zip")

# extract selected rows of file

HHpower_cons <- read.csv("./household_power_consumption.txt", header = TRUE, 
                         sep = ";")
library(dplyr)
power_feb1n2_2007 <- as_tibble(HHpower_cons)
pow_feb1n2 <- bind_rows(power_feb1n2_2007 %>% filter(Date == "1/2/2007"), 
                        power_feb1n2_2007 %>% filter(Date == "2/2/2007"))

# modify data class for line plot

library(lubridate)
pow_feb1n2dt <- pow_feb1n2 %>% mutate(Date = dmy(Date), Time = hms(Time), 
                                      Daytime = Date + Time, 
                          Global_active_power = as.numeric(Global_active_power),
                          Sub_metering_1 = as.numeric(Sub_metering_1), 
                          Sub_metering_2 = as.numeric(Sub_metering_2))
str(pow_feb1n2dt) # verify change of previous lines

# line plot

with(pow_feb1n2dt, plot.default(Daytime, Sub_metering_1, type = "l", xlab = "", 
                                ylab = paste("Energy sub metering")))
        with(subset(pow_feb1n2dt, select = Sub_metering_2), 
             lines(pow_feb1n2dt$Daytime, Sub_metering_2,col = "red"))
        with(subset(pow_feb1n2dt, select = Sub_metering_3), 
             lines(pow_feb1n2dt$Daytime, Sub_metering_3,col = "blue"))
        legend("topright", lwd = 1, bty = "o", col = c("black", "red", "blue"), 
               legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
               y.intersp = 0.6, text.width = 50000)

# create png file

dev.copy(png, file = "plot3.png")
dev.off()
