//
//  MoreViewController.m
//  HHSApp
//
//  Created by Connor Koehler on 3/19/13.
//  Copyright (c) 2013 Hanover High School. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@property (strong, nonatomic) NSArray *cellNames;

@property (strong, nonatomic) NSMutableArray *articles;
@property (strong, nonatomic) NSMutableDictionary *item;
@property (strong, nonatomic) NSString *currentElement;
@property (strong, nonatomic) NSMutableString *ElementValue;
@property (nonatomic) BOOL errorParsing;
@property (strong, nonatomic) NSMutableDictionary * stories;

@property (strong, nonatomic) NSMutableString * currentName, *currentLink;
@property (strong, nonatomic) UIActivityIndicatorView *act;
@property (strong, nonatomic) UIAlertView *wait;
@property (nonatomic) int numberOfLocalPages;


//Mail stuff
@property (strong, nonatomic) NSArray *feedBackEmail;
@property (strong, nonatomic) NSString *bugReportSubject;
@property (strong, nonatomic) NSString *bugReportBody;
@property (strong, nonatomic) NSString *incorrectInformaationSubject;
@property (strong, nonatomic) NSString *incorrectInformationBody;
@property (strong, nonatomic) NSString *feedbackSubject;
@property (strong, nonatomic) NSString *feedBackBody;

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}



- (void)viewDidLoad 
{
    NSLog(@"Got here");
    [super viewDidLoad];
    self.cellNames = [[NSArray alloc] initWithObjects:@"Handbook", @"Program of Studies", @"Power School", @"Council", @"SAU 70", @"Guidance", @"Yearbook", @"March Intensive", @"Media Center",@"Athletics",@"Snow Day", nil];
    self.moreTableView.delegate = self;
    self.moreTableView.dataSource = self;
    
    self.feedBackEmail = [[NSArray alloc] initWithObjects:@"conrad.koehler@hanovernorwichschools.org", nil];
    self.bugReportSubject = @"Bug report on Hanover High Application";
    self.bugReportBody = @"Please provide a detailed description of the bug including all steps to trigger it";
    self.incorrectInformaationSubject = @"Incorrect Information On Hanover High Application";
    self.incorrectInformationBody = @"Please provide all information that is incorrect as well as the correct information with which to replace it with";
    self.feedbackSubject = @"Feedback on the Hanover High Application";
    self.feedBackBody = @"Feedback on the Hanover High Application";
    self.numberOfLocalPages = 0;
    

    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    // set the blocks
    NSLog(@"Ran");
    reach.reachableBlock = ^(Reachability*reach)
    {
        NSLog(@"Reachable");

        self.stories = [[NSMutableDictionary alloc] init];
        [self.moreTableView reloadData];
        [self performSelectorInBackground:@selector(parseXMLFileAtURL:) withObject:@"http://www.app.dresden.us/moreTab.php"];
        
        //[self.wait performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];


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
    
    self.stories = [[NSMutableDictionary alloc] init];
    
	//you must then convert the path to a proper NSURL or it won't work
	NSURL *xmlURL = [NSURL URLWithString:URL];
    
	// here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
	// this may be necessary only for the toolchain
	self.rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
	// Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	[self.rssParser setDelegate:self];
    
	// Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
	[self.rssParser setShouldProcessNamespaces:NO];
    
	[self.rssParser setShouldReportNamespacePrefixes:NO];
    
	[self.rssParser setShouldResolveExternalEntities:NO];
    
    
	[self.rssParser parse];
    
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	// (@"found file and started parsing");
    self.item = [[NSMutableDictionary alloc] init];

}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i ). Please try again later.", [parseError code]];
	//NSLog(@"error parsing XML: %@", errorString);
    
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	self.currentElement = [elementName copy];
    //NSLog(@"Current Element: %@", currentElement);
	if ([elementName isEqualToString:@"name"]) {
		self.currentLink = [[NSMutableString alloc] init];
		self.currentName = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
	//NSLog(@"ended element: %@", elementName);
    
	if ([elementName isEqualToString:@"link"]) { //change this back to id
		// save values to an item, then store that item into the array...
        //NSLog(@"item: %@", item);
        NSString *string = [self.currentName substringToIndex:[self.currentName length]-1];
        
        [self.item setObject:self.currentLink forKey:string];
    
		self.stories = self.item;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    NSLog(@"%@: %@", self.currentElement, string);
    if ([self.currentElement isEqualToString:@"name"]){
        [self.currentName appendString:string];
    }else if ([self.currentElement isEqualToString:@"link"]) {
		[self.currentLink appendString:string];
        NSLog(@"appended");
    }
	// save the characters for the current item...
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [self.stories count]);
    
    NSLog(@"Stories: %@", self.stories);
    
    
    [self.moreTableView reloadData];
}
//Email Methods
#pragma mark - Email

- (IBAction)actionEmailComposer:(NSString *)type withBody:(NSString *)body{
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:[NSString stringWithFormat:@"%@", type]];
        [mailViewController setToRecipients:self.feedBackEmail];
        [mailViewController setMessageBody:[NSString stringWithFormat:@"%@",body] isHTML:NO];
        
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
#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"Updating table view, stories count: %i", [stories count]);
    
    return [self.cellNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        static NSString *CellIdentifer = @"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
        
        // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
        }
        
        if (indexPath.row>[tableView numberOfRowsInSection:indexPath.section]-(self.numberOfLocalPages+1)) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.accessoryView = nil;
            //NSLog(@"Local Page");
        }else{
        
        if ([self.stories count]==0) {
            UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            act.frame = CGRectMake(0, 0, 24, 24);
            //act.center = cell.accessoryView.center;
            [act startAnimating];
            cell.accessoryView = act;
            cell.accessoryType=UITableViewCellAccessoryNone;

        }else{
            cell.accessoryView = nil;
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        
        }
            
        }
        cell.textLabel.text = [self.cellNames objectAtIndex:[indexPath row]];
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
    if (indexPath.row>[tableView numberOfRowsInSection:indexPath.section]-(self.numberOfLocalPages+1)) {
        
    }else{
    if ([self.stories count]==0) {
        
    }else{
    MoreDetailViewController *detail = [[MoreDetailViewController alloc]initWithNibName:@"MoreDetailViewController" bundle:nil];
    detail.title = [self.cellNames objectAtIndex:[indexPath row]];
    
    [self.navigationController pushViewController:detail animated:YES];
    [detail loadWebPageWithTitle:[self.cellNames objectAtIndex:[indexPath row]] atURL:[NSURL URLWithString:[self.stories objectForKey:[self.cellNames objectAtIndex:[indexPath row]]]]];
    }
    //[detail setWebView:[indexPath row] :stories];
   
    
    // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


- (IBAction)feedbackMenu:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Report A Bug",@"Report Incorrect Information", @"Feedback", nil];
    [actionSheet showInView:self.moreTableView];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self actionEmailComposer:self.bugReportSubject withBody:self.bugReportBody];
    }
    
    if(buttonIndex == 1)
    {
        [self actionEmailComposer:self.incorrectInformaationSubject withBody:self.incorrectInformationBody];
    }
    
    if(buttonIndex == 2)
    {
        [self actionEmailComposer:self.feedbackSubject withBody:self.feedBackBody];
        
    }
}


@end
