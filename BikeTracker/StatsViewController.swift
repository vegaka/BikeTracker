//
//  StatsViewController.swift
//  BikeTracker
//
//  Created by Vegard Seim Karstang on 21.07.2018.
//  Copyright © 2018 Vegard Seim Karstang. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController, UITableViewDataSource  {

    @IBOutlet weak var homeTimeLabel: UILabel!
    @IBOutlet weak var workTimeLabel: UILabel!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TripManager.getAmountofTrips()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statTableCell") as! StatsTableViewCell

        let trip = TripManager.getTrip(index: indexPath.row)
        let startTime = trip.value(forKeyPath: "startTime") as! Date
        let endTime = trip.value(forKeyPath: "endTime") as! Date
        let direction = trip.value(forKeyPath: "direction") as! Bool

        cell.dateLabel.text = getDateString(date: startTime)
        cell.directionLabel.text = direction ? "Work" : "Home"
        cell.timeLabel.text = Utils.formatTimeDiff(timeDiff: endTime.timeIntervalSince(startTime))

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            TripManager.deleteTrip(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateFastestTimes();
        }
    }

    func updateFastestTimes() {
        let fastestHomeTime = TripManager.getFastestTime(direction: false)
        homeTimeLabel.text = Utils.formatTimeDiff(timeDiff: fastestHomeTime)

        let fastestWorkTime = TripManager.getFastestTime(direction: true)
        workTimeLabel.text = Utils.formatTimeDiff(timeDiff: fastestWorkTime)
    }

    private func getDateString(date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

        var result = "\(year)"
        result = month < 10 ? "\(result)-0\(month)" : "\(result)-\(month)"
        result = day < 10 ? "\(result)-0\(day)" : "\(result)-\(day)"

        return result
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        homeTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 24.0, weight: .regular)
        workTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 24.0, weight: .regular)

        updateFastestTimes()
    }


}
