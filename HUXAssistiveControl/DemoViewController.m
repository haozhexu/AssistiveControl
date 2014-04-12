//
//  ViewController.m
//  HUXAssistiveControl
//
//  Created by HAOZHE XU on 12/04/2014.
//  Copyright (c) 2014 Haozhe XU. All rights reserved.
//

#import "DemoViewController.h"
#import "HUXAssistiveControl.h"

@interface DemoViewController () <HUXAssistiveControlTouchDelegate>

@end

@implementation DemoViewController

- (void)loadView
{
    UIView *contentView = [[UIView alloc] init];
    
    contentView.backgroundColor = [UIColor lightGrayColor];
    
    self.view = contentView;
}

- (void)startDemo
{
    [HUXAssistiveControl createAssistiveControlWithFrame:CGRectMake(10, 10, 40, 40) onMainWindowWithDelegate:self];
}

@end
