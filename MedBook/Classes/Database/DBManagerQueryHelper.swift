//
//  DBManagerQueryHelper.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import CouchbaseLiteSwift

final class DBManagerQueryHelper {

    func applySortBy<T: CouchbaseLiteSwift.Query>(query: T, sortBy: String) -> CouchbaseLiteSwift.Query {
        let sortOrder = sortBy.first == "-" ? "descending" :  "ascending"
        let sortProperty = sortBy.first == "-" ? String(sortBy.dropFirst()) :  sortBy
        var sortByProperty = Ordering.property(sortProperty).descending()
        if sortOrder == "ascending" {
            sortByProperty = Ordering.property(sortProperty).ascending()
        }

        switch query {
        case let q as CouchbaseLiteSwift.From:
            return q.orderBy(sortByProperty)
        case let q as CouchbaseLiteSwift.GroupBy:
            return q.orderBy(sortByProperty)
        case let q as CouchbaseLiteSwift.Having:
            return q.orderBy(sortByProperty)
        case let q as CouchbaseLiteSwift.Joins:
            return q.orderBy(sortByProperty)
        case let q as CouchbaseLiteSwift.Where:
            return q.orderBy(sortByProperty)
        default:
            return query
        }
    }

    func applyGroupBy<T: CouchbaseLiteSwift.Query>(query: T, groupBy: String) -> CouchbaseLiteSwift.Query {
        switch query {
        case let q as CouchbaseLiteSwift.From:
            return q.groupBy(Expression.property(groupBy))
        case let q as CouchbaseLiteSwift.Where:
            return q.groupBy(Expression.property(groupBy))
        default:
            return query
        }
    }

    func applyFilter<T: CouchbaseLiteSwift.Query>(query: T, filters: [String: Any]) -> CouchbaseLiteSwift.Query {
        guard let filterExpression = buildExpressionWithFilters(filters: filters) else {
            return query
        }
        switch query {
        case let q as CouchbaseLiteSwift.From:
            return q.where(filterExpression)
        case let q as CouchbaseLiteSwift.Joins:
            return q.where(filterExpression)
        default:
            return query
        }
    }

    func applyOffsetLimit<T: CouchbaseLiteSwift.Query>(query: T, offset: Int, limit: Int) -> CouchbaseLiteSwift.Query {
        switch query {
        case let q as CouchbaseLiteSwift.From:
            return q.limit(Expression.int(limit), offset: Expression.int(offset))
        case let q as CouchbaseLiteSwift.GroupBy:
            return q.limit(Expression.int(limit), offset: Expression.int(offset))
        case let q as CouchbaseLiteSwift.Having:
            return q.limit(Expression.int(limit), offset: Expression.int(offset))
        case let q as CouchbaseLiteSwift.Joins:
            return q.limit(Expression.int(limit), offset: Expression.int(offset))
        case let q as CouchbaseLiteSwift.OrderBy:
            return q.limit(Expression.int(limit), offset: Expression.int(offset))
        case let q as CouchbaseLiteSwift.Where:
            return q.limit(Expression.int(limit), offset: Expression.int(offset))
        default:
            return query
        }
    }
}
