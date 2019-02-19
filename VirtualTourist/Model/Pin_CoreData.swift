//
//  Pin_CoreData.swift
//  VirtualTourist
//
//  Created by Reem Saloom on 1/26/19.
//  Copyright © 2019 Reem AlSalloom. All rights reserved.
//

import Foundation
import CoreData

public class PinItem: NSManagedObject
{

     public class func fetchRequest()-> NSFetchRequest<PinItem>
    {
        return NSFetchRequest<PinItem>(entityName: "Pin")
    }
    @NSManaged public var latitude: Double

    @NSManaged public var longitude: Double
    
    @NSManaged public var image: NSSet?
    
    @NSManaged public var id: Int32

    convenience init(lat: Double, long: Double, context: NSManagedObjectContext)
    {
        if let entity = NSEntityDescription.entity(forEntityName: "Pin", in: context)
        {
            self.init(entity: entity, insertInto: context)
            self.longitude = long
            self.latitude = lat
            self.id = 1
        }
        else
        {
            fatalError("ERROR: Unable to find Pin Entity")
        }
        
    }
//}
//
//extension PinItem
//{
    @objc(addImageObject:)
    @NSManaged public func addToImage(_ value: Photos)
    
    @objc(removeImageObject:)
    @NSManaged public func removeFromImage(_ value: Photos)
    
    @objc(addImage:)
    @NSManaged public func addToImage(_ values: NSSet)
    
    @objc(removeImage:)
    @NSManaged public func removeFromImage(_ values: NSSet)
}
