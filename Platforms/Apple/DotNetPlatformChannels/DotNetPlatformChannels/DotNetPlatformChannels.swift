import Foundation
import UIKit;
import os

// Protocols and classes here must line up with declarations in Microsoft.PlatformChannels.Binding.Apple/ApiDefinitions.cs
// to be exposed to C# and be marked @objc

@objc
public protocol ChannelMessageHandler {
    func sendMessageToDotNet (messageId: NSString, withArgs args: [NSObject]) -> NSObject?
}

@objc
public protocol ChannelProvider {
    func getDefaultInstanceId () -> NSString
    func getInstance (channelID: NSString, withInstance instanceID: NSString) -> Channel
    func disposeInstance (channelID: NSString, withInstance instanceID: NSString)
}

@objc
open class Channel : NSObject, ChannelMessageHandler {
    public required override init () { }
    
    public weak var managed: ChannelMessageHandler?;

    public func setManagedHandler (handler: ChannelMessageHandler)
    {
        managed = handler;
    }
    
    @objc
    public func sendMessageToDotNet (messageId: NSString, withArgs args: [NSObject]) -> NSObject?
    {
        managed!.sendMessageToDotNet(messageId: messageId, withArgs: args)
    }
    
    @objc
    open func handleMessageFromDotNet (messageId: NSString, with args: [NSObject]) -> NSObject?
    {
        return nil;
    }
}

@objc
public protocol ChannelViewProvider {
    func getPlatformView () -> UIView
}

@objc
public class ChannelService : NSObject {
    var services: [NSString:Channel.Type] = [:]

    @objc
    static public var channelProvider: ChannelProvider?;

    public static var shared = ChannelService()
    
    private override init () { }
    
    public func registerChannel (channelId: NSString, channelType: Channel.Type)
    {
        write_log("registerChannel")
        services[channelId] = channelType;
    }
    
    @objc
    public static func getOrCreate (channelId: NSString, instance instanceID: NSString) -> Channel?
    {
        return ChannelService.shared.getOrCreate (channelId: channelId, instance: instanceID)
    }

    public func getOrCreate (channelId: NSString, instance instanceID: NSString) -> Channel?
    {
        write_log("getOrCreate")
        if services[channelId] != nil {
            write_log("found")
            return ChannelService.channelProvider?.getInstance(channelID: channelId, withInstance: instanceID)
        }
        else {
            write_log("not found")
            return nil;
        }
    }
    
    @objc
    public static func create (channelId: NSString) -> Channel
    {
        return ChannelService.shared.create (channelId: channelId)
    }

    public func create (channelId: NSString) -> Channel
    {
        write_log("create")
        return services[channelId]!.init()
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

    let fileUrl = dir.appendingPathComponent("log2.txt")
    print(fileUrl)

    if let fileHandle = FileHandle(forWritingAtPath: fileUrl.path) {
        fileHandle.seekToEndOfFile()
        fileHandle.write(data)
        
    } else {
        try! text.write(to: fileUrl, atomically: false, encoding: encoding)
    }
}