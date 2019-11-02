//
//  MaxiVC.swift
//  
//
//  Created by Pawan Badsewal on 18/03/19.
//

import UIKit
import SPStorkController
import MediaPlayer

class MaxiVC: UIViewController, UIScrollViewDelegate {
    
    var airPlayRouteButton:UIButton?
    var timer:Timer!
    
    @IBOutlet var audioSlider: UISlider!
    @IBOutlet var songImg: UIImageView!
    @IBOutlet var playPauseBtn: UIButton!
    @IBOutlet var songNamelbl: UILabel!
    @IBOutlet var songArtistlbl: UILabel!
    @IBOutlet var timeEsclapedlbl: UILabel!
    @IBOutlet var timeRemaninglbl: UILabel!
    @IBOutlet var volumeView: MPVolumeView!
    @IBOutlet var mainView: UIView!
    
    
    
    private func airPlayButton() -> UIButton{
        let wrapperView = UIButton(frame: CGRect(x: 176, y: 653, width: 25, height: 25))
        wrapperView.setImage(#imageLiteral(resourceName: "airPlay"), for: .normal)
        wrapperView.backgroundColor = .clear
        wrapperView.addTarget(self, action: #selector(replaceRouteButton), for: UIControl.Event.touchUpInside)
        
        let volumeView = MPVolumeView(frame: wrapperView.bounds)
        volumeView.showsRouteButton = false
        volumeView.showsVolumeSlider = false
        volumeView.isUserInteractionEnabled = false
        
        self.airPlayRouteButton = volumeView.subviews.filter{ $0 is UIButton }.first as? UIButton
        
        wrapperView.addSubview(volumeView)
        return wrapperView
    }
    
    @objc func replaceRouteButton(){
        airPlayRouteButton?.sendActions(for: .touchUpInside)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            SPStorkController.scrollViewDidScroll(scrollView)
    }
    
    @objc func updateSlider(){
        audioSlider.value = Float(AudioPlayer.currentTime)
    }
    
    @IBAction func audioSliderScrubbed(_ sender: UISlider) {
        AudioPlayer.currentTime = TimeInterval(sender.value)
    }
    @IBAction func audioAction(_ sender: UIButton) {
        if (AudioPlayer != nil){
            if(AudioPlayer.isPlaying){
                AudioPlayer.pause()
                playPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            }else{
                AudioPlayer.play()
                playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        songImg.image = currentSong.songArtwork
        songNamelbl.text = currentSong.songName
        songArtistlbl.text = currentSong.songArtirst
        if(AudioPlayer != nil){
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
            audioSlider.maximumValue = Float(AudioPlayer.duration)
            if(AudioPlayer.isPlaying){
                playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            }else{
                playPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.addSubview(airPlayButton())
        volumeView.showsRouteButton = false
        audioSlider.setThumbImage(UIImage.init(named: "sliderDot"), for: .normal)
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
