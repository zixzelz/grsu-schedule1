//
//  FacultiesEntity.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/30/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import Foundation
import CoreData

@objc(FacultiesEntity)
class FacultiesEntity: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var id: String
    @NSManaged var groups: NSSet

}

enum FacultiesQueryInfo: QueryInfoType {
    case Default
    case JustInsert
}

extension FacultiesEntity: ModelType {

    typealias QueryInfo = FacultiesQueryInfo

    static func keyForIdentifier() -> String? {
        return "id"
    }

    static func objects(json: [String: AnyObject]) -> [[String: AnyObject]]? {

        return json["items"] as? [[String: AnyObject]]
    }

    func fill(json: [String: AnyObject], queryInfo: QueryInfo, context: Void) {

        id = json["id"] as! String
        update(json, queryInfo: queryInfo)
    }

    func update(json: [String: AnyObject], queryInfo: QueryInfo) {

        if queryInfo == .Default {
            
            let fullTitle = json["title"] as? String ?? ""
            title = fullTitle.stringByReplacingOccurrencesOfString("^Факультет ", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: nil).capitalizingFirstLetter()
        }
    }

    // MARK: - ManagedObjectType

    var identifier: String? {

        return id
    }

}
