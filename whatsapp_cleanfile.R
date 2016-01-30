#This script works with a .csv version of the Whatsapp chatlog.
#Use excel or a programm of your choice to separate the raw .txt file by spaces.

#Read data
setwd("C:/Users/Kira/OneDrive/Journocode/whatsapp")

chat <- read.csv("Whatsapp Chat mit journocode.csv",
                 header = FALSE, sep = ";",
                 na.strings="", stringsAsFactors = FALSE)

#Overview
cat("Rows without time stamp:", length(grep("^\\D", chat[,1])),
    "(", grep("^\\D", chat[,1]), ")", "\n")

#Add 5 empty rows to the end to make space for shifting
chat <- cbind(chat, matrix(nrow = nrow(chat), ncol = 5))

#Shift stampless rows 5 cols to the left, fill with NAs
cat("Shifting rows without time stamp...", "\n")
for(row in grep("^\\D", chat[,1])){
      end <- which(is.na(chat[row,]))[1] #first column without text in it
      chat[row, 6:(5+end)]<- chat[row, 1:(end-1)]
      chat[row, 1:(end-1)] <- NA
}

#Delete entirely empty rows
chat <- chat[-which(apply(chat, 1, function(x) all(is.na(x))) == TRUE),]

#Clean surname column
cat("Cleaning surname column from chat content...", "\n")

#Delete rows without ":" in either column 3 nor 4.
#Those are not messages but activities like adding members to a group chat
chat <-chat[grepl(".+:$", chat[,5]) |
                  grepl(".+:$", chat[,4]) | 
                  is.na(chat[,1]), ]

#Filter column 4. Shift everything that's not a surname
#to the first column without content
for(row in which(!grepl(".+:$", chat[,5]))){
      end <- which(is.na(chat[row,]))[1] #first column without chat content
      chat[row,end]<- chat[row,5]
      chat[row,5] <- NA
}
View(chat)
#Copy time stamp and name of row above for rows w/o time stamp
cat("Filling in timestamps, deleting spare columns...", "\n")
for(row in which(is.na(chat[,1]))){
      chat[row,1:5] <- chat[(row-1), 1:5]
}

#Delete column 3, contains only "-"
chat <- chat[,-3]

#Convert columns 1 and 2 to date format

#Merge columns 1 and 2 (date and time) to simplify things
chat[,1] <- paste(chat[,1], chat[,2])
#Remove now redundant second column
chat <- chat[,-2]

#Name the first three columns
colnames(chat)[1:3] <- c("time", "name", "surname")

#Convert the first column into a 'Posixlt' object.
chat$time <- strptime(chat$time, "%d.%m.%Y, %H:%M")

#Remove the colon at the end of the names

chat$name <- gsub(":$", "", chat$name)
chat$surname <- gsub(":$", "", chat$surname)

#Save R object for the visualization part
save(chat, file = "whatsapp_cleaned.Rdata")
View(chat)

cat("Done.")

