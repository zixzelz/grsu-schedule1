//
//  FavoriteManager.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/7/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import CoreData

let GSFavoriteManagerFavoritWillRemoveNotificationKey = "GSFavoriteManagerFavoritWillRemoveNotificationKey" // userInfo contains FavoriteEntity
let GSFavoriteManagerFavoriteObjectKey = "GSFavoriteManagerFavoriteObjectKey"

class FavoriteManager: NSObject {
   
    func getFavoriteStudentGroup(completionHandler: ((Array<FavoriteEntity>) -> Void)!) {
        
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ _ in
                
                var sorter: NSSortDescriptor = NSSortDescriptor(key: "order" , ascending: true)
                
                let request = NSFetchRequest(entityName: FavoriteEntityName)
                request.resultType = .ManagedObjectIDResultType
                request.sortDescriptors = [sorter]
                request.predicate = NSPredicate(format: "(group != nil)")
                
                var error : NSError?
                let itemIds = context.executeFetchRequest(request, error: &error) as [NSManagedObjectID]
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var items : [FavoriteEntity]?
                    if error == nil {
                        items = cdHelper.convertToMainQueue(itemIds) as? [FavoriteEntity]
                    } else {
                        NSLog("executeFetchRequest error: %@", error!)
                    }
                    
                    completionHandler(items!)
                })
            })
        } else {
            completionHandler([])
        }
    }
    
    func addFavorite(group: GroupsEntity) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ _ in
                
                let request = NSFetchRequest(entityName: FavoriteEntityName)
                var sorter: NSSortDescriptor = NSSortDescriptor(key: "order" , ascending: true)
                request.sortDescriptors = [sorter]
                request.predicate = NSPredicate(format: "(group != nil)")

                var error : NSError?
                let items = context.executeFetchRequest(request, error: &error) as [FavoriteEntity]
                let lastOrder = items.last?.order.integerValue ?? -1
                
                let group_ = context.objectWithID(group.objectID) as GroupsEntity
                
                var newItem = NSEntityDescription.insertNewObjectForEntityForName(FavoriteEntityName, inManagedObjectContext: context) as FavoriteEntity
                newItem.group = group_;
                newItem.synchronizeCalendar = false
                newItem.order = lastOrder+1

                cdHelper.saveContext(context)
            })
        }
    }
    
    func removeFavorite(item: FavoriteEntity) {
        
        NSNotificationCenter.defaultCenter().postNotificationName(GSFavoriteManagerFavoritWillRemoveNotificationKey, object: nil, userInfo: ["GSFavoriteManagerFavoriteObjectKey": item])
        
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ _ in
                
                let item_ = context.objectWithID(item.objectID) as FavoriteEntity
                
                 context.deleteObject(item_)
                 cdHelper.saveContext(context)
            })
        }
    }
    
}
