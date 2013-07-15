//
//  MoreDetailViewController.h
//  HHSApp
//
//  Created by James Owens on 3/21/13.
//  Copyright (c) 2013 Hanover High School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"




@interface MoreDetailViewController : UIViewController<UIWebViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *moreDetailWebView;
@property (nonatomic, strong) IBOutlet UIButton *button;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *act;


-(void)loadWebPageWithTitle:(NSString *)title atURL:(NSURL *)url;

- (IBAction)goBack:(id)sender;

@end
