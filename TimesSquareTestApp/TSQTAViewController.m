//
//  TSQTAViewController.m
//  TimesSquare
//
//  Created by Jim Puls on 12/5/12.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "TSQTAViewController.h"
#import "TSQTACalendarRowCell.h"
#import <TimesSquare/TimesSquare.h>

@interface TSQTAViewController () <TSQCalendarViewDelegate>

@property (nonatomic, retain) NSTimer *timer;

@property (strong) TSQCalendarView *calendarView;

@end


@interface TSQCalendarView (AccessingPrivateStuff)

@property (nonatomic, readonly) UITableView *tableView;

@end


@implementation TSQTAViewController

- (void)loadView;
{
    _calendarView = [[TSQCalendarView alloc] init];
    self.calendarView.calendar = self.calendar;
    self.calendarView.rowCellClass = [TSQTACalendarRowCell class];
    self.calendarView.firstDate = [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24 * 365 * 1];
    self.calendarView.lastDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 365 * 5];
    self.calendarView.backgroundColor = [UIColor colorWithRed:0.84f green:0.85f blue:0.86f alpha:1.0f];
    self.calendarView.pagingEnabled = YES;
    CGFloat onePixel = 1.0f / [UIScreen mainScreen].scale;
    self.calendarView.contentInset = UIEdgeInsetsMake(0.0f, onePixel, 0.0f, onePixel);
    self.calendarView.delegate = self;

    self.view = self.calendarView;
}

- (void)setCalendar:(NSCalendar *)calendar;
{
    _calendar = calendar;
    
    self.navigationItem.title = calendar.calendarIdentifier;
    self.tabBarItem.title = calendar.calendarIdentifier;
}

- (void)viewDidLayoutSubviews;
{
  // Set the calendar view to show today date on start
  [(TSQCalendarView *)self.view scrollToDate:[NSDate date] animated:NO];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    
    // Uncomment this to test scrolling performance of your custom drawing
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(scroll) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated;
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scroll;
{
    static BOOL atTop = YES;
    TSQCalendarView *calendarView = (TSQCalendarView *)self.view;
    UITableView *tableView = calendarView.tableView;
    
    [tableView setContentOffset:CGPointMake(0.f, atTop ? 10000.f : 0.f) animated:YES];
    atTop = !atTop;
}

#pragma mark - TSQCalendarViewDelegate Methods

- (BOOL)calendarView:(TSQCalendarView *)calendarView shouldDisplayEventMarkerForDate:(NSDate *)date;
{
    NSDateComponents *components = [calendarView.calendar components:NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    
    // This gives a nice pattern
    return (components.day % 9 == components.month % 9) || (components.day % 11 == components.month % 11);
}

- (void)calendarViewWillShowDayButton:(UIButton *)dayButton forDate:(NSDate *)date
{
    NSDateComponents *components = [self.calendarView.calendar components:NSMonthCalendarUnit|NSDayCalendarUnit
                                                                 fromDate:date];
    if (components.day % 3 == 0) {
        [dayButton setBackgroundColor:[UIColor colorWithRed:0.175 green:0.487 blue:0.896 alpha:1.000]];
        [dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [dayButton setTitleShadowColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    else {
        [dayButton setBackgroundColor:[UIColor clearColor]];
        [dayButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [dayButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

@end
