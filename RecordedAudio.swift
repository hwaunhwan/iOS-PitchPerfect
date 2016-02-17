//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Simon Kim on 2/16/16.
//  Copyright © 2016 KSH. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
   
    var filePathUrl: NSURL!
    var title: String!

    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}



