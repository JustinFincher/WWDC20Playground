import UIKit
import AVFoundation
import SpriteKit

class AudioUniformProviderManager: NSObject
{
    static let shared = AudioUniformProviderManager()
    let audioUniform : SKUniform = SKUniform(name: "u_audiodb", float: 0)
    var timer : Timer?
    
    override init()
    {
        super.init()
        timer = Timer.scheduledTimer(timeInterval: 1.0/60.0, target: self, selector: #selector(self.updateUniform), userInfo: nil, repeats: true)
    }
    
    deinit {
        audioRecorder?.stop()
        timer?.invalidate()
    }
    
    func requestPermission() -> Void
    {
        AVAudioSession.sharedInstance().requestRecordPermission() { [unowned self] allowed in
            DispatchQueue.main.async {
                if allowed
                {
                    self.initAudio()
                }
            }
        }
    }
    
    var audioRecorder : AVAudioRecorder?
    var audioRecordPath : URL?
    
    func initAudio() -> Void
    {
        do
        {
            try audioRecordPath = FileManager.init().createTemporaryDirectory()
            AVAudioSession.sharedInstance().availableInputs?.forEach({ (avAudioSessionPortDescription) in
                print("\(avAudioSessionPortDescription.portName) \(avAudioSessionPortDescription.portType)")
            })
            try AVAudioSession.sharedInstance().setPreferredInput(AVAudioSession.sharedInstance().availableInputs?.first)
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .measurement, options: [.allowAirPlay,.allowBluetooth,.allowBluetoothA2DP,.defaultToSpeaker,.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true, options: [])
            guard var audioRecordPath : URL = audioRecordPath else {
                return
            }
            audioRecordPath.appendPathComponent("recording.pcm")
            print("\(audioRecordPath)")
            let fmt = AVAudioFormat(commonFormat:.pcmFormatInt16,
                                    sampleRate:44100,
                                    channels:2,
                                    interleaved:true)
            
            if let fmt = fmt
            {
                try audioRecorder = AVAudioRecorder(url: audioRecordPath, format: fmt)
            }
            if let audioRecorder = audioRecorder
            {
                audioRecorder.prepareToRecord()
                audioRecorder.isMeteringEnabled = true
                audioRecorder.record()
            }
        }
        catch
        {
            print("Unexpected error: \(error).")
        }
    }
    
    @objc public func updateUniform() -> Void
    {
        if let audioRecorder = audioRecorder
        {
            audioRecorder.updateMeters()
            audioUniform.floatValue = 1.0 + audioRecorder.averagePower(forChannel: 0) / 80.0
            //print("\(audioRecorder.averagePower(forChannel: 0))  \(audioRecorder.peakPower(forChannel: 0))")
        }
    }
}
