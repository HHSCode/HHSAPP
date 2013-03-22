//
//  MoreViewController.h
//  HHSApp
//
//  Created by Sudikoff Lab iMac on 3/21/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreDetailViewController.h"
#import "Reachability.h"

@interface MoreViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    UITableView *moreTableView;
    NSArray *cellNames;
    
    NSXMLParser *rssParser;
    NSMutableArray *articles;
    NSMutableDictionary *item;
    NSString *currentElement;
    NSMutableString *ElementValue;
    BOOL errorParsing;
    NSMutableArray * stories;
    
    NSMutableString * currentName, *currentLink;
    UIActivityIndicatorView *act;
    UIAlertView *wait;
}

- (IBAction)feedbackMenu:(id)sender;

@property (nonatomic, retain) IBOutlet UITableView *moreTableView;

@property (nonatomic, retain) IBOutlet NSXMLParser * rssParser;

- (void)parseXMLFileAtURL:(NSString *)URL;

@end
