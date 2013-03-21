//
//  BroadsideDetailViewController.h
//  HHSApp
//
//  Created by Sudikoff Lab iMac on 3/19/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BroadsideDetailViewController : UIViewController <UIWebViewDelegate>{
    UIWebView *broadsideDetailWebView;
    UITextView *theTextView;
}
@property (retain, nonatomic) IBOutlet UIWebView *broadsideDetailWebView;
@property (nonatomic, retain) IBOutlet UITextView *theTextView;


-(void)setWebView:(int)indexPath :(NSMutableArray *)stories;

@end
