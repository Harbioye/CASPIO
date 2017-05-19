//
//  TimerViewController.swift
//  InfiniteSolution
//
//  Created by abioye mohammed on 5/18/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import SpeechToTextV1

class TimerViewController: UIViewController {
    
    var speechToText: SpeechToText!
    var speechToTextSession: SpeechToTextSession!
    var isStreaming = false
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var microphoneButton: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var results = ""
    
    //This variable will hold a starting value of seconds. It could be any amount above 0.
    var seconds = 0
    
    var timer = Timer()
    
    //This will be used to make sure only one timer is created at a time.
    var isTimerRunning = false
    
    var resume = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechToText = SpeechToText(
            username: Credentials.SpeechToTextUsername,
            password: Credentials.SpeechToTextPassword
        )
        speechToTextSession = SpeechToTextSession(
            username: Credentials.SpeechToTextUsername,
            password: Credentials.SpeechToTextPassword
        )
    }
    
    @IBAction func microphone(_ sender: UIButton) {
        streamMicrophoneBasic()
    }
    
    @IBAction func endRecording(_ sender: UIButton) {
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: #selector(TimerViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    func updateTimer(){
            seconds += 1
        timerLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    //pause
    @IBAction func pauseButton(_ sender: UIButton) {
        if self.resume == false {
            timer.invalidate()
            self.resume = true
            //self.pauseButton(<#T##sender: UIButton##UIButton#>)
        }
        else {
            runTimer()
            self.resume = false
            //self.pauseButton.setTitle("Pause",for: .normal)
        }
    }
    
    //format the time
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    /**
     This function demonstrates how to use the basic
     `SpeechToText` class to transcribe microphone audio.
     */
    public func streamMicrophoneBasic() {
        if !isStreaming {
            //begin running timer
            timerLabel.text = "\(seconds)"
            runTimer()
            // update state
            microphoneButton.setTitle("Stop Microphone", for: .normal)
            isStreaming = true
            
            // define recognition settings
            var settings = RecognitionSettings(contentType: .opus)
            settings.continuous = true
            settings.interimResults = true
            
            // define error function
            let failure = { (error: Error) in print(error) }
            
            // start recognizing microphone audio
            speechToText.recognizeMicrophone(settings: settings, failure: failure) {
                results in
                self.textView.text = results.bestTranscript
            }
            
        } else {
            
            // update state
            microphoneButton.setTitle("Start Microphone", for: .normal)
            isStreaming = false
            timer.invalidate()
            
            self.results = textView.text
            
            textView.text = AppState.instance.recordText
            
            // Grab text from label
            timerLabel.text = "\(seconds)"
            // stop recognizing microphone audio
            speechToText.stopRecognizeMicrophone()
        }
        //reset timer to 0
        timerLabel.text = "00:00:00"
    }
    
    /**
     This function demonstrates how to use the more advanced
     `SpeechToTextSession` class to transcribe microphone audio.
     */
    public func streamMicrophoneAdvanced() {
        if !isStreaming {
            
            // update state
            microphoneButton.setTitle("Stop Microphone", for: .normal)
            isStreaming = true
            
            // define callbacks
            speechToTextSession.onConnect = { print("connected") }
            speechToTextSession.onDisconnect = { print("disconnected") }
            speechToTextSession.onError = { error in print(error) }
            speechToTextSession.onPowerData = { decibels in print(decibels) }
            speechToTextSession.onMicrophoneData = { data in print("received data") }
            speechToTextSession.onResults = { results in self.textView.text = results.bestTranscript }
            
            // define recognition settings
            var settings = RecognitionSettings(contentType: .opus)
            settings.continuous = true
            settings.interimResults = true
            
            // start recognizing microphone audio
            speechToTextSession.connect()
            speechToTextSession.startRequest(settings: settings)
            speechToTextSession.startMicrophone()
            
        } else {
            
            // update state
            microphoneButton.setTitle("Start Microphone", for: .normal)
            isStreaming = false
            
            // stop recognizing microphone audio
            speechToTextSession.stopMicrophone()
            speechToTextSession.stopRequest()
            speechToTextSession.disconnect()
        }
    }
    //create a function to enable access to results variable from this controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? saveTextViewController {
            destination.results = self.results
        }
    }
}
