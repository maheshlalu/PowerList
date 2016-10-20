//
//  UserProfile+CoreDataProperties.swift
//  CoupCon
//
//  Created by apple on 20/10/16.
//  Copyright © 2016 CX. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UserProfile {

    @NSManaged var userId: String?
    @NSManaged var emailId: String?
    @NSManaged var firstName: String?
    @NSManaged var fullName: String?
    @NSManaged var lastName: String?
    @NSManaged var orgId: String?
    @NSManaged var userPic: String?
    @NSManaged var macId: String?
    @NSManaged var macIdJobId: String?

}
