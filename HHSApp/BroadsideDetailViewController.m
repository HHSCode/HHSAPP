//
//  BroadsideDetailViewController.m
//  HHSApp
//
//  Created by Sudikoff Lab iMac on 3/19/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import "BroadsideDetailViewController.h"

@interface BroadsideDetailViewController ()

@end

@implementation BroadsideDetailViewController
@synthesize broadsideDetailWebView;

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
    // Do any additional setup after loading the view from its nib.
}

-(void)setWebView:(int)indexPath :(NSMutableArray *)stories{
    [self setTitle:[[stories objectAtIndex:indexPath]objectForKey:@"title"]];
    //NSLog(@"%@", [[stories objectAtIndex:indexPath]objectForKey:@"HTML"]);
    NSMutableString *htmlString = [[stories objectAtIndex:indexPath]objectForKey:@"HTML"];
    NSMutableString *start = @"<html><body>";
    NSMutableString *end = @"</body></html>";
    [start stringByAppendingString:htmlString];
    [start stringByAppendingString:end];
    htmlString = start;
    [broadsideDetailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"www.google.com"]]];
    //[broadsideDetailWebView loadHTMLString:@"<html><body>Hi</body></html>" baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
