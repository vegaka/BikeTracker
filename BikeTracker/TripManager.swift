//
//  TimeManager.swift
//  BikeTracker
//
//  Created by Vegard Seim Karstang on 21.07.2018.
//  Copyright © 2018 Vegard Seim Karstang. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class TripManager {

    private static var trips: [NSManagedObject] = []
    private static var appDelegate: AppDelegate? = nil
    private static var managedContext: NSManagedObjectContext! = nil
    private static var entity: NSEntityDescription! = nil

    private static var loadError = false

    static func initManager() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate

        if let delegate = appDelegate {
            managedContext = delegate.persistentContainer.viewContext
            entity = NSEntityDescription.entity(forEntityName: "Trips", in: managedContext)!
        } else {
            loadError = true
            print("Error initializing TripManager")
        }
    }

    static func addNewTrip(startTime: Date, endTime: Date, direction: Bool) {
        if loadError {
            return
        }

        let trip = NSManagedObject(entity: entity, insertInto: managedContext)

        trip.setValue(startTime, forKey: "startTime")
        trip.setValue(endTime, forKey: "endTime")
        trip.setValue(direction, forKey: "direction")

        do {
            try managedContext.save()
            trips.append(trip)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    static func loadTrips() {
        if loadError {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Trips")

        do {
            trips = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
