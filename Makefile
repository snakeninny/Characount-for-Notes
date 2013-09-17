export ARCHS = armv7
export TARGET = iphone:latest:4.3

include theos/makefiles/common.mk

TWEAK_NAME = Characount
Characount_FILES = Tweak.xm
Characount_FRAMEWORKS = UIKit CoreGraphics QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk
