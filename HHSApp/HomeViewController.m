//
//  HomeViewController.m
//  HHSApp
//
//  Created by Connor Koehler on 3/17/13.
//  Copyright (c) 2013 Hanover High School. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@property (strong, nonatomic) NSMutableArray *articles;
@property (strong, nonatomic) NSMutableDictionary *item;
@property (strong, nonatomic) NSString *currentElement;
@property (strong, nonatomic) NSString *ElementValue;
@property (nonatomic) BOOL errorParsing;
@property (strong, nonatomic) NSMutableArray *stories;
@property (strong, nonatomic) NSMutableString * currentTitle, * currentAuthor, * currentSummary, * currentLink, *currentURL, *currentHTML, *currentDate;
@property (nonatomic) BOOL urlLoaded;

@end

@implementation HomeViewController

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
    self.slideshowImageView.contentMode = UIViewContentModeScaleAspectFit;

    [self.slideshowImageView setImage:[UIImage imageNamed:@"photo.png"]];
    self.calendarWebView.scrollView.scrollEnabled = NO;
    self.calendarWebView.scrollView.bounces = NO;
    [self.calendarWebView setDelegate:self];
    
    [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbarHHS.png"]];

    [self startupInternetBasedParts];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachChanged)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
}

-(void)reachChanged{
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
                //NSLog(@"REACHABLE!");
        
        //Pulling in the images from the website for the Home slideshow
        if([self.stories count]==0){
            [self.activityIndicatorSlideshow startAnimating];
            [self.activityIndicatorSlideshow setHidesWhenStopped:YES];
            //[self performSelectorInBackground:@selector(parseXMLFileAtURL:) withObject:@"https://picasaweb.google.com/data/feed/base/user/108131704742682781762/albumid/5817737329195291185?alt=rss"];
            //[self performSelectorInBackground:@selector(parseXMLFileAtURL:) withObject:@"https://picasaweb.google.com/data/feed/base/user/113409722911087719840/albumid/5886905617252928865?alt=rss&kind=photo&hl=en_US"];
            
            HomeParser *parser = [[HomeParser alloc]init];
            NSMutableArray *theArray = [parser parse:@"http://app.dresden.us/home.php"];
            [self performSelectorInBackground:@selector(parseXMLFileAtURL:) withObject:[[theArray objectAtIndex:0]objectForKey:@"url"]];

        
        [self.activityIndicatorCalendar startAnimating];
        [self.activityIndicatorCalendar setHidesWhenStopped:YES];
        
        
        //Pulling in the Google Calander on the website for the Home tab
        //[self.calendarWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com/calendar/embed?showTitle=0&showNav=0&showDate=0&showPrint=0&showTabs=0&showCalendars=0&showTz=0&mode=AGENDA&height=185&wkst=1&bgcolor=%2393061C&src=nn2509143kmbl2jbhlofvah8fs%40group.calendar.google.com&color=%232F6309&src=vs8lb5l1ej2cukd1l0s26atv2c%40group.calendar.google.com&color=%23B1440E&src=680mj2kt8enp5minffopangeeg%40group.calendar.google.com&color=%23875509&src=4uripfc30h2e7htmr6cn38g8bo%40group.calendar.google.com&color=%23B1365F&src=ak55rjsbcjca1b6c4g1pl98a30%40group.calendar.google.com&color=%231B887A&src=v5u6pb9hmmk6vdmc5sd97r67sg%40group.calendar.google.com&color=%235F6B02&src=d4ohdnvm96jfqsrj9copecbiu8%40group.calendar.google.com&color=%23333333&src=1rank92tt12gjt2q0u3cbgemmc%40group.calendar.google.com&color=%236B3304&src=ggb1fhi1mr66bati1ct16kvc78%40group.calendar.google.com&color=%235229A3&src=en.usa%23holiday%40group.v.calendar.google.com&color=%232952A3&src=ubsv6hfmoe8n03oclu2r1a61hk%40group.calendar.google.com&color=%23182C57&ctz=America%2FNew_York"]]];
            
            [self.calendarWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[theArray objectAtIndex:1]objectForKey:@"url"]]]];

        
        
        // Do any additional setup after loading the view.
        
        }
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        //NSLog(@"UNREACHABLE!");
        [self.activityIndicatorCalendar setHidden:YES];
        [self.activityIndicatorSlideshow setHidden:YES];
    };

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (self.urlLoaded) {
        return NO;
    }else{
        return YES;
    }
   
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.urlLoaded = YES;
    [self.activityIndicatorCalendar stopAnimating];
    [self.activityIndicatorCalendar setHidden:YES];
}

-(void)startupInternetBasedParts{
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        //NSLog(@"REACHABLE!");
        [self.activityIndicatorCalendar startAnimating];
        [self.activityIndicatorCalendar setHidesWhenStopped:YES];
        NetworkStatus status = [reach currentReachabilityStatus];
        HomeParser *parser = [[HomeParser alloc]init];
        NSMutableArray *theArray = [parser parse:@"http://app.dresden.us/home.php"];
        //NSLog(@"The array: %@", theArray);
        if(status == NotReachable)
        {
            //No internet
        }
        else if (status == ReachableViaWiFi)
        {
            //WiFi
            NSLog(@"Wifi");
            if([self.stories count]==0){
                [self.activityIndicatorSlideshow startAnimating];
                [self.activityIndicatorSlideshow setHidesWhenStopped:YES];
                //[self performSelectorInBackground:@selector(parseXMLFileAtURL:) withObject:@"https://picasaweb.google.com/data/feed/base/user/108131704742682781762/albumid/5817737329195291185?alt=rss"];
                
                
                
                [self performSelectorInBackground:@selector(parseXMLFileAtURL:) withObject:[[theArray objectAtIndex:0]objectForKey:@"url"]];
                //[self performSelectorInBackground:@selector(parseXMLFileAtURL:) withObject:@"https://picasaweb.google.com/data/feed/base/user/113409722911087719840/albumid/5886905617252928865?alt=rss&kind=photo&hl=en_US"];
            }
        }
        else if (status == ReachableViaWWAN)
        {
            //3G
            NSLog(@"3G");

            
            
            
        }

        
        
        [self.calendarWebView setDelegate:self];
        
        [self.calendarWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[theArray objectAtIndex:1]objectForKey:@"url"]]]]; //change back to 1
        
        //[self.calendarWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com/calendar/embed?showTitle=0&showNav=0&showDate=0&showPrint=0&showTabs=0&showCalendars=0&showTz=0&mode=AGENDA&height=185&wkst=1&bgcolor=%2393061C&src=nn2509143kmbl2jbhlofvah8fs%40group.calendar.google.com&color=%232F6309&src=vs8lb5l1ej2cukd1l0s26atv2c%40group.calendar.google.com&color=%23B1440E&src=680mj2kt8enp5minffopangeeg%40group.calendar.google.com&color=%23875509&src=4uripfc30h2e7htmr6cn38g8bo%40group.calendar.google.com&color=%23B1365F&src=ak55rjsbcjca1b6c4g1pl98a30%40group.calendar.google.com&color=%231B887A&src=v5u6pb9hmmk6vdmc5sd97r67sg%40group.calendar.google.com&color=%235F6B02&src=d4ohdnvm96jfqsrj9copecbiu8%40group.calendar.google.com&color=%23333333&src=1rank92tt12gjt2q0u3cbgemmc%40group.calendar.google.com&color=%236B3304&src=ggb1fhi1mr66bati1ct16kvc78%40group.calendar.google.com&color=%235229A3&src=en.usa%23holiday%40group.v.calendar.google.com&color=%232952A3&src=ubsv6hfmoe8n03oclu2r1a61hk%40group.calendar.google.com&color=%23182C57&ctz=America%2FNew_York"]]];
        
        
                // Do any additional setup after loading the view.
        
        
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        //NSLog(@"UNREACHABLE!");
        [self.activityIndicatorCalendar setHidden:YES];
        [self.activityIndicatorSlideshow setHidden:YES];
    };
    
    // start the notifier which will cause the reachability object to retain itself!
    [reach startNotifier];
}


-(void)setupImageView{
    NSMutableArray *theArray = [[NSMutableArray alloc]init];
    UIImage *theImage = [UIImage imageNamed:@"photo.png"];
    [theArray insertObject:theImage atIndex:[theArray count]];
    for (NSMutableDictionary *dic in self.stories) {
        //NSLog(@"Link: %@", [dic objectForKey:@"link"]);
        if ([[dic objectForKey:@"link"] isEqualToString:@""]) {
            
        }else{
            //NSLog(@"Link: %@", [dic objectForKey:@"link"]);
            
            UIImage *image = [self getImageFromURL:[NSString stringWithFormat:@"%@#@2x.png", [dic objectForKey:@"link"]]];
            [theArray insertObject:image atIndex:[theArray count]];
        }
        //if ([dic objectForKey:@"link"] != nil) {
        //    UIImage *image = [self getImageFromURL:[dic objectForKey:@"link"]];
        ///    [theArray insertObject:image atIndex:[theArray count]];
        //}
        [self.activityIndicatorSlideshow stopAnimating];
    }
    self.slideshowImageView.animationImages = theArray;
    self.slideshowImageView.animationDuration = 50;
    self.slideshowImageView.animationRepeatCount = 0;
    
    [self.slideshowImageView startAnimating];
}

-(UIImage *)getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    //NSLog(@"Done");
    return result;
}


// PARSE PHOTOS




-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

//PARSING AREA//
//the following line of code makes the parsing area easier to find in the menu above
#pragma mark - PARSING AREA

- (void)parseXMLFileAtURL:(NSString *)URL {
    
    self.stories = [[NSMutableArray alloc] init];
    
	//you must then convert the path to a proper NSURL or it won't work
	NSURL *xmlURL = [NSURL URLWithString:URL];
    
	// here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
	// this may be necessary only for the toolchain
	self.rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
	// Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	[self.rssParser setDelegate:self];
    
	// Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
	[self.rssParser setShouldProcessNamespaces:YES];
    
	[self.rssParser setShouldReportNamespacePrefixes:YES];
    
	[self.rssParser setShouldResolveExternalEntities:YES];
    
    
	[self.rssParser parse];
    
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	// (@"found file and started parsing");
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
	if ([elementName isEqualToString:@"title"]) {
		self.item = [[NSMutableDictionary alloc] init];
		self.currentTitle = [[NSMutableString alloc] init];
		self.currentAuthor = [[NSMutableString alloc] init];
		self.currentSummary = [[NSMutableString alloc] init];
		self.currentLink = [[NSMutableString alloc] init];
        self.currentURL = [[NSMutableString alloc]init];
        self.currentHTML = [[NSMutableString alloc]init];
        self.currentDate = [[NSMutableString alloc]init];
        
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
	//NSLog(@"ended element: %@", elementName);
    
	if ([elementName isEqualToString:@"title"]) { //change this back to id
		// save values to an item, then store that item into the array...
        //NSLog(@"item: %@", item);
        [self.item setObject:self.currentTitle forKey:@"title"];
		[self.item setObject:self.currentLink forKey:@"link"];
		[self.item setObject:self.currentAuthor forKey:@"author"];
        [self.item setObject:self.currentHTML forKey:@"HTML"];
        [self.item setObject:self.currentDate forKey:@"date"];
        
        
		[self.stories addObject:[self.item copy]];
    }
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    //NSLog(@"%@: %@", self.currentElement, string);
    if ([self.currentElement isEqualToString:@"link"]){
        //[currentLink appendString:string];
    }else if ([self.currentElement isEqualToString:@"title"]) {
		[self.currentTitle appendString:string];
    }else if ([self.currentElement isEqualToString:@"credit"]) {
		[self.currentAuthor appendString:string];
    }else if ([self.currentElement isEqualToString:@"content:encoded"]){
        [self.currentHTML appendString:string];
    }else if ([self.currentElement isEqualToString:@"pubDate"]){
        [self.currentDate appendString:string];
    }else if ([self.currentElement isEqualToString:@"description"]){
        if ([string length]>3) {
            
            NSString *checkImg = [string substringToIndex:3];
        if ([checkImg isEqualToString:@"img"]) {
            NSArray *url = [string componentsSeparatedByString:@"\""];
            //NSLog(@"%@", url);
            for (NSString *x in url) {
                if ([x length]>6){
                    
                    NSString *theURL = [x substringToIndex:5];
                    if ([theURL isEqualToString:@"https"]) {
                        //NSLog(@"Got here");
                        [self.currentLink appendString:x];
                    }
                }
            }
        }
        }
    }
	// save the characters for the current item...
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
	//NSLog(@"all done!");
	//NSLog(@"stories array has %d items", [stories count]);
    
    //NSLog(@"Stories: %@", self.stories);
    [self setupImageView];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
