#internal dynaSpec function called by scrolling_spectro. Modified from seewave::oscillo. Not to be called by users.

oscillo_dynaspec_int <- function (wave, f, channel = 1, tlab = "Time (s)", alab = "Amplitude",  colwave = "black", coltitle = "black", 
          cextitle = 1.2, fonttitle = 2, collab = "black", cexlab = 1, fontlab = 1, colline = "black", colaxis = "black", cexaxis = 1, 
          fontaxis = 1, coly0 = "lightgrey", tcl = 0.5, cex = 1,
          xaxt = "s", yaxt = "n", type = "l", bty = "l", labels = FALSE, bg = "white") 
{
  input <- seewave::inputw(wave = wave, f = f, channel = channel)
  wave <- input$w
  f <- input$f
  rm(input)
    a <- 0
    b <- length(wave)
    from <- 0
    to <- length(wave)/f
  
  wave <- as.matrix(wave[a:b, ])
  n <- nrow(wave)
  
  
    alim <- max(abs(wave))
      
        op <- graphics::par(tcl = tcl, col.axis = colaxis, cex.axis = cexaxis, 
                  font.axis = fontaxis, col = colline, las = 0, bg = bg)

        on.exit(graphics::par(op))
        
                plot(x = seq(from, to, length.out = n), y = wave, 
             col = colwave, type = type, cex = cex, xaxs = "i", 
             yaxs = "i", xlab = "", ylab = "", ylim = c(-alim, 
                                                        alim), xaxt = xaxt, yaxt = yaxt, cex.lab = 0.8, 
             font.lab = 2, bty = bty)
        if (bty == "l" | bty == "o") {
          graphics::axis(side = 1, col = colline, labels = FALSE)
          graphics::axis(side = 2, at = max(abs(wave), na.rm = TRUE), 
               col = colline, labels = FALSE)
        }
        if (labels) {
          graphics::mtext(tlab, col = collab, font = fontlab, 
                side = 1, line = 3, cex = cexlab)
          graphics::mtext(alab, col = collab, font = fontlab, 
                cex = cexlab, side = 2, line = 3)
        }
                graphics::abline(h = 0, col = coly0, lty = 2)
    
}
