# Carry1st Shop - iOS
This is a project undertaken to showcase my skills in iOS development to the team at Carry1st when building iOS Applications by building this E-Commerce App that allows for the purchase of digital credits and lives

## Setup & Running 
The project requires no additional libraries to set up and run. Just ensure you have access to Xcode. This particular project was built using Xcode version 16.1. Once you have that installed and ready, run the _Carry1st Shop.xcodeproj_ file in the _Carry1st Shop_ folder. This will open up the project revealing the code and it's folder structure. Select device you would like to run the project on.

*NB: For physical devices, you will require a paid Developer account so as to register the new bundle ID that the project ships with. You can still test comfortably on the provided Xcode simulators*

## App Functionality
On launch, the Carry1st Shop App makes a call to get products. This happens on initialization of The _ProductsViewModel_. This is then set on the ContentView as an Environment Object (Dependency Injection) to allow for access from any of the Views that will require the observable results within the model. Once the products are fetched, they are displayed on a SwiftUI List. 

Each of the List Items is then linked to a _ProductDetailsView_ that allows for viewing of all the details pertaining to the product. The page also allows one to Add to Cart or Buy Now. The Add to cart adds selected items to cart and one can easily see the cart item counter go up every time an item is added. One can then tap on the Cart button visible on the top left on both the Products page and on the Product Details Page. 

The user can then see the different counts of items within the cart and can choose to either increament or decreament the number of each products added. One can remove an item by decreamenting to zero. 

## Endpoints

- [Provided by Carry1st](https://my-json-server.typicode.com/carry1stdeveloper/mock-product-api/productBundles)

## Tech and Structures
- [x] SwiftUI
- [x] URLSession
- [X] RESTful APIs
- [x] SwiftUI Lists
- [x] MVVM Pattern


