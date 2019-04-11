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
## Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

library(dplyr)
NEISCC <- merge(NEI, SCC, by = "SCC")
coal_name <- grepl("coal", NEISCC$Short.Name, ignore.case = TRUE)
coal_source <- NEISCC[coal_name, ]

coal_em <- coal_source %>%
        group_by(year) %>%
        summarise(emissions = sum(Emissions))

png(filename = "plot4.png", width = 480, height = 480, units = "px")
with(coal_em,
     barplot(height = emissions,
             names = year,
             xlab = "years",
             ylab = "Emissions(tons)",
             main = "Total PM2.5 emission from coal combustion"))
dev.off()
