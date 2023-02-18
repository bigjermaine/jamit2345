//
//  RecordlistView.swift
//  jamit
//
//  Created by Apple on 18/02/2023.
//

import SwiftUI
import AVFoundation

struct RecordlistView: View {
    @ObservedObject var audioRecorder = AudioRecorder2()
    @AppStorage("email") var eMailAdress = "user@domain.com"
    var body: some View {
        NavigationView {
            ScrollView{
                ForEach(audioRecorder.recordingsList,id:\.self) { audio in
                    
                    HStack{
                        Text("\(audio.fileURL)")
                        Spacer()
                        
                        Button{
                            audioRecorder.deleteRecording(url: audio.fileURL)
                        }label: {
                            Image(systemName: "delete.left")
                        }
                        
                        Button{                          audioRecorder.startPlaying(url: audio.fileURL)
                        }label: {
                            Image(systemName: "play.fill")
                        }
                        Button{                          self.audioRecorder.uploadall(email: eMailAdress, fireurl: audio.fileURL, createdate: audio.createdAt)
                        }label: {
                            Text("f")
                        }
                        
                    }
                }
                
            }
        }
    }
}
struct RecordlistView_Previews: PreviewProvider {
    static var previews: some View {
        RecordlistView()
    }
}
