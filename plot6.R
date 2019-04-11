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
## Compare emissions from motor vehicle sources in Baltimore City with emissions from motor 
## vehicle sources in Los Angeles County, California (fips=="06037"). 
## Which city has seen greater changes over time in motor vehicle emissions?

library(dplyr)
vehicle_bat_los_em <- NEI %>%
        filter((fips == "24510" | fips == "06037" ) & type == "ON-ROAD") %>%
        group_by(year, fips) %>%
        summarise(emissions = sum(Emissions)) %>%
        mutate(city = ifelse(fips == "24510", "Baltimore",
                             ifelse(fips == "06037", "Los Angeles", "")))
        
png(filename = "plot6.png", width = 480, height = 480, units = "px")

library(ggplot2)
ggplot(vehicle_bat_los_em, aes(x = factor(year), y = emissions, fill = city)) +
        geom_bar(stat = "identity") +
        facet_grid( ~ city) +
        labs(x = "year",
             y = "Emissions(tons)", 
             title = "Baltimore and Los Angeles PM2.5 emission from motor vehicles")
dev.off()


