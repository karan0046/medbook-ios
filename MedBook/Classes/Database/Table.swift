//
//  Table.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

enum Table: String {
    case Country
    case Auth
    case CurrentUser
    case Book
    case BookMark
    
    
    private var dbInstance: DBManager {
        return DBManager.instance
    }
    
    func insert(withJson json: [String: Any], docId: String, completion: ((_ success: Bool, _ error: Error?) -> Void)) async {
        await dbInstance.insertOne(in: self.rawValue, withJson: json, docId: docId, completion: completion)
    }
    
    func upsert(id: String, withJson json: [String: Any], replace: Bool? = true, completion: ((_ success: Bool, _ error: Error?) -> Void)) async {
        await dbInstance.upsertOne(in: self.rawValue, id: id, withJson: json, replace: replace, completion: completion)
    }

    func fetchAll(selectQuery: SelectionIdentifier? = .all, filters: [String: Any]?, sortBy: String?, offset: Int?, limit: Int?, groupBy: String? = nil) async -> [[String: Any]] {
        return await dbInstance.fetchAll(selectQuery: selectQuery, fromTable: self.rawValue, filters: filters, sortBy: sortBy, offset: offset, limit: limit, groupBy: groupBy)
    }

    func count(filters: [String: Any]?) async -> Int {
        return await dbInstance.count(fromTable: self.rawValue, filters: filters)
    }

    func fetch(withId id: String) async -> [String: Any]? {
        return await dbInstance.fetchOne(fromTable: self.rawValue, withId: id)
    }

    func exists(withId id: String) async -> Bool {
        return await dbInstance.exists(fromTable: self.rawValue, withId: id)
    }
    
    func delete(withId id: String, completion: ((_ success: Bool, _ error: Error?) -> Void)) async {
        await dbInstance.deleteOne(in: self.rawValue, withId: id, completion: completion)
    }
    
    func deleteAll(filters: [String: Any]?, completion: ((_ success: Bool, _ error: Error?) -> Void)) async {
        await dbInstance.deleteAll(in: self.rawValue, filters: filters, completion: completion)
    }
}
