using Microsoft.Maui.Handlers;
using Microsoft.PlatformChannels;

namespace Microsoft.Maui.PlatformChannels;

public partial class PlatformChannelViewHandler : ViewHandler<IPlatformChannelView, UIKit.UIView>
{
    public static void MapChannelTypeId(IPlatformViewHandler handler, IPlatformChannelView view)
	{
		throw new System.NotImplementedException ();
	}

	public static void MapChannelInstanceId(IPlatformViewHandler handler, IPlatformChannelView view)
	{
		throw new System.NotImplementedException ();
	}

	protected override UIKit.UIView CreatePlatformView()
	{
		throw new System.NotImplementedException ();
	}

    internal object SendToPlatformImpl(string messageId, object[] args)
    {
        throw new System.NotImplementedException ();
    }
}