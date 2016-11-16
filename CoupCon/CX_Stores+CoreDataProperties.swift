//
//  CX_Stores+CoreDataProperties.swift
//  
//
//  Created by apple on 16/11/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CX_Stores {

    @NSManaged var createdById: String?
    @NSManaged var favourite: String?
    @NSManaged var itemCode: String?
    @NSManaged var json: String?
    @NSManaged var name: String?
    @NSManaged var storeID: String?
    @NSManaged var type: String?

}
