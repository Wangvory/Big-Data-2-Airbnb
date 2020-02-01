calendar<-read.csv("/Users/zhoujiawang/Desktop/Brandeis Life/BigData2/ABB Data Raw/calendar.csv")
listings<-read.csv("/Users/zhoujiawang/Desktop/Brandeis Life/BigData2/ABB Data Raw/listings.csv")
setwd("/Users/zhoujiawang/Desktop/Brandeis Life/BigData2/ABB Data Raw")
#delete duplicate cols
colnames(listings)
#"thumbnail_url","medium_url","xl_picture_url" Ect is a col with all NAS,
ix1 <- which(colnames(listings) %in% c("thumbnail_url","medium_url","xl_picture_url","neighbourhood_group_cleansed",
                                       "experiences_offered","host_acceptance_rate","jurisdiction_names",))
listclean <- listings[, -ix1]
#Drop Duplicated Information(City,State,Country)
ix2 <- which(colnames(listings) %in% c("neighbourhood","city","market","smart_location","country",
                                       "street","host_location","host_neighbourhood","host_listings_count","calendar_last_scraped"))
listclean <- listclean[, -ix2]
#last scraped always 2019/7/14 and I don't think thats important
listclean <- listclean[, -4]
