//
//  StaffViewCell.h
//  HHSApp
//
//  Created by Ben Chaimberg on 3/22/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaffViewCell : UITableViewCell{
    
    UILabel *topLabel;
    UILabel *bottomLabel;
    UILabel *noTitleLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *topLabel;
@property (nonatomic, retain) IBOutlet UILabel *bottomLabel;
@property (nonatomic, retain) IBOutlet UILabel *noTitleLabel;


@end
