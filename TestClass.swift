//
//  TestClass.swift
//  MyFirstProject
//
//  Created by Alex Koblik-Zelter on 10/7/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import XCTest
@testable import MyFirstProject

class TestClass: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test() {
        let dictionary = User(email: "test123@gmail.com", date: "11 11 2019", sex: .other)
        
        XCTAssertEqual(dictionary.date, "")
    }

}
