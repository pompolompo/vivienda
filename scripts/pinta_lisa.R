# esta función dibuja un mapa de moran con
# un shapefile, un objeto lisa y un título

pinta_lisa = function(s, lisa, tit){
  lisa_colors <- lisa_colors(lisa)
  lisa_labels <- lisa_labels(lisa)
  lisa_clusters <- lisa_clusters(lisa)
  
  plot(st_geometry(s), 
       col=sapply(lisa_clusters, function(x){return(lisa_colors[[x+1]])}), 
       border = "#333333", lwd=0.2)
  title(main = tit)
  legend('bottomright', legend = lisa_labels, fill = lisa_colors, border = "#eeeeee")
  return(invisible())
}
