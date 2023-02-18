//
//  HomeView.swift
//  jamit
//
//  Created by Apple on 18/02/2023.
//

import SwiftUI
import AVFoundation
import AVKit

struct HomeView: View {
    @ObservedObject var audioRecorder = AudioRecorder2()
    @ObservedObject var audioplayer = AudioPlayer()
    @State private var presentAlert = false
    @State var record = false
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("Record a Podcast")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.997, green: 0.569, blue: 0.001))
                    
                    ///microphone button
                    Button {
                        if audioRecorder.isRecording == true {
                            audioRecorder.stopRecording()
                            presentAlert = true
                            record = false
                            
                        } else {
                            audioRecorder.startRecording()
                            record = true
                            presentAlert = false
                        }
                        
                        
                        
                    }label:{
                        ProgressView(record: $record)
                    }
                    if audioRecorder.isRecording {
                        
                        VStack(alignment : .leading , spacing : -5){
                            HStack (spacing : 3) {
                                Image(systemName: audioRecorder.isRecording && audioRecorder.toggleColor ? "circle.fill" : "circle")
                                    .font(.system(size:10))
                                    .foregroundColor(.red)
                                Text("Rec")
                            }
                            Text(audioRecorder.timer)
                                .font(.system(size:60))
                                .foregroundColor(.white)
                        }
                        
                    } else {
                        VStack{
                            Text("Press the Recording Button above")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            Text("and Stop when its done")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }.frame(width: 300, height: 100, alignment: .center)
                        
                        
                    }
                    Spacer()
                    HStack{
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color.white.opacity(0.0)).frame(width: UIScreen.main.bounds.size.width, height: 65)
                            HStack {
                                Button(action: {}) {
                                    HStack {
                                        Image("images")
                                            .resizable()
                                            .frame(width: 45, height: 45).shadow(radius: 6, x: 0, y: 3)
                                            .cornerRadius(8)
                                           
                                        Text("Test Audio").padding(.leading, 10)
                                        Spacer()
                                    }
                                }.buttonStyle(PlainButtonStyle())
                                Button(action: {
                                    self.play()
                                }) {
                                    Image(systemName: "play.fill").font(.title3)
                                }.buttonStyle(PlainButtonStyle()).padding(.horizontal)
                                Button(action: {}) {
                                    Image(systemName: "forward.fill").font(.title3)
                                }.buttonStyle(PlainButtonStyle()).padding(.trailing, 30)
                            }
                            .background(.orange.opacity(0.5))
                            
                        }
                    }
                    
                }
                
                
                .alert("Recordings", isPresented: $presentAlert, actions: {
                    // actions
                }, message: {
                    Text("your last recording is saved")
                })
                .toolbar {
                    ToolbarItem(placement:.navigationBarTrailing) {
                        NavigationLink("\(Image(systemName: "music.note.list"))", destination: RecordlistView()
                                       
                        ).font(.title2)
                            .menuStyle(RedMenuStyle())
                    }
                    
                }
                .navigationTitle("Home")
            }
        }
        .navigationViewStyle(.stack)
        
    }
    
    func play() {
        if let firstElement = audioRecorder.recordingsList.first {
            let play1 =  firstElement.fileURL
            audioplayer.startPlayback(audio: play1)
        }
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


struct RedMenuStyle : MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .font(Font.system(size: 50))
            .foregroundColor(Color.orange)
    }
}

                                                                                                                            
