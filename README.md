# Carry1st Shop - iOS
This is a project undertaken to showcase my skills in iOS development to the team at Carry1st when building iOS Applications by building this E-Commerce App that allows for the purchase of digital credits and lives

![Simulator Screenshot - iPhone 16 Pro - 2024-12-07 at 17 55 31](https://github.com/user-attachments/assets/847a39fb-d188-463f-9096-1cfd04ea880b)
![Simulator Screenshot - iPhone 16 Pro - 2024-12-07 at 17 55 36](https://github.com/user-attachments/assets/64fd44de-27d0-46e0-88e1-6f0bbdeb8bc2)
![Simulator Screenshot - iPhone 16 Pro - 2024-12-07 at 17 55 40](https://github.com/user-attachments/assets/0958912a-91af-40cd-92c2-749da1af4748)
![Simulator Screenshot - iPhone 16 Pro - 2024-12-07 at 17 55 49](https://github.com/user-attachments/assets/62a647a9-e43a-4d32-a31b-88b10a268ff5)
![Simulator Screenshot - iPhone 16 Pro - 2024-12-07 at 17 56 08](https://github.com/user-attachments/assets/582d2d72-26ed-4c96-9365-d09b10583bc6)
![Simulator Screenshot - iPhone 16 Pro - 2024-12-07 at 17 56 48](https://github.com/user-attachments/assets/38a59830-df7c-4299-8d11-5146b7d0cf44)
![Simulator Screenshot - iPhone 16 Pro - 2024-12-07 at 17 56 56](https://github.com/user-attachments/assets/4da2ccfa-5dbc-4409-859d-f052c5a8f349)

## Setup & Running 
The project requires no additional libraries to set up and run. Just ensure you have access to Xcode. This particular project was built using Xcode version 16.1. Once you have that installed and ready, run the _Carry1st Shop.xcodeproj_ file in the _Carry1st Shop_ folder. This will open up the project revealing the code and it's folder structure. Select device you would like to run the project on.

*NB: For physical devices, you will require a paid Developer account so as to register the new bundle ID that the project ships with. You can still test comfortably on the provided Xcode simulators*

## App Functionality
On launch, the Carry1st Shop App makes a call to get products. This happens on initialization of The _ProductsViewModel_. This is then set on the ContentView as an Environment Object (Dependency Injection) to allow for access from any of the Views that will require the observable results within the model. Once the products are fetched, they are displayed on a SwiftUI List. 

Each of the List Items is then linked to a _ProductDetailsView_ that allows for viewing of all the details pertaining to the product. The page also allows one to Add to Cart or Buy Now. The Add to cart adds selected items to cart and one can easily see the cart item counter go up every time an item is added. One can then tap on the Cart button visible on the top left on both the Products page and on the Product Details Page. 

The user can then see the different counts of items within the cart and can choose to either increament or decreament the number of each products added. One can remove an item by decreamenting to zero. 

Usage of RealDB comes in handy here ar we save the product list so as to use even when offline (which the user is notified when accessing the app and it goes offline). The user can even add to cart when offline only that when they get to completing a purchase they might encounter and issue. A _LocalFileManager_ class has also been used to created a folder with the images data which acts as a cache for again when the user is offline and saves them data when they are online as there is no need to constantly redownload the images.

## External Libraries

- RealmDB from [RealmDB](https://github.com/realm/realm-swift.git)

Justification: Showcasing ability to include external libraries and incorporate them withing the apps functionality. It is also very versatile when it comes to storage, updating and usage of any structured data that we might get backend/API service. In this case, it allows for offline storage of Products to allow for browsing through the catalog even without internet. It also helps persist the data in the cart.

## Assumptions

- An assumption made is that the products don't change often and thus does not warrant an occassional background refresh
- Another is that there are only a limited number of products hence no need yet for paginated results which would ease the load if the product catalog was massive

## Endpoints

- [Provided by Carry1st](https://my-json-server.typicode.com/carry1stdeveloper/mock-product-api/productBundles)

## Tech and Structures
- [x] SwiftUI
- [x] URLSession
- [X] RESTful APIs
- [x] SwiftUI Lists
- [x] MVVM Pattern
- [x] RealmDB


