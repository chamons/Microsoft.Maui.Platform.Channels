test::
	make -C Platforms/Apple/
	dotnet build Microsoft.Maui.PlatformChannels/ -f:net6.0-ios
	dotnet build -f:net6.0-ios SamplePlatformChannels
	dotnet build -t:Run -f:net6.0-ios SamplePlatformChannels