//
//  SchoolInformationViewController.m
//  HHSApp
//
//  Created by Max Greenwald on 7/18/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import "SchoolInformationViewController.h"

@interface SchoolInformationViewController ()

@end

@implementation SchoolInformationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)callSchool:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:6036433431"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
