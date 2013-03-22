//
//  BroadsideDetailViewController.m
//  HHSApp
//
//  Created by Sudikoff Lab iMac on 3/19/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import "BroadsideDetailViewController.h"


@interface BroadsideDetailViewController ()

@end

@implementation BroadsideDetailViewController
@synthesize broadsideDetailWebView, theTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [broadsideDetailWebView setDelegate:self];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *activityButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActivityView)];
    self.navigationItem.rightBarButtonItem = activityButton;
}

-(void)setWebView:(int)indexPath :(NSMutableArray *)stories{
    [self setTitle:[[stories objectAtIndex:indexPath]objectForKey:@"title"]];
    url = [[stories objectAtIndex:indexPath]objectForKey:@"link"];
    //NSLog(@"%@", [[stories objectAtIndex:indexPath]objectForKey:@"HTML"]);
    NSMutableString *htmlString = [[stories objectAtIndex:indexPath]objectForKey:@"HTML"];
    NSMutableString *date = [[NSMutableString alloc]initWithString:[[stories objectAtIndex:indexPath]objectForKey:@"date"]];

    NSArray *theArray = [[NSArray alloc]init];
    theArray = [date componentsSeparatedByString:@"+"];
    date = [theArray objectAtIndex:0];
    NSMutableString *start = [NSString stringWithFormat:@"<html><body><center>by %@</center><center>%@</center>", [[stories objectAtIndex:indexPath]objectForKey:@"author"], date];
    
    NSString *end = @"</body></html>";
    NSString *temp = [start stringByAppendingString:htmlString];
    NSString *final = [temp stringByAppendingString:end];
    NSLog(@"HTML: %@", final);
    
    [final rangeOfString:@"<a"];
    
    [broadsideDetailWebView loadHTMLString:final baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showActivityView
{
    NSLog(@"1");    
    NSString *textToShare = @"Check out this HHS Broadside article!";
    NSLog(@"2");
    UIImage *imageToShare = [UIImage imageNamed:@"icon_iphone.png"];
    NSLog(@"3");
    NSURL *urlToShare = [NSURL URLWithString:url];
    NSLog(@"4");
    NSLog(@"%@", url);
    NSArray *activityItems = [[NSArray alloc]initWithObjects:textToShare, imageToShare, urlToShare, nil];
    NSLog(@"5");
    NSArray *applicationItems = [[NSArray alloc] initWithObjects:nil];
    NSLog(@"6");
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:applicationItems];
    NSLog(@"7");
    activityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    NSLog(@"8");
    //This is an array of excluded activities to appear on the UIActivityViewController
    NSLog(@"9");
    [self presentViewController:activityVC animated:TRUE completion:^{}];
    NSLog(@"10");
}



@end
