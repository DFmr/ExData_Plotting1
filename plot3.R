#this code reads the Eletric Power Consumption data downloaded from
#https://class.coursera.org/exdata-002/human_grading/view/courses/972082/assessments/3/submissions
#and creates applicable graphs from the data

#lines 11-27 are based on a solution suggested by Peter Huber on the Coursera Exploratory Data Analysis
#discussion forum for reading selections of large datasets.  
#See -- https://class.coursera.org/exdata-002/forum/thread?thread_id=19

#the lines below compiles lines from the two dates of interest -- 1/1/2007 and 1/2/2007 --
#and reads them into a data frame

read <- file("household_power_consumption.txt","rt");

nolines <- 500  #increments of lines read in each loop
selection<-c() #collection of lines meeting date criteria
repeat {
  lines=readLines(read,n=nolines)       #read number of lines specified  in nolines
  match <- grep("^[12]/2/2007", lines) #finds those lines that match dates of interest
  selection<-c(selection, lines[match])      #adds matches to selection
  #
  if(nolines!=length(lines)) {
    break #runs until it reaches end of file
  }
}
close(read)

txt<-textConnection(selection,"rt") #creates a text connection and loads data

energy<-read.table(txt,sep=";",header=FALSE) #reads text connection and creates a data frame


colnames(energy)<-c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity",
                    "Sub_metering_1","Sub_metering_2","Sub_metering_3")

dt<-paste(energy$Date,energy$Time) #pastes together date and time to create Date/time field

energy$Date.Time<-strptime(dt,format="%d/%m/%Y %H:%M:%S") #formats to date/frame field

energy$Week.Day<-weekdays(energy$Date.Time)  #creates a field with weekday for each record


png("plot3.png", width = 800, height = 600) #resizes the png device to allow for a larger image

par(mar=c(3,5,2,2),cex.lab=1.25) #adjusts margins and creates more readable axis label font size

with(energy,plot(Date.Time,Sub_metering_1,type="l",ylab="",xlab=""))

with(energy,lines(Date.Time,Sub_metering_2,col="red"))
with(energy,lines(Date.Time,Sub_metering_3,col="blue"))
with(energy,title(ylab="Energy sub metering",xlab=''))
legend("topright",lty="solid",col=c("black","red","blue"),legend=c("Sub-metering_1",
                                                                   "Sub-metering_2",
                                                                    "Sub-metering_3"))
                                                          

dev.off()





