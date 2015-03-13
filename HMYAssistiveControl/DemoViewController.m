//
//  ViewController.m
//  HMYAssistiveControl
//
//  Created by HAOZHE XU on 12/04/2014.
//  Copyright (c) 2014 Haozhe XU. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DemoViewController

- (void)loadView
{
    UIView *contentView = [[UIView alloc] init];
    
    contentView.backgroundColor = [UIColor lightGrayColor];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [contentView addSubview:self.tableView];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:@{@"tableView": _tableView}]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:@{@"tableView": _tableView}]];
    
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Demo";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = @"Item Bla";
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemoDetailViewController *detailVC = [[DemoDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end

@implementation DemoDetailViewController

- (void)loadView
{
    UIView *contentView = [[UIView alloc] init];
    
    contentView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.numberOfLines = 0;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    textLabel.text = @"Assistive control added to main window, so it is universally visible throughout the lifetime of the app.";
    
    NSDictionary *metrics = @{@"margin": @(10)};
    
    [contentView addSubview:textLabel];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[textLabel]|" options:0 metrics:metrics views:@{@"textLabel": textLabel}]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[textLabel]-margin-|" options:0 metrics:metrics views:@{@"textLabel": textLabel}]];
    
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Demo Details";
}

@end
