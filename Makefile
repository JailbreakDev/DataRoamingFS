export ARCHS = armv7 arm64
export TARGET = iphone:clang:7.1
include theos/makefiles/common.mk

BUNDLE_NAME = DataRoaming
DataRoaming_FILES = Switch.x
DataRoaming_FRAMEWORKS = UIKit CoreTelephony
DataRoaming_LIBRARIES = flipswitch
DataRoaming_INSTALL_PATH = /Library/Switches

include $(THEOS_MAKE_PATH)/bundle.mk
SUBPROJECTS += dataroaminghelper
include $(THEOS_MAKE_PATH)/aggregate.mk
