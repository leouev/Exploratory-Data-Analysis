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
## Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad)
## variable, which of these four sources have seen decreases in emissions from 1999–2008 
## for Baltimore City? Which have seen increases in emissions from 1999–2008? 
## Use the ggplot2 plotting system to make a plot answer this question.

library(dplyr)

bat_em_type <- NEI %>%
        filter(fips == "24510") %>%
        group_by(type, year) %>%
        summarise(emissions = sum(Emissions))

png(filename = "plot3.png", width = 480, height = 480, units = "px")
library(ggplot2)
ggplot(bat_em_type, aes(x = factor(year), y = emissions, fill = type)) +
        geom_bar(stat = "identity") +
        facet_grid( ~ type) +
        labs(x = "year", y = "Emissions(tons)", title = "Baltimore PM2.5 emission from 4 types of sources")
dev.off()
