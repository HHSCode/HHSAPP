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
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MoreViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate, NSXMLParserDelegate>

//all private properties are in .m interface extension

- (IBAction)feedbackMenu:(id)sender;

@property (nonatomic, retain) IBOutlet UITableView *moreTableView;

@property (nonatomic, retain) IBOutlet NSXMLParser * rssParser;

- (void)parseXMLFileAtURL:(NSString *)URL;
- (IBAction)actionEmailComposer;



@end
