//
//  Carry1st_ShopUITestsLaunchTests.swift
//  Carry1st ShopUITests
//
//  Created by John Gachuhi on 03/12/2024.
//

import XCTest
@testable import Carry1st_Shop

final class Carry1st_ShopUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    // MARK: ProductViewModel Tests
    
    func testViewModelInitializationLoadsOfflineProducts() {
        let viewModel = ProductViewModel()
        let products = viewModel.products
        XCTAssertFalse(products.isEmpty, "Products should not be empty if offline data is present")
    }
    
    func testFetchProductsSuccess() {
        let mockService = MockNetworkService(mockData: MockData.sampleProducts)
        let viewModel = ProductViewModel(networkService: mockService)
        viewModel.fetchProducts()
        XCTAssertFalse(viewModel.products.isEmpty, "Products should be fetched successfully")
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil on success")
    }
    
    func testFetchProductsFailure() {
        let mockService = MockNetworkService(shouldFail: true)
        let viewModel = ProductViewModel(networkService: mockService)
        viewModel.fetchProducts()
        XCTAssertTrue(viewModel.products.isEmpty, "Products should be empty on failure")
        XCTAssertNotNil(viewModel.errorMessage, "Error message should not be nil on failure")
    }
    
    func testUpdateLocalDatabase() {
        let mockProducts = MockData.sampleProducts
        let viewModel = ProductViewModel()
        viewModel.updateLocalDatabase(with: mockProducts)
        let realm = try! Realm()
        let realmProducts = realm.objects(ProductRealm.self)
        XCTAssertEqual(realmProducts.count, mockProducts.count, "Realm should store the correct number of products")
    }

    func testOfflineStateWhenNoNetwork() {
        let monitor = MockNetworkMonitor(isOnline: false)
        let viewModel = ProductViewModel(networkMonitor: monitor)
        let isOffline = viewModel.isOffline
        XCTAssertTrue(isOffline, "ViewModel should set offline state when no network is available")
    }
    
    // MARK: NetworkService Tests

    func testNetworkServiceFetchDataSuccess() {
        let mockService = MockNetworkService(mockData: MockData.sampleProducts)
        mockService.fetchData(endpoint: "dummyEndpoint", responseType: [Product].self) { result in
            switch result {
            case .success(let products):
                XCTAssertEqual(products.count, MockData.sampleProducts.count, "Should return the correct number of products")
            case .failure:
                XCTFail("API call should not fail")
            }
        }
    }
    
    func testNetworkServiceFetchDataFailure() {
        let mockService = MockNetworkService(shouldFail: true)
        mockService.fetchData(endpoint: "dummyEndpoint", responseType: [Product].self) { result in
            switch result {
            case .success:
                XCTFail("API call should fail")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should not be nil on failure")
            }
        }
    }
    
    // MARK: Realm Tests

    func testRealmSaveProducts() {
        let mockProducts = MockData.sampleProducts
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
            for product in mockProducts {
                realm.add(ProductRealm(from: product))
            }
        }
        let savedProducts = realm.objects(ProductRealm.self)
        XCTAssertEqual(savedProducts.count, mockProducts.count, "Realm should save the correct number of products")
    }

    func testRealmLoadProducts() {
        let realm = try! Realm()
        let viewModel = ProductViewModel()
        let products = viewModel.products
        XCTAssertEqual(products.count, realm.objects(ProductRealm.self).count, "ViewModel should load all products from Realm")
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

