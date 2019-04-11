# step 1 preparing
## downlaod the data into the working directory
data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

if(!file.exists("exdata_data_NEI_data.zip")) {
        download.file(data_url, "exdata_data_NEI_data.zip", method = "curl")
}
# unzip the data
if(!file.exists("Source_Classification_Code.rds") | !file.exists("summarySCC_PM25.rds")) {
        unzip("exdata_data_NEI_data.zip")
}

# read the data into r
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Question
## How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

library(dplyr)

vehicle_bat_em <- NEI %>%
        filter(fips == "24510" & type == "ON-ROAD") %>%
        group_by(year) %>%
        summarise(emissions = sum(Emissions))

png(filename = "plot5.png", width = 480, height = 480, units = "px")
with(vehicle_bat_em, 
     barplot(height = emissions, names = year,
             xlab = "years", ylab = "Emissions(tons)",
             main = "Baltimore PM2.5 emission from motor vehicles"))
dev.off()
