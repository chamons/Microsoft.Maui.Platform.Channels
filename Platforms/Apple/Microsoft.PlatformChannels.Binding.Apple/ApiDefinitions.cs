using Foundation;
using ObjCRuntime;
using UIKit;

namespace Microsoft.PlatformChannels.Platform
{

    // @protocol ChannelMessageHandler <NSObject>
    /*
	Check whether adding [Model] to this declaration is appropriate.
	[Model] is used to generate a C# class that implements this protocol,
	and might be useful for protocols that consumers are supposed to implement,
	since consumers can subclass the generated class instead of implementing
	the generated interface. If consumers are not supposed to implement this
	protocol, then [Model] is redundant and will generate code that will never
	be used.
	*/
    interface IChannelMessageHandler { }

    [Protocol]
    [BaseType(typeof(NSObject), Name = "_TtP22DotNetPlatformChannels21ChannelMessageHandler_")]
    interface ChannelMessageHandler
    {
        // @required -(id _Nullable)onChannelMessage:(NSString * _Nonnull)messageId withArgs:(NSArray * _Nullable)args;
        [Abstract]
        [Export("onChannelMessage:withArgs:")]
        [return: NullAllowed]
        NSObject OnChannelMessage(string messageId, [NullAllowed] NSObject[] args);
    }

    // @interface Channel : NSObject
    [BaseType(typeof(NSObject), Name = "_TtC22DotNetPlatformChannels7Channel")]
    interface Channel : ChannelMessageHandler
    {
        // @property (weak) id<ChannelMessageHandler> _Nullable managedHandler;
        [Export("setManagedHandler:", ArgumentSemantic.Weak)]
        void SetManagedHandler(IChannelMessageHandler handler);

        // -(id _Nonnull)sendMessageToDotNet:(NSString * _Nonnull)messageId withArgs:(NSArray * _Nonnull)args;
        [Export("sendMessageToDotNet:withArgs:")]
        NSObject SendMessageToDotNet(string messageId, NSObject[] args);
    }

    // @protocol ChannelProvider <NSObject>
    /*
	Check whether adding [Model] to this declaration is appropriate.
	[Model] is used to generate a C# class that implements this protocol,
	and might be useful for protocols that consumers are supposed to implement,
	since consumers can subclass the generated class instead of implementing
	the generated interface. If consumers are not supposed to implement this
	protocol, then [Model] is redundant and will generate code that will never
	be used.
	*/
    interface IChannelProvider { }

    [Protocol]
    [BaseType(typeof(NSObject), Name = "_TtP22DotNetPlatformChannels15ChannelProvider_")]
    interface ChannelProvider
    {
        // @required -(NSString * _Nonnull)getDefaultInstanceId;
        [Abstract]
        [Export("getDefaultInstanceId")]
        string DefaultInstanceId { get; }

        // @required -(Channel<ChannelMessageHandler> * _Nonnull)getInstance:(NSString * _Nonnull)channelId withInstance:(NSString * _Nonnull)instanceId;
        [Abstract]
        [Export("getInstance:withInstance:")]
        Channel GetInstance(string channelId, string instanceId);

        // @required -(void)disposeInstance:(NSString * _Nonnull)channelId withInstance:(NSString * _Nonnull)instanceId;
        [Abstract]
        [Export("disposeInstance:withInstance:")]
        void DisposeInstance(string channelId, string instanceId);
    }

    // @interface ChannelService : NSObject
    [BaseType(typeof(NSObject), Name = "_TtC22DotNetPlatformChannels14ChannelService")]
    interface ChannelService
    {
        [Export("getOrCreate:instance:")]
        [Static]
        Channel GetOrCreate(string channelId, string instanceId);

        [Export("create:")]
        [Static]
        Channel Create(string channelId);

        [NullAllowed, Export("channelProvider", ArgumentSemantic.Weak)]
        [Static]
        IChannelProvider Provider { get; set; }
    }

    [Protocol]
    [BaseType(typeof(NSObject), Name = "_TtP22DotNetPlatformChannels19ChannelViewProvider_")]
    interface ChannelViewProvider
    {
        // @required -(UIView *)getPlatformView;
        [Abstract]
        [Export("getPlatformView")]
        UIView GetPlatformView();
    }

    // @interface ViewChannel : Channel
    [BaseType(typeof(Channel))]
    interface ViewChannel : ChannelMessageHandler, ChannelViewProvider
    {
    }
}