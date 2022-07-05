ls buall::
	xcodebuild -configuration Debug -sdk iphonesimulator15.5
	xcodebuild -configuration Debug -destination 'platform=macOS,variant=Mac Catalyst' -scheme Sample SYMROOT=$(PWD)/build

clean:
	rm -r build/