//
//  FilterExpression.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 19/03/25.
//

import CouchbaseLiteSwift

enum FilterOperator: String {
    case eq = "eq",
         neq = "neq",
         in_ls = "in_ls",
         bt = "bt",
         lk = "lk",
         bb = "bb",
         isn = "isn",
         prefix = "prefix",
         suffix = "suffix",
         arrayAny = "arrayAny",
         arrayEvery = "arrayEvery",
         arraycontains = "arraycontains",
         ls_th,
         gr_th,
         not_in_ls

    func value(_ value: Any) -> Any {
        ["op": self.rawValue, "value": value]
    }
}
func getEQOperatorExpression(filterKey: String, filterValue: Any ) -> CouchbaseLiteSwift.ExpressionProtocol? {
    switch filterValue {
    case let _val as String:
        return Expression.property(filterKey).equalTo(Expression.string(_val))
    case let _val as Double:
        return Expression.property(filterKey).equalTo(Expression.double(_val))
    case let _val as Float:
        return Expression.property(filterKey).equalTo(Expression.float(_val))
    case let _val as Int:
        return Expression.property(filterKey).equalTo(Expression.int(_val))
    case let _val as Bool:
        return Expression.property(filterKey).equalTo(Expression.boolean(_val))
    default:
        print("default value in getEQOperatorExpression")
        return nil
    }
}

func getNotEQOperatorExpression(filterKey: String, filterValue: Any ) -> CouchbaseLiteSwift.ExpressionProtocol? {
    switch filterValue {
    case let _val as String:
        return Expression.property(filterKey).notEqualTo(Expression.string(_val))
    case let _val as Double:
        return Expression.property(filterKey).notEqualTo(Expression.double(_val))
    case let _val as Float:
        return Expression.property(filterKey).notEqualTo(Expression.float(_val))
    case let _val as Int:
        return Expression.property(filterKey).notEqualTo(Expression.int(_val))
    case let _val as Bool:
        return Expression.property(filterKey).notEqualTo(Expression.boolean(_val))
    default:
        print("default value in getEQOperatorExpression")
        return nil
    }
}

fileprivate func getArrayExpression(values: [Any]) -> [CouchbaseLiteSwift.ExpressionProtocol] {
    var expressionArr: [ExpressionProtocol] = []
    values.forEach { val in
        switch val {
        case let _val as String:
            expressionArr.append(Expression.string(_val))
        case let _val as Double:
            expressionArr.append(Expression.double(_val))
        case let _val as Float:
            expressionArr.append(Expression.float(_val))
        case let _val as [String: Any]:
            expressionArr.append(Expression.dictionary(_val))
        default:
            print("getArrayExpressionNotImplemented")
        }
    }
    return expressionArr
}

func getINLSOperatorExpression(filterKey: String, filterValue: Any ) -> CouchbaseLiteSwift.ExpressionProtocol? {
    let values = filterValue as? [Any]
    if let _values = values {
        let expressionArr = getArrayExpression(values: _values)
        return Expression.property(filterKey).in(expressionArr)
    }
    return nil
}

func getContainsOperatorExpression(filterKey: String, filterValue: Any ) -> CouchbaseLiteSwift.ExpressionProtocol? {
    switch filterValue {
    case let _val as String:
        return ArrayFunction.contains(Expression.property(filterKey), value: Expression.string(_val))
    case let _val as Double:
        return ArrayFunction.contains(Expression.property(filterKey), value: Expression.double(_val))
    case let _val as Float:
        return ArrayFunction.contains(Expression.property(filterKey), value: Expression.float(_val))
    case let _val as Int:
        return ArrayFunction.contains(Expression.property(filterKey), value: Expression.int(_val))
    case let _val as Bool:
        return ArrayFunction.contains(Expression.property(filterKey), value: Expression.boolean(_val))
    default:
        print("default value in getContainsOperatorExpression")
        return nil
    }
}

func getBTOperatorExpression(filterKey: String, filterValue: Any ) -> CouchbaseLiteSwift.ExpressionProtocol? {

    guard let _v = filterValue as? [Any], _v.count == 2 else {
        return nil
    }
    switch filterValue {
    case let _val as [Double]:
        return Expression.property(filterKey).between(Expression.double(_val[0]), and: Expression.double(_val[1]))
    case let _val as [Float]:
        return Expression.property(filterKey).between(Expression.float(_val[0]), and: Expression.float(_val[1]))
    case let _val as [Int]:
        return Expression.property(filterKey).between(Expression.int(_val[0]), and: Expression.int(_val[1]))
    default:
        print("default value in getBTOperatorExpression")
        return nil

    }
}

func getLKOperatorExpression(filterKey: String, filterValue: Any ) -> CouchbaseLiteSwift.ExpressionProtocol? {
    switch filterValue {
    case let _val as String:
        return Function.lower(Expression.property(filterKey)).like(Function.lower(Expression.string("%\(_val)%")))
    default:
        print("default value in getLKOperatorExpression")
        return nil
    }
}

func getPrefixOperatorExpression(filterKey: String, filterValue: Any ) -> CouchbaseLiteSwift.ExpressionProtocol? {
    switch filterValue {
    case let _val as String:
        return Expression.property(filterKey).like(Expression.string("\(_val)%"))
    default:
        print("default value in getLKOperatorExpression")
        return nil
    }
}

func getSuffixOperatorExpression(filterKey: String, filterValue: Any ) -> CouchbaseLiteSwift.ExpressionProtocol? {
    switch filterValue {
    case let _val as String:
        return Expression.property(filterKey).like(Expression.string("%\(_val)"))
    default:
        print("default value in getLKOperatorExpression")
        return nil
    }
}

func getBBOperatorExpression(filterKey: String, filterValue: Any ) -> CouchbaseLiteSwift.ExpressionProtocol? {
    switch filterValue {
    case let _v as [String: Double]:
        let minLat = _v["minLat"] ?? -90
        let maxLat = _v["maxLat"] ?? 90
        let minLng = _v["minLng"] ?? -180
        let maxLng = _v["maxLng"] ?? 180
        //will always be filtered on geoLat and geoLat, if the object doesn't has geoLat and geoLong, please introduce that
        return Expression.property("geoLat").between(Expression.double(minLat), and: Expression.double(maxLat)).and(Expression.property("geoLong").between(Expression.double(minLng), and: Expression.double(maxLng)))
    default:
        print("default value in getBBOperatorExpression")
        return nil
    }
}

func getLessThanOperatorExpression(filterKey: String, filterValue: Any) -> CouchbaseLiteSwift.ExpressionProtocol? {
    switch filterValue {
    case let v as Int:
        return Expression.property(filterKey).lessThanOrEqualTo(Expression.int(v))
    case let v as Double:
        return Expression.property(filterKey).lessThanOrEqualTo(Expression.double(v))
    case let v as Float:
        return Expression.property(filterKey).lessThanOrEqualTo(Expression.float(v))
    default:
        print("default value in getLessThanOperatorExpression")
        return nil
    }
}

func getGreaterThanOperatorExpression(filterKey: String, filterValue: Any) -> CouchbaseLiteSwift.ExpressionProtocol? {
    switch filterValue {
    case let v as Int:
        return Expression.property(filterKey).greaterThanOrEqualTo(Expression.int(v))
    case let v as Double:
        return Expression.property(filterKey).greaterThanOrEqualTo(Expression.double(v))
    case let v as Float:
        return Expression.property(filterKey).greaterThanOrEqualTo(Expression.float(v))
    default:
        print("default value in getLessThanOperatorExpression")
        return nil
    }
}

func getISNOperatorExpression(filterKey: String, filterValue: Any ) -> CouchbaseLiteSwift.ExpressionProtocol? {
    if filterValue as? Bool == true {
        return Expression.property(filterKey).isNotValued()
    } else {
        return Expression.property(filterKey).isNot(Expression.value(nil))
    }

}

func getNotInListOperatorExpression(filterKey: String, filterValue: Any ) -> CouchbaseLiteSwift.ExpressionProtocol? {
    if let inExpression = getINLSOperatorExpression(filterKey: filterKey, filterValue: filterValue) {
        return inExpression.equalTo(Expression.boolean(false))
    }
    return nil
}

func getExpressionBasedOnOperator(filterKey: String, filterValue: Any) -> ExpressionProtocol? {

    if let filterJson = filterValue as? [String: Any], let value = filterJson["value"], let _operator = FilterOperator(rawValue: filterJson["op"] as? String ?? "") {
        switch _operator {
        case FilterOperator.eq:
            return getEQOperatorExpression(filterKey: filterKey, filterValue: value)
        case FilterOperator.neq:
            return getNotEQOperatorExpression(filterKey: filterKey, filterValue: value)
        case FilterOperator.bt:
            return getBTOperatorExpression(filterKey: filterKey, filterValue: value)
        case FilterOperator.lk:
            return getLKOperatorExpression(filterKey: filterKey, filterValue: value)
        case FilterOperator.bb:
            return getBBOperatorExpression(filterKey: filterKey, filterValue: value)
        case FilterOperator.in_ls:
            return getINLSOperatorExpression(filterKey: filterKey, filterValue: value)
        case FilterOperator.isn:
            return getISNOperatorExpression(filterKey: filterKey, filterValue: value)
        case FilterOperator.prefix:
            return getPrefixOperatorExpression(filterKey: filterKey, filterValue: value)
        case FilterOperator.suffix:
            return getSuffixOperatorExpression(filterKey: filterKey, filterValue: value)
        case .arrayAny:
            return getArrayOperatorExpression(filterKey: filterKey, filterValue: value, checkEveryElement: false)
        case .arrayEvery:
            return getArrayOperatorExpression(filterKey: filterKey, filterValue: value, checkEveryElement: true)
        case FilterOperator.arraycontains:
            return getContainsOperatorExpression(filterKey: filterKey, filterValue: value)
        case FilterOperator.ls_th:
            return getLessThanOperatorExpression(filterKey: filterKey, filterValue: value)
        case FilterOperator.gr_th:
            return getGreaterThanOperatorExpression(filterKey: filterKey, filterValue: value)
        case .not_in_ls:
            return getNotInListOperatorExpression(filterKey: filterKey, filterValue: value)
        }
    }
    else if let value = filterValue as? [Any] {
        return getINLSOperatorExpression(filterKey: filterKey, filterValue: value)
    }
    else {
        let value = filterValue as Any
        return getEQOperatorExpression(filterKey: filterKey, filterValue: value)
    }

}

func buildExpressionWithFilters(filters: [String: Any]) -> CouchbaseLiteSwift.ExpressionProtocol? {
    let morphedFilters = getFilterBodyBasedOnTypes(filterBody: filters)
    var finalFilterExpression: ExpressionProtocol? = nil
    for (filterKey, filterValue) in morphedFilters {
        if filterKey.lowercased() == "or", let _filterValue = filterValue as? [[String: Any]] {
            _filterValue.forEach { orFilterData in
                if let orFilter = buildORExpressionWithFilters(filters: orFilterData) {
                    finalFilterExpression = finalFilterExpression?.and(orFilter) ?? orFilter
                }
            }
        }
        else if let filterExpression = getExpressionBasedOnOperator(filterKey: filterKey, filterValue: filterValue) {
            finalFilterExpression = finalFilterExpression?.and(filterExpression) ?? filterExpression
        }
    }
    return finalFilterExpression
}

fileprivate func buildORExpressionWithFilters(filters: [String: Any]) -> CouchbaseLiteSwift.ExpressionProtocol? {
    var finalFilterExpression: ExpressionProtocol? = nil
    for (filterKey, filterValue) in filters {
        if let filterExpression = getExpressionBasedOnOperator(filterKey: filterKey, filterValue: filterValue) {
            finalFilterExpression = finalFilterExpression?.or(filterExpression) ??  filterExpression
        }
    }
    return finalFilterExpression
}

func getArrayOperatorExpression(filterKey: String, filterValue: Any, checkEveryElement: Bool) -> CouchbaseLiteSwift.ExpressionProtocol? {
    let arrayElementName = filterKey+"element"
    guard let _filterValue = filterValue as? [String: Any] else { return nil }
    var _satifyExp: ExpressionProtocol? = nil
    for (arrayExpKey, arrayExpVal) in _filterValue {
        if let filterExpression = getArrayExpressionBasedOnOperator(filterKey: arrayElementName + "." + arrayExpKey, filterValue: arrayExpVal) {
            _satifyExp = _satifyExp?.and(filterExpression) ?? filterExpression
        }
    }
    guard let satifyExp = _satifyExp else { return nil }
    let arrayKeyVariable = ArrayExpression.variable(arrayElementName)
    if checkEveryElement {
        return ArrayExpression.every(arrayKeyVariable).in(Expression.property(filterKey)).satisfies(satifyExp)
    }
    return ArrayExpression.any(arrayKeyVariable).in(Expression.property(filterKey)).satisfies(satifyExp)
}

func getArrayExpressionBasedOnOperator(filterKey: String, filterValue: Any) -> ExpressionProtocol? {
    if let filterJson = filterValue as? [String: Any], let value = filterJson["value"], let _operator = FilterOperator(rawValue: filterJson["op"] as? String ?? "") {
        switch _operator {
        case FilterOperator.eq:
            return getEQOperatorArrayExpression(filterKey: filterKey, filterValue: value)
        case FilterOperator.neq:
            return getNotEQOperatorArrayExpression(filterKey: filterKey, filterValue: value)
        default:
            return nil
        }
    }
    else {
        let value = filterValue as Any
        return getEQOperatorArrayExpression(filterKey: filterKey, filterValue: value)
    }
}

func getEQOperatorArrayExpression(filterKey: String, filterValue: Any ) -> CouchbaseLiteSwift.ExpressionProtocol? {
    switch filterValue {
    case let _val as String:
        return ArrayExpression.variable(filterKey).equalTo(Expression.string(_val))
    case let _val as Double:
        return ArrayExpression.variable(filterKey).equalTo(Expression.double(_val))
    case let _val as Float:
        return ArrayExpression.variable(filterKey).equalTo(Expression.float(_val))
    case let _val as Int:
        return ArrayExpression.variable(filterKey).equalTo(Expression.int(_val))
    case let _val as Bool:
        return ArrayExpression.variable(filterKey).equalTo(Expression.boolean(_val))
    case let _val as [String]:
        return ArrayExpression.variable(filterKey).equalTo(Expression.array(_val))
    default:
        print("default value in getEQOperatorExpression")
        return nil
    }
}

func getNotEQOperatorArrayExpression(filterKey: String, filterValue: Any ) -> CouchbaseLiteSwift.ExpressionProtocol? {
    switch filterValue {
    case let _val as String:
        return ArrayExpression.variable(filterKey).notEqualTo(Expression.string(_val))
    case let _val as Double:
        return ArrayExpression.variable(filterKey).notEqualTo(Expression.double(_val))
    case let _val as Float:
        return ArrayExpression.variable(filterKey).notEqualTo(Expression.float(_val))
    case let _val as Int:
        return ArrayExpression.variable(filterKey).notEqualTo(Expression.int(_val))
    case let _val as Bool:
        return ArrayExpression.variable(filterKey).notEqualTo(Expression.boolean(_val))
    default:
        print("default value in getEQOperatorExpression")
        return nil
    }
}


func getFilterBodyBasedOnTypes(filterBody: [String: Any], isNested: Bool = false) -> [String: Any] {
    var morphedBody = [:] as [String: Any]
    for (filterKey, body) in filterBody {
        if let _body = (body as? [String: Any]) {
            let morphedFilterKey: String = filterKey
            morphedBody[morphedFilterKey] = _body["value"]
        }
        else if isNested,
                let body = (body as? [String: Any]) {
            for (nestedKey, nestedValue) in body {
                if let nestedData = nestedValue as? [String: Any],
                   let nestedDataValue = nestedData["value"] {
                    let combinedKey = filterKey + "." + nestedKey
                    morphedBody[combinedKey] = nestedDataValue
                }
            }
        } else {
            morphedBody[filterKey] = body
        }
    }
    return morphedBody
}

func getFormDataWithoutTypes(formBody: [String: Any]) -> [String: Any] {
    var morphedFormBody: [String: Any] = [:]
    for (key, value) in formBody {
        if let vdata = value as? [String: Any],
           let nestedValue = vdata["value"] {
            morphedFormBody[key] = nestedValue
        }

        if let vdata = value as? [String: Any] {
            for (nestedKey, nestedValue) in vdata {
                if let nestedData = nestedValue as? [String: Any],
                   let nestedDataValue = nestedData["value"] {
                    let combinedKey = key + "." + nestedKey
                    morphedFormBody[combinedKey] = nestedDataValue
                }
            }
        }
    }
    return morphedFormBody
}
