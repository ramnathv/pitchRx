#' Visualize PITCHf/x strikezones
#' 
#' Pitch locations as they crossed home plate.
#' 
#' Scatterplot with "px" on the horizonatl axis and "pz" on the vertical axis.
#'
#' @param data PITCHf/x data to be visualized.
#' @param layer list of other ggplot2 (layered) modifications.
#' @param geom type of geometry used for plotting.
#' @param point.color variable used to control coloring scheme when \code{geom = "point"}.
#' @param point.alpha variable used to control alpha when \code{geom = "point"}.
#' @param point.size control size of "points". Theoretically, this should be based on the distance from home plate (ie, \code{snapshot$y})
#' @return Returns a ggplot2 object.
#' @export
#' @examples
#' #value
#' 

strikeFX <- function(data, layer = list(), geom = "point", point.color = aes(color = pitch_types), point.alpha = aes(alpha = 0.5), point.size = 100){ 
  #Add descriptions to pitch_types
  if (!geom %in% c("point", "hex", "density2d", "tile")) warning("Current functionality is designed to support the following geometries: 'point', 'hex', 'density2d', 'tile'.")
  if (!"pitch_type" %in% names(data)) warning("Make sure you have the appropriate 'pitch_type' column. If you don't have 'pitch_type', consider using ggFX()")
  types <- cbind(pitch_type=c("SI", "FF", "IN", "SL", "CU", "CH", "FT", "FC", "PO", "KN", "FS", "FA", NA, "FO"),
                 pitch_types=c("Sinker", "Fastball (four-seam)", "Intentional Walk", "Slider", "Curveball", "Changeup", 
                               "Fastball (two-seam)", "Fastball (cutter)", "Pitchout", "Knuckleball", "Fastball (split-finger)",
                               "Fastball", "Unknown", "Fastball ... (FO?)"))
  pitchFX <- merge(data, types, by = "pitch_type")
  locations <- c("px", "pz")
  FX <- pitchFX[complete.cases(pitchFX[,locations]),] #get rid of records missing the necessary parameters
  for (i in locations)
    FX[,i] <- as.numeric(FX[,i])
  layers <- as.character(as.list(match.call())$layer)
  facet <- layers[grep("facet", layers)]
  facets <- gsub("[)]", "", gsub("facet_[a-z]+[(]","", facet))
  facets2 <- llply(str_split(as.character(facets), "~"), str_trim)
  facets3 <- unlist(llply(facets2, function(x) { x[!x %in% "."] }))
  if (length(facet) == 0) facets3 <- NULL
  color <- layers[grep("color", layers)]
  if (length(color) == 0) color <- "pitch_type"
  if ("p_throws" %in% names(FX)) FX$p_throws <- paste("Pitcher Throws:", FX$p_throws) #Add suffixes for context
  if ("stand" %in% names(FX)) FX$stand <- paste("Batter Stands:", FX$stand)
  if ("b_height" %in% names(FX)) {
    boundaries <- getStrikezones(FX, facets3, strikeFX = TRUE) #Strikezone boundaries
  } else warning("Strikezones and location adjustments depend on the stance (and height) of the batter. Make sure these variables are being entered as 'stand' and 'b_height', respectively.")
  #   if (!is.null(freeze)) {
  #     n <- dim(snapshots)[2]
  #     if (freeze == "first") snapshot <- data.frame(snapshots[,1,], other)
  #     if (freeze == "last") snapshot <- data.frame(snapshots[,n,], other)
  #     names(snapshot) <- c("x", "y", "z", names(other))
  #     p <- ggplot() + xlim(-3.5, 3.5) + xlab("Horizontal Pitch Location") + ylim(0, 7) + ylab("Height from Ground") + scale_size(guide="none") + scale_alpha(guide="none") + scale_color_brewer(palette="Set2")
  #     if (geom %in% "point") p <- p + layer(data = snapshot, mapping = aes(x = x, y = z, size = 100 - y), geom = geom) + aes(alpha = 0.5, color = pitch_type)
  #     if (geom %in% c("hex", "density2d")) p <- p + layer(data = snapshot, mapping = aes(x = x, y = z), geom = geom)
  #     if (geom %in% "tile") p <- p + geom_tile(data = snapshot, mapping = aes(x = x, y = z, fill = ..count..))
  #     print(p + geom_rect(data = boundaries, aes(ymax = top, ymin = bottom, xmax = right, xmin = left), alpha = 0.2, color="grey20") #draw strikezones
  #           + layer)
  #   } else {
  FX$pz_adj <- boundaries[[1]] #adjusted vertical locations
  for (i in locations)
    FX[,i] <- as.numeric(FX[,i])
  p <- ggplot() + xlim(-3.5, 3.5) + xlab("Horizontal Pitch Location") + ylim(0, 7) + ylab("Height from Ground") + scale_size(guide = "none") + scale_alpha(guide="none") + theme(legend.position = "bottom", legend.direction = "horizontal") + scale_color_brewer(palette="Set2")
  if (geom %in% "point") {
    FX$sizes <- point.size
    p <- p + layer(data = FX, mapping = aes(x = px, y = pz_adj, size = sizes), geom = geom) + point.color + point.alpha #+ aes(...) #+ scale_size_continuous(limits=c(min(sizes), max(sizes)))
  }
  if (geom %in% c("hex", "density2d")) p <- p + layer(data = FX, mapping = aes(x = px, y = pz_adj), geom = geom)
  if (geom %in% "tile") p <- p + geom_tile(data = FX, mapping = aes(x = px, y = pz_adj, fill = ..count..))
  print(p + geom_rect(data = boundaries[[2]], aes(ymax = top, ymin = bottom, xmax = right, xmin = left), alpha = 0.2, color="grey20") #draw strikezones
        + layer)
}