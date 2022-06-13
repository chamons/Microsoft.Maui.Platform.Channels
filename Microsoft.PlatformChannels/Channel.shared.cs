﻿
namespace Microsoft.PlatformChannels;

public partial class Channel : PlatformObject, IPlatformChannelMessageHandler
{
	internal Channel(PlatformChannel platformChannel)
	{
		PlatformChannel = platformChannel;
		PlatformChannel.SetManagedHandler(this);
	}

	public event ChannelMessageDelegate OnReceiveFromPlatform;

	internal PlatformChannel PlatformChannel { get; set; }

	public PlatformObject OnChannelMessage(string messageId, params PlatformObject[] parameters)
		=> ReceiveFromPlatform(messageId, parameters.ToDotNetObjects()).ToPlatformObject();

	public virtual object ReceiveFromPlatform(string messageId, params object[] parameters)
		=> OnReceiveFromPlatform?.Invoke(messageId, parameters);

	public object SendToPlatform(string messageId, params object[] parameters)
		=> PlatformChannel.HandleMessageFromDotNet(messageId, parameters.ToPlatformObjects()).ToDotNetObject();
}
