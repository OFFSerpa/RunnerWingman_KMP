//
//  TimeFormatters.swift
//  RunnerWingmanKMP
//
//  Wrapper Swift que delega ao TimeFormatters do shared Kotlin module.
//

import Foundation
import Shared

enum TimeFormattersHelper {
    static func mmss(_ seconds: Double) -> String {
        return TimeFormatters.shared.mmss(seconds: seconds)
    }
}
