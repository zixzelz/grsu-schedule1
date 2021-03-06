//
//  GetUniversityBuildings.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/26/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import CoreLocation

class GetUniversityBuildings: BaseDataService {

    class func getBuildings(_ completionHandler: (([UniversityBuilding]?, NSError?) -> Void)!) {
        featchBuildings(completionHandler)
    }


    fileprivate class func featchBuildings(_ completionHandler: (([UniversityBuilding]?, NSError?) -> Void)!) {

        guard let filePath = Bundle.main.path(forResource: "UniversityBuildings", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
                completionHandler([], nil)
                return
        }

        guard let response = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
            let responseArray = response as? [NSDictionary] else {
                completionHandler([], nil)
                return
        }

        var universityBuilding = [UniversityBuilding]()

        for buildingDict in responseArray {

            var building: UniversityBuilding!

            let type = buildingDict["type"] as? String
            if type == "Educational" {

                var faculties = [FacultyOfUniversity]()
                let facultyDicts = buildingDict["faculties"] as? [NSDictionary] ?? []
                for facultyDict in facultyDicts {

                    let faculty = FacultyOfUniversity()
                    faculty.title = facultyDict["title"] as? String
                    faculty.site = facultyDict["site"] as? String

                    faculties.append(faculty)
                }

                let educational = EducationalUniversityBuilding()
                educational.faculties = faculties

                building = educational
            } else if type == "Hostel" {
                let hostel = HostelUniversityBuilding()
                hostel.title = buildingDict["title"] as? String
                hostel.number = buildingDict["number"] as? String

                building = hostel
            }

            let location = CLLocationCoordinate2D(latitude: (buildingDict["lat"] as! NSString).doubleValue, longitude: (buildingDict["lng"] as! NSString).doubleValue)

            building.photo = buildingDict["photo"] as? String
            building.address = buildingDict["address"] as? String
            building.location = location

            universityBuilding.append(building!)
        }

        completionHandler(universityBuilding, nil)
    }

}
