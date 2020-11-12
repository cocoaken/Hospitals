//
//  RemoteDataTests.swift
//  HospitalsTests
//
//  Created by ken on 12/11/2020.
//

import XCTest
@testable import Hospitals

class RemoteDataTests: XCTestCase {

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testDataIsTabDelimited() throws {
		// The remote file is called .csv yet isn't comma separated values, it's tab separated values (.tsv / .tab). Check this continues to be the case, otherwise future imports will cease to be able to see the 2nd field onwards per row, and will instead
		
		// Use XCTAssert and related functions to verify your tests produce the correct results.
	}

	func testDataUsesRNLineBreaks() throws {
		// The remote file uses \r\n as its line break. If this ceases to be the case one day, all future imports will grind to a halt (as there'll only appear to be 1 line on the file)
		
		// Use XCTAssert and related functions to verify your tests produce the correct results.
	}

	func testPerformanceExample() throws {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}

}
