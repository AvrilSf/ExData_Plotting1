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

# modify data class for line plots

library(lubridate)
pow_feb1n2dt <- pow_feb1n2 %>% mutate(Date = dmy(Date), Time = hms(Time),
                                      Datetime = Date + Time, 
                          Global_active_power = as.numeric(Global_active_power),
                          Sub_metering_1 = as.numeric(Sub_metering_1), 
                          Sub_metering_2 = as.numeric(Sub_metering_2),
                      Global_reactive_power = as.numeric(Global_reactive_power), 
                          Voltage = as.numeric(Voltage), 
                          Global_intensity = as.numeric(Global_intensity))
str(pow_feb1n2dt) # verify change of previous lines

# four line plots

par(mfrow = c(2, 2))
with(pow_feb1n2dt, {
        plot.default(Datetime, Global_active_power, type = "l", xlab = "", 
                     ylab = paste("Global Active Power (kilowatts)"))
        plot.default(Datetime, Voltage, type = "l", xlab = "datetime", 
                     ylab = paste("Voltage"))
        plot.default(Datetime, Sub_metering_1, type = "l", xlab = "", 
                     ylab = paste("Energy sub metering"))
        with(subset(pow_feb1n2dt, select = Sub_metering_2), 
             lines(pow_feb1n2dt$Datetime, Sub_metering_2,col = "red"))
        with(subset(pow_feb1n2dt, select = Sub_metering_3), 
             lines(pow_feb1n2dt$Datetime, Sub_metering_3,col = "blue"))
        legend("topright", lwd = 0.5, bty = "n", col = c("black", "red", "blue"), 
               legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
               y.intersp = 0.5, inset = c(0.10, 0.01))
        plot.default(Datetime, Global_reactive_power, type = "l", 
                     xlab = "datetime", ylab = paste("Global reactive power"))
})

# create png file

dev.copy(png, file = "plot4.png")
dev.off()
