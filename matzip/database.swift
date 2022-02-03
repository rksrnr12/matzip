//
//  database.swift
//  matzip
//
//  Created by 한국 on 2022/02/03.
//

import Foundation
import RealmSwift

class tableData:Object{
    @objc dynamic var name:String = ""
    @objc dynamic var address:String = ""
    @objc dynamic var explain:String = ""
    @objc dynamic var image:Data = Data()
}
