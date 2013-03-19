//
//  BroadsideCell.h
//  HHSApp
//
//  Created by Sudikoff Lab iMac on 3/19/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BroadsideCell : UITableViewCell{
    
    UILabel *title;
    UILabel *date;
    UILabel *author;
    NSString *html;
}

@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UILabel *date;
@property (nonatomic, retain) IBOutlet UILabel *author;

@end
