# Machine-Learning-Sample-Code
This is a memorandum for Big Data 2
How much should you charge someone to live in your house? Or how much would you pay to live in someone else’s house? Would you pay more or less for a planned vacation or for a spur-of-the-moment getaway?
This project is meant to help customers know average price of the chosen Airbnb house within given information in order to determine whether the price is reasonable. Our orgianial dataset is from Inside Airbnb http://insideairbnb.com/get-the-data.html.
## Start from Data Processing and Data Cleaning
Trifacta Cleaning
1. cleaned column with all NA or empty or just several useless values: thumbnail_url,
medium_url, xl_picture_url, neighbourhood_group_cleansed, experiences_offered,
host_acceptance_rate, license, jurisdiction_names
2. cleaned column with meaningless same value throughout the sheet: scrape_id,
neighbourhood, city, market, smart_location, country_code, street, host_location, host_neighbourhood, host_listings_count, calendar_last_scraped, has_availability, requires_license, is_business_travel_ready
3. delete all text description and pictures( we might add them back in next stages analysis if we decide to go fancy and applying some NLP, for no we only look at those numeric variables: name, summary, space, description, neighborhood_overview, notes, transit, access, interaction, house_rules, host_about
4. Delete all urls which we might also add back later but for now just useless: picture_url, host_thumbnail_url, host_picture_url
5. Delete listing_url(= https://www.airbnb.com/rooms/listing_id), host_url(=https:// www.airbnb.com/users/show/host_id)totally meaningless.
6. Although we only leave numbers and deleted both, just a reminder, summary and description are very similar column.
7. Change the data type of “reply rate” to numbers and replace N/A to average value.
8. Make all empty or 0 value in host_total_listings_count / square_feet /amenities/square_feet
as NULL
9. Delete “” and space in the amenities text and host_verifications
10. Clean the empty and “” value in zip code to NULL, for some zip code longer than 5 digit,
only leave the first five digit, all Boston area zip code should start with 0, make those wired
zip code NULL as well.
11. I don think we care about the maximum_night we should only care about the minimum
night at this case( if I am wrong we can add it back anyway, but for now let’s just delete
other column.
12. Calculate the average price by host and add as a new column by left join.
13. Still looking for a way to turn amenities and host_verifications into factors but I think that’s
pretty much good for now.
## Applied linear regression/logistic regression/KNN
For Logistic Regression:
• Check for outliers.
• Each predictor should have a p-value statistical significance less than 0.05.
• Interpretation: For each predictor, look at the exp(B) column, i.e., the log odds. Compare the
value against 1.0. Less than 1.0 means a decrease of 1.0-exp(B) percent. Greater than 1.0 means an increase of exp(B)-1.0 percent vs. the baseline category.
1, Logistic Model is not that accuracy to predict high score with Specificity smaller than Sensitivity.
2, From above we can get some wired but interesting insight, the host should respond less diligent/Provide not too many Amenities/not instant bookable/set strict cancellation policy to increase their review score. In our view, this might have an internal cause or origin “endogenous” it is not that hosts don’t response get a higher score but those low score hosts want to change their business so they will respond more frequently, which finally makes the “Response-Low Score” relationship.
## KNN/Classification Tree/Random Forest Classification
The optimal classification tree has 9 leaves, but our optimal KNN has the k of 47. This means the optimal KNN outputs more specific categories, though KNN’s accuracy is not higher than classification tree.
The classification tree’s split criteria are similar to logistic regression, which indicates that they are reinforcing each other. For example, based on the classification tree, higher response rate can improve review score and we see the same pattern in logisic model. Similarily, both models suggest listings in neighborhoods such as Brighton, East Boston, Fenway and Hyde Park have advantages on obtaining higher scores. Similar pattern is observed in KNN.
