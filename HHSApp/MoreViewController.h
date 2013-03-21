//
//  MoreViewController.h
//  HHSApp
//
//  Created by Sudikoff Lab iMac on 3/21/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    UITableView *moreTableView;
}


@property (nonatomic, retain) IBOutlet UITableView *moreTableView;
@end
