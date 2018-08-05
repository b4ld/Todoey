//
//  item.swift
//  Todoey
//
//  Created by Pedro Carmezim on 02/08/18.
//  Copyright © 2018 Pedro Carmezim. All rights reserved.
//

import Foundation

//Replace Codable
class Item : Encodable,Decodable {
    
    //NSCODER
    //Turn this class encodeble _Able to enconde his self to a .plist or JSON
    //Cant HAve Custom ClassTypes or Custem Type
    
    var title : String = ""
    var done : Bool = false
      
}
