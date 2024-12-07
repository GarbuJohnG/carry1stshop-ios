//
//  Carry1st_ShopUITests.swift
//  Carry1st ShopUITests
//
//  Created by John Gachuhi on 03/12/2024.
//

import XCTest
@testable import Carry1st_Shop

final class Carry1st_ShopUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testProductListDisplaysCorrectData() {
        
        let mockProducts = MockData.sampleProducts
        let viewModel = ProductViewModel()
        viewModel.products = mockProducts
        
        let view = ContentView()
            .environmentObject(viewModel)
        
        for product in mockProducts {
            XCTAssertTrue(view.accessibilityElements.contains { element in
                  element.label?.contains(product.name) ?? false
                }, "List should display product names")
        }
    }
    
    func testOfflineBannerIsShown() {
        let viewModel = ProductViewModel()
        viewModel.isOffline = true
        let view = ContentView()
            .environmentObject(viewModel)
        XCTAssertTrue(view.accessibilityElements.contains { element in
            element.label?.contains("You are offline") ?? false
        }, "Offline banner should be visible when offline")
    }
    
    func testProductListDisplaysCorrectData() {
        let mockProducts = MockData.sampleProducts
        let viewModel = ProductViewModel()
        viewModel.products = mockProducts
        let view = ContentView()
            .environmentObject(viewModel)
        for product in mockProducts {
            XCTAssertTrue(view.accessibilityElements.contains { element in
                element.label?.contains(product.name) ?? false
            }, "List should display product names")
        }
    }


    
}

class MockNetworkService: NetworkService {
    
    let mockData: [Product]?
    let shouldFail: Bool
    
    init(mockData: [Product]? = nil, shouldFail: Bool = false) {
        self.mockData = mockData
        self.shouldFail = shouldFail
    }
    
    override func fetchData<T>(endpoint: String, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        if shouldFail {
            completion(.failure(NSError(domain: "Test Error", code: 1, userInfo: nil)))
        } else if let mockData = mockData as? T {
            completion(.success(mockData))
        }
    }
    
}


struct MockData {
    static let sampleProducts = [
        Product(id: 1, name: "Product 1", description: "Description 1", price: 10.0, currencyCode: "USD", currencySymbol: "$", quantity: 100, imageLocation: "image1.jpg", status: "available"),
        Product(id: 2, name: "Product 2", description: "Description 2", price: 20.0, currencyCode: "USD", currencySymbol: "$", quantity: 200, imageLocation: "image2.jpg", status: "available")
    ]
}
