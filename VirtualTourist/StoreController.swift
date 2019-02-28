//
//  StoreController.swift
//  VirtualTourist
//
//  Created by Reem Saloom on 2/27/19.
//  Copyright © 2019 Reem AlSalloom. All rights reserved.
//

import Foundation
import CoreData

class StoreController{
    let persistentContainer:NSPersistentContainer
    
    var context:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescripation , error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
}
