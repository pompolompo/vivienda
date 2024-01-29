library(sf)
library(readxl)
library(dplyr)
library(stringr)

# se modifican manualmente los nombres de las prvincias que no coinciden en .shp y .xls

# shapefile provincias
shp = read_sf("data/shapefile")
shp = shp["Texto"] %>% rename(prov = Texto)
shp = shp[-which(shp$prov %in% c("Ceuta", "Melilla")),]

# población
pob = read_xls("data/pob.xls", range = "A11:B62", col_names = c("prov", "pob")) %>%
  mutate(prov = str_sub(prov, start = 4))

# total de transacciones
trans = read_xls("data/transac.xls", range = "B14:CC77")[, c(1, 74:77)]
trans[,2] = rowSums(trans[,2:5])
trans = trans[,1:2]
names(trans) = c("prov", "trans")
trans = trans[which(trans$prov %in% shp$prov),]

# precio medio por m^2
preu = read_xls("data/precio.xls", range = "B14:CC74")[, c(1, 74:77)]
preu[,2] = rowMeans(preu[,2:5])
preu = preu[,1:2]
names(preu) = c("prov", "preu")
preu = preu[which(preu$prov %in% shp$prov),]

# parque de viviendas
parc = read_xls("data/parque.xls", range = "B15:BP76")[, c(1, 65:67)]
parc = parc[,-2]
names(parc) = c("prov", "prin", "nprin")
parc = parc[which(parc$prov %in% shp$prov),]

# join todos los datos
shp = left_join(shp, trans, by = "prov") %>%
  left_join(., preu, by = "prov") %>%
  left_join(., parc, by = "prov") %>%
  left_join(., pob, by = "prov")
