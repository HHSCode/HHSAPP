//
//  HomeViewController.m
//  HHSApp
//
//  Created by Connor Koehler on 3/17/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize calendarWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [calendarWebView loadHTMLString:@"<iframe src=\"https://www.google.com/calendar/embed?title=Hanover%20High%20School&amp;showTitle=0&amp;showNav=0&amp;showDate=0&amp;showPrint=0&amp;showTabs=0&amp;showCalendars=0&amp;showTz=0&amp;mode=AGENDA&amp;height=240&amp;wkst=1&amp;bgcolor=%23FFFFFF&amp;src=nn2509143kmbl2jbhlofvah8fs%40group.calendar.google.com&amp;color=%23182C57&amp;src=vs8lb5l1ej2cukd1l0s26atv2c%40group.calendar.google.com&amp;color=%236B3304&amp;src=680mj2kt8enp5minffopangeeg%40group.calendar.google.com&amp;color=%23AB8B00&amp;src=4uripfc30h2e7htmr6cn38g8bo%40group.calendar.google.com&amp;color=%23333333&amp;src=ak55rjsbcjca1b6c4g1pl98a30%40group.calendar.google.com&amp;color=%231B887A&amp;src=v5u6pb9hmmk6vdmc5sd97r67sg%40group.calendar.google.com&amp;color=%235229A3&amp;src=d4ohdnvm96jfqsrj9copecbiu8%40group.calendar.google.com&amp;color=%23853104&amp;src=1rank92tt12gjt2q0u3cbgemmc%40group.calendar.google.com&amp;color=%23B1365F&amp;src=ggb1fhi1mr66bati1ct16kvc78%40group.calendar.google.com&amp;color=%23B1440E&amp;src=en.usa%23holiday%40group.v.calendar.google.com&amp;color=%232952A3&amp;src=ubsv6hfmoe8n03oclu2r1a61hk%40group.calendar.google.com&amp;color=%235F6B02&amp;ctz=America%2FNew_York\" style=\" border-width:0 \" width=\"305\" height=\"225\" frameborder=\"0\" scrolling=\"no\"></iframe>" baseURL:[NSURL URLWithString: @"www.google.com"]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
