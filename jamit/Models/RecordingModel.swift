//
//  RecordingModel.swift
//  jamit
//
//  Created by Apple on 18/02/2023.
//

import Foundation





///Recordingmodel
struct Recording : Equatable,Hashable {
    
    let fileURL : URL
    let createdAt : Date
 
    init(fileURL: URL, createdAt: Date) {
        self.fileURL = fileURL
        self.createdAt = createdAt
    }
}
struct Recording2 : Equatable,Hashable {
    
    let fileURL : String
    let createdAt : Date
 
    init(fileURL: String, createdAt: Date) {
        self.fileURL = fileURL
        self.createdAt = createdAt
    }
}
