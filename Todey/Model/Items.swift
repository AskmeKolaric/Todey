//
//  Items.swift
//  Todey
//
//  Created by Marko Kolaric on 11.03.19.
//  Copyright © 2019 Marko Kolaric. All rights reserved.
//

import Foundation
import RealmSwift

class Items: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Categories.self, property: "items")
}
