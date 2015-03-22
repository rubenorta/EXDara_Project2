setwd('/home/ruben/coursera_ds/ExploratoryDataAnalysis/CourseProject2')

# Read Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Extract only the cols needed + Group by Year and Summarize Emissions
my_NEI <- subset(NEI, select = c('year','Emissions'))
data_by_year <- group_by(my_NEI,year)
data_summary <- summarise_each(data_by_year,funs(sum))

png(file = './plot1.png', width = 480, height = 480)

# Create the plot with the data, the custom x axis and a linear regression model
plot(data_summary$year, data_summary$Emissions, xlab = 'Year', ylab='PM2.5 Emissions (Tons)', main = "US Pollution Emissions", xaxt="n")
axis(side = 1, at = unique(data_summary$year),labels = T)
abline(lm(data_summary$Emissions ~ data_summary$year))
points(data_summary$year, data_summary$Emissions, col = "red")

dev.off()
