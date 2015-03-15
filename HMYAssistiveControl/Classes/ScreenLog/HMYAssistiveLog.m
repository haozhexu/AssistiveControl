//
//  HMYAssistiveLogView.m
//  HMYAssistiveControl
//
//  Created by HAOZHE XU on 14/03/2015.
//  Copyright (c) 2015 Haozhe XU. All rights reserved.
//

#import "HMYAssistiveLog.h"

@protocol HMYAssistiveLogObserver <NSObject>
- (void)newLogAddedInChannel:(NSString *)channel text:(NSString *)text;
@end

@interface HMYAssistiveLogMessage : NSObject
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *message;
@end

@implementation HMYAssistiveLogMessage
@end

@interface HMYAssistiveLogExpandedView : UIView <HMYAssistiveLogObserver>

@property (nonatomic, strong) NSMutableArray *logs;
@property (nonatomic, strong) NSMutableArray *channels;
@property (nonatomic) NSInteger currentChannel;

@property (nonatomic, strong) UITextView *logTextView;
@property (nonatomic, strong) UIScrollView *channelScrollView;
@property (nonatomic, weak) UIButton *lastButtonAdded;

@end

@implementation HMYAssistiveLogExpandedView

static const CGFloat kChannelButtonSpacing = 4;
static const CGFloat kChannelButtonWidth = 60;
static NSString * const kAllChannelName = @"ALL";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _logs = [[NSMutableArray alloc] init];
        _channels = [[NSMutableArray alloc] init];
        
        [self addViews];
        [self setupConstraints];
        
        [self addNewChannel:kAllChannelName]; // add all channel
    }
    return self;
}

- (void)addViews
{
    self.logTextView = [[UITextView alloc] init];
    self.logTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.logTextView.editable = NO;
    self.logTextView.textColor = [UIColor whiteColor];
    self.logTextView.backgroundColor = [UIColor blackColor];
    
    [self addSubview:self.logTextView];
    
    self.channelScrollView = [[UIScrollView alloc] init];
    self.channelScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.channelScrollView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.channelScrollView];
    
    
    
}

- (void)setupConstraints
{
    // here we want to fill the container with text view and scroll view,
    // where text view occupies top 80% of space
    
    // horizontally fit
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[log]|" options:0 metrics:nil views:@{@"log": self.logTextView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[channel]|" options:0 metrics:nil views:@{@"channel": self.channelScrollView}]];
    
    // align top and bottom
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logTextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.channelScrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    // percentage
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logTextView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.8 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.channelScrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.2 constant:0]];
}

#pragma mark - HMYAssistiveLogObserver
- (void)newLogAddedInChannel:(NSString *)channel text:(NSString *)text
{
    HMYAssistiveLogMessage *message = [[HMYAssistiveLogMessage alloc] init];
    message.channel = channel;
    message.message = text;
    
    [self.logs addObject:message];
    
    NSInteger channelIndex = 0;
    
    if (channel != nil)
    {
        if (![self.channels containsObject:channel])
        {
            [self addNewChannel:channel];
        }
        channelIndex = [self.channels indexOfObject:channel];
    }
    
    [self updateLogsForChannelIndex:channelIndex];
    
}

#pragma mark - Private
- (void)addNewChannel:(NSString *)channel
{
    [self.channels addObject:channel];
    
    UIButton *channelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    channelButton.tag = self.channels.count - 1;
    channelButton.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [channelButton setTitle:channel forState:UIControlStateNormal];
    [channelButton addTarget:self action:@selector(channelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect newFrame = CGRectMake(self.lastButtonAdded.frame.origin.x + self.lastButtonAdded.frame.size.width + kChannelButtonSpacing, 0, kChannelButtonWidth, self.channelScrollView.bounds.size.height);
    channelButton.frame = newFrame;
    
    [self.channelScrollView addSubview:channelButton];
    self.channelScrollView.contentSize = CGSizeMake(newFrame.origin.x + newFrame.size.width, self.channelScrollView.bounds.size.height);
    
    self.lastButtonAdded = channelButton;
}

- (void)updateLogsForChannelIndex:(NSInteger)channelIndex
{
    if (self.currentChannel == channelIndex || self.currentChannel == 0)
    {
        NSString *channelName = self.channels[channelIndex];
        NSArray *channelLogs = self.logs;
        
        if (self.currentChannel != 0 && [channelName isEqualToString:kAllChannelName] == NO)
        {
            channelLogs = [self.logs filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(HMYAssistiveLogMessage *msg, NSDictionary *bindings) {
                return [msg.channel isEqualToString:channelName];
            }]];
        }
        
        NSArray *texts = [channelLogs valueForKey:@"message"];
        self.logTextView.text = [texts componentsJoinedByString:@"\n"];
    }
}

#pragma mark - Button Action
- (void)channelButtonAction:(UIButton *)button
{
    NSInteger index = button.tag;
    if (index >= 0 && index < self.channelScrollView.subviews.count)
    {
        self.currentChannel = index;
        [self updateLogsForChannelIndex:index];
    }
}

@end

@interface HMYAssistiveLogCollapsedView : UIView <HMYAssistiveLogObserver>
@property (nonatomic, strong) NSMutableArray *labels;
@end

@implementation HMYAssistiveLogCollapsedView

static const NSInteger kLabelCount = 3;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _labels = [[NSMutableArray alloc] initWithCapacity:kLabelCount];
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
        
        [self addViews];
        [self setupConstraints];
    }
    return self;
}

- (void)addViews
{
    for (NSInteger i = 0 ; i < kLabelCount ; i++)
    {
        UILabel *label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.font = [UIFont systemFontOfSize:i < kLabelCount - 1 ? 9 : 12];
        label.textColor = [UIColor whiteColor];
        [self.labels addObject:label];
        [self addSubview:label];
    }
}

- (void)setupConstraints
{
    UILabel *prevLabel = nil;
    for (UILabel *label in self.labels)
    {
        // fit label horizontally
        [self addConstraint: [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0] ];
        [self addConstraint: [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0] ];
        
        if (prevLabel == nil)
        {
            // top align first label
            [self addConstraint: [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0] ];
        }
        else
        {
            // spacing between labels
            [self addConstraint: [NSLayoutConstraint constraintWithItem:prevLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeTop multiplier:1 constant:0] ];
        }
        
        prevLabel = label;
    }
    
    // bottom align last label
    if (prevLabel)
    {
        [self addConstraint: [NSLayoutConstraint constraintWithItem:prevLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0] ];
    }
    
    [self setNeedsLayout];
}

#pragma mark - HMYAssistiveLogObserver
- (void)newLogAddedInChannel:(NSString *)channel text:(NSString *)text
{
    UILabel *prevLabel = nil;
    for (UILabel *label in self.labels)
    {
        if (prevLabel)
        {
            prevLabel.text = label.text;
            label.text = nil;
        }
        
        prevLabel = label;
        
        label.text = channel;
    }
    
    prevLabel.text = channel;
}

@end

@interface HMYAssistiveLog ()
@property (nonatomic, strong) NSMutableArray *messageList;
@end

@implementation HMYAssistiveLog

static const NSInteger kDefaultListSizeLimit = 256;

@synthesize expandedView = _expandedView;
@synthesize collapsedView = _collapsedView;

- (id)init
{
    self = [super init];
    if (self)
    {
        _logListSizeLimit = kDefaultListSizeLimit;
        _messageList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (UIView *)expandedView
{
    if (_expandedView == nil)
    {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGSize viewSize = CGSizeMake(screenSize.width - 20, screenSize.height / 2);
        _expandedView = [[HMYAssistiveLogExpandedView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    }
    
    return _expandedView;
}

- (UIView *)collapsedView
{
    if (_collapsedView == nil)
    {
        _collapsedView = [[HMYAssistiveLogCollapsedView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    }
    return _collapsedView;
}

- (void)alog:(NSString *)channel format:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *log = [NSString stringWithFormat:format, args];
    [(HMYAssistiveLogExpandedView *)self.expandedView newLogAddedInChannel:channel text:log];
    [(HMYAssistiveLogCollapsedView *)self.collapsedView newLogAddedInChannel:channel text:log];
    va_end(args);
}

+ (instancetype)sharedInstance
{
    static HMYAssistiveLog *log;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        log = [[HMYAssistiveLog alloc] init];
    });
    
    return log;
}

@end
