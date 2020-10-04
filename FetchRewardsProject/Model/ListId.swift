//
//  ListId.swift
//  FetchRewards
//
//  Created by Royce Reynolds on 10/3/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import Foundation

struct ListId{
    
    var listId: Int
    var id: Int
    var name: String
    
    init(listId: Int, id: Int, name: String ){
        
        self.listId = listId
        self.id = id
        self.name = name
    }
    
    static func parseListIdJSON(_ data: AnyObject) -> [Int:[ListId]]{
        
        //Convert JSON into usable object
        guard let results = data as? [[String:AnyObject]] else {return [Int:[ListId]]()}
        
        var listDictionary = [Int:[ListId]]()
        for list in results{
            //Filter out any items where name is blank or null
            guard let listId = list["listId"] as? Int, let id = list["id"] as? Int, let name = list["name"] as? String, name != "" else {continue
            }
            
            let listObject = ListId(listId: listId, id: id, name: name)
            
            //Group by list id
            if var listArray = listDictionary[listId]{
                listArray.append(listObject)
                listDictionary[listId] = listArray
            }else{
                listDictionary[listId] = [listObject]
            }
        }
        
        //Sort the grouped lists
        let sortedDict = sortAndOrderLists(listDictionary)
    
        
        return sortedDict
    }
    
    private static func sortAndOrderLists(_ lists: [Int:[ListId]]) -> [Int:[ListId]]{
        
        var newLists = lists
        for (key, lists) in newLists{
            //Sort By Name
            let sortedList = lists.sorted(by: { $0.name < $1.name})
            newLists[key] = sortedList
        }
        
        return newLists
    }
    
    static func getSortedKeys(_ lists: [Int:[ListId]]) -> [Int]{
        return lists.keys.sorted(by: <)
    }
}
