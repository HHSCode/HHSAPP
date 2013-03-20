//
//  HomeViewController.h
//  HHSApp
//
//  Created by Connor Koehler on 3/17/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface HomeViewController : UIViewController<NSXMLParserDelegate>{
    NSXMLParser *rssParser;
    NSMutableArray *articles;
    NSMutableDictionary *item;
    NSString *currentElement;
    NSMutableString *ElementValue;
    BOOL errorParsing;
    NSMutableArray * stories;
    
    NSMutableString * currentTitle, * currentAuthor, * currentSummary, * currentLink, *currentURL, *currentHTML, *currentDate;
    
}
@property (strong, nonatomic) IBOutlet UIWebView *calendarWebView;
@property (strong, nonatomic) IBOutlet UIWebView *photosWebView;
@property (strong, nonatomic) IBOutlet UIImageView *slideshowImageView;
@property (nonatomic, retain) IBOutlet NSXMLParser * rssParser;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorSlideshow;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorCalendar;


- (void)parseXMLFileAtURL:(NSString *)URL;
-(UIImage *) getImageFromURL:(NSString *)fileURL;
-(void)setupImageView;
-(void)startupInternetBasedParts;
-(void)reachChanged;
@end
//does this work