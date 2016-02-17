//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Simon Kim on 2/16/16.
//  Copyright © 2016 KSH. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    @IBOutlet weak var stopButton: UIButton!
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    // To convert NSURL from receivedAudio to AudioFile
    var audioFile:AVAudioFile!
    var audioPlayerNode:AVAudioPlayerNode!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        audioPlayer = try!
            AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
    }
    
    // To prevent sound effect overlaps
    func stopAndResetAudio(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.currentTime = 0.0
        stopButton.hidden = false
        stopButton.enabled = true
    }
    
        // Play audio slowly
    @IBAction func playSlowAudio(sender: UIButton) {
        stopAndResetAudio()
        audioPlayer.rate = 0.5
        audioPlayer.play()
        
    }
        // Play audio fast
    @IBAction func playFastAudio(sender: UIButton) {
        stopAndResetAudio()
        audioPlayer.rate = 2.0
        audioPlayer.play()
    }
    
    
    //     Acceptable Effect Range:
    //
    //     Pitch:         -2400 to 2400
    //     Reverb:        0 to 100
    //     Echo/Interval: 0 to 2
    
    func playWithEffect(pitch: Float, echo: Float, reverb: Float){
        
        stopAndResetAudio()
        
        // Attach the AVAudioPlayerNode to AVAudioEngine
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // Control the level of pitch
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // Control the echo effect
        let changeEchoEffect = AVAudioUnitDelay()
        changeEchoEffect.delayTime = NSTimeInterval(echo)
        audioEngine.attachNode(changeEchoEffect)
        
        // Control the reverb effect
        let changeReverbEffect = AVAudioUnitReverb()
        changeReverbEffect.wetDryMix = reverb
        audioEngine.attachNode(changeReverbEffect)
        
        // Connect the AVAudioPlayerNode to the effects then connect it to the output
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: changeEchoEffect, format: nil)
        audioEngine.connect(changeEchoEffect, to: changeReverbEffect, format: nil)
        audioEngine.connect(changeReverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
   

    @IBAction func playChipmunkAudio(sender: UIButton) {
        playWithEffect(1000, echo: 0, reverb: 0)
    }
    
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playWithEffect(-1000, echo: 0, reverb: 0)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        playWithEffect(0, echo: 0.5, reverb: 0)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        playWithEffect(0, echo: 0, reverb: 100)
    }
    
    // Stop audio and reset when stop button is pressed
    @IBAction func stopAudio(sender: UIButton) {
        stopAndResetAudio()
        stopButton.enabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
}
