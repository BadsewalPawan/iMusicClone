//
//  MiniVC.swift
//  iMusicClone
//
//  Created by Pawan Badsewal on 29/03/19.
//  Copyright © 2019 Pawan Badsewal. All rights reserved.
//

import UIKit
import SPStorkController

class MiniVC: UIViewController {
    
    @IBOutlet var songImg: UIImageView!
    @IBOutlet var songNamelbl: UILabel!
    @IBOutlet var playPauseBtn: UIButton!
    @IBOutlet var skipBtn: UIButton!
    @IBOutlet var backgroundView: UIView!
    
    
    
    func updateView(song: songInfo?){
        guard let song = song else {
            songNamelbl.text = "Not Playing"
            songImg.image = nil
            return
        }
        songNamelbl.text = song.songName
        songImg.image = song.songArtwork
        currentSong = song
        if song.songName != "Notplaying" {
            playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
        
        /*if let song = song {
            songNamelbl.text = song.songName
            songImg.image = song.songArtwork
        } else {
            songNamelbl.text = nil
            songImg.image = nil
        }*/
        
        //currentSong = song
    }
    
    @IBAction func playSkipAction(_ sender: UIButton) {
        if (sender.tag == 1){
            if (AudioPlayer != nil){
                if(AudioPlayer.isPlaying){
                    AudioPlayer.pause()
                    playPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                }else{
                    AudioPlayer.play()
                    playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                }
            }
        }else{
            print("skipped")
            
            
        }
    }
    
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MaxiVC")
        let transitionDelegate = SPStorkTransitioningDelegate()
        controller.transitioningDelegate = transitionDelegate
        controller.modalPresentationStyle = .custom
        self.present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        backgroundView.addGestureRecognizer(tap)
        updateView(song: currentSong)
    }
    
}
