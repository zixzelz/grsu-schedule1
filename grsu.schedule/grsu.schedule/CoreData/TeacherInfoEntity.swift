//
//  TeacherInfoEntity.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/5/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import Foundation
import CoreData

@objc(TeacherInfoEntity)
class TeacherInfoEntity: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var title: String?
    @NSManaged var name: String?
    @NSManaged var surname: String?
    @NSManaged var patronym: String?
    @NSManaged var post: String?
    @NSManaged var phone: String?
    @NSManaged var descr: String?
    @NSManaged var email: String?
    @NSManaged var skype: String?
    @NSManaged var updatedDate: NSDate
    @NSManaged var lessons: NSSet
    @NSManaged var favorite: FavoriteEntity?

}

extension TeacherInfoEntity: ModelType {

    typealias QueryInfo = TeachersServiceQueryInfo

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
        
        title = json["fullname"] as? String
        name = json["name"] as? String
        surname = json["surname"] as? String
        patronym = json["patronym"] as? String
        post = json["post"] as? String
        phone = json["phone"] as? String
        descr = json["descr"] as? String
        email = json["email"] as? String
        skype = json["skype"] as? String
        updatedDate = NSDate()
    }

}

extension TeacherInfoEntity: ManagedObjectType {
    
    var identifier: String? {
        return id
    }
}
