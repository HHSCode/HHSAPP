//
//  BroadsideDetailViewController.h
//  HHSApp
//
//  Created by Sudikoff Lab iMac on 3/19/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BroadsideDetailViewController : UIViewController{
    
}
@property (weak, nonatomic) IBOutlet UIWebView *broadsideDetailWebView;
-(void)setWebView:(int)indexPath :(NSMutableArray *)stories;

@end
