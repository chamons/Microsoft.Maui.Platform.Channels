//
//  Init.swift
//  Sample
//
//  Created by Jon Dick on 2022-06-14.
//

import Foundation
import DotNetPlatformChannels
import os

@objc
public class SampleChannels : NSObject {
    
    @objc
    public static func initChannels() {
        write_log ("initChannels")
        ChannelService.shared.registerChannel(channelId: "math", channelType: MathChannel.self)
        ChannelService.shared.registerChannel(channelId: "labelView", channelType: LabelViewChannel.self)
        write_log ("initChannels done")
    }
}

func write_log(_ text: String) {
    let text = text + "\n"
    guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return
    }

    let encoding = String.Encoding.utf8

    guard let data = text.data(using: encoding) else {
        return
    }

    let fileUrl = dir.appendingPathComponent("log.txt")
    print(fileUrl)
    
    if let fileHandle = FileHandle(forWritingAtPath: fileUrl.path) {
        fileHandle.seekToEndOfFile()
        fileHandle.write(data)
    } else {
        try! text.write(to: fileUrl, atomically: false, encoding: encoding)
    }
}
