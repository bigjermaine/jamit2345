//
//  onlineRecordlist.swift
//  jamit
//
//  Created by Apple on 19/02/2023.
//

import SwiftUI

struct onlineRecordlist: View {
    @ObservedObject var audioRecorder = AudioRecorder2()
    @AppStorage("email") var eMailAdress = "user@domain.com"
  
    var body: some View {
        NavigationView {
            ScrollView{
                ForEach(audioRecorder.recordingsList2) { audio in
                    
                    HStack{
                        Text("\(audio.fileURL)")
                        Spacer()
                        
                        Button{
                            audioRecorder.deleledata(todotodelete: audio, email: eMailAdress)
                        }label: {
                            Image(systemName: "delete.left")
                        }
                        
                        Button{
                         guard   let fileUrl = URL(string: audio.fileURL)
                            else {return}
                            audioRecorder.startPlaying(url: fileUrl)
                        }label: {
                            Image(systemName: "play.fill")
                        }
                        
                        
                    }
                }
                
            }
        }
        .onAppear {
        audioRecorder.getpost(for: eMailAdress)
            
        }
    }
}
struct onlineRecordlist_Previews: PreviewProvider {
    static var previews: some View {
        onlineRecordlist()
    }
}
