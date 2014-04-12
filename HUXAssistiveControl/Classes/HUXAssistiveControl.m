//
//  HUXAssistiveControl.m
//  HUXAssistiveControl
//
//  Created by HAOZHE XU on 12/04/2014.
//  Copyright (c) 2014 Haozhe XU. All rights reserved.
//

#import "HUXAssistiveControl.h"

@interface HUXAssistiveControl ()

@property (nonatomic) CGPoint previousTouchPoint;

@end

@implementation HUXAssistiveControl

const static CGFloat kDefaultBackgroundAlpha = 0.5f;
const static NSTimeInterval kAnimDuration = 0.3f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // by default we want the control to stick to edge of screen (or its superview)
        // to mimic the behaviour of Assistive Touch
        _stickyEdge = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kDefaultBackgroundAlpha];
    }
    return self;
}

- (void)didMoveToSuperview
{
    // once the control is added to a superview and stickyEdge is true,
    // we need to calculate the correct position of the control
    [self adjustControlPositionForStickyEdgeWithCompletion:nil];
}

- (void)setStickyEdge:(BOOL)stickyEdge
{
    _stickyEdge = stickyEdge;
    [self adjustControlPositionForStickyEdgeWithCompletion:nil];
}

#pragma mark - Essential control action events
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    _previousTouchPoint = [touch locationInView:self.superview];
    
    if ([_delegate respondsToSelector:@selector(assistiveControl:willBeginTrackingWithTouch:event:)])
    {
        [_delegate assistiveControl:self willBeginTrackingWithTouch:touch event:event];
    }
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self.superview];
    CGSize movementDelta = CGSizeMake(touchPoint.x - _previousTouchPoint.x,touchPoint.y - _previousTouchPoint.y);
    
    _previousTouchPoint = touchPoint;
    
    self.center = CGPointMake(self.center.x + movementDelta.width, self.center.y + movementDelta.height);
    
    if ([_delegate respondsToSelector:@selector(assistiveControl:didContinueTrackingWithTouch:event:)])
    {
        [_delegate assistiveControl:self didContinueTrackingWithTouch:touch event:event];
    }
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    __weak HUXAssistiveControl *weakSelf = self;
    
    [self adjustControlPositionForStickyEdgeWithCompletion:^(BOOL frameChanged){
        if ([_delegate respondsToSelector:@selector(assistiveControl:didEndTrackingWithTouch:event:)])
        {
            [_delegate assistiveControl:weakSelf didEndTrackingWithTouch:touch event:event];
        }
    }];
}

#pragma mark - Private
- (void)adjustControlPositionForStickyEdgeWithCompletion:(void (^)(BOOL frameChanged))completion
{
    if (_stickyEdge && self.superview != nil)
    {
        CGPoint destPosition = [self calculateStickyEdgeDestinationPosition];
        
        if (CGPointEqualToPoint(self.frame.origin, destPosition) == NO)
        {
            [UIView animateWithDuration:kAnimDuration animations:^(){
                self.frame = CGRectMake(destPosition.x, destPosition.y, self.frame.size.width, self.frame.size.height);
            } completion:^(BOOL finished){
                if (completion != nil)
                {
                    completion(YES);
                }
            }];
        }
        else if (completion != nil)
        {
            completion(NO);
        }
    }
    else if (completion != nil)
    {
        completion(NO);
    }
}

- (CGPoint)calculateStickyEdgeDestinationPosition
{
    CGRect containerBounds = self.superview.bounds;
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(self.frame.origin.y, self.frame.origin.x, containerBounds.size.height - (self.frame.origin.y + self.frame.size.height), containerBounds.size.width - (self.frame.origin.x + self.frame.size.width));
    CGFloat edgeDistance = edgeInsets.top;
    CGPoint destPosition = CGPointMake(self.frame.origin.x, 0);
    
    if (edgeInsets.bottom < edgeDistance)
    {
        edgeDistance = edgeInsets.bottom;
        destPosition = CGPointMake(self.frame.origin.x, containerBounds.size.height - self.frame.size.height);
    }
    if (edgeInsets.left < edgeDistance)
    {
        edgeDistance = edgeInsets.left;
        destPosition = CGPointMake(0, self.frame.origin.y);
    }
    if (edgeInsets.right < edgeDistance)
    {
        edgeDistance = edgeInsets.right;
        destPosition = CGPointMake(containerBounds.size.width - self.frame.size.width, self.frame.origin.y);
    }
    
    if (destPosition.x < 0)
    {
        destPosition.x = 0;
    }
    else if (destPosition.x > containerBounds.size.width - self.frame.size.width)
    {
        destPosition.x = containerBounds.size.width - self.frame.size.width;
    }
    if (destPosition.y < 0)
    {
        destPosition.y = 0;
    }
    else if (destPosition.y > containerBounds.size.height - self.frame.size.height)
    {
        destPosition.y = containerBounds.size.height - self.frame.size.height;
    }
    
    return destPosition;
}

#pragma mark - Convenient Creators

+ (HUXAssistiveControl *)createAssistiveControlWithFrame:(CGRect)frame onView:(UIView *)view touchDelegate:(id<HUXAssistiveControlTouchDelegate>)delegate
{
    HUXAssistiveControl *control = [[HUXAssistiveControl alloc] initWithFrame:frame];
    control.delegate = delegate;
    [view addSubview:control];
    [view bringSubviewToFront:control];
    
    return control;
}

+ (HUXAssistiveControl *)createAssistiveControlWithFrame:(CGRect)frame onMainWindowWithDelegate:(id<HUXAssistiveControlTouchDelegate>)delegate
{
    UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
    if (mainWindow != nil)
    {
        return [self createAssistiveControlWithFrame:frame onView:mainWindow touchDelegate:delegate];
    }
    return nil;
}

@end
