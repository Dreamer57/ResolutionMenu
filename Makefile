PRODUCT=$(shell ls -d *.xcodeproj | head -n 1 | sed 's/.xcodeproj$$//' | sed 's/ /\\ /g')
TARGET=$(shell echo $(PRODUCT) | sed 's/ /\\ /g' | sed 's/\..*//')
PROJECT=$(PRODUCT).xcodeproj
INTERMEDIATE=build/Release/$(APP)
APP=$(PRODUCT).app
ZIP=$(PRODUCT).zip

.PHONY: all
all: $(APP)

.PHONY: dist
dist: $(ZIP)

$(APP): $(INTERMEDIATE)
	rm -Rf $(APP)
	cp -R build/Release/$(APP) ./

$(INTERMEDIATE): xcodebuild
	@true

.PHONY: xcodebuild
xcodebuild:
# 	xcodebuild -project $(PROJECT) -target $(TARGET) -configuration Archive ARCHS=arm64 SDKROOT=macosx SUPPORTED_PLATFORMS=macosx
# 	xcodebuild -project $(PROJECT) -scheme $(TARGET) -configuration Release ARCHS=arm64 SDKROOT=macosx SUPPORTED_PLATFORMS=macosx
	xcodebuild -project $(PROJECT) -target $(TARGET) -configuration Release

$(ZIP): $(APP)
	rm -f $(ZIP)
	zip -r $(ZIP) $(APP)

.PHONY: clean
clean:
	rm -Rf build/

.PHONY: distclean
distclean: clean
	rm -Rf $(APP)
	rm -f $(ZIP)
