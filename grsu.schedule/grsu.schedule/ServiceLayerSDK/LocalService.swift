//
//  LocalService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/6/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

protocol LocalServiceQueryType {

    associatedtype QueryInfo: QueryInfoType

    var queryInfo: QueryInfo? { get }

    var predicate: NSPredicate? { get }
    var sortBy: [NSSortDescriptor]? { get }
}

extension LocalServiceQueryType {

    var queryInfo: NoneQueryInfo? {
        return nil
    }
}

class LocalService < T: ModelType > {

    typealias LocalServiceFetchCompletionHandlet = ServiceResult<[T], ServiceError> -> ()
    typealias LocalServiceStoreCompletionHandlet = ServiceResult<Void, ServiceError> -> ()

    func parseAndStore < LocalServiceQuery: LocalServiceQueryType where LocalServiceQuery.QueryInfo == T.QueryInfo > (query: LocalServiceQuery, json: [String: AnyObject], completionHandler: LocalServiceStoreCompletionHandlet) {

        store(query, json: json, completionHandler: completionHandler)
    }

    func featch < LocalServiceQuery: LocalServiceQueryType where LocalServiceQuery.QueryInfo == T.QueryInfo > (query: LocalServiceQuery, completionHandler: LocalServiceFetchCompletionHandlet) {

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.cdh.backgroundContext

        context.performBlock { _ in

            T.objectsForMainQueue(withPredicate: query.predicate, inContext: context, sortBy: query.sortBy) { (items) in

                completionHandler(.Success(items))
            }
        }
    }

    private func store < LocalServiceQuery: LocalServiceQueryType where LocalServiceQuery.QueryInfo == T.QueryInfo > (query: LocalServiceQuery, json: [String: AnyObject], completionHandler: LocalServiceStoreCompletionHandlet) {

        guard let items = json[T.keyForEnumerateObjects()] as? [[String: AnyObject]] else {
            completionHandler(.Failure(.WrongResponseFormat))
            return
        }

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.cdh.backgroundContext

        context.performBlock { _ in

            let cacheItems = T.objects(withPredicate: query.predicate, inContext: context) ?? []
            let cacheItemsMap = cacheItems.dict { ($0.identifier, $0) }

            var handledItemsKey = [String]()
            for item in items {

                let identifier = item[T.keyForIdentifier()] as! String
                if let oldItem = cacheItemsMap[identifier] {

                    oldItem.fill(item, queryInfo: query.queryInfo)
                    handledItemsKey.append(identifier)
                } else {

                    let newItem = T.insert(inContext: context)
                    newItem.fill(item, queryInfo: query.queryInfo)
                    handledItemsKey.append(identifier)
                }
            }

            let itemForDelete = cacheItemsMap.filter { !handledItemsKey.contains($0.0) }
            for (_, item) in itemForDelete {
                item.delete(context)
            }

            context.saveIfNeeded()

            completionHandler(.Success())
        }
    }

}
