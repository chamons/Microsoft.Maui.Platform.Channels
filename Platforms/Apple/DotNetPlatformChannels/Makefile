all::
	rm -r build/
	xcodebuild archive -sdk iphonesimulator -scheme DotNetPlatformChannels -archivePath build/DotNetPlatformChannels-iphonesimulator.xcarchive SKIP_INSTALL=NO
	xcodebuild archive -destination 'platform=macOS,variant=Mac Catalyst' -scheme DotNetPlatformChannels -archivePath build/DotNetPlatformChannels-maccatalyst.xcarchive SKIP_INSTALL=NO
	xcodebuild archive -sdk iphoneos -scheme DotNetPlatformChannels -archivePath build/DotNetPlatformChannels-iphoneos.xcarchive SKIP_INSTALL=NO
	xcodebuild -create-xcframework -framework build/DotNetPlatformChannels-iphoneos.xcarchive/Products/Library/Frameworks/DotNetPlatformChannels.framework  -framework build/DotNetPlatformChannels-iphonesimulator.xcarchive/Products/Library/Frameworks/DotNetPlatformChannels.framework -framework build/DotNetPlatformChannels-maccatalyst.xcarchive/Products/Library/Frameworks/DotNetPlatformChannels.framework -output build/DotNetPlatformChannels.xcframework

clean:
	rm -r build/