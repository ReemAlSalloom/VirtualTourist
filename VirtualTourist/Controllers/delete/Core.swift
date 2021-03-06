////
////  Core.swift
////  VirtualTourist
////
////  Created by Reem Saloom on 1/26/19.
////
//
//import UIKit
//import CoreData
//import Foundation
//
//class Core: UIViewController, UICollectionViewDelegate
//{
//    //MARK: Outlets
//    
//    
//    @IBOutlet weak var collectionView: UICollectionView!
//    //MARK: Properties
//    
//    let delegate = UIApplication.shared.delegate as! AppDelegate
//    var update = [IndexPath]()
//    var delete = [IndexPath]()
//    var insert = [IndexPath]()
//    
//    
//    var fetchedResultController : NSFetchedResultsController<Photos>?
//    
//    required init?(coder aDecoder: NSCoder)
//    {
//        super.init(coder: aDecoder)
//    }
//    
//    func startSearch()
//    {
//        if let fetchController = fetchedResultController
//        {
//            do
//            {
//                try fetchController.performFetch()
//            }
//            catch
//            {
//                print("ERROR: Unable to perform fetch")
//            }
//        }
//    }
//    
//    func numberOfSectionsInCollectionView(_ collectionView: UICollectionView)-> Int
//    {
//        //return 1;
//        if let count = self.fetchedResultController
//        {
//            return(count.sections?.count)!
//        }
//        else
//        {
//            return 0
//        }
//    }
//    
//    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int
//    {
//        if let sec = self.fetchedResultController!.sections
//        {
//            return sec[section].numberOfObjects
//        }
//        return 0
//    }
//    
//    @objc (collectionView:didSelectItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
//    {
//        if let fetchController = self.fetchedResultController
//        {
//            fetchController.managedObjectContext.delete((fetchedResultController?.object(at: indexPath))! as NSManagedObject)
//            try! self.delegate.store.saveContext()
//            
//            DispatchQueue.main.async
//                {
//                    self.collectionView.reloadData()
//            }
//        }
//    }
//    
//}
//extension Core: NSFetchedResultsControllerDelegate
//{
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
//    {
//        self.insert = [IndexPath]()
//        self.update = [IndexPath]()
//        self.delete = [IndexPath]()
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
//    {
//        switch type
//        {
//        case .delete:
//            self.delete.append(indexPath!)
//            break
//        case .insert:
//            self.insert.append(newIndexPath!)
//            break
//        case .update:
//            self.update.append(indexPath!)
//            break
//        default:
//            return
//        }
//    }
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
//    {
//        self.collectionView.performBatchUpdates({ ()-> Void in
//            for completed in self.delete
//            {
//                self.collectionView.deleteItems(at: [completed])
//            }
//            for completed in self.insert
//            {
//                self.collectionView.insertItems(at: [completed])
//            }
//            for completed in self.update
//            {
//                self.collectionView.reloadItems(at: [completed])
//            }
//        }, completion: nil)
//    }
//    
//}
