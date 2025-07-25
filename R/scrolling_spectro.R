#' Create scrolling dynamic spectrograms
#' 
#' \code{scrolling_spectro} create videos of single row spectrograms scrolling from right to left sync'ed with sound.
#' @usage scrolling_spectro(wave, file.name = "scroll.spectro.mp4", hop.size = 11.6, wl = NULL, 
#' ovlp = 70, flim = NULL, pal = seewave::reverse.gray.colors.1, speed = 1, fps = 50, 
#' t.display = 1.5, fix.time = TRUE, res = 70, 
#' width = 700, height = 400, parallel = 1, pb = TRUE,
#'  play = TRUE, loop = 1, lcol = "#07889B99", 
#'  lty = 2, lwd = 2, axis.type = "standard", buffer = 1, 
#'  ggspectro = FALSE, lower.spectro = TRUE, height.prop = c(5, 1), derivative = FALSE, 
#'  osc = FALSE, colwave = "black", colbg = "white",
#'  spectro.call = NULL, annotation.call = NULL, ...)
#' @param wave object of class 'Wave'.
#' @param file.name Character string with the name of the output video file. Must include the .mp4 extension. Default is 'scroll.spectro.mp4'.
#' @param hop.size A numeric vector of length 1 specifying the time window duration (in ms). Default is 11.6 ms, which is equivalent to 512 wl for a 44.1 kHz sampling rate. Ignored if 'wl' is supplied.
#' @param wl A numeric vector of length 1 specifying the window length of the spectrogram, default 
#' is NULL. If supplied, 'hop.size' is ignored.
#' @param ovlp Numeric vector of length 1 specifying the percent overlap between two 
#'   consecutive windows, as in \code{\link[seewave]{spectro}}. Default is 70.
#' @param flim A numeric vector of length 2 specifying  limits in the frequency axis (in kHz). Default is \code{NULL} (which means from 0 to Nyquist frequency).
#' @param pal Character string with the color palette to be used. Default is 'reverse.gray.colors.1'.  
#' @param speed Numeric vector of length 1 indicating the speed at which the sound file will be reproduced (default is 1, normal speed). Values < 1 (but higher than 0) slow down while values > 1 speed up. Note that changes in speed are achieved by modifying the number of frames per second in the output video. Hence, you may want to adjust 'fps' if video quality is considerably affected. 
#' @param fps Numeric vector of length 1 specifying the number of frames per second.
#' @param t.display Numeric vector of length 1 specifying the time range displayed in the spectrogram.
#' @param fix.time Logical argument to control if the time axis moves along with the spectrogram or remains fixed. Default is \code{TRUE} (fixed).
#' @param res Numeric vector of length 1 specifying the resolution of the image files (see \code{\link[grDevices]{png}}). Default is 70.
#' @param width Numeric vector of length 1 specifying width of the video frame in pixels (see \code{\link[grDevices]{png}}). Default is 700.
#' @param height Numeric vector of length 1 specifying height of the video frame in pixels (see \code{\link[grDevices]{png}}). Default is 400.
#' @param res Numeric vector of length 1 specifying the resolution of the image files (see \code{\link[grDevices]{png}}).
#' @param parallel Numeric vector of length 1. Controls whether parallel computing is applied by specifying the number of cores to be used. Default is 1 (i.e. no parallel computing).
#' @param pb Logical argument to control if progress bar is shown. Default is \code{TRUE}.
#' @param play Logical argument to control if the video is played after generated. Default is \code{TRUE}.
#' @param loop Logical argument to control if the video is formatted to be played in a loop (i.e. if ends at the start of the clip).
#' @param lcol Character string with the color to be used for the vertical line at which sounds are played. Default is \code{"#07889B99"}.
#' @param lty Character string to control the type of the line at which sounds are played. Line types can either be specified as an integer (0=blank, 1=solid (default), 2=dashed, 3=dotted, 4=dotdash, 5=longdash, 6=twodash) or as one of the character strings "blank", "solid", "dashed", "dotted", "dotdash", "longdash", or "twodash", where "blank" uses 'invisible lines' (i.e., does not draw them).Default is 2.
#' @param lwd Character string to control the width of the line at which sounds are played. Default is 2.
#' @param axis.type Character string to control the style of spectrogram axes. Currently there are 3 options:
#'  \itemize{
#' \item \code{standard}: Both Y and X axes are printed as in the default \code{\link[seewave]{spectro}} view. 
#' \item \code{minimal}: Single lines are used to denote the range defined by 1 s and 1 kHz for the X and Y axes respectively.
#' \item \code{none}: No axis is printed (also removes ticks, tick labels, and axis labels).
#' }
#' @param buffer Numeric vector of length 1 (> 0) specifying the time to delay the start of the spectrogram scrolling (in seconds). Default is 1. Not available when loop is > 1.
#' @param ggspectro Logical argument to control if a ggspectro (\code{\link[seewave]{ggspectro}}) is used instead. Note that there is much less control on display parameters when \code{ggpsectro = TRUE}. Default is \code{FALSE}. 
#' @param lower.spectro Logical argument to control if a spectrogram of the full wave object is plotted at the bottom of the graph. Default is \code{TRUE}.
#' @param height.prop Numeric vector of length 2 to control the relative height of the scrolling and lower spectro, respectively. Default is \code{c(5, 1)}. Ignored if \code{lower.spectro = FALSE}.
#' @param derivative Logical argument to control if spectral derivative is used instead of spectrogram (as in Sound Analysis Pro, see \code{\link[imager]{deriche}}). Default is \code{FALSE}.
#' @param osc Logical argument to control if the oscillogram is plotted at the bottom of the spectrogram. Default is \code{FALSE}. Note that 'osc' and 'lower.spectro' are mutually exclusive.
#' @param colwave Character string to control the color of the oscillogram. Default is 'black'.
#' @param colbg Character string to control the background color. Default is 'white'.
#' @param spectro.call A call from a spectrogram creating function (i.e. \code{\link[seewave]{spectro}}, \code{\link[warbleR]{color_spectro}}) generated by the function \code{\link[base]{call}}. This call will replace the internal spectrogram creating call. Default is \code{NULL}.
#' @param annotation.call A call from \code{\link[graphics]{text}} generated by the function \code{\link[base]{call}}. The call should also include the argmuents 'start' and 'end' to indicate the time at which the labels are displayed (in s).'fading' is optional and allows fade-in and fade-out effects on labels (in s as well). The position ('x' and 'y' arguments) should be between 0 and 1: \code{x = 0, y = 0} corresponds to the bottom left and \code{x = 1, y = 1} corresponds to the top right position.
#' @param ... Additional arguments to be passed to \code{\link[seewave]{spectro}} for customizing spectrograms. Note that 'scale' cannot be included.
#' @return A video file in mp4 format in the working directory with the scrolling spectrogram.
#' @export
#' @name scrolling_spectro
#' @details The function creates videos (mp4 format) of single row spectrograms scrolling from right to left. The audio is sync'ed with the spectrograms. Sound files with a sampling rate other than 44.1 kHz will be resampled to 44.1 kHz as required by ffmpeg when embeding audio to video files.
#' @seealso \code{\link[seewave]{spectro}}
#' @examples
#' \dontrun{
#' # load example data
#' data(list = c("Phae.long1"))
#' 
#' # run function
#' scrolling_spectro(wave = Phae.long1, wl = 300, ovlp = 90, 
#' fps = 50, t.display = 1.5, collevels = seq(-40, 0, 5),
#'  pal = reverse.heat.colors, grid = FALSE, flim = c(1, 10), 
#'  res = 120)
#' }
#' 
#' @author Marcelo Araya-Salas (\email{marcelo.araya@@ucr.ac.cr}) 
#' @references
#' Araya-Salas M & Wilkins M R. (2020). dynaSpec: dynamic spectrogram visualizations in R. R package version 1.0.0.

scrolling_spectro <- function(wave, file.name = "scroll.spectro.mp4", hop.size = 11.6, wl = NULL, ovlp = 70, flim = NULL, pal = seewave::reverse.gray.colors.1, speed = 1, fps = 50, t.display = 1.5, fix.time = TRUE, res = 70, width = 700, height = 400, parallel = 1, pb = TRUE, play = TRUE, loop = 1, lcol = "#07889B99", lty = 2, lwd = 2, axis.type = "standard", buffer = 1, ggspectro = FALSE, lower.spectro = TRUE, height.prop = c(5, 1), derivative = FALSE, osc = FALSE, colwave = "black", colbg = "white", spectro.call = NULL, annotation.call = NULL, ...)
{

  # stop if wave is shorter than t.display
  if (seewave::duration(wave) <= t.display)
    stop2("duration of 'wave' must be larger than 't.display'")
  
  # error message if wavethresh is not installed
  if (derivative & !requireNamespace("imager", quietly = TRUE))
    stop2("must install 'imager' when using spectral derivatives (derivative = TRUE)")
  
  if (derivative & ggspectro) warning2("spectral derivatives (derivative = TRUE) are not allowed with 'ggspectro'. 'derivative' will be ignored")
  
  if (osc & lower.spectro) warning2("lower.spectro (lower.spectro = TRUE)  and oscillogram (osc = TRUE) are mutually exclusive. 'lower.spectro' will be ignored")
  
  # change lower.spectro if osc = T
  if (osc) lower.spectro <- FALSE
  
  # turn background gray when derivatives
  if (derivative)
  colbg <- "gray"
  
  # check call
  if (!is.null(spectro.call)) 
    if (!is.call(spectro.call)) stop2("'spectro.call' is not a call")
  
  # hopsize  
  if (!is.numeric(hop.size) | hop.size < 0) stop2("'hop.size' must be a positive number") 

  # buffer  
  if (!is.numeric(buffer) | buffer < 0) stop2("'buffer' must be a positive number") 

  # loop  
  if (!is.numeric(loop) | loop < 0) stop2("'loop' must be a positive number") 

  # error if buffer and loop > 1
  if (buffer > 0 & loop > 1) {
    warning2("buffer cannot be used (> 0) when loop is > 1. Buffer was set to 0")

    buffer <- 0
    }  
    
  # If parallel is not numeric
  if (!is.numeric(parallel)) stop2("'parallel' must be a numeric vector of length 1") 
  if (any(!(parallel %% 1 == 0),parallel < 1)) stop2("'parallel' should be a positive integer")
  
  # set height prop to 0, 1
  if (!lower.spectro & !osc) height.prop <- c(1, 0)
  
  ## create a segment to add at the beggining and end
  if (loop == 1) 
    add_sgm_end <- add_sgm_strt <- tuneR::silence(duration = t.display / 2, samp.rate = wave@samp.rate,
                   xunit = "time") else {
                     
                     add_sgm_strt <- seewave::cutw(wave = wave, from = seewave::duration(wave) - t.display / 2, to = seewave::duration(wave), output = "Wave")
                     
                     add_sgm_end <- seewave::cutw(wave = wave, from = 0, to = t.display / 2)
                   }
                     
  # add silence to start and end
  wave_sil <- seewave::pastew(wave2 = add_sgm_strt, wave1 = wave, f = wave@samp.rate,
               output = "Wave")

  wave_sil <- seewave::pastew(wave1 = add_sgm_end, wave2 = wave_sil, f = wave_sil@samp.rate,
               output = "Wave")
  
  # adjust wl based on hope.size
  if (is.null(wl))
    wl <- round(wave_sil@samp.rate * hop.size / 1000, 0)
  
  # make wl even if odd
  if (!(wl %% 2) == 0) wl <- wl + 1
  
  # make width and height even if odd
  if (!(width %% 2) == 0) width <- width + 1
  if (!(height %% 2) == 0) height <- height + 1
  
  # number of frames
  frames <- round((seewave::duration(wave) + buffer) * fps, 0) 
  
  # time increase between frames
  step_time <- (seewave::duration(wave_sil) - t.display) / (frames  - (buffer * fps))
  
  # time increase for lower spectrogram
  step_time_low <- t.display / (frames  - (buffer * fps))  
  
  # relative size of white rectangle in lower spectrogram
  white_window <- (t.display) / (seewave::duration(wave)) * t.display
  
  # create a color transparency vector for labeling annotations
  if (!is.null(annotation.call)){
    
  # create vector
  ann_alpha <- rep(0, frames)   
    
    # loop over labels
    for (w in seq_len(length(annotation.call$labels)))
    ann_alpha <- fading_text_dynaspec_int(x = ann_alpha, start = (annotation.call$start[w] + (t.display / 2))* fps, end = (annotation.call$end[w] + (t.display / 2))* fps, fading = if (!is.null(annotation.call$fading)) annotation.call$fading * fps else 1, labels = annotation.call$labels[w])
    
    # remove fading from call
     annotation.call$fading <- NULL
    
     # remove start and end
    annotation.call$start <- NULL
    annotation.call$end <- NULL
    
  }
  
  # make vector with name of images
  img_names <- paste0(sprintf(paste0("%0",nchar(frames) + 2, "d"), 1:(frames * loop)), ".temp.img.tiff")
  
  if (is.null(flim)) # flim on original wave
    flim <- c(0, wave@samp.rate / 2000)

  # reset margins at the end
  opar <- graphics::par(mar = graphics::par("mar"), bg = graphics::par("bg"), no.readonly = TRUE)
  on.exit(graphics::par(opar), add = TRUE)
  
  # remove temporary files at the end
  on.exit(try(unlink(c(temp.video, temp.audio, list.files(path = tempdir(), full.names = TRUE, pattern = "\\.temp.img.tiff$"))), silent = TRUE), add = TRUE)
 
  on.exit(try(unlink(c(file.path(path = tempdir(), "temp.full.spectro.png"), file.path(path = tempdir(), "temp.full.oscillo.png"))), silent = TRUE), add = TRUE)
  
  wdt <- width * seewave::duration(wave_sil) / t.display
  if (wdt > 32767) wdt <- 32767 
   
  if (!ggspectro){
  # save full spectrogram of wave
  grDevices::png(filename = file.path(tempdir(), "temp.full.spectro.png"), height = height, width = wdt, res = res)
  
  # set plot margins for spectrogram
  graphics::par(mar = rep(0, 4))
  
  # plot spectro
  if (is.null(spectro.call))
  suppressMessages(seewave::spectro(wave = wave_sil, f = wave_sil@samp.rate, wl = wl, ovlp = ovlp, axisX = FALSE, axisY = FALSE, scale = FALSE, flim = flim, palette = pal, osc = FALSE, colbg = colbg, ...)) else {
    
    # modify wave in call
    spectro.call$wave <- wave_sil
    
    # fix times in selection table if present in spectro.call
    if (!is.null(spectro.call$X)) {
      
      # add selection to repeated part in loop 
      if (loop > 1)
    {    
        # for calls added at the end 
        end.X <- spectro.call$X[spectro.call$X$start <= (t.display / 2), ]
        
        if (nrow(end.X) > 0){
          
          # fix start to add whole wave duration
          end.X$start <- end.X$start + seewave::duration(wave) 
          end.X$end <- end.X$end + seewave::duration(wave) 
          
          # for calls added at the start
          spectro.call$X <- rbind(spectro.call$X, end.X)
        }    
        
        # for calls added at the start
        start.X <- spectro.call$X[spectro.call$X$start >= (t.display / 2) + seewave::duration(wave), ]
      
        if (nrow(start.X) > 0){
          # fix end to substract whole wave duration
        start.X$start <- end.X$start - seewave::duration(wave) - t.display / 2 
        
        start.X$end <- start.X$end - seewave::duration(wave) - (t.display / 2)
        # for calls added at the end
        spectro.call$X <- rbind(spectro.call$X, start.X)
        }
        
        
      # fix start and end
      spectro.call$X$start <- spectro.call$X$start + (t.display / 2)
      spectro.call$X$end <- spectro.call$X$end + (t.display / 2)
      
      }
    }
    # evaluate call
    eval(spectro.call)
  }
    
  # close plot
  grDevices::dev.off()
  
  # spectral derivatives
  if (derivative){
  
    # read spectrogram image
  spc_img <- imager::load.image(file.path(tempdir(), "temp.full.spectro.png"))
  
  # resave with derivatives
  grDevices::png(filename = file.path(tempdir(), "temp.full.spectro.png"), height = height, width = wdt, res = res)
  
  # remove margins and make background gray
  graphics::par(mar = rep(0, 4), bg = "gray")
  
  # calculate 2 order derivative
  der.im <- imager::deriche(spc_img, sigma = 3, order = 2, axis="y") 
  
  # plot
  graphics::plot(der.im)
  
  grDevices::dev.off()
  }

  graphics::par(bg = "white")
  
  } else {
  ..level.. <- NA
    
    suppressMessages(ggsp <- seewave::ggspectro(wave = wave_sil, f = wave_sil@samp.rate, wl = wl, ovlp = ovlp) +
      ggplot2::stat_contour(geom = "polygon", ggplot2::aes(fill = ..level..), bins = 30, na.rm = TRUE) + 
      ggplot2::scale_fill_gradientn(name="Amplitude\n(dB)\n", limits = c(-42, 0), guide = FALSE, na.value = "transparent", colours = pal(30)) + 
      ggplot2::scale_x_continuous(expand = c(0, 0)) + 
      ggplot2::scale_y_continuous(expand = c(0, 0), limits = flim) +
      ggplot2::theme(axis.line = ggplot2::element_blank(), axis.text.x = ggplot2::element_blank(), axis.text.y = ggplot2::element_blank(), axis.ticks = ggplot2::element_blank(), axis.title.x = ggplot2::element_blank(), axis.title.y = ggplot2::element_blank(), legend.position = "none"))

    ggplot2::ggsave(plot = ggsp, filename = file.path(tempdir(), "temp.full.spectro.png"), height = height / res, width = wdt / res, units = "in", dpi = res, device = "png", limitsize = FALSE)    
  }
  
  # plot oscillogram
  if (osc){
    grDevices::png(filename = file.path(tempdir(), "temp.full.oscillo.png"), height = height, width = wdt, res = res)
    
    # set plot margins for spectrogram
    graphics::par(mar = rep(0, 4))
    
    # plot spectro
    oscillo_dynaspec_int(wave = wave_sil, f = wave_sil@samp.rate, xaxt = "n", yaxt = "n", colwave = colwave, bg = colbg)
    
    # close plot
    grDevices::dev.off()
  
    # read image
    osc_img <- png::readPNG(source = file.path(tempdir(), "temp.full.oscillo.png"))
    
    }
  
  # read image
  spc_img <- png::readPNG(source = file.path(tempdir(), "temp.full.spectro.png"))
  
  # calculate pixels per second
  px.per.s <- dim(spc_img)[2] / seewave::duration(wave_sil)
  
  # set clusters for windows OS
  if (Sys.info()[1] == "Windows" & parallel > 1)
    cl <- parallel::makePSOCKcluster(getOption("cl.cores", parallel)) else cl <- parallel
  
  #loop to create image files 
  out <- warbleR:::pblapply_wrblr_int(X = seq_len(frames), pbar = pb, function(x){
    
    # time limit
    tlim <- c((x - 1) * step_time, (x - 1) * step_time) - buffer
    
    # fix if negative
    if (tlim[1] < 0) tlim <- c(0, 0)
    
    # add t.display to tlim 2
    tlim[2] <- tlim[2] + t.display
    
    # pixel limt
    img.x.lim <- round(tlim * px.per.s, 0)
    
    # tlim_low are limits for white rectangle in lower spectrogram
    tlim_low <- c((x - 1) * step_time_low, (x - 1) * step_time_low) - buffer * t.display / seewave::duration(wave)
    
    # fix if negative
    if (tlim_low[1] < 0) tlim_low <- c(0, 0)
    
    tlim_low <- tlim_low + c(white_window * -1, white_window) / 2

    # start tiff device
    grDevices::tiff(file.path(tempdir(), img_names[x]),res = res, width = width, height = height)
    
    # set regular margins
    if (axis.type == "none")
      graphics::par(mar =  rep(0, 4)) else
    graphics::par(mar =  c(4.2, 4.2, 1, 1) + 0.1)
    
    # keep original values
    org.flim <- flim
    
    # modify flim if lower spectro
    if (lower.spectro | osc){
      
      # add space at the bottom
      flim[1] <- flim[1] - (flim[2] - flim[1]) * ((height.prop[2]) / (height.prop[1] - height.prop[2]))
    }
    
    # plot anything at specific time and freq
    graphics::plot(0,0, xlim = if(fix.time) c(0, t.display) else tlim, ylim = flim, xlab = "Time (s)", ylab = "Frequency (kHz)", xaxs = "i", yaxs = "i", bty = "o", yaxt = "n")
    
    # get plotting area coordinates
    plt <- graphics::par("plt")
    
    # get plotting area in original units
    usr <- graphics::par("usr")
    
    # add spectrogram segment to plot
    grid::grid.raster(spc_img[, img.x.lim[1]:img.x.lim[2], ], x = plt[1], y =  plt[3] + (plt[4] - plt[3]) * height.prop[2] / height.prop[1], height = (plt[4] - plt[3]) * (1 - height.prop[2] / height.prop[1]), width = plt[2] - plt[1], hjust = 0, vjust = 0)

    # add oscillogram
    if (osc) {
      grid::grid.raster(osc_img[, img.x.lim[1]:img.x.lim[2], ], x = plt[1], y =  plt[3], height = (plt[4] - plt[3]) * (height.prop[2] / height.prop[1]), width = plt[2] - plt[1], hjust = 0, vjust = 0) 
    }
    
    # add play line
    graphics::abline(v = usr[1] + (usr[2] - usr[1]) / 2, lty = lty, col = lcol, lwd = lwd)

    # add spectro at bottom   
    if (lower.spectro) {
      grid::grid.raster(spc_img[, round((t.display / 2) * px.per.s, 0):round(((t.display / 2) + seewave::duration(wave)) * px.per.s, 0), ], x = plt[1], y =  plt[3], height = (plt[4] - plt[3]) * height.prop[2] / height.prop[1], width = plt[2] - plt[1], hjust = 0, vjust = 0)

    #left gray rectangle
    graphics::rect(xleft = if (tlim_low[2] + usr[1] > usr[2] & loop > 1) tlim_low[2] + 2 * usr[1] - usr[2] else 0, ybottom = flim[1], ytop = flim[1] + (flim[2] - flim[1]) * height.prop[2] / height.prop[1], xright = tlim_low[1] + usr[1], col = grDevices::adjustcolor("gray", 0.42), border = NA)

    # right gray rectangle
    if (fix.time)
    graphics::rect(xleft = tlim_low[2] + usr[1], ybottom = flim[1], ytop = flim[1] + (flim[2] - flim[1]) * height.prop[2] / height.prop[1], xright = if(loop > 1 & tlim_low[1] - usr[1] <= 0) usr[2] - (white_window - (tlim_low[2] - usr[1])) else usr[2], col = grDevices::adjustcolor("gray", 0.42), border = NA) else # different time limits when looping
      graphics::rect(xleft = tlim_low[2] + usr[1], ybottom = flim[1], ytop = flim[1] + (flim[2] - flim[1]) * height.prop[2] / height.prop[1], xright = if(loop > 1 & tlim_low[1] - usr[1] <= 0) {usr[2] - (white_window - (tlim_low[2] - usr[1]))
        + if (tlim_low[1] - usr[1] <= 0) tlim_low[2] + usr[1] + (seewave::duration(wave_sil) - white_window) / 2 else 0 
      }  else usr[2], col = grDevices::adjustcolor("gray", 0.42), border = NA)
       
    # box in playing area
    graphics::rect(xleft = tlim_low[1] + usr[1], ybottom = flim[1], ytop = flim[1] + (flim[2] - flim[1]) * height.prop[2] / height.prop[1], xright = tlim_low[2] + usr[1], col = "transparent", lwd = 0.4)

    # rectangle start at the same time that the other disapears
    if (tlim_low[2] + usr[1] > usr[2] & loop > 1)
      graphics::rect(xleft = -1, ybottom = flim[1], ytop = flim[1] + (flim[2] - flim[1]) * height.prop[2] / height.prop[1], xright = tlim_low[2] + 2 * usr[1] - usr[2], col = "transparent", lwd = 0.4)
    }
  
    # add y axis
    frng <- flim[1]:flim[2]
    labs <- pretty(frng, h = 2)
    labs <- labs[labs >= org.flim[1]]
    
    graphics::axis(side = 2, at = labs, labels = labs)
    
    # add lower spectro division line
    if (lower.spectro | osc)
      graphics::abline(h = org.flim[1])
    
    # annotations
    if (!is.null(annotation.call)){
     
      # fix x and y to values relative to usr
      annotation.call$x <- ((usr[2] - usr[1]) * annotation.call$x) + usr[1]
      annotation.call$y <- ((usr[4] - usr[3]) * annotation.call$y) + usr[3]
      
      if (is.null(annotation.call$col)) annotation.call$col <- "black"
      
      # overwrite col in call
      annotation.call$col <- grDevices::adjustcolor(annotation.call$col, alpha.f = ann_alpha[x])
        
      # overwrite label in call
      
      annotation.call$labels <- names(ann_alpha)[x]
      # evaluate call
        eval(annotation.call)
      }
    
    # reprint box
    graphics::box()
  
    grDevices::dev.off()
    
    # if loop > 1 and out of buffer time
    if (loop > 1)
      for (i in 1:loop)
      file.copy(file.path(tempdir(), img_names[x]), file.path(tempdir(), img_names[x + (frames * i)]))
  })
  
  # temporary file names
  temp.audio <- file.path(tempdir(), "audio.scroll.spectro.wav")
  temp.video <- file.path(tempdir(), "scroll.spectro.temp.mp4")
  
  # add buffer as silence
  if (buffer > 0)
    wave <- seewave::pastew(wave2 = tuneR::silence(duration = buffer, samp.rate = wave@samp.rate, xunit = "time"), wave1 = wave, f = wave@samp.rate,output = "Wave")
    
  # change speed
  if (speed != 1)
  { 
    # change rate
    wave@samp.rate <- wave@samp.rate * speed
    fps <- fps * speed  
  }
  
  # add waves as many time as loop
  if (loop > 1)
    for (i in 1:(loop - 1)) 
    {    
      # non-repeated wave
      wave1 <- wave
      wave <- seewave::pastew(wave2 = wave1, wave1 = wave, f = wave@samp.rate,output = "Wave")
}
    
  suppressWarnings(tuneR::writeWave(object = wave, filename = temp.audio, extensible = FALSE))
  
  # resample to 44.1 kHz
  if (wave@samp.rate != 44100){
    temp.audio.rsmp <- gsub(".wav$", ".rsmp.wav", temp.audio) 
    cll_resample <- paste0("ffmpeg -i ", temp.audio, " -ar 44100 ", temp.audio.rsmp)
    out_resmpl <- system(cll_resample, intern = TRUE, ignore.stdout = TRUE, ignore.stderr = TRUE)
    temp.audio <- temp.audio.rsmp # overwrite name
  } 
  
  # put together call for ffmpeg
  cll1 <- paste0("ffmpeg -framerate ", fps, " -i ", tempdir(), "/", paste0("%0", nchar(frames) + 2, "d.temp.img.tiff")," -c:v libx264 -profile:v high -crf 2 -pix_fmt yuv420p -y ", temp.video)
  
  # run ffmpeg to create video
  out1 <- system(cll1, intern = TRUE, ignore.stdout = TRUE, ignore.stderr = TRUE)
  
  # add audio
  cll2 <- paste0("ffmpeg -i ", temp.video, " -i ", temp.audio, " -vcodec libx264 -acodec libmp3lame -shortest -y ", file.name)
  
  # run ffmpeg to add audio
  out2 <- system(cll2, intern = TRUE, ignore.stdout = TRUE, ignore.stderr = TRUE)
  
  # reproduce
  if (play)
  if (.Platform["OS.type"] == "windows") {
    shell.exec(file.name)
  }
  else {
    system(paste(Sys.getenv("R_BROWSER"), file.name), ignore.stdout = TRUE, 
           ignore.stderr = TRUE)
  }
  
}
