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
#import "GAITrackedViewController.h"
@interface MoreViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate>{
    UITableView *moreTableView;
    NSArray *cellNames;
    
    NSXMLParser *rssParser;
    NSMutableArray *articles;
    NSMutableDictionary *item;
    NSString *currentElement;
    NSMutableString *ElementValue;
    BOOL errorParsing;
    NSMutableDictionary * stories;
    
    NSMutableString * currentName, *currentLink;
    UIActivityIndicatorView *act;
    UIAlertView *wait;
    
    //Mail stuff
    NSArray *feedBackEmail;
    NSString *bugReportSubject;
    NSString *bugReportBody;
    NSString *incorrectInformaationSubject;
    NSString *incorrectInformationBody;
    NSString *feedbackSubject;
    NSString *feedBackBody;
    
}

- (IBAction)feedbackMenu:(id)sender;

@property (nonatomic, retain) IBOutlet UITableView *moreTableView;

@property (nonatomic, retain) IBOutlet NSXMLParser * rssParser;

- (void)parseXMLFileAtURL:(NSString *)URL;
- (IBAction)actionEmailComposer;



@end
