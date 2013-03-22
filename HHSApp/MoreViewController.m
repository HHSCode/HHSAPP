//
//  MoreViewController.m
//  HHSApp
//
//  Created by Sudikoff Lab iMac on 3/21/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

@synthesize moreTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    cellNames = [[NSArray alloc] initWithObjects:@"Handbook", @"Program of Studies", @"Council", @"SAU 70", @"Guidance", @"Yearbook", @"March Intensive", @"Media Center",@"Athletics",@"Snow Day", nil];
    moreTableView.delegate = self;
    moreTableView.dataSource = self;
    
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    // set the blocks
    NSLog(@"Ran");
    reach.reachableBlock = ^(Reachability*reach)
    {
        NSLog(@"Reachable");
        stories = [[NSMutableDictionary alloc] init];
        [moreTableView reloadData];
        [self performSelectorInBackground:@selector(parseXMLFileAtURL:) withObject:@"http://www.lordtechyproductions.com/hhsapp/moreTab.php"];
        act = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(12.0, 85, 260.0, 25.0)];
        
        
       
         wait = [[UIAlertView alloc]
                        initWithTitle:@"Loading..."
                        message:@"Please wait"
                        delegate:self
                        cancelButtonTitle:nil
                        otherButtonTitles:nil];
            [wait addSubview:act];
        [act startAnimating];
        [wait performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];


    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"UNREACHABLE!");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"No internet connection! Expect errors when loading documents." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        
    };
    [reach startNotifier];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Parser

- (void)parseXMLFileAtURL:(NSString *)URL {
    
    stories = [[NSMutableDictionary alloc] init];
    
	//you must then convert the path to a proper NSURL or it won't work
	NSURL *xmlURL = [NSURL URLWithString:URL];
    
	// here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
	// this may be necessary only for the toolchain
	rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
	// Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	[rssParser setDelegate:self];
    
	// Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
	[rssParser setShouldProcessNamespaces:NO];
    
	[rssParser setShouldReportNamespacePrefixes:NO];
    
	[rssParser setShouldResolveExternalEntities:NO];
    
    
	[rssParser parse];
    
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	// (@"found file and started parsing");
    item = [[NSMutableDictionary alloc] init];

}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i ). Please try again later.", [parseError code]];
	//NSLog(@"error parsing XML: %@", errorString);
    
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	currentElement = [elementName copy];
    //NSLog(@"Current Element: %@", currentElement);
	if ([elementName isEqualToString:@"name"]) {
		currentLink = [[NSMutableString alloc] init];
		currentName = [[NSMutableString alloc] init];

        
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
	//NSLog(@"ended element: %@", elementName);
    
	if ([elementName isEqualToString:@"link"]) { //change this back to id
		// save values to an item, then store that item into the array...
        //NSLog(@"item: %@", item);
        NSString *string = [currentName substringToIndex:[currentName length]-1];
        
        [item setObject:currentLink forKey:string];
    
		stories = item;
    }
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    //NSLog(@"%@: %@", currentElement, string);
    if ([currentElement isEqualToString:@"name"]){
        [currentName appendString:string];
    }else if ([currentElement isEqualToString:@"link"]) {
		[currentLink appendString:string];
    }
	// save the characters for the current item...
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
    
    NSLog(@"Stories: %@", stories);
    
    [wait dismissWithClickedButtonIndex:0 animated:YES];

    [act stopAnimating];
    
}
//Email Method

- (IBAction)actionEmailComposer{
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@"Here's Some Feedback On Your App"];
         [mailViewController setMessageBody:@"I have some feedback for you" isHTML:NO];
          
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
//TABLEVIEW

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"Updating table view, stories count: %i", [stories count]);
    
    return [cellNames count];

    
    
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        static NSString *CellIdentifer = @"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
        
        // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
        }
        
        
        cell.textLabel.text = [cellNames objectAtIndex:[indexPath row]];
        
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
    MoreDetailViewController *detail = [[MoreDetailViewController alloc]initWithNibName:@"MoreDetailViewController" bundle:nil];
    detail.title = [cellNames objectAtIndex:[indexPath row]];
    NSLog(@"%@", [cellNames objectAtIndex:[indexPath row]]);
    NSLog(@"%@", [stories objectForKey:[cellNames objectAtIndex:[indexPath row]]]);
    [self.navigationController pushViewController:detail animated:YES];
    [detail loadWebPageWithTitle:[cellNames objectAtIndex:[indexPath row]] atURL:[NSURL URLWithString:[stories objectForKey:[cellNames objectAtIndex:[indexPath row]]]]];

    //[detail setWebView:[indexPath row] :stories];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    
    // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


- (IBAction)feedbackMenu:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Report A Bug",@"Report Incorrect Information", @"Feedback", nil];
    [actionSheet showInView:self.moreTableView];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self actionEmailComposer]; 
    }
    
    if(buttonIndex == 1)
    {
        NSURL *url = [ [ NSURL alloc ] initWithString: @"http://broadside.dresden.us/" ];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    if(buttonIndex == 2)
    {
        NSURL *url = [ [ NSURL alloc ] initWithString: @"googlechrome://broadside.dresden.us/" ];
        [[UIApplication sharedApplication] openURL:url];
        
    }
}


@end
