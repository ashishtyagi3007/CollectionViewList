//
//  Model.swift
//  CollectionViewList
//
//  Created by Ashish Tyagi on 20/10/20.
//

import Foundation
import UIKit

struct HeaderItem: Hashable {
    let title: String
    let symbols: [SFSymbolItem]
}


struct SFSymbolItem: Hashable {
    let name: String
    let image: UIImage
    
    init(name: String) {
        self.name = name
        self.image = UIImage(systemName: name)!
    }
}
