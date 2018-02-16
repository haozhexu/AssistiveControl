//
//  HMYAssistiveControl.m
//  HMYAssistiveControl
//
//  Created by HAOZHE XU on 12/04/2014.
//  Copyright (c) 2014 Haozhe XU. All rights reserved.
//

#import "HMYAssistiveControl.h"

@interface HMYAssistiveControl ()

@property (nonatomic) CGPoint previousTouchPoint, collapsedViewLastPosition;
@property (nonatomic) BOOL draggedAfterFirstTouch;

@end

@implementation HMYAssistiveControl

const static NSTimeInterval kAnimDuration = 0.3f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // by default we want the control to stick to edge of screen (or its superview)
        // to mimic the behaviour of Assistive Touch
        _stickyEdge = YES;
        self.backgroundColor = [UIColor clearColor];
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

- (void)setCollapsedView:(UIView *)collapsedView
{
    [_collapsedView removeFromSuperview];
    _collapsedView = collapsedView;
    _collapsedView.userInteractionEnabled = NO;
    _collapsedViewLastPosition = collapsedView.frame.origin;
    
    if (_currentState == assistiveControlStateCollapsed)
    {
        [self showCollapsedView];
    }
}

- (void)setExpandedView:(UIView *)expandedView
{
    [_expandedView removeFromSuperview];
    _expandedView = expandedView;
    
    if (_currentState == assistiveControlStateExpanded)
    {
        [self showExpandedView];
    }
}

#pragma mark - Essential control action events
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    _previousTouchPoint = [touch locationInView:self.superview];
    _draggedAfterFirstTouch = NO;
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self.superview];
    
    _draggedAfterFirstTouch = YES;
    
    if (_currentState == assistiveControlStateCollapsed)
    {
        CGSize movementDelta = CGSizeMake(touchPoint.x - _previousTouchPoint.x,touchPoint.y - _previousTouchPoint.y);
        self.center = CGPointMake(self.center.x + movementDelta.width, self.center.y + movementDelta.height);
    }
    
    _previousTouchPoint = touchPoint;
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (_currentState == assistiveControlStateCollapsed)
    {
        if (_draggedAfterFirstTouch)
        {
            [self adjustControlPositionForStickyEdgeWithCompletion:nil];
        }
        else
        {
            [self showExpandedView];
        }
    }
    else
    {
        CGPoint touchPoint = [touch locationInView:self];
        if (CGRectContainsPoint(_expandedView.frame, touchPoint) == NO)
        {
            [self showCollapsedView];
        }
    }
    
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

- (void)showExpandedView
{
    [_collapsedView removeFromSuperview];
    
    _collapsedViewLastPosition = self.frame.origin;
    
    // work out where to put expanded view
    UIView *container = self.superview;
    CGRect containerBounds = container.bounds;
    CGRect destFrame = _expandedView.frame;
    
    if (_expandedLocation == assistiveControlExpandedLocationCenter)
    {
        destFrame.origin = CGPointMake((containerBounds.size.width - destFrame.size.width) / 2, (containerBounds.size.height - destFrame.size.height) / 2);
    }
    else
    {
        if (_expandedLocation & assistiveControlExpandedLocationTop)
        {
            destFrame.origin.y = 0;
        }
        if (_expandedLocation & assistiveControlExpandedLocationRight)
        {
            destFrame.origin.x = containerBounds.size.width - destFrame.size.width;
        }
        if (_expandedLocation & assistiveControlExpandedLocationBottom)
        {
            destFrame.origin.y = containerBounds.size.height - destFrame.size.height;
        }
        if (_expandedLocation & assistiveControlExpandedLocationLeft)
        {
            destFrame.origin.x = 0;
        }
    }
    
    self.frame = self.superview.bounds;
    _expandedView.frame = destFrame;
    
    [self addSubview:_expandedView];
    
    _currentState = assistiveControlStateExpanded;
}

- (void)showCollapsedView
{
    [_expandedView removeFromSuperview];
    
    CGRect destFrame = _collapsedView.frame;
    destFrame.origin = _collapsedViewLastPosition;
    
    self.frame = destFrame;
    _collapsedView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    [self addSubview:_collapsedView];
    
    [self adjustControlPositionForStickyEdgeWithCompletion:nil];
    
    _currentState = assistiveControlStateCollapsed;
}

#pragma mark - Convenient Creators

+ (HMYAssistiveControl *)createOnView:(UIView *)view withCollapsedView:(UIView *)collapsedView andExpandedView:(UIView *)expandedView
{
    HMYAssistiveControl *control = [[HMYAssistiveControl alloc] initWithFrame:collapsedView.frame];
    [view addSubview:control];
    
    control.collapsedView = collapsedView;
    control.expandedView = expandedView;
    
    return control;
}

+ (HMYAssistiveControl *)createOnMainWindowWithCollapsedView:(UIView *)collapsedView andExpandedView:(UIView *)expandedView
{
    UIView *baseView = [[[UIApplication sharedApplication] delegate] window];
    return [self createOnView:baseView withCollapsedView:collapsedView andExpandedView:expandedView];
}

@end
