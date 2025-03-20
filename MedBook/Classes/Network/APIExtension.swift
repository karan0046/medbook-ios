//
//  API+HTTPMehod.swift
//  MedBook
//
//  Created by Karan Kumar Sah on 20/03/25.
//

extension API {
    func get() -> Self {
        self.method = .get
        return self
    }

    func post() -> Self {
        self.method = .post
        return self
    }

    func put() -> Self {
        self.method = .put
        return self
    }

    func delete() -> Self {
        self.method = .delete
        return self
    }
}
