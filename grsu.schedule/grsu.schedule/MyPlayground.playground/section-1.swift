// Playground - noun: a place where people can play

import UIKit

let date = NSDate()
let calendar = NSCalendar.currentCalendar()

var startOfTheWeek : NSDate?
var endOfWeek : NSDate?
var interval: NSTimeInterval = 0

calendar.rangeOfUnit(NSCalendarUnit.WeekCalendarUnit, startDate: &startOfTheWeek, interval: &interval, forDate: date)
endOfWeek = startOfTheWeek?.dateByAddingTimeInterval(interval-1)

startOfTheWeek
endOfWeek
interval