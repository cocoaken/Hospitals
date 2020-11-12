//
//  Hospital.swift
//  Hospitals
//
//  Created by ken on 12/11/2020.
//

import Foundation

class Hospital {
	
	enum HospitalSector: CaseIterable, RawRepresentable { //used for search bar scopes
		case all
		case nhs
		case independent
		
		//MARK: - HospitalSector RawRepresentable protocol
		
		typealias RawValue = String
		
		init?(rawValue: RawValue) {
		  switch rawValue {
		  case "All": self = .all
		  case "NHS": self = .nhs
		  case "Independent": self = .independent
		  default: return nil
		  }
		}
		
		var rawValue: RawValue {
		  switch self {
		  case .all: return "All"
		  case .nhs: return "NHS"
		  case .independent: return "Independent"
		  }
		}
	  }
	
	//I'll assume the following are non-optional fields (and that therefore the .csv file must contain values for them for all hospital objects)
	let organisationID: String //I'll assume this is not optional (i.e. like a primary key in a database) and doesn't change once created. It looks (from the file) numerical, and is presumably unique per hospital, although for the sake of the sample app I'm doing no validation checking for uniqueness. I could implement this using eg. class methods to check all instances of the class to determine if a given ID is already in use (in which case it's not unique), or better still a proper database storage mechanism eg. Core Data, which can specify unique constraints. I've never used Realm (it was in the job spec) but it looks like that has similar functionality
	let organisationCode: String //I'll assume this is not optional and doesn't change once created
	let organisationName: String //I'll assume this is not optional and doesn't change once created

	//I'll assume the rest of the fields listed in the .csv header are optional, and that the .csv might not have data in these fields for every hospital (eg. not all hospitals might have a website listed etc.)
	var organisationType: String? = nil
	var subType: String? = nil
	var sector: String? = nil
	var hospitalSector: HospitalSector? = nil //used for searching by NHS / Independent. Set during import based on text value of "sector"
	var organisationStatus: String? = nil
	var isPimsManaged: Bool? = nil //I don't know what this means, so I'll assume it is allowed to be optional rather than set it to either true or false by default (in case that has repercussions that I'm not aware of)
	var address1: String? = nil
	var address2: String? = nil
	var address3: String? = nil
	var city: String? = nil
	var county: String? = nil
	var postcode: String? = nil //this could in theory be validated using Core Location's forward geocoding to check the postcode exists
	var latitude: Double? = nil //Double so it can be used by Core Location (CLLocationDegrees is a typealias for a Double)
	var longitude: Double? = nil //Double so it can be used by Core Location (CLLocationDegrees is a typealias for a Double)
	var parentODSCode: String? = nil
	var parentName: String? = nil
	var phone: String? = nil //this could be an Int, but the data might not always be purely numerical (eg. it could be "01234 567891 x234" (contains spaces and an "x"))
	var email: String? = nil //this could be validated (eg. using Regex to check it's an e-mail format, using DNS to check the host exists) but the data might not be expected to be clean (eg. it could be "person1@company.com Mon-Weds, person2@company.com Thurs - Sun", which would fail most sane regexes!)
	var website: String? = nil //this could be an optional URL object instead of storing it as a String, and could be validated (eg. checking it's a valid URL that also exists on DNS), but I'm just importing it as an optional String in case the data isn't clean (and isn't expected to be clean)
	var fax: String? = nil

	init(organisationID: String, organisationCode: String, organisationName: String) { //the init only needs the required fields to be supplied, the rest are all vars that can be optionally set afterwards
		self.organisationID = organisationID
		self.organisationCode = organisationCode
		self.organisationName = organisationName
	}
}

