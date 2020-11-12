//
//  DetailViewController.swift
//  Hospitals
//
//  Created by ken on 12/11/2020.
//

import UIKit

class DetailViewController: UITableViewController {

	var hospital: Hospital? {
		didSet {
			refreshUI()
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	private func refreshUI() {
		loadViewIfNeeded()
		self.tableView.reloadData()
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 4 // 4 sections: Organisation details | Address | Parent | Contact
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			//	 organisationName
			//	 organisationID
			//	 organisationCode
			//	 organisationStatus
			//	 organisationType
			//	 subType
			//	 sector
			//	 isPimsManaged
			return 8
		case 1:
			//	 address1
			//	 address2
			//	 address3
			//	 city
			//	 county
			//	 postcode
			//	 latitude
			//	 longitude
			return 8
		case 2:
			//	 parentName
			//	 parentODSCode
			return 2
		case 3:
			//	 website
			//	 email
			//	 phone
			//	 fax
			return 4
		default:
			return 0
		}
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return "Organisation details"
		case 1:
			return "Address"
		case 2:
			return "Parent"
		case 3:
			return "Contact"
		default:
			return nil
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		
		switch indexPath.section {
		
		case 0: //Organisation details
			switch indexPath.row {
			case 0:
				cell.textLabel?.text = hospital?.organisationName
				cell.detailTextLabel?.text = "Name"
			case 1:
				cell.textLabel?.text = hospital?.organisationID
				cell.detailTextLabel?.text = "ID"
			case 2:
				cell.textLabel?.text = hospital?.organisationCode
				cell.detailTextLabel?.text = "Code"
			case 3:
				cell.textLabel?.text = hospital?.organisationStatus
				cell.detailTextLabel?.text = "Status"
			case 4:
				cell.textLabel?.text = hospital?.organisationType
				cell.detailTextLabel?.text = "Type"
			case 5:
				cell.textLabel?.text = hospital?.subType
				cell.detailTextLabel?.text = "Subtype"
			case 6:
				cell.textLabel?.text = hospital?.sector
				cell.detailTextLabel?.text = "Sector"
			case 7:
				if let isPimsManagedBool = hospital?.isPimsManaged {
					cell.textLabel?.text = isPimsManagedBool == true ? "Yes" : "No"
				} else {
					cell.textLabel?.text = hospital == nil ? "" : "Unknown"
				}
				cell.detailTextLabel?.text = "PIMS Managed"
			default:
				break //we shouldn't ever get this far
			}
		
		case 1: //Address
			switch indexPath.row {
			case 0:
				cell.textLabel?.text = hospital?.address1
				cell.detailTextLabel?.text = "Address1"
			case 1:
				cell.textLabel?.text = hospital?.address2
				cell.detailTextLabel?.text = "Address2"
			case 2:
				cell.textLabel?.text = hospital?.address3
				cell.detailTextLabel?.text = "Address3"
			case 3:
				cell.textLabel?.text = hospital?.city
				cell.detailTextLabel?.text = "City"
			case 4:
				cell.textLabel?.text = hospital?.county
				cell.detailTextLabel?.text = "County"
			case 5:
				cell.textLabel?.text = hospital?.postcode
				cell.detailTextLabel?.text = "Postcode"
			case 6:
				if let latitudeNumber = hospital?.latitude {
					cell.textLabel?.text = String(latitudeNumber)
				} else {
					cell.textLabel?.text = ""
				}
				cell.detailTextLabel?.text = "Latitude"
			case 7:
				if let longitudeNumber = hospital?.longitude {
					cell.textLabel?.text = String(longitudeNumber)
				} else {
					cell.textLabel?.text = ""
				}
				cell.detailTextLabel?.text = "Longitude"
			default:
				break //we shouldn't ever get this far
			}

		case 2: //Parent
			switch indexPath.row {
			case 0:
				cell.textLabel?.text = hospital?.parentName
				cell.detailTextLabel?.text = "Parent"
			case 1:
				cell.textLabel?.text = hospital?.parentODSCode
				cell.detailTextLabel?.text = "Parent ODS Code"
			default:
				break //we shouldn't ever get this far
			}
			
		case 3: //Contact
			switch indexPath.row {
			case 0:
				cell.textLabel?.text = hospital?.website
				cell.detailTextLabel?.text = "Website"
			case 1:
				cell.textLabel?.text = hospital?.email
				cell.detailTextLabel?.text = "e-mail"
			case 2:
				cell.textLabel?.text = hospital?.phone
				cell.detailTextLabel?.text = "Phone"
			case 3:
				cell.textLabel?.text = hospital?.fax
				cell.detailTextLabel?.text = "Fax"
			default:
				break //we shouldn't ever get this far
			}
		
		default:
			break //we shouldn't ever get this far
		}
		return cell
	}



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
