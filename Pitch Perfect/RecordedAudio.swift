//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Dharini Kadiwala on 20/05/15.
//  Copyright (c) 2015 Dharini Kadiwala. All rights reserved.
//


import Foundation

class RecordedAudio{
    
    var filePathUrl: NSURL
    var title: String
    
    init (filePathUrl: NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}