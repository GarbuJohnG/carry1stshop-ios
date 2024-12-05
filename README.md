# Carry1st Shop - iOS
This is a project undertaken to showcase my skills in iOS development to the team at Carry1st when building iOS Applications by building this E-Commerce App that allows for the purchase of digital credits and lives

## Setup & Running 
The project requires no additional libraries to set up and run. Just ensure you have access to Xcode. This particular project was built using Xcode version 16.1. Once you have that installed and ready, run the _Carry1st Shop.xcodeproj_ file in the _Carry1st Shop_ folder. This will open up the project revealing the code and it's folder structure. Select device you would like to run the project on.

*NB: For physical devices, you will require a paid Developer account so as to register the new bundle ID that the project ships with. You can still test comfortably on the provided Xcode simulators*

## App Functionality
On launch, the Carry1st Shop App makes a call to get products. This happens on initialization of The _ProductsViewModel_. This is then set as an Environment Object to allow for access from any of the Views that will require the observable results within the model.

## Endpoints

- [Provided by Carry1st](https://my-json-server.typicode.com/carry1stdeveloper/mock-product-api/productBundles)

## Tech and Structures
- [x] SwiftUI
- [x] URLSession
- [X] RESTful APIs
- [x] SwiftUI Lists
- [x] MVVM Pattern


