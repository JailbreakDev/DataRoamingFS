#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"

#ifndef CTCELLULARDATAPLAN_H_
Boolean CTRegistrationGetInternationalDataAccessStatus();
void CTRegistrationSetInternationalDataAccessStatus(Boolean enabled);
#endif

static void FSDataRoamingSwitchStatusDidChange(void);

@interface DataRoamingSwitch : NSObject <FSSwitchDataSource>
@end

@implementation DataRoamingSwitch

- (id)init {

    self = [super init];

    if (self) {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)FSDataRoamingSwitchStatusDidChange, CFSTR("com.sharedroutine.dataroaming.update"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    }

    return self;
}

- (void)dealloc {
    CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), (CFNotificationCallback)FSDataRoamingSwitchStatusDidChange, NULL, NULL);
    [super dealloc];
}

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier {
	return CTRegistrationGetInternationalDataAccessStatus();
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier {
	if (newState == FSSwitchStateIndeterminate)
		return;
	CTRegistrationSetInternationalDataAccessStatus(newState);
}

- (void)applyAlternateActionForSwitchIdentifier:(NSString *)switchIdentifier {
	NSURL *url = [NSURL URLWithString:(kCFCoreFoundationVersionNumber > 700 ? @"prefs:root=General&path=MOBILE_DATA_SETTINGS_ID" : @"prefs:root=General&path=Network")];
	[[FSSwitchPanel sharedPanel] openURLAsAlternateAction:url];
}

- (NSString *)titleForSwitchIdentifier:(NSString *)aSwitchIdentifier {
    return @"Data Roaming";
}

@end

static void FSDataRoamingSwitchStatusDidChange(void) {
    [[FSSwitchPanel sharedPanel] stateDidChangeForSwitchIdentifier:[NSBundle bundleForClass:[DataRoamingSwitch class]].bundleIdentifier];
}