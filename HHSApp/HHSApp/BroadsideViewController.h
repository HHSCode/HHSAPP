//
//  BroadsideViewController.h
//  HHSApp
//
//  Created by Connor Koehler on 3/19/13.
//  Copyright (c) 2013 Hanover High School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BroadsideCell.h"
#import "BroadsideDetailViewController.h"
#import "Reachability.h"

@interface BroadsideViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITableView *broadsideTableView;
@property (nonatomic, retain) IBOutlet NSXMLParser * rssParser;
- (void)parseXMLFileAtURL:(NSString *)URL;
- (IBAction)showActionsheetButton:(id)sender;
- (void)refreshView:(UIRefreshControl *)refresh;
- (void)refreshBroadside;


@end
