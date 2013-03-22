//
//  MoreDetailViewController.h
//  HHSApp
//
//  Created by James Owens on 3/21/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface MoreDetailViewController : UIViewController{

}

@property (nonatomic, retain) IBOutlet UIWebView *moreDetailWebView;

-(void)loadWebPageWithTitle:(NSString *)title atURL:(NSURL *)url;

- (IBAction)goBack:(id)sender;

@end
