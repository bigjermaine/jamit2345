//
//  Microphone.swift
//  jamit
//
//  Created by Apple on 18/02/2023.
//

import SwiftUI

struct ProgressView: View {
    @Binding var record:Bool
    var body: some View {
            
        ZStack{
            Circle()
                .fill(record ? Color.green : Color.white)
                .frame(width:125)
                .shadow(radius:25)
            ///mic
            Image(systemName: "mic")
                .font(.system(size: 40))
        }
       
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(record: .constant(false))
    }
}
