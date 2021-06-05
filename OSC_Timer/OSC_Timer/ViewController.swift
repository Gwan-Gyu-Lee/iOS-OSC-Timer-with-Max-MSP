//
//  ViewController.swift
//  OSC_Timer
//
//  Created by Gwan-Gyu Lee(frd.lee@icloud.com) on 4/24/21.
// 
//  This application contains copyrighted software under MIT License.
//  OSCKit - Copyright (c) 2018 Steffan Andrews - https://github.com/orchetect

import UIKit
import OSCKit

class ViewController: UIViewController {
    
    @IBOutlet var lblHours: UILabel!
    @IBOutlet var lblMinutes: UILabel!
    @IBOutlet var lblSeconds: UILabel!
    @IBOutlet var lblMiliSeconds: UILabel!
    
    var timer: Timer = Timer()
    var timerForMiliSeconds: Timer = Timer()
    
    var count: Int = 240
    var startCount: Int = 240
    var repeatCount: Int = 260
    
    var countForMiliSeconds: Int = 0
    
    var timerCounting: Bool = false
    
    var oscServer: UDPServer?
    
    var oscOnOff = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // OSC server setup
        
        do {
            oscServer = try UDPServer(
                host: "localhost",
                port: 8000,
                queue: DispatchQueue.global(qos: .userInteractive)
            )
        } catch {
            print("Error initializing UDP server:", error)
            return
        }
        
        oscServer?.setHandler { [weak self] data in
            
            // incoming data handler is fired on the UDPServer's queue
            // but we want to deal with it on the main thread
            // to update UI as a result, etc. here
            
            DispatchQueue.main.async {
                
                do {
                    guard let oscPayload = try data.parseOSC() else { return }
                    self?.handleOSCPayload(oscPayload)
                    
                } catch let error as OSCBundle.DecodeError {
                    // handle bundle errors
                    switch error {
                    case .malformed(let verboseError):
                        print("Error:", verboseError)
                    }
                    
                } catch let error as OSCMessage.DecodeError {
                    // handle message errors
                    switch error {
                    case .malformed(let verboseError):
                        print("Error:", verboseError)
                        
                    case .unexpectedType(let oscType):
                        print("Error: unexpected OSC type tag:", oscType)
                        
                    }
                    
                } catch {
                    // handle other errors
                    print("Error:", error)
                }
                
            }
            
        }
        
        print("UDP server set up.")
        
    }
    
    /// Handle incoming OSC data recursively
    func handleOSCPayload(_ oscPayload: OSCBundlePayload) {
        
        switch oscPayload {
        case .bundle(let bundle):
            // recursively handle nested bundles and messages
            bundle.elements.forEach { handleOSCPayload($0) }

        case .message(let message):
            // handle message
            oscOnOff = message.values.description
            oscOnOff.removeFirst(7)
            oscOnOff.removeLast()
            
        }
        
        if oscOnOff == "0" {
            timerCounting = false
            timer.invalidate()
            timerForMiliSeconds.invalidate()

//            self.count = 0
//            self.countForMiliSeconds = 0
//            self.timer.invalidate()
//            self.timerForMiliSeconds.invalidate()
//            
//            self.lblHours.text = self.makeTimreString(time: 0)
//            self.lblMinutes.text = self.makeTimreString(time: 0)
//            self.lblSeconds.text = self.makeTimreString(time: 0)
//            self.lblMiliSeconds.text = self.makeTimreString(time: 0)
            
        } else if oscOnOff == "1" {
            timerCounting = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            timerForMiliSeconds = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerCounterForMiliSeconds), userInfo: nil, repeats: true)
        
        }
       
    }

    @objc func timerCounter() -> Void {
        count = count + 1
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let hours = makeTimreString(time: time.0)
        let minutes = makeTimreString(time: time.1)
        let seconds = makeTimreString(time: time.2)
        
        lblHours.text = hours
        lblMinutes.text = minutes
        lblSeconds.text = seconds
        
        if count == repeatCount {
            count = startCount
        }
        
        print(count)
    }
    
    @objc func timerCounterForMiliSeconds() -> Void {
        countForMiliSeconds = countForMiliSeconds + 1
        let time = miliSeconds(miliSeconds: countForMiliSeconds)
        let miliSeconds = makeTimreString(time: time)
        
        lblMiliSeconds.text = miliSeconds
        
//        print(countForMiliSeconds)
    }
    
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        
        return ( (seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60) )
    }
    
    func miliSeconds(miliSeconds: Int) -> Int {
        return ( (miliSeconds % 3600) % 100 )
    }
    
    func makeTimreString(time: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", time)

        return timeString
    }
    
    
}

