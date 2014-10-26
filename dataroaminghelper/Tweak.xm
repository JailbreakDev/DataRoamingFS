#import <CoreFoundation/CoreFoundation.h>

%hook SettingsNetworkController

- (void)setDataRoamingEnabled:(id)enabled specifier:(id)spec {
	%orig;
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.sharedroutine.dataroaming.update"), NULL, NULL, TRUE);
}

%end