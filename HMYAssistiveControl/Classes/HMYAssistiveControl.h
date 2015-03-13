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
//  HMYAssistiveControl.h
//  HMYAssistiveControl
//
//  Created by HAOZHE XU on 12/04/2014.
//  http://www.huiimy.ninja
//  Copyright (c) 2014 Haozhe XU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMYAssistiveControl;

typedef NS_ENUM(NSInteger, HMYAssistiveControlExpandedLocation)
{
    assistiveControlExpandedLocationCenter      = 0,
    assistiveControlExpandedLocationTop         = 1 << 1,
    assistiveControlExpandedLocationLeft        = 1 << 2,
    assistiveControlExpandedLocationBottom      = 1 << 3,
    assistiveControlExpandedLocationRight       = 1 << 4
};

typedef NS_ENUM(NSInteger, HMYAssistiveControlState)
{
    assistiveControlStateCollapsed,
    assistiveControlStateExpanded
};

@interface HMYAssistiveControl : UIControl

/**
 * A flag indicate whether the control should 'stick to edge' of screen (or its superview in general)
 * This mimics the behaviour of iOS Assistive Touch, by default it's set to YES
 **/
@property (nonatomic) BOOL stickyEdge;

@property (nonatomic) HMYAssistiveControlExpandedLocation expandedLocation;
@property (nonatomic, readonly) HMYAssistiveControlState currentState;

@property (nonatomic, strong) UIView *collapsedView;
@property (nonatomic, strong) UIView *expandedView;

+ (HMYAssistiveControl *)createOnView:(UIView *)view withCollapsedView:(UIView *)collapsedView andExpandedView:(UIView *)expandedView;
+ (HMYAssistiveControl *)createOnMainWindowWithCollapsedView:(UIView *)collapsedView andExpandedView:(UIView *)expandedView;

@end
