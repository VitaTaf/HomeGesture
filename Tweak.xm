long _dismissalSlidingMode = 0;

// Enable home gestures
%hook BSPlatform
- (NSInteger)homeButtonType {
	return 2;
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
%end
