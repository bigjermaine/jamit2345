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
                ForEach(audioRecorder.recordingsList2,id:\.self) { audio in
                    
                    HStack{
                        Text("\(audio.fileURL)")
                        Spacer()
                        
                        Button{
//                            audioRecorder.deleteRecording(url: audio.fileURL)
                        }label: {
                            Image(systemName: "delete.left")
                        }
                        
                        Button{                          
                        }label: {
                            Image(systemName: "play.fill")
                        }
                        
                        
                    }
                }
                
            }
        }
    }
}
struct onlineRecordlist_Previews: PreviewProvider {
    static var previews: some View {
        onlineRecordlist()
    }
}
