//
//  Product+CoreDataProperties.swift
//  Shopping List
//
//  Created by Victor Martinez on 6/5/21.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var productName: String?
    @NSManaged public var productDescription: String?
    @NSManaged public var productPrice: NSDecimalNumber?

}

extension Product : Identifiable {
    
}
