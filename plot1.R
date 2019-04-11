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
## Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
## Using the base plotting system, make a plot showing the total PM2.5 emission from 
## all sources for each of the years 1999, 2002, 2005, and 2008.

library(dplyr)

total_em <- NEI %>% group_by(year) %>% summarise(emissions = sum(Emissions))

png(filename = "plot1.png", width = 480, height = 480, units = "px")
with(total_em,
     barplot(height = emissions,
             names = year,
             xlab = "years",
             ylab = "Emissions(tons)",
             main = "Total PM2.5 emission from all sources"))
dev.off()