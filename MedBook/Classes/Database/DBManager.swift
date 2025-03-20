//
//  DBManager.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import CouchbaseLiteSwift

class DBManager {
    let identifier = "MedBook"
    var database: Database!
    static let instance = DBManager()
    
    private init() {}
    
   func createDatabase() {
        do {
            self.database = try Database(name: identifier)
            print("Database config: ", database.config)
        } catch {
            fatalError("Database initialization failed\(error)")
        }
    }
    
    func insertOne(in table: String, withJson json: [String: Any], docId: String, completion: ((_ success: Bool, _ error: Error?) -> Void)) async {
        let mutableDoc = MutableDocument(id: docId);
        do {
            let collection = try database.createCollection(name: table)
            let morphedJson = json
            try mutableDoc.setJSON(morphedJson.jsonString()!)
            try collection.save(document: mutableDoc)
            completion(true, nil)
        } catch {
            completion(false, error)
        }
    }
    
    func upsertOne(in table: String, id: String, withJson json: [String: Any], replace: Bool? = true, completion: ((_ success: Bool, _ error: Error?) -> Void)) async {
        let existingJsonObj = await fetchOne(fromTable: table, withId: id) ?? [:]
        let mutableDoc = MutableDocument(id: id, data: existingJsonObj)
        do {
            let collection = try database.createCollection(name: table)
            var morphedJson = json
            if replace == false {
                morphedJson = mergeJSON(mutableDoc.toDictionary(), morphedJson)
            }
            try mutableDoc.setJSON(morphedJson.jsonString()!)
            try collection.save(document: mutableDoc)
            completion(true, nil)
        } catch {
            completion(false, error)
        }
    }
    
    private func mergeJSON(_ oldJSON: [String: Any], _ newJSON: [String: Any]) -> [String: Any] {
        let morphedJSON = oldJSON.merging(newJSON) { $1 }
        return morphedJSON
    }
    
    func fetchOne(fromTable: String, withId id: String) async -> [String: Any]? {
        do {
            let collection = try database.createCollection(name: fromTable)
            let fetchedDoc = try collection.document(id: id)
            return fetchedDoc?.toDictionary()
        } catch {
            return nil
        }
    }
    
    func fetchAll(selectQuery: SelectionIdentifier? = .all, fromTable table: String, filters: [String: Any]?, sortBy: String?, offset: Int?, limit: Int?, groupBy: String? = nil) async -> [[String: Any]] {
        guard let database = database, let collection = try? database.createCollection(name: table) else {
            return [[String: Any]]()
        }
        var query: Any? = nil
        switch selectQuery {
        case .all:
            query = QueryBuilder
                .select(SelectResult.all())
                .from(DataSource.collection(collection))
        case .select(let _columns):
            query = QueryBuilder
                .select(_columns.map({SelectResult.expression(Expression.property($0))}))
                .from(DataSource.collection(collection))
        case .distinct(let _columns):
            query = QueryBuilder
                .selectDistinct(_columns.map({SelectResult.expression(Expression.property($0))}))
                .from(DataSource.collection(collection))
        case .custom(let _columns):
            query = QueryBuilder
                .select(_columns.map({$0.expression}))
                .from(DataSource.collection(collection))
        default:
            print("DBManager: - Query type not supported")
            break
        }
        let queryHelper = DBManagerQueryHelper()
        if let _filters = filters, let _query = query as? CouchbaseLiteSwift.Query {
            query = queryHelper.applyFilter(query: _query, filters: _filters)
        }

        if let _groupBy = groupBy, let _query = query as? CouchbaseLiteSwift.Query {
            query = queryHelper.applyGroupBy(query: _query, groupBy: _groupBy)
        }

        if let _sortBy = sortBy, let _query = query as? CouchbaseLiteSwift.Query {
            query = queryHelper.applySortBy(query: _query, sortBy: _sortBy)
        }

        if let _offset = offset, let _limit = limit, let _query = query as? CouchbaseLiteSwift.Query {
            query = queryHelper.applyOffsetLimit(query: _query, offset: _offset, limit: _limit)
        }

        var jsonArr: [[String: Any]] = []
        // print("\(String(describing: try? (query as? CouchbaseLiteSwift.Query)?.explain()))")
        let results = try? (query as? CouchbaseLiteSwift.Query)?.execute()
        if let _results = results {
            for result in _results {
                switch selectQuery {
                case .distinct(let columns), .select(let columns):
                    if !columns.isEmpty {
                        jsonArr.append(result.toDictionary())
                    }
                    else if let dic = (result.toDictionary())[collection.name] as? [String: Any] {
                        jsonArr.append(dic)
                    }
                case .custom(let columns):
                    if !columns.isEmpty {
                        jsonArr.append(result.toDictionary())
                    }
                    else if let dic = (result.toDictionary())[collection.name] as? [String: Any] {
                        jsonArr.append(dic)
                    }
                default:
                    if let dic = (result.toDictionary())[collection.name] as? [String: Any] {
                        jsonArr.append(dic)
                    }
                }
            }
        }

        return jsonArr
    }
    
    func count(fromTable table: String, filters: [String: Any]?) async -> Int {
        guard let collection = try? database.createCollection(name: table) else { return 0 }
        var query: Any = QueryBuilder
            .select(SelectResult.expression(Function.count(Expression.all())).as("count"))
            .from(DataSource.collection(collection))
        let queryHelper = DBManagerQueryHelper()
        if let _filters = filters, let _query = query as? CouchbaseLiteSwift.Query {
            query = queryHelper.applyFilter(query: _query, filters: _filters)
        }
        let results = try? (query as? CouchbaseLiteSwift.Query)?.execute()
        //print("\(String(describing: try? (query as? CouchbaseLiteSwift.Query)?.explain()))")
        var count = 0
        if let _results = results {
            let e = _results.first { _ in true }
            count = e?.toDictionary()["count"] as? Int ?? 0
        }
        return count
    }

    func exists(fromTable: String, withId id: String) async -> Bool {
        do {
            let collection = try database.createCollection(name: fromTable)
            let doc = try collection.document(id: id)
            return (doc != nil)
        } catch {
            return false
        }
    }
    
    func deleteOne(in table: String, withId id: String, completion: ((_ success: Bool, _ error: Error?) -> Void)) async {
        do {
            let collection = try database.createCollection(name: table)
            if let document = try collection.document(id: id) {
                try collection.delete(document: document)
            }
        } catch {
            completion(false, error)
        }
    }
    
    func deleteAll(in table: String, filters: [String: Any]?, completion: ((_ success: Bool, _ error: Error?) -> Void)) async {
        var _documentsToBePurged: ResultSet?
        do {
            let collection = try database.createCollection(name: table)
            var query: Any = QueryBuilder
                .select(SelectResult.expression(Meta.id))
                .from(DataSource.collection(collection))

            let queryHelper = DBManagerQueryHelper()
            if let _filters = filters, let _query = query as? CouchbaseLiteSwift.Query {
                query = queryHelper.applyFilter(query: _query, filters: _filters)
            }
            _documentsToBePurged = try (query as? CouchbaseLiteSwift.Query)?.execute()

        } catch {
            completion(false, nil)
        }

        if let documentsToBePurged = _documentsToBePurged {
            for doc in documentsToBePurged {
                guard let id = doc.string(forKey: "id") else { continue }
                await deleteOne(in: table, withId: id) {success, error in
                    guard success else {
                        print(error as Any)
                        return
                    }
                }
            }
            completion(true, nil)
        } else {
            completion(false, nil)
        }
    }
}
