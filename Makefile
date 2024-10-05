ARCHS := arm64
PACKAGE_FORMAT := ipa
TARGET := iphone:clang:16.5:16.0

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = Nugget
LIBRARY_NAME = libEMProxy libimobiledevice

# Link em_proxy separately as it has duplicated symbols with minimuxer
libEMProxy_FILES = lib/empty.swift
libEMProxy_LDFLAGS = -force_load lib/libem_proxy-ios.a -install_name @rpath/libEMProxy.dylib
libEMProxy_FRAMEWORKS = Security
libEMProxy_INSTALL_PATH = /Applications/$(APPLICATION_NAME).app/Frameworks

# libimobiledevice + minimuxer
libimobiledevice_FILES = idevicebackup2.c
libimobiledevice_CFLAGS = -Iinclude
libimobiledevice_LDFLAGS = \
  -force_load lib/libimobiledevice-1.0.a \
  -force_load lib/libimobiledevice-glue-1.0.a \
  -force_load lib/libplist-2.0.a \
  -force_load lib/libusbmuxd-2.0.a \
  -force_load lib/libcrypto.a \
  -force_load lib/libssl.a \
  -force_load lib/libminimuxer-ios.a \
  -Wl,-mllvm,--opaque-pointers \
  -install_name @rpath/libimobiledevice.dylib
libimobiledevice_FRAMEWORKS = Foundation Security SystemConfiguration
libimobiledevice_INSTALL_PATH = /Applications/$(APPLICATION_NAME).app/Frameworks

SRC_DIR := Nugget
# Directories
SPARSERESTORE_DIR := $(SRC_DIR)/Sparserestore

VIEWS_DIR := $(SRC_DIR)/Views
NAV_VIEWS_DIR := $(VIEWS_DIR)/NavigatorViews
TWEAK_VIEWS_DIR := $(VIEWS_DIR)/Tweaks
ACC_VIEWS_DIR := $(VIEWS_DIR)/AccessoryViews
FILE_PICKER_VIEWS_DIR := $(VIEWS_DIR)/FilePicker

EXT_DIR := $(SRC_DIR)/Extensions
UI_EXT_DIR := $(EXT_DIR)/UI

CONTROLLERS_DIR := $(SRC_DIR)/Controllers
TWEAK_CONTROLLERS_DIR := $(CONTROLLERS_DIR)/Tweaks
STATUS_MANAGER_DIR := $(TWEAK_CONTROLLERS_DIR)/StatusManager

$(APPLICATION_NAME)_FILES = \
  include/minimuxer-helpers.swift \
  include/minimuxer.swift \
  include/em_proxy.swift \
  include/SwiftBridgeCore.swift \
  $(SRC_DIR)/SwiftNIO/NIOFoundationCompat/ByteBuffer-foundation.swift \
  $(SRC_DIR)/SwiftNIO/_NIOBase64/Base64.swift \
  $(SRC_DIR)/SwiftNIO/NIOCore/ByteBuffer-lengthPrefix.swift \
  $(SRC_DIR)/SwiftNIO/NIOCore/ByteBuffer-conversions.swift \
  $(SRC_DIR)/SwiftNIO/NIOCore/IntegerTypes.swift \
  $(SRC_DIR)/SwiftNIO/NIOCore/ByteBuffer-multi-int.swift \
  $(SRC_DIR)/SwiftNIO/NIOCore/ByteBuffer-views.swift \
  $(SRC_DIR)/SwiftNIO/NIOCore/ByteBuffer-hexdump.swift \
  $(SRC_DIR)/SwiftNIO/NIOCore/IntegerBitPacking.swift \
  $(SRC_DIR)/SwiftNIO/NIOCore/ByteBuffer-aux.swift \
  $(SRC_DIR)/SwiftNIO/NIOCore/ByteBuffer-core.swift \
  $(SRC_DIR)/SwiftNIO/NIOCore/CircularBuffer.swift \
  $(SRC_DIR)/SwiftNIO/NIOCore/ByteBuffer-int.swift \
  $(SRC_DIR)/SwiftNIO/NIOPosix/PointerHelpers.swift

$(APPLICATION_NAME)_FILES += $(wildcard $(SPARSERESTORE_DIR)/*.swift)
$(APPLICATION_NAME)_FILES += $(wildcard $(NAV_VIEWS_DIR)/*.swift)
$(APPLICATION_NAME)_FILES += $(wildcard $(TWEAK_VIEWS_DIR)/*.swift)
$(APPLICATION_NAME)_FILES += $(wildcard $(ACC_VIEWS_DIR)/*.swift)
$(APPLICATION_NAME)_FILES += $(wildcard $(FILE_PICKER_VIEWS_DIR)/*.swift)
$(APPLICATION_NAME)_FILES += $(wildcard $(VIEWS_DIR)/*.swift)
$(APPLICATION_NAME)_FILES += $(wildcard $(EXT_DIR)/*.swift)
$(APPLICATION_NAME)_FILES += $(wildcard $(UI_EXT_DIR)/*.swift)
$(APPLICATION_NAME)_FILES += $(wildcard $(TWEAK_CONTROLLERS_DIR)/*.swift)
$(APPLICATION_NAME)_FILES += $(wildcard $(CONTROLLERS_DIR)/*.swift)
$(APPLICATION_NAME)_FILES += $(wildcard $(STATUS_MANAGER_DIR)/*.m)
$(APPLICATION_NAME)_FILES += $(SRC_DIR)/NuggetApp.swift

$(APPLICATION_NAME)_FRAMEWORKS = UIKit
$(APPLICATION_NAME)_CFLAGS = -fcommon -fobjc-arc
$(APPLICATION_NAME)_SWIFTFLAGS = -Iinclude -import-objc-header include/minimuxer-Bridging-Header.h
# $(APPLICATION_NAME)_SWIFTFLAGS += -Iinclude -import-objc-header Nugget/Nugget-Bridging-Header.h
$(APPLICATION_NAME)_LDFLAGS = -L$(THEOS_OBJ_DIR) -rpath @executable_path/Frameworks
$(APPLICATION_NAME)_LIBRARIES = EMProxy imobiledevice
$(APPLICATION_NAME)_CODESIGN_FLAGS = -Sentitlements.plist
include $(THEOS_MAKE_PATH)/library.mk
include $(THEOS_MAKE_PATH)/application.mk
