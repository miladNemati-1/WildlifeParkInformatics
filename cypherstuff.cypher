//import from csvs
LOAD CSV WITH HEADERS FROM "file:///wildlife_a2.csv" as wildlife
LOAD CSV WITH HEADERS FROM "file:///parks_a2.csv" as parks
MERGE (park: Park {parkid: parks.ParkID, area: toInteger(parks.AreaInAcres), latitude: toInteger(parks.Latitude), longitude: toInteger(parks.Longitude), statecode: parks.StateCode, parkestday: toInteger(parks.ParkEstDay), parkestmonth: toInteger(parks.ParkEstMonth), parkestyear: toInteger(parks.ParkEstYear), parkname: parks.ParkName})
MERGE (animals: Wildlife {speciesid: wildlife.SpeciesID, parkname: wildlife.ParkName, scientificName: wildlife.ScientificName, commonames: Split(wildlife.CommonNames, ","), recordstatus: wildlife.RecordStatus, occurrence: wildlife.Occurrence, nativeness: wildlife.Nativeness})
MERGE (category: Category {category: wildlife.Category})

MERGE (order: Order {ordername: wildlife.Order})

MERGE (family: Family {familyname: wildlife.Family})

MERGE (conservationstatus: ConservationStatus {conservationstatusname: wildlife.ConservationStatus})
MERGE (seasonality: Seasonality {seasonalityname: wildlife.Seasonality})
MERGE (abundance: Abundance {abundancename: wildlife.Abundance})

MERGE (park) -[:has]-> (animals)
MERGE (animals) -[:category_is]-> (category)
MERGE (animals) -[:order_is]-> (order)
MERGE (animals) -[:family_is]-> (family)
MERGE (animals) -[:conservationstatus_is]-> (conservationstatus)
MERGE (animals) -[:seasonality_is]-> (seasonality)
MERGE (animals) -[:abundance_is]-> (abundance)

//////ANd then 

MATCH (p:Park), (w:Wildlife) WHERE p.parkname = w.wildlife MERGE (p) -[:has]-> (w)




///////Count the number of species in each family. Display the counting result in descending order and limit the top 5 in the output


MATCH (animal:Wildlife)-[:family_is]->(family:Family) WITH family, count(animal) as NoSpecies RETURN family, NoSpecies ORDER BY NoSpecies DESC LIMIT 5

/////// Show all unique ScientificNames that with conditions of ‘BIRD’ category, ‘PASSERIFORMES’ order and ‘PRESENT’ occurrence in ascending order and lower case

MATCH (animal:Wildlife)-[a:category_is]->(Category: Category ) WHERE Category.category = "BIRD"
MATCH (animal)-[o:order_is]->(order: Order ) WHERE order.ordername = "PASSERIFORMES" 
MATCH (animal) WHERE animal.occurrence = "PRESENT" RETURN DISTINCT toLower(animal.scientificName) ORDER BY toLower(animal.scientificName)

//////Count the number of species of each Park with a range of 90,000 - 210,000 (both inclusive) AreaAcres


MATCH (park:Park)-[h:has]->(a: Wildlife )  WHERE park.area <= 210000 AND park.area >= 90000 WITH park, count(a) as noSpecies  RETURN park, noSpecies

///List all unique categories that contain ‘YELLOW’ as part of the content in CommonNames.

MATCH (animal:Wildlife)-[ci:category_is]->(c: Category ) WHERE ANY (name IN animal.commonames WHERE name=~ '(?i).*YELLOW.*') RETURN DISTINCT c;

///////







