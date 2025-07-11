let res = db._query(`
LET Z1 = 5  LET Z2 = 10 LET CLON = -118.0614431 LET CLAT = 34.068509    
LET AB1 = (     
  FOR cell IN Finedust_idx         
  FILTER (Z1 <= cell.timestamp) AND (cell.timestamp <= Z2)         
  LET win = (             
    FOR wcell IN Finedust_idx                  
    FILTER (cell.timestamp == wcell.timestamp) AND ((cell.latitude - 2) <= wcell.latitude) AND (wcell.latitude <= (2 + cell.latitude)) AND ((cell.longitude - 2) <= wcell.longitude) AND (wcell.longitude <= (2 + cell.longitude))
    RETURN wcell.pm10             
  )                      
  RETURN { latitude: cell.latitude, longitude: cell.longitude, pm10_sum: SUM(win[*]), pm10_count: COUNT(win[*])}      
)    
LET AB = (     
  FOR cell IN AB1         
  COLLECT latitude = cell.latitude, longitude = cell.longitude INTO g                  
  RETURN { coordinates: [-118.34501002237936 + (longitude * 0.000216636), 34.011898718557454 + (latitude * 0.000172998)], pm10_avg : (SUM(g[*].cell.pm10_sum) / SUM(g[*].cell.pm10_count))}       
)  
LET C = ( 
  FOR cell IN AB 
  SORT cell.pm10_avg DESC  
  LET s1 = ( 
    FOR site IN Site             
    FILTER site.properties.type == 'roadnode'             
    SORT GEO_DISTANCE([CLON, CLAT], site.geometry) ASC                 
    LIMIT 1                 
    RETURN site 
  ) 
  LET src = ( 
    FOR node IN Roadnode 
    FILTER s1[0].site_id == node.site_id 
    LIMIT 1 
    RETURN node 
  ) 
  LET s2 = ( 
    FOR site IN Site             
    FILTER site.properties.type == 'roadnode'             
    SORT GEO_DISTANCE([cell.coordinates[0], cell.coordinates[1]], site.geometry) ASC             
    LIMIT 1                 
    RETURN site 
  ) 
  LET dst = ( 
    FOR node IN Roadnode 
    FILTER s2[0].site_id == node.site_id 
    LIMIT 1 
    RETURN node 
  )  
  LET path = ( 
    FOR v, e IN OUTBOUND SHORTEST_PATH src[0] TO dst[0] GRAPH 'Road_Network' OPTIONS {weightAttribute: 'distance'}         
    RETURN {v, e} 
  )  
  LIMIT 1 
  RETURN path 
)  
RETURN Length(C[0])
`);
let res2 = res.getExtra();

print(res);
print(res2['stats']['executionTime']);
