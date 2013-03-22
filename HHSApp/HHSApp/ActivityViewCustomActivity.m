//
//  ActivityViewCustomActivity.m
//  HHSApp
//
//  Created by Sudikoff Lab iMac on 3/22/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import "ActivityViewCustomActivity.h"
@implementation ActivityViewCustomActivity

- (NSString *)activityType
{
    return @"yourappname.Review.App";
}

- (NSString *)activityTitle
{
    return @"Open in Safari";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"safari icon.png"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    NSLog(@"%s", __FUNCTION__);
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    NSLog(@"%s",__FUNCTION__);
}

- (UIViewController *)activityViewController
{
    NSLog(@"%s",__FUNCTION__);
    return nil;
}

- (void)performActivity
{
    // This is where you can do anything you want, and is the whole reason for creating a custom
    // UIActivity and UIActivityProvider
    BroadsideDetailViewController *safariURL = [[BroadsideDetailViewController alloc]init];
    NSLog(@"%@",[safariURL getURL]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:/*[safariURL getURL]*/@"http://google.com"]];
    [self activityDidFinish:YES];
}

@end