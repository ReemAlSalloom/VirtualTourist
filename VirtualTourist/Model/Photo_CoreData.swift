//
//  Image_CoreData.swift
//  VirtualTourist
//
//  Created by Reem Saloom on 1/26/19.
//  Copyright © 2019 Reem AlSalloom. All rights reserved.
//


import Foundation
import CoreData

//MARK: Image & CoreData Class

public class Photos: NSManagedObject
{

    @nonobjc public class func fetchRequest()-> NSFetchRequest<Photos>
    {
        return NSFetchRequest<Photos>(entityName: "Photo")
    }
    @NSManaged public var url: String?
    
    @NSManaged public var pin: PinItem?
   
     @NSManaged public var image : NSData?
    
    convenience init(image: NSData?, point: PinItem, context: NSManagedObjectContext, url: String = "")
    {
        if let entity = NSEntityDescription.entity(forEntityName: "Photo", in: context)
        {
            self.init(entity: entity, insertInto: context)
           
            self.pin = point
            self.url = url
             self.image = image
        }
        else
        {
            fatalError("ERROR: Unable to find Photo Entity")
        }
    }
}
