//
//  BroadsideDetailViewController.h
//  HHSApp
//
//  Created by Connor Koehler on 3/19/13.
//  Copyright (c) 2013 Hanover High School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BroadsideDetailViewController : UIViewController <UIWebViewDelegate>{
    NSMutableArray *story;
    int index;
}

@property (retain, nonatomic) IBOutlet UIWebView *broadsideDetailWebView;
@property (nonatomic, retain) IBOutlet UITextView *theTextView;

- (void)setWebView:(int)indexPath :(NSMutableArray *)stories;
- (IBAction)showActivityView;
- (NSString *)getURL;

@end
