//
//  ViewController.swift
//  iMusicClone
//
//  Created by Pawan Badsewal on 18/03/19.
//  Copyright © 2019 Pawan Badsewal. All rights reserved.
//

import UIKit
import AVFoundation



struct songInfo {
    
    var songArtwork:UIImage
    var songName:String
    var songArtirst:String
    
    init(songArtwork:UIImage, songName:String, songArtirst:String) {
        self.songArtwork = songArtwork
        self.songName = songName
        self.songArtirst = songArtirst
    }
    
    mutating func setSongName(selectedSongName:String){
        songName = selectedSongName
    }
    
    mutating func setSongArtwork(selectedSongArtwork:UIImage){
        songArtwork = selectedSongArtwork
    }
    
    mutating func setSongArtist(selectedSongAtrist:String){
        songArtirst = selectedSongAtrist
    }
}

var currentSong = songInfo(songArtwork: #imageLiteral(resourceName: "nilArtwork"), songName: "Notplaying", songArtirst: " ")
var AudioPlayer: AVAudioPlayer!

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    
    var miniPlayerController:MiniVC?    //= nil
    
    var data:Data! // = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    var jsonResult:NSDictionary! // = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
    
    
    @IBOutlet var menuCV: UICollectionView!
    @IBOutlet var miniControllerView: UIView!
    @IBAction func unwindToVC(_ sender: UIStoryboardSegue) {}
    
    func playSound(targetSound:String){
        let path = Bundle.main.path(forResource: "songs/\(targetSound)" , ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        do{
            AudioPlayer = try AVAudioPlayer(contentsOf: url)
            AudioPlayer.prepareToPlay()
        }
        catch let error as NSError{
            print(error.description)
        }
        AudioPlayer.play()
    }
    
    func openJsonFile(){
        if let path:String = Bundle.main.path(forResource: "songs/songsDB", ofType: "json") {
            do {
                data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! NSDictionary?
            } catch {
                print("Error:",error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let songInfo = jsonResult["\(indexPath.row)"] as? [String]{
            currentSong.setSongArtwork(selectedSongArtwork: UIImage(named: songInfo[0])!)
            currentSong.setSongName(selectedSongName: songInfo[1])
            currentSong.setSongArtist(selectedSongAtrist: songInfo[2])
            playSound(targetSound: songInfo[1])
        }
        miniPlayerController?.updateView(song: currentSong)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jsonResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row != jsonResult.count){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongInfoCVC", for: indexPath) as! SongInfoCVC
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let songInfo = jsonResult["\(indexPath.row)"] as? [String]{
                cell.songArtworkImg.image = UIImage(named: songInfo[0])
                cell.songNamelbl.text = songInfo[1]
                cell.songArtistlbl.text = songInfo[2]
                return cell
            }
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OffsetCVC", for: indexPath) as! OffsetCVC
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.row != jsonResult.count - 1){
            return CGSize(width: UIScreen.main.bounds.width / 2 - 25, height: ((UIScreen.main.bounds.width / 2 - 25) * 1.3125))
        }
        return CGSize(width: UIScreen.main.bounds.width, height: 60)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let miniVC = segue.destination as? MiniVC {
            miniPlayerController = miniVC
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openJsonFile()
        print(jsonResult)
        print(type(of: jsonResult))
        let cellWidth = UIScreen.main.bounds.width / 2 - 25
        let cellHeight = cellWidth * 1.3125
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        collectionLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        menuCV.collectionViewLayout = collectionLayout
        menuCV.allowsMultipleSelection = false
        menuCV.register(UINib(nibName: "SongInfoCVC", bundle: nil), forCellWithReuseIdentifier: "SongInfoCVC")
        menuCV.register(UINib(nibName: "OffsetCVC", bundle: nil), forCellWithReuseIdentifier: "OffsetCVC")
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        miniControllerView = blurEffectView
        
    }
    
}

