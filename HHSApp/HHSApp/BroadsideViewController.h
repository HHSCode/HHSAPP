//
//  BroadsideViewController.h
//  HHSApp
//
//  Created by Sudikoff Lab iMac on 3/19/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BroadsideCell.h"
#import "BroadsideDetailViewController.h"

@interface BroadsideViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate>{
    NSXMLParser *rssParser;
    NSMutableArray *articles;
    NSMutableDictionary *item;
    NSString *currentElement;
    NSMutableString *ElementValue;
    BOOL errorParsing;
    NSMutableArray * stories;
    
    NSMutableString * currentTitle, * currentAuthor, * currentSummary, * currentLink, *currentURL, *currentHTML, *currentDate;
}
@property (weak, nonatomic) IBOutlet UITableView *broadsideTableView;
@property (nonatomic, retain) IBOutlet NSXMLParser * rssParser;

- (void)parseXMLFileAtURL:(NSString *)URL;

@end
