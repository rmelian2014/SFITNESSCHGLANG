//
//  Classes.m
//  SFITNESS
//
//  Created by BRO on 24/01/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "Classes.h"
#import "AppDelegate.h"
#import "ClassesDet.h"

@interface Classes(){
    AppDelegate *appDelegate;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *sDtDate;
    NSString *latitude, *longitude, *state, *country;
    NSString *sMemCode, *sLanguage;
}
@end

//--- customizeable button attributes
CGFloat X_BUFFER = 0.0; //--- the number of pixels on either side of the segment
CGFloat Y_BUFFER = 0.0; //--- number of pixels on top of the segment
CGFloat HEIGHT = 65.0; //--- height of the segment

CGFloat numControllers = 7.0;


//CGFloat Y_POS_BTN = 40.0;
CGFloat HEIGHT_BTN = 55.0; //--- 10 pixels from the navigation view

CGFloat HEIGHT_LABEL = 30.0;
CGFloat HEIGHT_LABEL2 = 15.0;

//--- customizeable selector bar attributes (the black bar under the buttons)
CGFloat SELECTOR_Y_BUFFER = 0.0; //--- the y-value of the bar that shows what page you are on (0 is the top)
CGFloat SELECTOR_HEIGHT = 44.0; //--- thickness of the selector bar

CGFloat X_OFFSET = 8.0; //--- for some reason there's a little bit of a glitchy offset.  I'm going to look for a better workaround in the future

@implementation Classes

@synthesize locationManager;
@synthesize webView;
@synthesize selectionBar;
@synthesize dtDate;
@synthesize navigationView;
@synthesize sURL;
@synthesize sURLFromSearch;
@synthesize sCordinatesFromSearch;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //=== Call the stored txtMemCode and txtLang, something like session
    //sLanguage = [defaults objectForKey:@"txtLanguage"];
    
    //if([sLanguage isEqualToString:@"CN"]){
      //  self.navigationController.tabBarItem.title = @"课程";
        
    
   // }
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated]; //=== Will only Call the View Once
    
    //=== Hide the Top Navigation Controller Bar at the current View
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    dtDate = [[NSMutableArray alloc] init]; //=== Mutable array to store the dates generated
    
    self.currentPageIndex = 0; //=== Set the Top Segmented buttons to the 1st one.
    
    [self setupSegmentButtons]; //=== Call the method to setup the Top Segmented buttons
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"]; //=== set the Format
    sDtDate = [dateFormatter stringFromDate:now]; //== Get today's date
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //=== Call the stored txtMemCode and txtLang, something like session
    sMemCode = [defaults objectForKey:@"txtMemCode"];
    sLanguage = [defaults objectForKey:@"txtLanguage"];
    //=== Check if the view is being push by Search VC ===
    sURLFromSearch = [defaults objectForKey:@"txtURLFromSearch"];
    
    //NSLog(@"Is it from SearchVC=====%@******",sURLFromSearch);

    [self LoadClasses]; //=== Load all the Classes
}

//=== Top Navigation Controller reappear on the next VC
-(void)viewDidDisappear:(BOOL)animated{
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
   
}

-(void)setupSegmentButtons
{
    CGFloat Y_POS_BTN = [[UIApplication sharedApplication] statusBarFrame].size.height+5;
    
    //=== The view where the buttons sits
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(X_BUFFER,Y_POS_BTN,self.view.frame.size.width,HEIGHT_BTN)];
    navigationView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:navigationView]; //=== Create a View called navigationView
    
    //==== Setup the shadows
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.navigationView.bounds];
    self.navigationView.layer.masksToBounds = NO;
    self.navigationView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.navigationView.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    self.navigationView.layer.shadowOpacity = 0.8f;
    self.navigationView.layer.shadowPath = shadowPath.CGPath;

    //=== Get the dates and formatting of the dates
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *beginningOfThisWeek;
    NSTimeInterval durationOfWeek;
    
    [calendar rangeOfUnit:NSWeekCalendarUnit
                startDate:&beginningOfThisWeek
                 interval:&durationOfWeek
                  forDate:now];
    
    NSDateComponents *comps = [calendar components:NSUIntegerMax fromDate:now];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    NSDateFormatter *datelblFormat = [[NSDateFormatter alloc] init];
    [datelblFormat setDateFormat:@"dd"];
    NSDateFormatter *daylblFormat= [[NSDateFormatter alloc] init];
    [daylblFormat setDateFormat:@"EEE"];
    
    //=== Loop 7 times to create the Buttons and the 2 lines Labels
    for (int i = 0; i<numControllers; i++) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*(self.navigationView.frame.size.width/numControllers), Y_BUFFER, (self.navigationView.frame.size.width/numControllers),HEIGHT_BTN)];

        [navigationView addSubview:button]; //=== Put the buttons into the navigation View
        
        NSString *dateString = [dateFormatter stringFromDate:[calendar dateFromComponents:comps]];
        [dtDate addObject:dateString];
        
        NSString *lblDate = [datelblFormat stringFromDate:[calendar dateFromComponents:comps]];
        
        UILabel *firstLineButton = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width/numControllers,HEIGHT_LABEL)];
        
        firstLineButton.text = lblDate;
        firstLineButton.font = [UIFont systemFontOfSize:18];
        firstLineButton.textAlignment=NSTextAlignmentCenter;
        [button addSubview:firstLineButton]; //=== Put the Date in the 1st line of the the button
        
        NSString *lblDay = [daylblFormat stringFromDate:[calendar dateFromComponents:comps]];
        
        UILabel *secondLineButton = [[UILabel alloc] initWithFrame:CGRectMake(0,30,self.view.frame.size.width/numControllers,HEIGHT_LABEL2)];
        secondLineButton.text = lblDay;
        secondLineButton.font = [UIFont boldSystemFontOfSize:11];
        secondLineButton.textAlignment=NSTextAlignmentCenter;
        [button addSubview:secondLineButton]; //=== Put the Day in the 2nd line of the Button
        
        button.tag = i; //--- IMPORTANT: if you make your own custom buttons, you have to tag them appropriately
        
        button.backgroundColor = [UIColor whiteColor];//%%% buttoncolors
        
        [button addTarget:self action:@selector(tapSegmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        ++comps.day;
    }
    
    //NSLog(@" The array %@", dtDate);
    
    [self setupSelector]; //=== The selection bar or highligthed area
}

//=== sets up the selection bar under the buttons or the highligted buttons on the navigation bar
-(void)setupSelector {
    
    //CGFloat Y_POS_BTN = [[UIApplication sharedApplication] statusBarFrame].size.height+5;
    selectionBar = [[UIView alloc]initWithFrame:CGRectMake(0, Y_BUFFER, (self.view.frame.size.width/numControllers),HEIGHT_BTN)];
    selectionBar.backgroundColor = [UIColor colorWithRed:189.0f/255.0f green:225.0f/255.0f blue:255.0f/255.0f alpha:0.6]; //%%% sbcolor
    //selectionBar.alpha = 0.8; //%%% sbalpha
    [navigationView addSubview:selectionBar];
    
}

//=== When the top button is tapped
#pragma mark Setup
 -(void)tapSegmentButtonAction:(UIButton *)button {
    
    sDtDate = dtDate[button.tag];
    
    [self LoadClasses];
    
    __weak typeof(self) weakSelf = self;
    [weakSelf updateCurrentPageIndex:button.tag];
    
    NSInteger xCoor = selectionBar.frame.size.width*self.currentPageIndex;
    
    selectionBar.frame = CGRectMake(xCoor, selectionBar.frame.origin.y, selectionBar.frame.size.width, selectionBar.frame.size.height);
}

//=== makes sure the nav bar is always aware of what date page you're at in reference to the array of view controllers you gave
-(void)updateCurrentPageIndex:(int)newIndex {
    self.currentPageIndex = newIndex;
}

- (void)LoadClasses {
    
    //=== Check if it is push from Search VC
    if ([sURLFromSearch length] != 0){
        
        NSString *sSeparator= @"&";
        //=== Check lat=from the string from Search, if got Latitude, meaning got Cordinates
        NSRange range = [sURLFromSearch rangeOfString:sSeparator];
        NSInteger position = range.location + range.length;
        sCordinatesFromSearch = [sURLFromSearch substringToIndex:position-1];
        
        sSeparator= @"=";
        range = [sCordinatesFromSearch rangeOfString:sSeparator];
        position = range.location + range.length;
        sCordinatesFromSearch = [sCordinatesFromSearch substringFromIndex:position];

    }
    
    NSLog(@"======sURLFromSearch====%@**********", sURLFromSearch);
    
    NSLog(@"======sCoordinatesFromSearch====%@*************", sCordinatesFromSearch);
    
    if ([sURLFromSearch length] != 0 && [sCordinatesFromSearch length] != 0 ) {
        
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        sURL = appDelegate.gURL;
        sURL = [sURL stringByAppendingString:@"/apps/class.asp?"];
        sURL = [sURL stringByAppendingString:sURLFromSearch];
        sURL = [sURL stringByAppendingString:@"&memCode="];
        sURL = [sURL stringByAppendingString:sMemCode];
        sURL = [sURL stringByAppendingString:@"&dtpClass="];
        sURL = [sURL stringByAppendingString:sDtDate];
        sURL = [sURL stringByAppendingString:@"&lang="];
        sURL = [sURL stringByAppendingString:sLanguage];
        
        NSLog(@"====From Search, Load Lat and Long from Search and the sURL on WebView : %@ ", sURL);
        
    } else if ([sURLFromSearch length] != 0 && [sCordinatesFromSearch length] == 0 ) {
        
        //=== Remove lat=&long= from sURLFromSearch
        NSString *sSeparator= @"&";
        NSString *sURLFromSearchWithLatLong = sURLFromSearch;
        
        NSRange range = [sURLFromSearchWithLatLong rangeOfString:sSeparator];
        NSInteger position = range.location + range.length;
        NSString *sWhatIsIt = [sURLFromSearchWithLatLong substringToIndex:position-1];
        NSString *sURLFromSearchWithLong = [sURLFromSearchWithLatLong substringFromIndex:position];
        
        range = [sURLFromSearchWithLong rangeOfString:sSeparator];
        position = range.location + range.length;
        sWhatIsIt = [sURLFromSearchWithLong substringToIndex:position-1];
        NSString *sURLFromSearchClean = [sURLFromSearchWithLong substringFromIndex:position];
        
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        latitude = appDelegate.slatitude;
        longitude = appDelegate.slongitude;
        //NSLog(@" The longitude : %@ ", longitude);
        
        sURL = appDelegate.gURL;
        sURL = [sURL stringByAppendingString:@"/apps/class.asp?"];
        sURL = [sURL stringByAppendingString:sURLFromSearchClean];
        //sURL = [sURL stringByAppendingString:@"&lat=0.3456"];
        //sURL = [sURL stringByAppendingString:@"&long=5.56677"];
        sURL = [sURL stringByAppendingString:@"&lang="];
        sURL = [sURL stringByAppendingString:sLanguage];
        sURL = [sURL stringByAppendingString:@"&lat="];
        sURL = [sURL stringByAppendingString:latitude];
        sURL = [sURL stringByAppendingString:@"&long="];
        sURL = [sURL stringByAppendingString:longitude];
        sURL = [sURL stringByAppendingString:@"&memCode="];
        sURL = [sURL stringByAppendingString:sMemCode];
        sURL = [sURL stringByAppendingString:@"&dtpClass="];
        sURL = [sURL stringByAppendingString:sDtDate];
        
        NSLog(@" =====Without Lat and Long from Search, Load current Lat and Long and Load the sURL on WebView : %@ ", sURL);
        
    }else {
      
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        latitude = appDelegate.slatitude;
        longitude = appDelegate.slongitude;
        //NSLog(@" The longitude : %@ ", longitude);
        
        sURL = appDelegate.gURL;
        sURL = [sURL stringByAppendingString:@"/apps/class.asp?"];
        sURL = [sURL stringByAppendingString:@"memCode="];
        sURL = [sURL stringByAppendingString:sMemCode];
        sURL = [sURL stringByAppendingString:@"&dtpClass="];
        sURL = [sURL stringByAppendingString:sDtDate];
        //sURL = [sURL stringByAppendingString:@"&lat=0.3456"];
        //sURL = [sURL stringByAppendingString:@"&long=5.56677"];
        sURL = [sURL stringByAppendingString:@"&lang="];
        sURL = [sURL stringByAppendingString:sLanguage];
        sURL = [sURL stringByAppendingString:@"&lat="];
        sURL = [sURL stringByAppendingString:latitude];
        sURL = [sURL stringByAppendingString:@"&long="];
        sURL = [sURL stringByAppendingString:longitude];
        
        NSLog(@"=====Click on Class Tab or Not from Search Tab, load current Lat and Long and the sURL on WebView : %@ ", sURL);
        
    }
    
    //NSLog(@" ======Double confirm: The sURL to be loaded %@ ", sURL);
    
    //=== Clear the value from SearchVC because when changing view, I want it back to default.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"txtURLFromSearch"];
    [defaults synchronize];
    
    NSURL *url = [NSURL URLWithString:sURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:urlRequest];
    [webView setDelegate:(id<UIWebViewDelegate>)self];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [webView.scrollView addSubview:refreshControl];
    
}

- (void)handleRefresh:(UIRefreshControl *)refresh {
    
    NSLog(@" HANDLE REFRESH sURL : %@ ", sURL);
    
    NSURL *url = [NSURL URLWithString:sURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:urlRequest];
    [refresh endRefreshing];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ClassesDet *target = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"ClassesDet"]) {
        
        NSLog(@" To ClassesDet sURL : %@", sURL);
        target.urlString = sURL;
        
    }
    
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *URL = [request URL];
    NSString *theString = [URL absoluteString];
    NSRange match;
    
    match = [theString rangeOfString: @"class_det.asp"];
    
    //=== If the URL string does not contain class_det.asp meaning it will the webview.
    if (match.location == NSNotFound) {
        
        NSLog(@"Load the WebView with this sURL : %@", sURL);
        return YES; //Load webview, the URL will be sURL nothing to do with theString
        
    } else {
        
        sURL = theString; //=== After clicking the class, sURL will become theString.
        
        NSLog(@"Trigger the Segue ClassesDet and pass the sURL : %@  Over ",sURL );
        
        [self performSegueWithIdentifier:@"ClassesDet" sender:self];
        
        return NO; // Don't load the webview
    }
    
}

@end
