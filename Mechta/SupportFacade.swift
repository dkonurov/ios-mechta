//
//  SupportFacade.swift
//  Mechta
//
//  Created by Evgeniy Safronov on 12.02.17.
//
//

import UIKit

class SupportFacade {
    let supportedApps: [(title: String, icon: String, url: String)]
    
    private let apps: [(title: String, icon: String, url: String)] = [
        (title: "Whatsapp", icon: "SupportWhatsapp", url: "whatsapp://send?text=Hello%2C%20World!"),
        (title: "Viber", icon: "SupportViber", url: "viber://add?number=0123456789"),
        (title: "Звонок с мобильного", icon: "SupportPhone", url: "telprompt://9109000000")
    ]

    init() {
        supportedApps = apps.filter() {_,_,url in
            if let url = URL(string: url) {
                return UIApplication.shared.canOpenURL(url)
            } else {
                return false
            }
        }
    }
    
    func call(url: String) {
        let parsedUrl = URL(string: url)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(parsedUrl, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(parsedUrl)
        }
    }
    
    var hasSupportedApps: Bool {
        return supportedApps.count > 0
    }
}
