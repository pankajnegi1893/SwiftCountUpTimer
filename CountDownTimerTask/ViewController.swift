//
//  ViewController.swift
//  CountDownTimerTask
//
//  Created by Pankaj Negi on 07/06/19.
//  Copyright © 2019 Pankaj Negi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var incrementByLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    
    @IBOutlet weak var startPauseButton: UIButton!
    
    var isTimerStop = false
    
    var currentSecond = 0
    
    var scheduleTimerTask: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        incrementByLabel.text = Int(sender.value).description
    }
    
    func scheduleTimer(){
        if scheduleTimerTask == nil {
            scheduleTimerTask = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.taskUpdate), userInfo: nil, repeats: true)
        }
    }
    
    func stopScheduleTimer() {
        if scheduleTimerTask != nil {
            scheduleTimerTask?.invalidate()
        }
    }
    
    @objc func taskUpdate() {
        countdownLabel.text = getCurrentTimeString()
    }
    
    @IBAction func btnStartPauseTapped(_ sender: UIButton) {
        if isTimerStop {
            stopTimer()
        }else {
            startTimer()
        }
    }
    
    @IBAction func btnStopTapped(_ sender: UIButton) {
        stopTimer()
        currentSecond = 0
        countdownLabel.text = "00:00:00"
    }
    
    func stopTimer() {
        startPauseButton.setTitle("Start", for: .normal)
        isTimerStop = false
        stopScheduleTimer()
        scheduleTimerTask = nil
    }
    
    func startTimer() {
        startPauseButton.setTitle("Pause", for: .normal)
        isTimerStop = true
        scheduleTimer()
    }
    
}

extension ViewController {
    
    func getCurrentTimeString() -> String {
        let currentIncrementValue: Int = Int(stepper!.value)
        currentSecond = currentSecond + currentIncrementValue
        if currentSecond <= 0 {
            currentSecond = 0
            return "00:00:00"
        }
        if currentSecond < 59 {
            return "00:00: \(currentSecond > 9 ? "\(currentSecond)" : "0\(currentSecond)" )"
        }else if getMins(currentSecond) < 59 {
            let currentMin = getMins(currentSecond) > 9 ? "\(getMins(currentSecond))"  : "0\(getMins(currentSecond))"
            let currentSec = getRemainSec(currentSecond) > 9 ? "\(getRemainSec(currentSecond))" : "0\(getRemainSec(currentSecond))"
            return "00:\(currentMin):\(currentSec)"
        }else {
            let currentHours = getHours(currentSecond) > 9 ? "\(getHours(currentSecond))"  : "0\(getHours(currentSecond))"
            let totalMin = getMins(currentSecond)
            let currentMinWithHrs = totalMin % 60
            let currentMin = currentMinWithHrs > 9 ? "\(currentMinWithHrs)"  : "0\(currentMinWithHrs)"
            
            let currentSec = getReaminSecFromHrsSec(currentSecond) > 9 ? "\(getReaminSecFromHrsSec(currentSecond))" : "0\(getReaminSecFromHrsSec(currentSecond))"
            return "\(currentHours):\(currentMin):\(currentSec)"
            
        }
    }
    
    func getHours(_ sec: Int) -> Int {
        return sec/60/60
    }
    
    func getMins(_ sec: Int) -> Int {
        return sec/60
    }
    
    func getRemainSec(_ sec: Int) -> Int {
        return sec%60
    }
    
    func getReaminSecFromHrsSec(_ sec: Int) -> Int {
        let currentSec =  Double(sec) / 60.0
        let floatingMinRemainder = currentSec.truncatingRemainder(dividingBy: 1)
        return Int((floatingMinRemainder * 60).rounded())
    }
}

