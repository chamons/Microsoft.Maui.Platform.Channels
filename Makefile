#TARGET=net6.0-ios
TARGET=net6.0-maccatalyst

test::
	make -C Platforms/Apple/
	dotnet build Microsoft.Maui.PlatformChannels/ -f:$(TARGET)
	dotnet build -f:$(TARGET) SamplePlatformChannels
	MONO_TRACE=E:all ./SamplePlatformChannels/bin/Debug/net6.0-maccatalyst/maccatalyst-x64/SamplePlatformChannels.app/Contents/MacOS/SamplePlatformChannels