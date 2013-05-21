//
//  ActivityViewCustomActivity.m
//  HHSApp
//
//  Created by Connor Koehler on 3/19/13.
//  Copyright (c) 2013 Hanover High School. All rights reserved.
//

#import "ActivityViewCustomActivityChrome.h"
@implementation ActivityViewCustomActivityChrome

- (NSString *)activityType
{
    return @"yourappname.Review.App";
}

- (NSString *)activityTitle
{
    return @"Open in Chrome";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"chrome icon.png"];
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
    NSString *localURL = [safariURL getURL];
    NSString *noSpaceURL = [localURL stringByReplacingOccurrencesOfString:@"\n\t\t" withString:@""];
    //NSLog(@"%@",noSpaceURL);
    NSString *chromeURL = [noSpaceURL stringByReplacingOccurrencesOfString:@"http" withString:@"googlechrome"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:chromeURL]];
    [self activityDidFinish:YES];
}

@end