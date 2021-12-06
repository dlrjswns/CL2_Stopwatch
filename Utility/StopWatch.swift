//
//  StopWatch.swift
//  CL2_Stopwatch
//
//  Created by 이건준 on 2021/12/06.
//

import Foundation

class Stopwatch: NSObject {
  var counter: Double
  var timer: Timer
  
  override init() {
    counter = 0.0
    timer = Timer()
  }
}
