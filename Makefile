#TARGET=net6.0-ios
TARGET=net6.0-maccatalyst

test::
	make -C Platforms/Apple/
	dotnet build Microsoft.Maui.PlatformChannels/ -f:$(TARGET)
	dotnet build -f:$(TARGET) SamplePlatformChannels
	dotnet build -t:Run -f:$(TARGET) SamplePlatformChannels