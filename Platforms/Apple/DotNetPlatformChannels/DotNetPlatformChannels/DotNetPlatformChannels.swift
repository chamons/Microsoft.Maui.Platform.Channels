import Foundation
import UIKit;

// Protocols and classes here must line up with declarations in Microsoft.PlatformChannels.Binding.Apple/ApiDefinitions.cs
// to be exposed to C# and be marked @objc

@objc
protocol ChannelMessageHandler {
    func sendMessageToDotNet (messageId: NSString, with args: [NSArray]) -> NSObject?
}

@objc
protocol ChannelProvider {
    func getDefaultInstanceId () -> NSString
    func getInstance (channelID: NSString, withInstance instanceID: NSString) -> Channel
    func disposeInstance (channelID: NSString, withInstance instanceID: NSString)
}

@objc
class Channel : NSObject {
    public required override init () { }
    
    public weak var managed: ChannelMessageHandler?;

    public func setManagedHandler (handler: ChannelMessageHandler)
    {
        managed = handler;
    }
    
    public func sendMessageToDotNet (messageId: NSString, withArgs args: [NSArray]) -> NSObject?
    {
        managed!.sendMessageToDotNet(messageId: messageId, with: args);
    }
    
    public func handleMessageFromDotNet (messageId: NSString, with args: [NSArray]) -> NSObject?
    {
        return nil;
    }
}

@objc
protocol ViewChannel {
    func makePlatformView () -> UIView
}

@objc
class ChannelService : NSObject {
    var services: [NSString:Channel.Type] = [:]

    public var channelProvider: ChannelProvider?;
    
    static var shared = ChannelService()
    private override init () { }
    
    public func registerChannel (channelId: NSString, channelType: Channel.Type)
    {
        services[channelId] = channelType;
    }
    
    public func getOrCreate (channelId: NSString, instance instanceID: NSString) -> Channel?
    {
        if services[channelId] != nil {
            return channelProvider?.getInstance(channelID: channelId, withInstance: instanceID)
        }
        else {
            return nil;
        }
    }
    
    public func create (channelId: NSString) -> Channel
    {
        return services[channelId]!.init()
    }
}
