//
//  FetchResultsController.swift
//  VirtualTourist
//
//  Created by Reem Saloom on 2/18/19.
//  Copyright © 2019 Reem AlSalloom. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FetchResultsController: UIViewController
{
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    func fetchCompletion(fetchedResultController: NSFetchedResultsController<NSFetchRequestResult>?, completion: ()->() )
    {
        fetchedResultController?.delegate = self as? NSFetchedResultsControllerDelegate
        startSearch()
        completion()
    }
    
}

extension FetchResultsController
{
    func startSearch()
    {
        if let fetchController = fetchedResultsController
        {
            do
            {
                try fetchController.performFetch()
            }
            catch let error as NSError
            {
                print("ERROR: Unable to perform search operation!\n\(error)")
            }
        }
    }
}
