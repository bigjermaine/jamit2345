//
//  Extensions.swift
//  jamit
//
//  Created by Apple on 18/02/2023.
//

import Foundation
import UIKit
import SwiftUI

///userdefaults to string
extension UserDefaults {

    func setValue(value: String, key: String) {
        set(value, forKey: key)
        synchronize()
    }

    func getValue(key: String) -> String {
        return string(forKey: key) ?? "nigeria"
    }
}
///Blur effect on the bottom bar
struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemChromeMaterial
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}


extension AudioRecorder2 {
    func covertSecToMinAndHour(seconds : Int) -> String{
        
        let (_,m,s) = (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        let sec : String = s < 10 ? "0\(s)" : "\(s)"
        return "\(m):\(sec)"
        
    }
}

extension Date
{
    func toString(dateFormat format: String ) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
        
    }

}
