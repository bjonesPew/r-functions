plotTrend <- function(to.plot, 
                      xlim, 
                      ylim,
                      x = NULL,
                      axis.control = NULL, 
                      col.vec = NULL, 
                      ord = NULL,
                      plot.width = 3.2,
                      plot.height = 2,
                      labels = NULL,
                      lab.pos = NULL,
                      hollow = TRUE,
                      res = 1,
                      write.file = "no",
                      addPoints = TRUE,
                      xadj = c(0,0),
                      lwd = 2.5,
                      lty = 1,
                      val.lab.adj = NULL,
                      point.size = 1.2,
                      lab.points = NULL,
                      lab.points.pos = NULL,
                      add.lines = NULL,
                      add.scatter = NULL,
                      add.legend = NULL,
                      text.labels.list = NULL,
                      add.value.labels = TRUE,
                      add.all.value.labels = NULL) {
  
  ##open the plot window (multiplied by the resolution factor)
  dev.new(width=plot.width*res, height=plot.height*res)
  
  ##Re order value label adjustment columns
  if (!is.null(val.lab.adj)) val.lab.adj <- 
      val.lab.adj[,ncol(val.lab.adj):1]
  
  ##save to file
  if (write.file != "no") {
    
    if (write.file == "jpg") {
      src <- tempfile(fileext = ".jpg")
      jpeg(src, width = plot.width, height = plot.height,
           units = 'in', res = 1000)
    }
    if (write.file == "pdf") {
      src <- tempfile(fileext = ".pdf")
      pdf(src, width = plot.width, height = plot.height)      
    }
    
  }
  
  if (is.null(ord)) ord <- 1:ncol(to.plot)
  
  ##Reorder the data if it is in the wrong order
  sort <- order(x, decreasing = TRUE)
  x <- x[sort]
  to.plot <- to.plot[sort,]
  
  ##Open plot window
  par(mar = c(1.7,.1,.1,.1))
  fam <- ifelse(write.file == "pdf", "", "Franklin Gothic Book")
  
  plot(0,0, pch = '', xlim = xlim+xadj, ylim = ylim,
       axes = FALSE, xlab = '', ylab = '',
       family = fam)
  ##print axis
  if (is.null(axis.control)) axis(1, family = fam) 
  if (!is.null(axis.control)) {
    
    
    axis(1, at=xlim, labels=c("",""), 
         col = grey(.4), lwd.ticks=0)
    
    axis(1, at = axis.control[['at']], labels = NA,
         cex.axis = .75, col = grey(.4), tcl = -.4,
         tck = -.02)
    
    axis(1, at = axis.control[['at']], family = fam,
         labels = axis.control[['labels']],
         cex.axis = .75, lwd = 0, line = -.7)            
  }
  
  if (length(lwd) != ncol(to.plot)) lwds <- rep(lwd, ncol(to.plot))
  if (length(lwd) == ncol(to.plot)) lwds <- lwd
  if (is.null(val.lab.adj)) val.lab.adj <- array(0, c(length(ord), 2))
  
  if ( length(hollow) == 1) hollow = rep(hollow, nrow(to.plot))
  if (length(lty) == 1) lty = rep(lty, nrow(to.plot))
  
  if (is.null(lab.points)) {
    lab.points = c(1, nrow(to.plot))
    lab.points.pos = c(4, 2)
  }
  
  ##Add background elements
  if (!is.null(add.lines)) {
    abline(v = add.lines, col = 'grey')
  }
  if (!is.null(add.scatter)) {
    scatter_col <- ifelse(is.null(add.scatter$col), "grey", add.scatter$col)
    scatter_cex <- ifelse(is.null(add.scatter$cex), 1, add.scatter$cex)
    scatter_pch <- ifelse(is.null(add.scatter$pch), 20, add.scatter$pch)
    
    points(add.scatter$coords[,1],
           add.scatter$coords[,2],
           col = scatter_col, cex = scatter_cex,
           pch = scatter_pch)
  }
  
  for (j in ord) {
    fam <- ifelse(write.file == "pdf", "", "Franklin Gothic Demi")
    
    ##Add trend lines
    for (k in 2:length(to.plot[,j])) {
      segments(y0 = to.plot[k,j],
               y1 = to.plot[k-1,j],
               x0 = x[k], x1 = x[k-1],
               col = col.vec[j],
               lty = lty[k-1],
               lwd = lwds[j])
    }
    
    
    ##Add value labels
    if (add.value.labels) {
      for (k in 1:length(lab.points)) {
        lp <- lab.points[k]
        text(x[lp], to.plot[lp,j]+val.lab.adj[j,k], 
             round(abs(to.plot[lp,j])), family = fam,
             col = col.vec[j], pos = lab.points.pos[k], cex = .75)
      }
    }
    
    if (!is.null(add.all.value.labels)) {
      for (k in 1:length(x)) {
        for (i in 1:length(add.all.value.labels)) {
          text(x[k], to.plot[k,i], round(abs(to.plot[k,i])),
               family = fam, col = col.vec[i], pos = add.all.value.labels[i],
               cex = .75)
        }                     
      }
    }
    
    if (addPoints) {
      for (k in 1:nrow(to.plot)) {
        if (length(point.size) == 1) ptsz = point.size
        if (length(point.size) > 1) ptsz = point.size[j]
        
        addDot(x[k], to.plot[k,j], col = col.vec[j],
               hollow = hollow[k], cex = ptsz)
      }
    }
  }
  
  if (length(lab.pos)>0) {
    for (j in 1:length(lab.pos)) {
      fam <- ifelse(write.file == "pdf", "", "Franklin Gothic Demi")
      pos <- lab.pos[[j]]
      text(pos[1], pos[2], labels[j],
           family = fam,
           col = col.vec[j],
           cex = .75)
    }
  }
  
  if (!is.null(add.legend)) {
    leg <- sort(ord)
    fam <- ifelse(write.file == "pdf", "", "Franklin Gothic Book")
    op <- par(family = fam)
    legend(x = sum(xlim/2), y = ylim[2], xjust = .5, 
           add.legend$labels, horiz = TRUE,
           lwd = lwd[leg], col = col.vec[leg], bty = 'n',
           cex = .75)
    
  }
  
  if (!is.null(text.labels.list)) {
    for (j in 1:length(text.labels.list)) {
      txt <- text.labels.list[[j]]
      text(txt$x, txt$y, txt$text,
           family = txt$fam,
           col = txt$col,
           cex = .75)
    }
  }
  
  if (write.file != "no") {
    dev.off()
    dev.off()
    return(src)
  }       
  
}
