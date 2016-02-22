//
//  ManagedItem+CoreDataProperties.swift
//  AppleSearcher
//
//  Created by andrey on 22/02/16.
//  Copyright © 2016 AndreyLebedev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ManagedItem {

    @NSManaged var desription: String?
    @NSManaged var imageURLString: String?
    @NSManaged var name: String?
    @NSManaged var trackID: NSNumber?

}
