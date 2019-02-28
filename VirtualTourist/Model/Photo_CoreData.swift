//
//  Image_CoreData.swift
//  VirtualTourist
//
//  Created by Reem Saloom on 1/26/19.
//  Copyright © 2019 Reem AlSalloom. All rights reserved.
//


import Foundation
import CoreData
import Alamofire


public class PhotoItem: NSManagedObject
{

    static func fetchController(pin:Pin,context:NSManagedObjectContext) -> NSFetchedResultsController<Photo>{
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:context, sectionNameKeyPath: nil, cacheName: nil)
    }
    static func add(url: String,pin:Pin,context:NSManagedObjectContext) {
        let photo = Photo(context: context)
        photo.url = url
        //photo.image = image.jpegData(compressionQuality: 1.0)
        photo.pin = pin
        do
        {
            try context.save()
        }
        catch
        {
            print(error)
        }
    }
    
    static func deleteAll(fetchController:NSFetchedResultsController<Photo>,context:NSManagedObjectContext) {
        
        do
        {
            fetchController.fetchedObjects!.forEach { (photo) in
                context.delete(photo)
            }
            try context.save()
        }
        catch
        {
            print(error)
        }
    }
    
    static func delete(photo:Photo ,context:NSManagedObjectContext) {
        context.delete(photo)
        do
        {
            try context.save()
        }
        catch
        {
            print(error)
        }
    }
    
    static func getImagesUrls(lat: Double, long: Double,page:Int, completion: @escaping ([String],String?)->Void) {
        let param = FParams(latitude:lat,longitude:long,page:page)
        let url = param.getUrl()
        var images = [String]()
        print(url)
        AF.request(url).responseJSON { (response) in
            //    print(response)
            switch response.result {
            case .failure(let error):
                print(error)
                completion([],error.localizedDescription)
            case .success:
                print(response)
                let AlbumRes:AlbumResponse? = try? JSONDecoder().decode(AlbumResponse.self, from:response.data! )
                if(AlbumRes?.stat == "ok"){
                    for photo in (AlbumRes?.photos.photo)!{
                        images.append(photo.url)
                    }
                    completion(images,nil)
                }
                else {
                    completion([],"Error during photos download")
                }
                
            }
        }
    }
}

extension Photo {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        createdDate = Date()
    }
}
