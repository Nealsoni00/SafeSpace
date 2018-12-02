//
//  SoundVC.swift
//  SafeSpace
//
//  Created by Neal Soni on 12/2/18.
//  Copyright © 2018 Neal Soni. All rights reserved.
//

import UIKit
import AVFoundation

class SoundVC: UIViewController {

    @IBOutlet weak var soundLabel: UILabel!
    var timer: DispatchSourceTimer?
    var progress: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = directoryURL()
        progress = 0
        let recordSettings = [
            AVSampleRateKey : NSNumber(value: Float(44100.0) as Float),
            AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC) as Int32),
            AVNumberOfChannelsKey : NSNumber(value: 1 as Int32),
            AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue) as Int32),
            ]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options:  AVAudioSession.CategoryOptions.defaultToSpeaker)
            let audioRecorder = try AVAudioRecorder(url: url!, settings: recordSettings)
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            try audioSession.setActive(true)
            audioRecorder.isMeteringEnabled = true
            recordForever(audioRecorder: audioRecorder)
        } catch let err {
            print("Unable start recording", err)
        }
    }
    
    func directoryURL() -> URL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent("sound.m4a")
        return soundURL
    }
    
    func recordForever(audioRecorder: AVAudioRecorder) {
        
            
            
        let queue = DispatchQueue(label: "io.segment.decibel", attributes: .concurrent)
        timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        timer?.scheduleRepeating(deadline: .now(), interval: .seconds(1), leeway: .milliseconds(100))
        timer?.setEventHandler { [weak self] in
            audioRecorder.updateMeters()
            self!.progress += 1
            print("progress \(self?.progress)")
            // NOTE: seems to be the approx correction to get real decibels
            let correction: Float = 100
            let average = audioRecorder.averagePower(forChannel: 0) + correction
            let peak = audioRecorder.peakPower(forChannel: 0) + correction
            print("\(average) and \(peak)")
            self!.soundLabel.text = "Average: \(average) hz and peak: \(peak) hz"
//            if (self!.progress > 10){
//                self!.timer?.cancel()
//                self!.timer?.suspend()
//            }
            //            self?.recordDatapoint(average: average, peak: peak)
        }
       
    }
    @IBAction func cancelPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addPressed(_ sender: AnyObject) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
