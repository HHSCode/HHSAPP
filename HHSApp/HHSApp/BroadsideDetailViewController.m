//
//  BroadsideDetailViewController.m
//  HHSApp
//
//  Created by Connor Koehler on 3/19/13.
//  Copyright (c) 2013 Hanover High School. All rights reserved.
//

#import "BroadsideDetailViewController.h"
#import "ActivityViewCustomProvider.h"
#import "ActivityViewCustomActivity.h"
#import "ActivityViewCustomActivityChrome.h"

@interface BroadsideDetailViewController ()

@property (nonatomic, strong) NSString *urlToShare;

@end

@implementation BroadsideDetailViewController

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
    [self.broadsideDetailWebView setDelegate:self];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *activityButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActivityView)];
    self.navigationItem.rightBarButtonItem = activityButton;
}

-(void)setWebView:(int)indexPath :(NSMutableArray *)stories{
    [self setTitle:[[stories objectAtIndex:indexPath]objectForKey:@"title"]];
    self.urlToShare = [[stories objectAtIndex:indexPath]objectForKey:@"link"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.urlToShare forKey:@"url"];
    //NSLog(@"%@", [[stories objectAtIndex:indexPath]objectForKey:@"link"]);
    //NSLog(@"%@", self.urlToShare);
    NSMutableString *htmlString = [[stories objectAtIndex:indexPath]objectForKey:@"HTML"];
    NSMutableString *date = [[NSMutableString alloc]initWithString:[[stories objectAtIndex:indexPath]objectForKey:@"date"]];

    NSArray *theArray = [[NSArray alloc]init];
    theArray = [date componentsSeparatedByString:@"+"];
    date = [theArray objectAtIndex:0];
    NSMutableString *start = [NSString stringWithFormat:@"<html><body><div id=\"container\" style=\"width:300px\"><center>by %@</center><center>%@</center>", [[stories objectAtIndex:indexPath]objectForKey:@"author"], date];
    
    NSString *end = @"</div></body></html>";
    NSString *temp = [start stringByAppendingString:htmlString];
    NSString *final = [temp stringByAppendingString:end];
    //NSLog(@"HTML: %@", final);
    
    [final rangeOfString:@"<a"];
    
    [self.broadsideDetailWebView loadHTMLString:final baseURL:nil];
}

- (NSString *)getURL{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.urlToShare = [defaults valueForKey:@"url"];
    return self.urlToShare;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showActivityView
{
    //ActivityViewCustomProvider *customProvider = [[ActivityViewCustomProvider alloc]init];
    ActivityViewCustomActivity *ca = [[ActivityViewCustomActivity alloc]init];
    ActivityViewCustomActivityChrome *ca2 = [[ActivityViewCustomActivityChrome alloc]init];
    NSString *textToShare = @"Check out this HHS Broadside article!";
    UIImage *imageToShare = [UIImage imageNamed:@"icon_iphone.png"];
    NSArray *activityItems = [[NSArray alloc]initWithObjects:textToShare, imageToShare, self.urlToShare, nil];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:[NSArray arrayWithObjects:ca,ca2,nil]];
    activityVC.excludedActivityTypes = [[NSArray alloc]initWithObjects:UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll, nil];
    [self presentViewController:activityVC animated:TRUE completion:^{}];
}



@end
