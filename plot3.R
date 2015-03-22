setwd('/home/ruben/coursera_ds/ExploratoryDataAnalysis/CourseProject2')
library(ggplot2)

# Read Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Filter data for Baltimore City
baltimore_data <- filter(NEI, fips == "24510")
# Group by year and summarize the emissions
my_NEI <- subset(baltimore_data, select = c('year','type','Emissions'))
data_by_year <- group_by(my_NEI,year,type)
data_summary <- summarise_each(data_by_year,funs(sum))

# Draw a plot with a linear model regression
png(file = './plot3.png', width = 600, height = 480)
ggplot(data_summary, aes(x=year, y=Emissions, color=type)) + 
  geom_point(shape=1) + 
  labs(y="PM2.5 Emissions (Tons)") + labs(title='Emissions by source type at Baltimore City') +
  scale_colour_hue(l=50) +
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE) 
dev.off()