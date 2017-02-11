//
//  MechtaTests.swift
//  MechtaTests
//
//  Created by Evgeniy Safronov on 08.02.17.
//
//

import XCTest
@testable import Mechta

class MechtaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJson() {
        let expectation = self.expectation(description: "")
        NetworkManager.get("news", onError: onError) {
            print($0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testNews() {
        let expectation = self.expectation(description: "")
        
        let model = AppModel.instance.newsModel
        model.updateNewsInStorage(onError: onError) {
            let saved = model.newsFromStorage()
            _ = saved.map() { print($0.title!) }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func onError(error: NetworkError) {
        print(error)
        XCTFail()
    }
    
}
