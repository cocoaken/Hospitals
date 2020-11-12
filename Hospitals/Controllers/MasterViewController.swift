//
//  MasterViewController.swift
//  Hospitals
//
//  Created by ken on 12/11/2020.
//

import UIKit

class MasterViewController: UITableViewController {

	let remoteDataURLString = "https://media.nhschoices.nhs.uk/data/foi/Hospital.csv" //use https not http
	let firstHeaderField = "OrganisationID" //the presence of this in a row is used to differentiate a header row from a non-header row
	var hospitals: [Hospital] = []


	//MARK: - View Controller lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.clearsSelectionOnViewWillAppear = false //preserve selection between presentations
		if hospitals.isEmpty { //no data has been loaded yet, or the VC has been purged from memory so needs to re-initialise array
			downloadHospitalData()
		}
    }

	//MARK: - Download Hospital Data

	func downloadHospitalData() {
		URLCache.shared.removeAllCachedResponses()
		if let remoteDataURL = URL(string: remoteDataURLString) { //make the URL
			print("URL  created")
						
			//let session = URLSession.shared
			let task = URLSession.shared.dataTask(with: remoteDataURL) {  (data, response, error) in
				
				if let data = data, let fileContents = String(data: data, encoding: .isoLatin1) { //the supplied .csv file is encoded as Western Latin 1 (aka ISO Latin 1), not UTF-8 etc.
					do {
						//do the following still in the background
						var hospitals = self.transformFileContentsIntoObjects(fileContents)
						hospitals.sort { //file is sorted by organisationID, but master controller lists organisationName, so sort the array accordingly
							$0.organisationName < $1.organisationName
						}

						//do the following (UI updates) on the main thread
						DispatchQueue.main.async {
							self.hospitals = hospitals
							self.tableView.reloadData()
						}
					}
				} else {
					print("Error retrieving hospital data")
				}
			}
			task.resume() //let it go get the data (which then calls the completion handler block above)

		} else {
			print("Couldn't create remote data URL - invalid URL")
		}
	}


	//MARK: - Transform .csv file into array of objects

	func transformFileContentsIntoObjects(_ fileContents: String) -> [Hospital] {
		let allRows = transformStringIntoRows(fileContents: fileContents)
		let usableRows = removeHeaderRow(allRows: allRows)
		let hospitals = transformRowsIntoObjects(usableRows: usableRows)
		return hospitals
	}

	func transformStringIntoRows(fileContents: String) -> [String] {
		let rows = fileContents.components(separatedBy: "\r\n")
		return rows
	}

	func removeHeaderRow(allRows: [String]) -> [String] {
		var rows = allRows
		let firstRow = rows[0]
		if firstRow.starts(with: firstHeaderField) { //only delete the first row if it's a header row (which I'm defining as "if it begins with the first column heading")
			rows.removeFirst()
		}
		return rows
	}

	func transformRowsIntoObjects(usableRows: [String]) -> [Hospital] {
		
		//Order of columns in the .csv file, including array indexes (for referring to them in a minute):
		//0 OrganisationID
		//1 OrganisationCode
		//2 OrganisationType
		//3 SubType
		//4 Sector
		//5 OrganisationStatus
		//6 IsPimsManaged
		//7 OrganisationName
		//8 Address1
		//9 Address2
		//10 Address3
		//11 City
		//12 County
		//13 Postcode
		//14Latitude
		//15 Longitude
		//16 ParentODSCode
		//17 ParentName
		//18 Phone
		//19 Email
		//20 Website
		//21 Fax
		
		var hospitals: [Hospital] = [] //empty
		for row in usableRows { //parse each row in the file (which has already had any header row removed)
			let fields: [String] = row.components(separatedBy: "¬") //separate by tabs (it's a .csv, but it's actually a tab separated file (.tsv / .tab), not comma separated
			if fields.count > 1 { //remove last row if it's a blank line
				if fields.indices.contains(0) && fields.indices.contains(1) && fields.indices.contains(7) { //firstly check the array contains the non-optional values, the rest don't matter (as they're optional)
					let hospital = Hospital(organisationID: fields[0], organisationCode: fields[1], organisationName: fields[7])
					//now go through each optional field... we know there are the first 8 fields already in the row, as we've already checked
					if !fields[2].isEmpty {
						hospital.organisationType = fields[2]
					}
					if !fields[3].isEmpty {
						hospital.subType = fields[3]
					}
					if !fields[4].isEmpty {
						hospital.sector = fields[4]
						if fields[4].lowercased().contains("nhs") {
							hospital.hospitalSector = .nhs
						} else {
							hospital.hospitalSector = .independent
						}
					}
					if !fields[5].isEmpty {
						hospital.organisationStatus = fields[5]
					}
					if !fields[6].isEmpty {
						hospital.isPimsManaged = fields[6] == "True" ? true : false //data values in the .csv seem to only be True or False
					}
					//we don't yet know there are more fields in the row past organisationName, so don't assume they exist
					if fields.indices.contains(8) && !fields[8].isEmpty {
						hospital.address1 = fields[8]
					}
					if fields.indices.contains(9) && !fields[9].isEmpty {
						hospital.address2 = fields[9]
					}
					if fields.indices.contains(10) && !fields[10].isEmpty {
						hospital.address3 = fields[10]
					}
					if fields.indices.contains(11) && !fields[11].isEmpty {
						hospital.city = fields[11]
					}
					if fields.indices.contains(12) && !fields[12].isEmpty {
						hospital.county = fields[12]
					}
					if fields.indices.contains(13) && !fields[13].isEmpty {
						hospital.postcode = fields[13]
					}
					if fields.indices.contains(14) && !fields[14].isEmpty {
						hospital.latitude = Double(fields[14])
					}
					if fields.indices.contains(15) && !fields[15].isEmpty {
						hospital.longitude = Double(fields[15])
					}
					if fields.indices.contains(16) && !fields[16].isEmpty {
						hospital.parentODSCode = fields[16]
					}
					if fields.indices.contains(17) && !fields[17].isEmpty {
						hospital.parentName = fields[17]
					}
					if fields.indices.contains(18) && !fields[18].isEmpty {
						hospital.phone = fields[18]
					}
					if fields.indices.contains(19) && !fields[19].isEmpty {
						hospital.email = fields[19]
					}
					if fields.indices.contains(20) && !fields[20].isEmpty {
						hospital.website = fields[20]
					}
					if fields.indices.contains(21) && !fields[21].isEmpty {
						hospital.fax = fields[21]
					}
					
					hospitals.append(hospital)
				} else {
					//catch edge case where required data isn't available for a given hospital
				}
			} else {
				//ignore any rows that only have 1 or less fields (eg. the end of the .csv file, which typically only contains the EOF rather than any data)
			}
		}
		print("\(hospitals.count) hospitals imported")
		return hospitals
	}


    // MARK: - Table view data source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return hospitals.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let hospital = hospitals[indexPath.row]
		cell.textLabel?.text = hospital.organisationName
		return cell
	}
	
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
