//
//  QueryFunction.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import CouchbaseLiteSwift

enum QueryFunction {
    case count(_ property: String, _ fieldName: String)
    case avg(_ property: String, _ fieldName: String)
    case sum(_ property: String, _ fieldName: String)
    case property(_ property: String, _ fieldName: String)

    var expression: CouchbaseLiteSwift.SelectResultProtocol {
        switch self {
        case .count(let property, let fieldName):
            return SelectResult.expression(Function.count(Expression.property(property))).as(fieldName)
        case .avg(let property, let fieldName):
            return SelectResult.expression(Function.avg(Expression.property(property))).as(fieldName)
        case .sum(let property, let fieldName):
            return SelectResult.expression(Function.sum(Expression.property(property))).as(fieldName)
        case .property(let property, let fieldName):
            return SelectResult.expression(Expression.property(property)).as(fieldName)
        }
    }
}
