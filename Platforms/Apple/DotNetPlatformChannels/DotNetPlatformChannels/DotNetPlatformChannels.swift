import Foundation
import UIKit;
import os

// Protocols and classes here must line up with declarations in Microsoft.PlatformChannels.Binding.Apple/ApiDefinitions.cs
// to be exposed to C# and be marked @objc

@objc
public protocol ChannelMessageHandler {
    func sendMessageToDotNet (_ messageId: NSString, withArgs args: [NSObject]) -> NSObject?
}

@objc
public protocol ChannelProvider {
    func getDefaultInstanceId () -> NSString
    func getInstance (_ channelID: NSString, withInstance instanceID: NSString) -> Channel
    func disposeInstance (_ channelID: NSString, withInstance instanceID: NSString)
}

@objc
open class Channel : NSObject, ChannelMessageHandler {
    public required override init () { }
    
    public weak var managed: ChannelMessageHandler?;

    @objc
    public func setManagedHandler (_ handler: ChannelMessageHandler)
    {
        managed = handler;
    }
    
    @objc
    public func sendMessageToDotNet (_ messageId: NSString, withArgs args: [NSObject]) -> NSObject?
    {
        managed!.sendMessageToDotNet(messageId, withArgs: args)
    }
 
    @objc
    open func onChannelMessage (_ messageId: NSString, withArgs args: [NSObject]) -> NSObject?
    {
        return nil;
    }
}

@objc
open class ViewChannel : Channel {
    @objc
    open func getPlatformView () -> UIView?
    {
        return nil;
    }
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
        write_log("registerChannel: " + (channelId as String) + " " +  String(describing: channelType))
        services[channelId] = channelType;
    }
    
    @objc
    public static func getOrCreate (_ channelId: NSString, instance instanceID: NSString) -> Channel?
    {
        return ChannelService.shared.getOrCreate (channelId, instance: instanceID)
    }

    public func getOrCreate (_ channelId: NSString, instance instanceID: NSString) -> Channel?
    {
        write_log("getOrCreate: " + (channelId as String) + " " + (instanceID as String))
        if services[channelId] != nil {
            write_log("found")
            return ChannelService.channelProvider?.getInstance(channelId, withInstance: instanceID)
        }
        else {
            write_log("not found")
            return nil;
        }
    }
    
    @objc
    public static func create (_ channelId: NSString) -> Channel
    {
        return ChannelService.shared.create (channelId: channelId)
    }

    public func create (channelId: NSString) -> Channel
    {
        write_log("create: " + (channelId as String))
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
