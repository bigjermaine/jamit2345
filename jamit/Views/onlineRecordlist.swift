//
//  onlineRecordlist.swift
//  jamit
//
//  Created by Apple on 19/02/2023.
//

import SwiftUI

struct onlineRecordlist: View {
    @ObservedObject var audioRecorder = AudioRecorder2()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct onlineRecordlist_Previews: PreviewProvider {
    static var previews: some View {
        onlineRecordlist()
    }
}
