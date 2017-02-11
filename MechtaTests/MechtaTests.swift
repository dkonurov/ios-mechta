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
        model.newsFromNetwork(onError: onError) {
            print($0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testExcursions() {
        let expectation = self.expectation(description: "")
        let model = AppModel.instance.excursionsModel
        model.excursionsFromNetwork(onError: onError) {
            print($0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testOffers() {
        let expectation = self.expectation(description: "")
        let model = AppModel.instance.offersModel
        model.offersFromNetwork(onError: onError) {
            print($0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testServices() {
        let expectation = self.expectation(description: "")
        let model = AppModel.instance.servicesModel
        model.servicesFromNetwork(onError: onError) {
            print($0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testNotifications() {
        let expectation = self.expectation(description: "")
        let model = AppModel.instance.notificationsModel
        model.notificationsFromNetwork(onError: onError) {
            print($0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func onError(error: NetworkError) {
        print(error)
        XCTFail()
    }
    
}
