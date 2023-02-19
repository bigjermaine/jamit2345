//
//  audioManager.swift
//  jamit
//
//  Created by Apple on 18/02/2023.
//
//
//import FirebaseCore
//import FirebaseFirestore
//import FirebaseAuth
//import Firebase
//import FirebaseFirestoreSwift
import Foundation
import Combine
import SwiftUI
import AVFoundation
import FirebaseStorage
import UIKit
import FirebaseFirestore



class AudioRecorder2: NSObject, ObservableObject , AVAudioPlayerDelegate  {
    @Published var isRecording : Bool = false
    var audioPlayer: AVAudioPlayer!
    var audioRecorder: AVAudioRecorder!
    @Published var countSec = 0
    @Published var recordingsList = [Recording]()
    @Published var recordingsList2 = [Recording2]()
    @Published var blinkingCount : Timer?
    @Published var toggleColor : Bool = false
    @Published var timerCount : Timer?
    @Published var timer : String = "0:00"
    private let database2 = Firestore.firestore()
    private let database = Storage.storage()
    let jermaine = UserDefaults.standard.getValue(key:"email")
    override init() {
        super.init()
        fetchRecordings()
       
        self.getpost(for:jermaine)
        
    }
    
    
    ///Recording
    func startRecording(){
        
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Can not setup the Recording")
        }
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = path.appendingPathComponent("\(Date()).m5arrrr")
        
        
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecorder.record()
            isRecording = true
            
            timerCount = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (value) in
                self.countSec += 1
                self.timer = self.covertSecToMinAndHour(seconds: self.countSec)
            })
            blinkColor()
            
        } catch {
            print("Failed to Setup the Recording")
        }
        
    }
    
    
    ///fetch all recordings
    func fetchRecordings()  {
        
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for i in directoryContents {
            recordingsList.append(Recording(fileURL : i, createdAt:getFileDate(for: i)))
        }
        
        recordingsList.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending})
        
        
    }
    
    ///Stop Recording
    func stopRecording(){
        audioRecorder.stop()
        
        isRecording = false
        self.countSec = 0
        timerCount!.invalidate()
        blinkingCount!.invalidate()
        // isRecording = false
        fetchRecordings()
    }
    
    func startPlaying(url : URL) {
        
        let playSession = AVAudioSession.sharedInstance()
        
        do {
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing failed in Device")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf : url)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
            
        } catch {
            print("Playing Failed")
            
        }
    }
    
    
    
    func stopPlaying(url : URL) {
        
        audioPlayer.stop()
        
    }
    
    func deleteRecording(url : URL){
        
        do {
            try FileManager.default.removeItem(at : url)
        } catch {
            print("Can't delete")
        }
        
        
        for audio in 0..<recordingsList.count {
            
            if recordingsList[audio].fileURL == url {
                
                //stopPlaying(url: recordingsList[i].fileURL)
                
                recordingsList.remove(at:audio)
                break
            }
        }
        
    }
    
    func  deleledata(todotodelete:Recording2,email:String) {
        let ref = email.replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: ".")
        
        database2.collection("users").document(ref).collection("posts").document(todotodelete.id).delete { error  in
            if  error  == nil {
                DispatchQueue.main.async {
                    self.recordingsList2.removeAll { todo in
                        return todo.id == todotodelete.id
                    }
                }
            }
        }
        
    }
    
    
    
    
    
    func uploadblogpostheaderimage(id:String,email:String ,image:URL,completion:@escaping(Bool)-> Void){
        
        let ref = email.replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: ".")
        
        let uploadmetadata = StorageMetadata.init()
        uploadmetadata.contentType = "audio/mpeg"
        
        database.reference(withPath:"posts_headers\(ref)/\(id)").putFile(from: image, metadata:uploadmetadata) { data, error in
            guard  data != nil , error == nil else {
                completion(false)
                return
            }
            completion(true)
            
        }
    }
    
    func dowloadblogpostheaderimage(id:String,email:String,completion:@escaping(URL?)-> Void) {
        let ref = email.replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: ".")
        
        database.reference(withPath: "posts_headers\(ref)/\(id)").downloadURL{ url, error in
            
            completion(url)
        }
    }
    
    func getpost(
        for email:String) {
            let ref = email.replacingOccurrences(of: ".", with: "_")
                .replacingOccurrences(of: "@", with: ".")
            database2.collection("users")
                .document(ref)
                .collection("posts")
                .getDocuments { snapshot, error in
                    if error == nil {
                        
                        if let snapshot = snapshot {
                            
                            DispatchQueue.main.async {
                                
                                self.recordingsList2 = snapshot.documents.map{ d in
                                    return Recording2(id: d.documentID, fileURL:d["fileURL"] as? String ?? "eee" ,
                                                     createdAt:d["createdAt"] as? Date ?? Date())
                                    
                                    
                                }
                                
                            }
                            
                        }else  {
                            
                        }
                    }
                    
                }
            
            
        }
    public func insertblogpost(
        post:Recording,
        email:String,id:String,
        completion: @escaping (Bool) -> Void
        
        
    ){
      
        let ref = email.replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: ".")
        let datas = [
            "fileURL":post.fileURL.absoluteString,
            "createdAt":post.createdAt
        ] as [String : Any]
        database2.collection("users").document(ref).collection("posts").document(id)
            .setData(datas) { error in
                completion(error == nil)
            }
    }
    
    func getFileDate(for file: URL) -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
           let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
    
    func blinkColor() {
        
        blinkingCount = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { (value) in
            self.toggleColor.toggle()
        })
        
    }
    
    
    
    
    
    
    func uploadall(email:String,fireurl:URL,createdate:Date) {
        
        let newpostid = UUID().uuidString
        uploadblogpostheaderimage(id: newpostid, email:email , image:fireurl) { [weak self] sucess in
            guard sucess else {return}
            
            self?.dowloadblogpostheaderimage(id: newpostid, email: email) { urls in
                guard let headerurl = urls else {return}
                print(headerurl)
                let post = Recording(fileURL: headerurl, createdAt: createdate)
                print(post)
                //
                self?.insertblogpost(post: post, email: email, id: newpostid) { posted in
                    guard posted else {return}
                    
                }
                
            }
            
        }
    }
}














    class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
        
        static let instance = AudioPlayer()
        var audioPlayer: AVAudioPlayer!
        @Published var name:String = ""
        @Published var dame:String = "ddd"
        
        var imagename:String = ""
        var player:AVPlayer!
        
        let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
        // let storages  = Storage.storage().reference()
        //@Published var fetchurl: [firebaseurl2] = []
        @Published var currentindex = 0 {
            didSet {
                Task.init {
                    //   fetchurl2[currentindex+1]
                }
            }
        }
        //   @Published var fetchurl2: [firebaseurl2] = []
        
        var isPlaying = false {
            didSet {
                objectWillChange.send(self)
                
            }
        }
        override init() {
            
            //      fetchpost()
            
        }
        func startPlaying(url : URL) {
            
            let playSession = AVAudioSession.sharedInstance()
            
            do {
                try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            } catch {
                print("Playing failed in Device")
            }
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf : url)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                
            } catch {
                print("Playing Failed")
            }
            
        }
        
        ///Fuction to play recording
        func startPlayback (audio: URL) {
            
            let playbackSession = AVAudioSession.sharedInstance()
            
            do {
                try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                print("\(audio)")
            } catch {
                print("Playing over the device's speakers failed")
            }
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audio)
                audioPlayer.delegate = self
                audioPlayer.play()
                isPlaying = true
            } catch {
                print("Playback failed.")
            }
        }
        ///Fuction to stop recording after stop
        func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            if flag {
                isPlaying = false
            }
        }
        ///Fuction to stop recording stop
        func stopPlayback() {
            audioPlayer.stop()
            isPlaying = false
            
        }
        ///Fuction to stop deleterecording stop
        func deleteRecording(urlsToDelete: [URL]) {
            
            for url in urlsToDelete {
                print(url)
                do {
                    try FileManager.default.removeItem(at: url)
                } catch {
                    print("File could not be deleted!")
                }
            }
            
            
            
        }
        
        ///play httpurl  with  audioplayer istead of  AVAudioPlayer
        func playurlfromfirebase(url: String)   {
            
            ///convert string to url
            guard  let Sci = URL(string:url) else {return}
            
            
            player = AVPlayer(url: Sci)
            player.allowsExternalPlayback = true
            player.appliesMediaSelectionCriteriaAutomatically = true
            player.automaticallyWaitsToMinimizeStalling = true
            player.volume = 100
            player.play()
            
            isPlaying = true
            
            if let duration = player.currentItem?.asset.duration {
                let seconds = CMTimeGetSeconds(duration)
                print("Seconds :: \(seconds)")
            }
        }
        
        
        func stopurlfromfirebase() {
            
            player.replaceCurrentItem(with: nil)
            isPlaying = false
            
        }
        
        //   ///post url to firebaseCloud
        //   func firebasepost(url:URL) {
        //
        //     // File located on disk
        //
        //     let filename = ("\(url.lastPathComponent)")
        //
        //      // Create a reference to the file you want to upload
        //     let riversRef = storages.child("\(filename)")
        //
        //     let uploadmetadata = StorageMetadata.init()
        //       uploadmetadata.contentType = "audio/mpeg"
        //      // Upload the file to the path
        //     let taskreference = riversRef.putFile(from: url, metadata: uploadmetadata) {( metadata, error )in
        //       // check error
        //      if let error = error {
        //       // Uh-oh, an error occurred!
        //            print(error.localizedDescription)
        //         }
        //
        //        }
        //          print("sucessfull")
        //
        //       ///track progress
        //     taskreference.observe(.progress) { [weak self]
        //       (snapshot) in
        //       if let completedunitcount = snapshot.progress?.completedUnitCount {
        //           self?.name = String("\(completedunitcount)sent to firebase")
        //       }
        //     }
        //
        //       ///dowload url of audio file
        //
        //       riversRef.downloadURL {  (url ,error ) in
        //           if let error =  error {
        //               print(error.localizedDescription)
        //           }
        //
        //               if  let url = url {
        //               print("dwoload complete \(url.absoluteString)")
        //
        //               ///calling the firebase post function
        ////
        ////                 self.ToPost(Link: url.absoluteString)
        //                //String(contentsOf: URL)
        //
        //               self.dame = url.absoluteString
        //
        //
        //
        //           }
        //
        //       }
        //   }
        //
        //    func fireposturl3()  -> String {
        //        let name = dame
        //
        //        return name
        //
        //    }
        //    func fireposturl4()  -> String {
        //        let name2 = imagename
        //
        //        return name2
        //    }
        //
        //    ///post to firebase
        //    func ToPost(Link:String){
        //        let db = Firestore.firestore()
        //        let newfirebaseurl = firebaseurl( fileURL: Link)
        //        do {
        //            try db.collection("posts").document().setData(from:newfirebaseurl)
        //
        //        }catch {
        //
        //            print(error.localizedDescription)
        //        }
        //
        //    }
        //
        //    ///post to url image and audio
        //    func ToPost2(){
        //
        //
        //        let db = Firestore.firestore()
        //        let newfirebaseurl = firebaseurl2(audiofileURL: fireposturl4()  , imagefileURL: fireposturl3() )
        //        do {
        //            try db.collection("post2").document().setData(from:newfirebaseurl)
        //
        //        }catch {
        //
        //            print(error.localizedDescription)
        //        }
        //
        //
        //
        //    }
        //    func persistImageToStorage(image:UIImage) {
        //
        //         let imagestring = "\(image)"
        //        let ref = storages.child("\(imagestring).jpg")
        //           guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        //           ref.putData(imageData, metadata: nil) { metadata, err in
        //               if let err = err {
        //                   print("Failed to push image to Storage: \(err)")
        //                   return
        //               }
        //
        //               ref.downloadURL { url, err in
        //                   if let err = err {
        //                       print("Failed to retrieve downloadURL: \(err)")
        //                       return
        //                   }
        //                   if  let url = url {
        //                       print("Successfully stored image with url: \(url.absoluteString)")
        //
        //                     self.imagename = url.absoluteString
        //
        //                   }
        //
        //           }
        //       }
        //    }
        //  //Fetching post
        //    func fetchpost() {
        //        let db = Firestore.firestore()
        //
        //        db.collection("post2").getDocuments() { (querySnapshot, error) in
        //            if let error = error {
        //                print("Error getting documents: \(error)")
        //            } else {
        //                if let querySnapshot = querySnapshot {
        //                    for document in querySnapshot.documents {
        //                        let data = document.data()
        //
        //
        //                        let imagefileURL = data["imagefileURL"] as? String ?? ""
        //                        let audiofileURL = data["audiofileURL"] as? String ?? ""
        //
        //                        let fetchurls = firebaseurl2(audiofileURL:  audiofileURL , imagefileURL: imagefileURL)
        //
        //                            self.fetchurl.append(fetchurls)
        //
        //
        //                        print("\(self.fetchurl)")
        //
        //                    }
        //                }
        //
        //            }
        //        }
        //       }
        //
        
    }


