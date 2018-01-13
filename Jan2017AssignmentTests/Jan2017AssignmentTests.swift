//
//  Jan2017AssignmentTests.swift
//  Jan2017AssignmentTests
//
//  Created by Brendan Seabrook on 2018-01-13.
//  Copyright © 2018 Brendan Seabrook. All rights reserved.
//

import XCTest
@testable import Jan2017Assignment

class Jan2017AssignmentTests: XCTestCase {
    
    func testYelpAPI() {
        YelpDataProvider.shared.processResponse(data: YelpTesting.getMockedResponse(forCondition: .Normal)!, completion: { (restaurants, error) in
            XCTAssert(error == nil, "Should not produce error")
            XCTAssert(restaurants != nil, "Restaurants should be present")
            XCTAssert(restaurants?.count == 3, "There should be 3 restaurants present")
        })
        
        YelpDataProvider.shared.processResponse(data: YelpTesting.getMockedResponse(forCondition: .BadAPIKey)!) { (restaurants, error) -> (Void) in
            XCTAssert(error != nil, "Should have error")
            XCTAssert(error == .BadAPIKey, "Should be BadAPIKey error not \(String(describing: error!.self))")
        }
        
        YelpDataProvider.shared.processResponse(data:
        YelpTesting.getMockedResponse(forCondition: .MalformedRequest)!) { (restaurants, error) -> (Void) in
            
            XCTAssert(error != nil, "Should have error")
            XCTAssert(error == .BadRequest, "Should be BadRequest error not \(String(describing: error!.self))")
        }
        
        YelpDataProvider.shared.processResponse(data:
        YelpTesting.getMockedResponse(forCondition: .MalformedResponse)!) { (restaurants, error) -> (Void) in
            
            XCTAssert(error != nil, "Should have error")
            XCTAssert(error == .BadResponse , "Should be BadResponse error not \(String(describing: error!.self))")
        }
    }
}

enum RestaurantDataProviderOperatingCondition {
    case Normal
    case BadAPIKey
    case MalformedRequest
    case MalformedResponse
}

protocol RestaurantDataProviderTests {
    static func getMockedResponse(forCondition:RestaurantDataProviderOperatingCondition) -> Data?
}

class YelpTesting : RestaurantDataProviderTests {
    static func getMockedResponse(forCondition condition: RestaurantDataProviderOperatingCondition) -> Data? {
        let bundle = Bundle(for: self)
        let filePath:String?
        switch condition {
        case .Normal:
            filePath = bundle.path(forResource: "NormalMock", ofType: "json")
        case .BadAPIKey:
            filePath = bundle.path(forResource: "BadAPIKeyMock", ofType: "json")
        case .MalformedRequest:
            filePath = bundle.path(forResource: "MalformedRequestMock", ofType: "json")
        case .MalformedResponse:
            filePath = bundle.path(forResource: "MalformedResponseMock", ofType: "json")
        }
        
        return try? Data(contentsOf: URL(fileURLWithPath: filePath!))
    }
}
