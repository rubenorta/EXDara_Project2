setwd('/home/ruben/coursera_ds/ExploratoryDataAnalysis/CourseProject2')

# Read Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# get observations that are from Vehicle and from Baltimore and Los Angeles
onroad_data <- filter(NEI, type == 'ON-ROAD')
bmore_data <- filter(onroad_data, fips == "24510")
la_data <- filter(onroad_data, fips == "06037")
ba_la_data = rbind(la_data,bmore_data)

# Only observations with SCC that contains Veh
vehicle_rows <- grep('veh',SCC$Short.Name, ignore.case=TRUE)
scc_for_vehicle <- SCC[vehicle_rows,]
veh_NEI <- filter(ba_la_data,SCC %in% scc_for_vehicle$SCC)

# Extract the data and summarize
my_NEI <- subset(veh_NEI, select = c('year','fips','Emissions'))
data_by_year <- group_by(my_NEI,year,fips)
data_summary <- summarise_each(data_by_year,funs(sum))

# Draw a plot with a linear model regression for Los Angeles and Baltimore
png(file = './plot6.png', width = 600, height = 480)
# Translate fips values to city names
data_summary$fips <- factor(data_summary$fips, levels = c('06037','24510'), labels=c('Los Angeles','Baltimore City')) 

ggplot(data_summary, aes(x=year, y=Emissions, color=fips)) + 
  geom_point(shape=1) +
  labs(y="PM2.5 Emissions (Tons)") + labs(title='Los Angeles VS Baltimore City Motor Vehicle Emissions') +
  scale_colour_hue(l=50) +
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE) +
  guides(color=guide_legend(title="City"))

dev.off()
