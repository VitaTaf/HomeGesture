long _dismissalSlidingMode = 0;
bool originalButton;
long _homeButtonType = 1;
int applicationDidFinishLaunching;

// Enable home gestures
%hook BSPlatform
- (NSInteger)homeButtonType {
	_homeButtonType = %orig;
	if (originalButton) {
		originalButton = NO;
		return %orig;
	} else {
		return 2;
	}
}
%end

// Hide home bar
%hook MTLumaDodgePillView
- (id)initWithFrame:(struct CGRect)arg1 {
	return NULL;
}
%end

// Workaround for TouchID respring bug
%hook SBCoverSheetSlidingViewController
- (void)_finishTransitionToPresented:(_Bool)arg1 animated:(_Bool)arg2 withCompletion:(id)arg3 {
	if ((_dismissalSlidingMode != 1) && (arg1 == 0)) {
		return;
	} else {
		%orig;
	}
}
- (long long)dismissalSlidingMode {
	_dismissalSlidingMode = %orig;
	return %orig;
}
%end

// Remove carrier text
%hook UIStatusBarServiceItemView
- (id)_serviceContentsImage {
    return nil;
}
- (CGFloat)extraRightPadding {
    return 0.0f;
}
- (CGFloat)standardPadding {
    return 2.0f;
}
%end

// Workaround for status bar transition bug
%hook CCUIOverlayStatusBarPresentationProvider
- (void)_addHeaderContentTransformAnimationToBatch:(id)arg1 transitionState:(id)arg2 {
	return;
}
- (struct CGRect)headerViewFrame {
	return CGRectMake(0, 0, %orig.size.width, 45);
}
%end
// Prevent status bar from flashing when invoking control center
%hook CCUIModularControlCenterOverlayViewController
- (void)setOverlayStatusBarHidden:(bool)arg1 {
	return;
}
%end
// Prevent status bar from displaying in fullscreen when invoking control center
%hook CCUIStatusBarStyleSnapshot
- (bool)isHidden {
	return YES;
}
%end

// Hide home bar in cover sheet
%hook SBDashboardHomeAffordanceView
- (void)_createStaticHomeAffordance {
	return;
}
%end

// Restore footer indicators
%hook SBDashBoardViewController
- (void)viewDidLoad {
	originalButton = YES;
	%orig;
}
%end

// Restore button to invoke Siri
%hook SBLockHardwareButtonActions
- (id)initWithHomeButtonType:(long long)arg1 proximitySensorManager:(id)arg2 {
	return %orig(_homeButtonType, arg2);
}
%end
%hook SBHomeHardwareButtonActions
- (id)initWitHomeButtonType:(long long)arg1 {
	return %orig(_homeButtonType);
}
%end

// Restore screenshot shortcut
%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)arg1 {
	applicationDidFinishLaunching = 2;
	%orig;
}
%end
%hook SBPressGestureRecognizer
- (void)setAllowedPressTypes:(NSArray *)arg1 {
	NSArray * lockHome = @[@104, @101];
	NSArray * lockVol = @[@104, @102, @103];
	if ([arg1 isEqual:lockVol] && applicationDidFinishLaunching == 2) {
		%orig(lockHome);
		applicationDidFinishLaunching--;
		return;
	}
	%orig;
}
%end
%hook SBClickGestureRecognizer
- (void)addShortcutWithPressTypes:(id)arg1 {
	if (applicationDidFinishLaunching == 1) {
		applicationDidFinishLaunching--;
		return;
	}
	%orig;
}
%end
%hook SBHomeHardwareButton
- (id)initWithScreenshotGestureRecognizer:(id)arg1 homeButtonType:(long long)arg2 buttonActions:(id)arg3 gestureRecognizerConfiguration:(id)arg4 {
	return %orig(arg1, _homeButtonType, arg3, arg4);
}
- (id)initWithScreenshotGestureRecognizer:(id)arg1 homeButtonType:(long long)arg2 {
	return %orig(arg1, _homeButtonType);
}
%end

// Hide notification hints
%hook NCNotificationListSectionRevealHintView
- (void)_updateHintTitle {
	return;
}
%end

// Hide unlock hints
%hook SBDashBoardTeachableMomentsContainerViewController
- (void)_updateTextLabel {
	return;
}
%end

// Disable breadcrumb
%hook SBWorkspaceDefaults
- (bool)isBreadcrumbDisabled {
	return YES;
}
%end

// Workaround for crash when launching app and invoking control center simultaneously
%hook SBSceneHandle
- (id)scene {
	@try {
		return %orig;
	}
	@catch (NSException *e) {
		return nil;
	}
}
%end