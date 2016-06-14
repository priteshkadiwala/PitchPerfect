//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Dharini Kadiwala on 19/05/15.
//  Copyright (c) 2015 Dharini Kadiwala. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseRecord: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var tapRecord: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        tapRecord.text = "Tap to record"
        recordButton.enabled = true
        pauseRecord.hidden = true
        tapRecord.hidden = false
        stopButton.hidden = true
        playButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playButton(sender: UIButton) {
        audioRecorder.record()
        tapRecord.text = "Resumed recording"
        playButton.enabled = false
        pauseRecord.enabled = true
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        audioRecorder.pause()
        pauseRecord.enabled = false
        tapRecord.text = "Recording paused"
        playButton.enabled = true
    }

    @IBAction func stop(sender: UIButton) {
        tapRecord.text = "Tap to record"
        recordButton.enabled = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        tapRecord.hidden = false
        
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        tapRecord.text = "Recording"
        stopButton.hidden = false
        recordButton.enabled = false
        pauseRecord.hidden = false
        tapRecord.hidden = false
        playButton.hidden = false
        
        //Recording the sound
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
    
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC: playsoundsViewcontroller = segue.destinationViewController as! playsoundsViewcontroller

            let data = sender as! RecordedAudio
            
            playSoundsVC.receivedAudio = data
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            //To save the audio recording
            
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            
        
           //To help connect the audio file
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else{
            println("Recording was incomplete")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
}

