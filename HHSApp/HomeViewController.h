//
//  HomeViewController.h
//  HHSApp
//
//  Created by Connor Koehler on 3/17/13.
//  Copyright (c) 2013 Hanover High School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface HomeViewController : UIViewController<NSXMLParserDelegate, UIWebViewDelegate>
//instance variables have been removed, replaced by properties. All properties not below are in the private interface in the .m file
//use dot notation or methods to access properties, don't access instance variables directly unless you are implementing the getters or setters

@property (strong, nonatomic) IBOutlet UIWebView *calendarWebView;
@property (strong, nonatomic) IBOutlet UIWebView *photosWebView;
@property (strong, nonatomic) IBOutlet UIImageView *slideshowImageView;
@property (nonatomic, strong) IBOutlet NSXMLParser * rssParser;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorSlideshow;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorCalendar;

- (void)parseXMLFileAtURL:(NSString *)URL;
-(UIImage *) getImageFromURL:(NSString *)fileURL;
-(void)setupImageView;
-(void)startupInternetBasedParts;
-(void)reachChanged;
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end