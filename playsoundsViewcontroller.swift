//
//  playsoundsViewcontroller.swift
//  Pitch Perfect
//
//  Created by Dharini Kadiwala on 19/05/15.
//  Copyright (c) 2015 Dharini Kadiwala. All rights reserved.
//

import UIKit
import AVFoundation

class playsoundsViewcontroller: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var reverbPlayers:[AVAudioPlayer] = []
    
    let N:Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
    }

    @IBAction func dharSound(sender: UIButton) {
        
        playAudioWithVariablePitch(-1000)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
        
    }
    
    @IBAction func Echo(sender: UIButton) {
        //http://sandmemory.blogspot.in/2014/12/how-would-you-add-reverbecho-to-audio.html
        
        resetItAll()//new method created to reset audioPlayer and audioEngine
        audioPlayer.currentTime = 0;
        audioPlayer.play()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var unitReverb = AVAudioUnitDelay()
        unitReverb.delayTime = 1
        
        audioEngine.attachNode(unitReverb)
        
        audioEngine.connect(audioPlayerNode, to: unitReverb, format: nil)
        audioEngine.connect(unitReverb, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func resetItAll(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
       
        resetItAll()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func slowSound(sender: UIButton) {
        //play audio slowly
        playAudioWithVariableRate(0.5)
        
    }
    
    @IBAction func fastSound(sender: UIButton) {
        //play audio fast
        playAudioWithVariableRate(2.0)
        
    }
    
    func playAudioWithVariableRate(givenRate: Float)
    {
        resetItAll()
        audioPlayer.rate = givenRate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
  
    @IBAction func stopAudio(sender: UIButton) {
        resetItAll()
        
    }

}
