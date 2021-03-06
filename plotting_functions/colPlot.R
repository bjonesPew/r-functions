plotCol <- function(
  y,          ####data values to plot 
  x.pos,      ####horizontal position to plot
  col.vec,    ####colors
  lab,         ####label to plot underneath the column
  print.small = NULL	###value of labels that are too small to print
  ) {
  
  ##keep track of vertical position
  y.pos = 0
  
  ##loop through data vector and build the column
  for (j in 1:length(y)) {
    ##add the boxes that make up the column
    polygon(x = c(x.pos - .4, x.pos + .4,
                 x.pos + .4, x.pos - .4),
            y = c(y.pos, y.pos,
                  y.pos + y[j], y.pos + y[j]),
            col = col.vec[j], border = NA)
    ##add the data label
if (!is.null(print.small)) {
    if (y[j]*100 > print.small) {
    	text(x = x.pos, y = y.pos + y[j]/2, round(y[j]*100),
         cex = .75, family = "Franklin Gothic Book")
    }
}
    ##increment the y position
    y.pos = y.pos + y[j]
  }
  
  ##add the label underneath the column
  text(x = x.pos, y = 0, lab, pos = 1, cex = .75,
       family = "Franklin Gothic Book")
}

colPlot <- function(
  to.plot,                  ###data to plot
  col.vec,                  ###colors
  plot.width = 3.2,         ###width of the plot in inches
  plot.height = NULL,       ###height of the plot if necessary
  write.file = 'no',        ###write out the file or no
  xlim = NULL,              ###set the left hand margin for data labels (it would be nicer to set this automatically...)
  ylim = c(-.2, 1.2),       ###set the upper and lower bounds for column and group labels
  n.cats,                   ###which values to plot (first n.cats)
  val.lab = NULL,           ###Add value labels
  val.pos = NULL,           ###positioning of the value labels (defaults to the first column
  group.lab = NULL,	    ###Add group labels
  group.lab.pos = NULL,	    ###positioning for group labels
  print.small = NULL
 ) {
	
###open up a plot window
dev.new(width = plot.width, height = plot.height)	

 ##set the height of the plot if it isn't supplied
 if (is.null(plot.height)) plot.height <- plot.width/1.6
 ##save to file
if (write.file!="no") {

if (write.file == "jpg") {
	src <- tempfile(fileext = ".jpg")
	jpeg(src, width = plot.width, 
		height = plot.height,
		units = 'in', res = 1000)
}
if (write.file == "pdf") {
	src <- tempfile(fileext = ".pdf")
	pdf(src, width = plot.width,
		height = plot.height)
}

}

par(mar = rep(.1, 4))
plot(0,0, pch = '', xlim = xlim,
     ylim = ylim, axes = FALSE)


##loop through the data to add columns
x.pos <- 1
for (j in 1:length(to.plot)) {

  ##skip null entries and add a vertical separator
  if (is.null(to.plot[[j]])) {
    segments(x0 = x.pos, x1 = x.pos,
             y0 = ylim[1], y1 = ylim[2], lty = c("14"))
    x.pos = x.pos + 1
    next
  }
  
  ##loop through the elements of the data list and add the columns

  plotCol(to.plot[[j]][1:n.cats], x.pos, col.vec,
          lab = names(to.plot)[j],
	 print.small = print.small)
  x.pos = x.pos + 1


}

##Add group labels if they are supplied
if (!is.null(group.lab)) {
  for (j in 1:length(group.lab)) {
  ##add the group label
  text(group.lab.pos[j], y = 1.1,
       group.lab[j], cex = .75, family = "Franklin Gothic Demi")
  }
}

###Add the value labels to the left-hand margin

if (!is.null(val.lab)) {
if (is.null(val.pos)) val.pos = to.plot[[1]][1:n.cats]
y.pos = 0
for (j in 1:length(val.lab)) {
  text(.4, y.pos + val.pos[j]/2, val.lab[j], cex = .75,
       col = col.vec[j], family = "Franklin Gothic Demi", 
       pos = 2)
  y.pos = y.pos + val.pos[j]
}
}

##Close the plot window
if (write.file!="no") {
	dev.off()
	dev.off()
	return(src)
}

}

