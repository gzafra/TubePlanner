//
//  TubePlannerTests.swift
//  TubePlannerTests
//
//  Created by Guillermo Zafra on 30/05/2017.
//  Copyright © 2017 gzp. All rights reserved.
//

import XCTest
@testable import TubePlanner

class TubePlannerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        guard let data = DataManager.offlineData else {
            XCTFail("Failed to load offline data")
            return
        }
        
        DataManager.shared.loadData(data)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLineSimple() {
        let cheapestRoute = DataManager.shared.graphMap.calculateRouteFrom("East end", to: "South Park")
        XCTAssert(cheapestRoute != nil)
        XCTAssert(cheapestRoute!.cost == 6)
        XCTAssert(cheapestRoute!.stations.last!.name == "South Park")
        
    }
    
    func testLineSimpleBackwards() {
        let cheapestRoute = DataManager.shared.graphMap.calculateRouteFrom("South Park", to: "East end")
        XCTAssert(cheapestRoute != nil)
        XCTAssert(cheapestRoute!.stations.last!.name == "East end")
        XCTAssert(cheapestRoute!.cost == 6)
    }
    
    func test1Change() {
        let cheapestRoute = DataManager.shared.graphMap.calculateRouteFrom("East end", to: "Trinity lane")
        XCTAssert(cheapestRoute != nil)
        XCTAssert(cheapestRoute!.stations.last!.name == "Trinity lane")
        XCTAssert(cheapestRoute!.cost == 11)
    }
    
    func test1ChangeBackwards() {
        let cheapestRoute = DataManager.shared.graphMap.calculateRouteFrom("Smith lane", to: "East end")
        XCTAssert(cheapestRoute != nil)
        XCTAssert(cheapestRoute!.stations.last!.name == "East end")
        XCTAssert(cheapestRoute!.cost == 11)
    }
    
    func test2Changes() {
        let cheapestRoute = DataManager.shared.graphMap.calculateRouteFrom("Matrix stand", to: "Gotham street")
        XCTAssert(cheapestRoute != nil)
        XCTAssert(cheapestRoute!.stations.last!.name == "Gotham street")
        XCTAssert(cheapestRoute!.cost == 14)
    }
    
    func test2ChangesBackwards() {
        let cheapestRoute = DataManager.shared.graphMap.calculateRouteFrom("Gotham street", to: "Matrix stand")
        XCTAssert(cheapestRoute != nil)
        XCTAssert(cheapestRoute!.stations.last!.name == "Matrix stand")
        XCTAssert(cheapestRoute!.cost == 14)
    }
    
    func testAssignmentSample1() {
        let cheapestRoute = DataManager.shared.graphMap.calculateRouteFrom("East end", to: "Peter Park")
        XCTAssert(cheapestRoute != nil)
        XCTAssert(cheapestRoute!.stations.last!.name == "Peter Park")
        XCTAssert(cheapestRoute!.cost == 4)
    }
    
    func testAssignmentSample2() {
        let cheapestRoute = DataManager.shared.graphMap.calculateRouteFrom("Green Cross", to: "Neo lane")
        XCTAssert(cheapestRoute != nil)
        XCTAssert(cheapestRoute!.stations.last!.name == "Neo lane")
        XCTAssert(cheapestRoute!.cost == 6)
    }
    
    func testAssignmentSample3() {
        let cheapestRoute = DataManager.shared.graphMap.calculateRouteFrom("Stadium House", to: "East end")
        XCTAssert(cheapestRoute != nil)
        XCTAssert(cheapestRoute!.stations.last!.name == "East end")
        XCTAssert(cheapestRoute!.cost == 5)
    }
    
}
