//
//  HospitalsTests.swift
//  HospitalsTests
//
//  Created by ken on 12/11/2020.
//

import XCTest
@testable import Hospitals

class HospitalsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	/// Tests the Hospital's hospitalSector is set accordingly for NHS hospitals
    func testHospitalNHSSector() throws {
        let sut = Hospital(organisationID: "1234", organisationCode: "5678", organisationName: "ACME Hospital Inc.")
		sut.sector = "Some NHS Hospital Somewhere" //at this point it should have picked up it's NHS
		
		XCTAssertTrue(sut.hospitalSector != nil && sut.hospitalSector! == .nhs)
    }

	/// Tests the Hospital's hospitalSector is set accordingly for NHS hospitals
	func testHospitalIndependentSector() throws {
		let sut = Hospital(organisationID: "1234", organisationCode: "5678", organisationName: "ACME Hospital Inc.")
		sut.sector = "Some Nondescript Hospital Somewhere" //at this point it should have picked up it's not NHS (because it doesn't contain NHS in "sector")
		
		XCTAssertTrue(sut.hospitalSector != nil && sut.hospitalSector! == .independent)
	}

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
