//
//  ViewController.swift
//  BikeTracker
//
//  Created by Vegard Seim Karstang on 21.07.2018.
//  Copyright © 2018 Vegard Seim Karstang. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    private var startTime: Date = Date()
    private var curTime: Date = Date()
    private var endTime: Date = Date()
    private var curTimeDiff: TimeInterval = 0.0
    private var finalTimeDiff: TimeInterval = 0.0
    private var timer = Timer()
    private var running = false
    private var direction = true // True = to work, false = to home

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var directionButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 60.0, weight: .regular)
    }

    @IBAction func startButtonClicked(_ sender: UIButton) {
        if (running) {
            running = false
            endTime = Date()
            timer.invalidate()
            finalTimeDiff = endTime.timeIntervalSince(startTime)
            startButton.setTitle("Start", for: .normal)
            timeLabel.text = formatTimeDiff(timeDiff: finalTimeDiff)
            TripManager.addNewTrip(startTime: startTime, endTime: endTime, direction: direction)
        } else {
            startTime = Date()
            startButton.setTitle("Stop", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            running = true
        }

    }

    @objc func updateTimer() {
        if (running) {
            curTime = Date()
            curTimeDiff = curTime.timeIntervalSince(startTime)
            timeLabel.text = formatTimeDiff(timeDiff: curTimeDiff)
        }
    }

    func formatTimeDiff(timeDiff: TimeInterval) -> String {
        var result = ""

        let hundreths = Int(timeDiff.truncatingRemainder(dividingBy: 1) * 100)
        let seconds = Int(timeDiff) % 60
        let minutes = (Int(timeDiff) / 60) % 60

        result = hundreths < 10 ? "0\(hundreths)" : "\(hundreths)"
        result = seconds < 10 ? "0\(seconds).\(result)" : "\(seconds).\(result)"
        result = minutes < 10 ? "0\(minutes):\(result)" : "\(minutes):\(result)"

        return result

    }

    @IBAction func directionButtonClicked(_ sender: UIButton) {
        if (!running) {
            direction = !direction
            let buttonTitle = direction ? "Work" : "Home"
            directionButton.setTitle(buttonTitle, for: .normal)
        }
    }
}

