# Recommendation System using Beacons
Aim of this project is to design a Recommendation System using Beacons to provide location-based recommendations to customers for Grocery Stores.

This Repo includes:

Smart Shopping (Xcode Project) - This is the front end of the application which an iPhone App. This app continiously monitors the users location within the store and as soon as user enters in a particular beacon region, recommendation system is triggered using the REST APIs.

CMPEDataMiningProject - This is the Spring project that is used to write the REST APIs using Spring Framework. We have demonstrated 3 APIS (1. Trending product in a particular aisle, 2. Recommended products for the customer based on previous buying habits, 3. Trending product in the store)

Datasets folder contains 3 datasets, "Product list.csv" - Mapping of products into categories, "Transaction.csv" - Trasactional data for the store, "beacons.csv" - Beacons dataset for the system

Scrips folder included different scirpts written using R Framework to provide fuctionalities behind the 3 REST calls

Others documents are the research paper and presentation, project report and presentation.

Team size - 4
Number of beacons - 3
Technologies/Tools - Objective-C, Spring Framework, MongoDB, Apriori Algorithm, MapReduce Pattern, R Framework, Amazon EC2.
 