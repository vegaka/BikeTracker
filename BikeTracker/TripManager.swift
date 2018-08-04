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
            trips.insert(trip, at: 0)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    static func deleteTrip(index: Int) {
        let objectToDelete = trips[index]
        managedContext.delete(objectToDelete)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        trips.remove(at: index)
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

        trips.sort(by: compareTrips(trip1:trip2:))
    }

    static func getFastestTime(direction: Bool) -> TimeInterval {
        var fastestTime: TimeInterval = Double.greatestFiniteMagnitude

        for trip in trips {
            let dir = trip.value(forKeyPath: "direction") as! Bool
            if dir == direction {
                let start = trip.value(forKeyPath: "startTime") as! Date
                let end = trip.value(forKeyPath: "endTime") as! Date
                let diff = end.timeIntervalSince(start)
                if diff < fastestTime {
                    fastestTime = diff
                }
            }
        }

        return fastestTime
    }

    private static func compareTrips(trip1: NSManagedObject, trip2: NSManagedObject) -> Bool {
        let date1 = trip1.value(forKeyPath: "startTime") as! Date
        let date2 = trip2.value(forKeyPath: "startTime") as! Date

        return date1.compare(date2) == ComparisonResult.orderedDescending
    }

    static func getAmountofTrips() -> Int {
        return trips.count
    }

    static func getTrip(index: Int) -> NSManagedObject {
        return trips[index]
    }
}
