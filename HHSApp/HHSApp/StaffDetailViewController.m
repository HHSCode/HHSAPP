//
//  StaffDetailViewController.m
//  HHSApp
//
//  Created by Max Greenwald on 3/21/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import "StaffDetailViewController.h"

@interface StaffDetailViewController ()

@end

@implementation StaffDetailViewController

@synthesize staffDetailTableView;

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
	// Do any additional setup after loading the view.
    [staffDetailTableView setDelegate:self];
    [staffDetailTableView setDataSource:self];
}

-(void)setTableViewObjects:(NSDictionary *)dict :(NSIndexPath *)index :(NSArray *)sortedDepartments{

    theDictionary = dict;
    indexP = index;
    NSString *dep = [sortedDepartments objectAtIndex:index.section];
    NSDictionary *names = [dict objectForKey:dep];
    NSArray *list = [names allKeys];
    NSArray *sortedList = [list sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    firstName = [[names objectForKey:[sortedList objectAtIndex:[index row]]]objectForKey:@"first"];
    lastName = [[names objectForKey:[sortedList objectAtIndex:[index row]]]objectForKey:@"last"];
    phone = [[names objectForKey:[sortedList objectAtIndex:[index row]]]objectForKey:@"phone"];
    department = [[names objectForKey:[sortedList objectAtIndex:[index row]]]objectForKey:@"dept"];
    email = [[names objectForKey:[sortedList objectAtIndex:[index row]]]objectForKey:@"email"];
    title = [[names objectForKey:[sortedList objectAtIndex:[index row]]]objectForKey:@"title"];
    url = [[names objectForKey:[sortedList objectAtIndex:[index row]]]objectForKey:@"site"];
    phoneOrig = phone;
    phone = [NSString stringWithFormat:@"1 (603) 643-3431 ext. %@", phone];
    [staffDetailTableView reloadData];
}

// EMAIL

- (IBAction)actionEmailComposer{
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@"Email to Staff"];
        NSArray *array = [[NSArray alloc]initWithObjects:email, nil];
        [mailViewController setToRecipients:array];
        [mailViewController setMessageBody:@"" isHTML:NO];
        
        [self presentModalViewController:mailViewController animated:YES];
        
        
    }
    
    else {
        
        NSLog(@"Device is unable to send email in its current state.");
        
    }
    
}


- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    [self dismissModalViewControllerAnimated:YES];
    return;
}


// TABLEVIEW

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int cells = 5;
    if ([phoneOrig isEqualToString:@"-1"]) {
        cells -=1;
        
    }
    if ([url isEqualToString:@" "]) {
        cells -=1;
    }
    return 2;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        int cells = 4;
        if ([phoneOrig isEqualToString:@"-1"]) {
            cells -=1;
            
        }
        if ([url isEqualToString:@" "]) {
            cells -=1;
        }
        return cells;
        
    }
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifer = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifer];
    }
    
    if ([indexPath section]==0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@", firstName, lastName];
        cell.detailTextLabel.text = title;
    }else{
        
            
        if ([indexPath row]==0){
            cell.textLabel.text = department;
        }else if([indexPath row]==1){
            cell.textLabel.text = email;
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        }
        
        
        if ([phoneOrig isEqualToString:@"-1"]) {
            if ([url isEqualToString:@" "]) {
                //neither
            }else{
                if ([indexPath row]==2){
                    cell.textLabel.text = url;
                }
            }

        }else if ([url isEqualToString:@" "]) {
            if ([indexPath row]==2){
                cell.textLabel.text = phone;
            }
        }else{
            if ([indexPath row]==2){
                cell.textLabel.text = url;
            }else if ([indexPath row]==3){
                cell.textLabel.text = phone;
            }
        }

    
    }
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell = [tableView cellForRowAtIndexPath:indexPath];
   // NSLog(@"-%@-", cell.textLabel.text);
    if ([cell.textLabel.text isEqualToString:url]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        NSLog(@"opened");
    }else if ([cell.textLabel.text isEqualToString:email]){
        [self actionEmailComposer];
    }else if ([cell.textLabel.text isEqualToString:phone]){
        NSString *string = [[NSString alloc]initWithString:phone];
        string = [string stringByReplacingOccurrencesOfString:@"ext. " withString:@","];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", string]]];
        
    }

    // Navigation logic may go here. Create and push another view controller.
    /*
     *detailViewController = [[ alloc] initWithNibName:@"" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
