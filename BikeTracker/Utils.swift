//
//  Utils.swift
//  BikeTracker
//
//  Created by Vegard Seim Karstang on 24.07.2018.
//  Copyright © 2018 Vegard Seim Karstang. All rights reserved.
//

import Foundation

class Utils {
    static func formatTimeDiff(timeDiff: TimeInterval) -> String {
        var result = ""

        let hundreths = Int(timeDiff.truncatingRemainder(dividingBy: 1) * 100)
        let seconds = Int(timeDiff) % 60
        let minutes = (Int(timeDiff) / 60) % 60

        result = hundreths < 10 ? "0\(hundreths)" : "\(hundreths)"
        result = seconds < 10 ? "0\(seconds).\(result)" : "\(seconds).\(result)"
        result = minutes < 10 ? "0\(minutes):\(result)" : "\(minutes):\(result)"

        return result

    }
}
