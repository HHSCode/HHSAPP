//
//  BroadsideDetailViewController.m
//  HHSApp
//
//  Created by Sudikoff Lab iMac on 3/19/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import "BroadsideDetailViewController.h"
#import "ActivityViewCustomProvider.h"
#import "ActivityViewCustomActivity.h"

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
    urlToShare = [[stories objectAtIndex:indexPath]objectForKey:@"link"];
    NSLog(@"%@", [[stories objectAtIndex:indexPath]objectForKey:@"link"]);
    NSLog(@"%@", urlToShare);
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

- (NSString *)getURL{
    NSString *getURLString = [[NSString alloc] initWithString:urlToShare];
    NSLog(@"%@", getURLString);
    return getURLString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showActivityView
{
    ActivityViewCustomProvider *customProvider =
    [[ActivityViewCustomProvider alloc]init];
    ActivityViewCustomActivity *ca = [[ActivityViewCustomActivity alloc]init];
    NSString *textToShare = @"Check out this HHS Broadside article!";
    UIImage *imageToShare = [UIImage imageNamed:@"icon_iphone.png"];
    NSArray *activityItems = [[NSArray alloc]initWithObjects:textToShare, imageToShare, urlToShare, nil];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:[NSArray arrayWithObject:ca]];
    activityVC.excludedActivityTypes = [[NSArray alloc]initWithObjects:UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, nil];
    [self presentViewController:activityVC animated:TRUE completion:^{}];
}



@end
