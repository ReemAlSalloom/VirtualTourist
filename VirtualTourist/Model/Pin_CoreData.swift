//
//  Pin_CoreData.swift
//  VirtualTourist
//
//  Created by Reem Saloom on 1/26/19.
//  Copyright © 2019 Reem AlSalloom. All rights reserved.
//

import Foundation
import CoreData
import MapKit

public class PinItem
{
    static func add(latitude: Double ,longitude: Double,context:NSManagedObjectContext) -> Pin {
        let pin = Pin(context: context)
        pin.latitude = latitude
        pin.longitude = longitude
        do
        {
            try context.save()
        }
        catch
        {
            print(error)
        }
        return pin
    }
    
    static func getPins(context:NSManagedObjectContext) -> [Pin]{
        var pins: [Pin] = []
        let fetchRequest = NSFetchRequest<Pin>(entityName: "Pin")
        do {
            pins = try context.fetch(fetchRequest)
        } catch {
            fatalError("error fetching : \(error.localizedDescription)")
        }
        
        return pins
    }
    
    static func getPinByCoordination(pins:[Pin],coordinate:CLLocationCoordinate2D?)->Pin?{
        guard let coordinate = coordinate else {
            return nil
        }
        for pin in pins {
            if pin.latitude == coordinate.latitude && pin.longitude == coordinate.longitude {
                return pin
            }
        }
        return nil
    }
}
