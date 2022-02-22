//
//  RealmObjects.swift
//  RealmExp
//
//  Created by vliu on 21/2/2022.
//

import Foundation
import RealmSwift

//class Project: Object, ObjectKeyIdentifiable {
//    @Persisted(primaryKey: true) var id: String = UUID().uuidString.lowercased()
//    @Persisted var reference: String = ""
//}

class Project: ObservableObject, Identifiable {
    @Published var id: String = UUID().uuidString.lowercased()
    @Published var reference: String = ""
}
