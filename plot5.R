setwd('/home/ruben/coursera_ds/ExploratoryDataAnalysis/CourseProject2')

# Read Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Get Baltimore Data
baltimore_data <- filter(NEI, fips == "24510")

# get data from On-Road / Vehicle observations and from a Vehicle
onroad_data <- filter(baltimore_data,type == 'ON-ROAD')
vehicle_rows <- grep('veh',SCC$Short.Name, ignore.case=TRUE)
scc_for_vehicle <- SCC[vehicle_rows,]
veh_NEI <- filter(onroad_data,SCC %in% scc_for_vehicle$SCC)

# Extract the data for coal combustion and summarize
my_NEI <- subset(veh_NEI, select = c('year','Emissions'))
data_by_year <- group_by(my_NEI,year)
data_summary <- summarise_each(data_by_year,funs(sum))

# Draw a plot with a linear model regression
png(file = './plot5.png', width = 600, height = 480)
plot(data_summary$year, data_summary$Emissions, pch = '.', xlab = 'Year', ylab='PM2.5 Emissions (Tons)', main = "Baltimore City Motor Vehicle Emissions", xaxt="n")
axis(side = 1, at = unique(data_summary$year),labels = T)
points(data_summary$year, data_summary$Emissions, col = "red")
abline(lm(data_summary$Emissions ~ data_summary$year))
dev.off()
