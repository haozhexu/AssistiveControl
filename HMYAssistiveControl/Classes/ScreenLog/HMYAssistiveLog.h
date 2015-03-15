//
//  HMYAssistiveLogView.h
//  HMYAssistiveControl
//
//  Created by HAOZHE XU on 14/03/2015.
//  Copyright (c) 2015 Haozhe XU. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef DEBUG
#   define UIDLog(channel, fmt, ...) [[HMYAssistiveLog sharedInstance] alog:channel format:fmt, ##__VA_ARGS__];
#else
#   define UIDLog(...)
#endif

#define UILog(channel, fmt, ...) [[HMYAssistiveLog sharedInstance] alog:channel format:fmt, ##__VA_ARGS__];

/**
 A class that provides expanded and collapsed view for HMYAssistiveControl showing logging text.
 **/
@interface HMYAssistiveLog : NSObject

/**
 Expanded view, readonly
 **/
@property (nonatomic, readonly) UIView *expandedView;

/**
 Collapsed view, readonly
 **/
@property (nonatomic, readonly) UIView *collapsedView;

/**
 Size limit of the log list.
 Once the number of logs exceeds the limit, adding new log will remove first log in the list.
 The default size is 256
 **/
@property (nonatomic) NSInteger logListSizeLimit;

/**
 Whether the log output to assistive view should also be printed in console.
 Default is NO
 **/
@property (nonatomic) BOOL alsoLogInConsole;

/**
 Prints log text into the assistive log view.
 @param channel which channel should the log belong to, can be nil
 @param format format and text of the log
 **/
- (void)alog:(NSString *)channel format:(NSString *)format, ...;

/**
 @return a shared instance of HMYAssistiveLog
 **/
+ (instancetype)sharedInstance;

@end
