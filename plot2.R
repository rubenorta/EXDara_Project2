setwd('/home/ruben/coursera_ds/ExploratoryDataAnalysis/CourseProject2')

# Read Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Filter data for Baltimore, Extact columns,  Group by Year and and Summarize Emissions
baltimore_data <- filter(NEI, fips == "24510")
my_NEI <- subset(baltimore_data, select = c('year','Emissions'))
data_by_year <- group_by(my_NEI,year)
data_summary <- summarise_each(data_by_year,funs(sum))

png(file = './plot2.png', width = 480, height = 480)
# Draw the plot, add the custom axis, draw the linear regression model and the points
plot(data_summary$year, data_summary$Emissions, pch = '.', 
     xlab = 'Year', ylab='PM2.5 Emissions (Tons)', main = "Pollution Emissions on Baltimore City", xaxt="n")
axis(side = 1, at = unique(data_summary$year),labels = T)
abline(lm(data_summary$Emissions ~ data_summary$year))
points(data_summary$year, data_summary$Emissions, col = "red")
dev.off()
