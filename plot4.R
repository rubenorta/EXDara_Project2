setwd('/home/ruben/coursera_ds/ExploratoryDataAnalysis/CourseProject2')

# Read Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Find SCC that are from combusion (Comb) of Coal
coal_comb_row <- grep("(coal(.*)comb)|(comb(.*)coal)",SCC$Short.Name, ignore.case=TRUE)
scc_for_coal_comb <- SCC[coal_comb_row,]

# Extract the data for coal combustion and summarize
coal_NEI <- filter(NEI,SCC %in% scc_for_coal_comb$SCC)
my_NEI <- subset(coal_NEI, select = c('year','type','Emissions'))
data_by_year <- group_by(my_NEI,year,type)
data_summary <- summarise_each(data_by_year,funs(sum))

# Draw a plot with a linear model regression
png(file = './plot4.png', width = 600, height = 480)
ggplot(data_summary, aes(x=year, y=Emissions, color=type)) + 
  geom_point(shape=1) +
  labs(y="PM2.5 Emissions (Tons)") + labs(title='US Coal Combustion Emissions') +
  scale_colour_hue(l=50) +
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE) 
dev.off()
