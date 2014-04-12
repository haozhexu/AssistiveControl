/**
 The MIT License (MIT)
 
 Copyright (c) 2014 Haozhe XU
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 **/

//
//  HUXAssistiveControl.h
//  HUXAssistiveControl
//
//  Created by HAOZHE XU on 12/04/2014.
//  Copyright (c) 2014 Haozhe XU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HUXAssistiveControl;

/**
 * Touch delegate of HUXAssistiveControl
 **/
@protocol HUXAssistiveControlTouchDelegate <NSObject>

@optional
- (void)assistiveControl:(HUXAssistiveControl *)control willBeginTrackingWithTouch:(UITouch *)touch event:(UIEvent *)event;
- (void)assistiveControl:(HUXAssistiveControl *)control didContinueTrackingWithTouch:(UITouch *)touch event:(UIEvent *)event;
- (void)assistiveControl:(HUXAssistiveControl *)control didEndTrackingWithTouch:(UITouch *)touch event:(UIEvent *)event;

@end

@interface HUXAssistiveControl : UIControl

/**
 * A flag indicate whether the control should 'stick to edge' of screen (or its superview in general)
 * This mimics the behaviour of iOS Assistive Touch, by default it's set to YES
 **/
@property (nonatomic) BOOL stickyEdge;

/**
 * Delegate of all touch events of the control
 **/
@property (nonatomic, weak) id<HUXAssistiveControlTouchDelegate> delegate;

/**
 * Creates the control with specified frame, on specified view with an optional touch delegate
 **/
+ (HUXAssistiveControl *)createAssistiveControlWithFrame:(CGRect)frame onView:(UIView *)view touchDelegate:(id<HUXAssistiveControlTouchDelegate>)delegate;

/**
 * Creates the control with specified frame, on main window (UIWindow) with an optional touch delegate.
 * The control will be visible throughout most of the lifetime of the app
 * Note: it looks for [[[UIApplication sharedApplication] delegate] window], and does nothing if the window doesn't exist
 **/
+ (HUXAssistiveControl *)createAssistiveControlWithFrame:(CGRect)frame onMainWindowWithDelegate:(id<HUXAssistiveControlTouchDelegate>)delegate;

@end
