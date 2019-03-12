//
//  Categories.swift
//  Todey
//
//  Created by Marko Kolaric on 11.03.19.
//  Copyright © 2019 Marko Kolaric. All rights reserved.
//

import Foundation
import RealmSwift

class Categories: Object {
    @objc dynamic var name : String = ""
    let items = List<Items>()
}
