###Tutorial on how to plot a colorful barplot of your previously cleaned Whatsapp chatlog.###


#For the visualization you need to add the package "ggplot2" to your user library.
#this can be done with this function:
require("ggplot2")

#Now, load the clean dataset we created with the whatsapp_cleaning.R script
load("C:/Users/yourname/folder/anotherfolder/lastfolderipromise/whatsapp_cleaned.Rdata")

#Now you can start visualizing your data. We have two examples prepared for you:
ggplot(chat[chat$time$hour < 6,], #this plots only the number of messages sent before 6 am
  aes(x = time$hour, fill = name)) + #this manipulates the aesthetics of your plot.
  #In this case it tells the function to put the hours of the column 'time' on the 'x' axis and
  #associate('fill') the bars with the different names
  stat_count(position = "dodge", show.legend = TRUE) + #this plots the bars next to each other.
    #You can also use the argument 'stack' instead, if you want to have them stacked
  #you don't necessarily need the following lines to plot something, 
  #but they add titles and labels to your plot and set the font of the title to be 'bold'
  ggtitle("Journocode conversations per hour") +
  ylab("# of messages") + xlab("hours of day") +
  theme(plot.title = element_text(lineheight = .8, face = "bold"))

#As you can see, with 'ggplot2' it is important that you don't connect
#the separate arguments of the function with ',' but with '+'

ggplot(chat, aes(x = time$hour, fill = name)) +
  stat_count(position = "dodge", show.legend = TRUE) +
  ggtitle("Journocode conversations per hour") +
  ylab("# of messages") + xlab("time") +
  theme(plot.title = element_text(lineheight = .8, face = "bold"))
  
#Now feel free to play a little with this by yourself!
#Try for example changing the values for the x-axis aes(x = ...)  to chat$time$months or simply changing the title.

#If you have any questions, feel free to contact me or one of the other journocode members via www.journocode.com
