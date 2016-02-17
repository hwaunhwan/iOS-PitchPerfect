//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Simon Kim on 2/15/16.
//  Copyright © 2016 KSH. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(animated: Bool) {
        //Hide the stop, pause, resume button initially
        stopButton.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
        recordingInProgress.text = "Tab to Record"
        recordButton.enabled = true
    }
    
    // Record the audio when microphone icon is pressed
    @IBAction func recordAudio(sender: UIButton) {
        stopButton.hidden = false
        pauseButton.hidden = false
        resumeButton.hidden = false
        recordingInProgress.text = "Recording..."
        recordButton.enabled = false
        pauseButton.enabled = true
        resumeButton.enabled = false
        
        // Selecting the path to save the file
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        // Save it as my_audio.wav
        let recordingName = "my_audio.wav"
        
        let pathArray = [dirPath, recordingName]
        
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
        // Saving the recorded audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
        
            // Performing segue with saved audio
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
            pauseButton.hidden = true
            resumeButton.hidden = true
        }
        
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        recordingInProgress.text = "Paused"
        pauseButton.enabled = false
        resumeButton.enabled = true
        audioRecorder.pause()
    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        recordingInProgress.text = "Resumed..."
        resumeButton.enabled = false
        pauseButton.enabled = true
        audioRecorder.record()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    
    // Stop recording the audio
    @IBAction func stopAudio(sender: UIButton) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
}

