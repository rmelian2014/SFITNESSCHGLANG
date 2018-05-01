//
//  Search.m
//  SFITNESS
//
//  Created by BRO on 25/01/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "Search.h"
#import "CERangeSlider.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import "Classes.h"
#import "MyTabBarController.h"

@interface Search(){
    
    AppDelegate *appDelegate;
    CERangeSlider* _rangeSlider;
    NSString *sURL, *strResult, *sRemaining, *sStartTime, *sEndTime, *sSelectedLat, *sSelectedLong;
    NSString *sLanguage;
}

@end

@implementation Search

@synthesize lblLocation;
@synthesize lblActivity;
@synthesize lblStart;
@synthesize lblEnd;
@synthesize categoryMArray;
@synthesize autocompleteTableView;
@synthesize autocompleteMArray;
@synthesize sSelectedAdd;
@synthesize btnSearch;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //--- Call the stored txtMemCode, something like session ---
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    sLanguage = [defaults objectForKey:@"txtLanguage"];
    
    //=== Customize the btnSendVeri
    btnSearch.layer.cornerRadius =7.0f;
    btnSearch.layer.shadowRadius = 3.0f;
    btnSearch.layer.shadowColor = [UIColor blackColor].CGColor;
    btnSearch.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    btnSearch.layer.shadowOpacity = 0.5f;
    btnSearch.layer.masksToBounds = NO;
    
    //==== Google Place autocomplete
    _txtPlaceSearch.placeSearchDelegate                 = self;
    _txtPlaceSearch.strApiKey                           = @"AIzaSyBJvZbCA-BiAE3HBgdrm6TTjAiVkYTU9Kk";
    _txtPlaceSearch.superViewOfList                     = self.view;  // View, on which Autocompletion list should be appeared.
    _txtPlaceSearch.autoCompleteShouldHideOnSelection   = YES;
    _txtPlaceSearch.maximumNumberOfAutoCompleteRows     = 5;
    
    //=== Call the rangeSlider Class
    NSUInteger marginX = 20;
    NSInteger marginY = 50;
    CGRect sliderFrame = CGRectMake(marginX, CGRectGetMaxY(_txtActivity.frame)+marginY, self.view.frame.size.width - marginX * 2, 30);
    _rangeSlider = [[CERangeSlider alloc] initWithFrame:sliderFrame];
    
    [self.view addSubview:_rangeSlider];
    
    [_rangeSlider addTarget:self
                     action:@selector(slideValueChanged:)
           forControlEvents:UIControlEventValueChanged];
    
    [self performSelector:@selector(updateState) withObject:nil afterDelay:2.0f];
    
    //=== Insert the labels
    sStartTime = [NSString stringWithFormat:@"%@", [self floatToTime:_rangeSlider.lowerValue]];
    sEndTime = [NSString stringWithFormat:@"%@", [self floatToTime:_rangeSlider.upperValue]];
    
    if ([sLanguage isEqualToString:@"CN"]){
        self.title = @"搜索";
        lblLocation.text = @"搜索你所在城市的地方";
        [_txtPlaceSearch setPlaceholder:@"搜索你所在城市的地方"];
        lblActivity.text = @"按活动搜索";
        [_txtActivity setPlaceholder:@"按活动搜索"];
        lblStart.text = [@"开始时间 : " stringByAppendingString:sStartTime];
        lblEnd.text = [@"结束时间 : " stringByAppendingString:sEndTime];
        [btnSearch setTitle:@"搜索" forState:UIControlStateNormal];
        
    }else{
        
        lblStart.text = [@"Start Time : " stringByAppendingString:sStartTime];
        lblEnd.text = [@"End Time : " stringByAppendingString:sEndTime];
    }
    //=== Pass the string to web and get the return Category result
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    sURL = appDelegate.gURL;
    sURL = [sURL stringByAppendingString:@"/apps/getcat.asp?"];
    
    self.responseData = [NSMutableData data];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:sURL]];
    
    (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //--- Configure the TableView
    self.txtActivity.delegate = self;
     
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Optional Properties for Google Place AutoComplete
    _txtPlaceSearch.autoCompleteRegularFontName =  @"HelveticaNeue-Bold";
    _txtPlaceSearch.autoCompleteBoldFontName = @"HelveticaNeue";
    _txtPlaceSearch.autoCompleteTableCornerRadius=0.0;
    _txtPlaceSearch.autoCompleteRowHeight=35;
    _txtPlaceSearch.autoCompleteTableCellTextColor=[UIColor colorWithWhite:0.131 alpha:1.000];
    _txtPlaceSearch.autoCompleteFontSize=14;
    _txtPlaceSearch.autoCompleteTableBorderWidth=1.0;
    _txtPlaceSearch.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=YES;
    _txtPlaceSearch.autoCompleteShouldHideOnSelection=YES;
    _txtPlaceSearch.autoCompleteShouldHideClosingKeyboard=YES;
    _txtPlaceSearch.autoCompleteShouldSelectOnExactMatchAutomatically = YES;
    _txtPlaceSearch.autoCompleteTableFrame = CGRectMake((self.view.frame.size.width-_txtPlaceSearch.frame.size.width)*0.5, _txtPlaceSearch.frame.size.height+100.0, _txtPlaceSearch.frame.size.width, 200.0);
    
     [self cofigureAutoComTableView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    if ([textField isEqual:_txtActivity]) {
        autocompleteTableView.hidden = NO;
        
        NSString *substring = [NSString stringWithString:textField.text];
        substring = [substring
                     stringByReplacingCharactersInRange:range withString:string];
        [self searchAutocompleteEntriesWithSubstring:substring];

        return YES;
    }
    return YES;
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring
{
    autocompleteMArray = [[NSMutableArray alloc] init];
    [autocompleteMArray removeAllObjects];
    if ([substring length] > 0)
    {
        for(NSString *curString in categoryMArray)
        {
            NSRange substringRange = [curString rangeOfString:substring];
            if (substringRange.length > 0)
            {
                [autocompleteMArray addObject:curString];
            }
        }
    }
    else
    {
        autocompleteTableView.hidden = YES;
    }
    NSLog(@"*******The autocompleteMArray : %@ ", autocompleteMArray);
    [autocompleteTableView reloadData];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //NSLog(@"didFailWithError");
    //NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
    //[spinner stopAnimating];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //NSLog(@"connectionDidFinishLoading");
    //NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    strResult = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"This returned response.write stuff %@", strResult);
    
    NSString *sSeparator= @"|";
    
    NSRange range = [strResult rangeOfString:sSeparator];
    NSInteger position = range.location + range.length;
    NSString *sLoop = [strResult substringToIndex:position-1];
    sRemaining = [strResult substringFromIndex:position];
    
    categoryMArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i< [sLoop intValue]; i++) {
        
        range = [sRemaining rangeOfString:sSeparator];
        position = range.location + range.length;
        
        NSString *sCatName = [sRemaining substringToIndex:position-1];
        sRemaining = [sRemaining substringFromIndex:position];
    
        [categoryMArray addObject:sCatName];
    }
    
    NSLog(@"The Array : %@ ", categoryMArray);
    
}

-(void)cofigureAutoComTableView {
    
    autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.txtActivity.frame.origin.x,self.txtActivity.frame.origin.y+32,_txtActivity.frame.size.width, 200) style:UITableViewStylePlain];
    
    autocompleteTableView.delegate = self;
    autocompleteTableView.dataSource = self;
    autocompleteTableView.scrollEnabled = YES;
    //autocompleteTableView.
    autocompleteTableView.hidden = YES;
    [self.view addSubview:autocompleteTableView];
    
    CALayer *layer = autocompleteTableView.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius: 0.0];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[[UIColor blackColor] CGColor]];
    
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath {
    
    UIFont *myFont = [ UIFont fontWithName: @"HelveticaNeue" size: 14.0 ];
    cell.textLabel.font  = myFont;
    
    //if(indexPath.row % 2 == 0)
      //  cell.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:0.6];
    //else
        cell.backgroundColor = [UIColor whiteColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return autocompleteMArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [self.autocompleteTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text =  [autocompleteMArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"Selected Cell %@", [autocompleteMArray objectAtIndex:indexPath.row]);
    
    autocompleteTableView.hidden = YES;
    _txtActivity.text = [autocompleteMArray objectAtIndex:indexPath.row];
}

#pragma mark - Place search Textfield Delegates

-(void)placeSearch:(MVPlaceSearchTextField*)textField ResponseForSelectedPlace:(GMSPlace*)responseDict{
    [self.view endEditing:YES];
    
    sSelectedLat = [NSString stringWithFormat: @"%f", responseDict.coordinate.latitude];
    sSelectedLong = [NSString stringWithFormat: @"%f", responseDict.coordinate.longitude];
    
    //NSLog(@"SELECTED ADDRESS :%@",responseDict);
}

-(void)placeSearchWillShowResult:(MVPlaceSearchTextField*)textField{
    
}

-(void)placeSearchWillHideResult:(MVPlaceSearchTextField*)textField{
    
}
-(void)placeSearch:(MVPlaceSearchTextField*)textField ResultCell:(UITableViewCell*)cell withPlaceObject:(PlaceObject*)placeObject atIndex:(NSInteger)index{
    //if(index%2==0){
      //  cell.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
  //  }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    //}
}

-(BOOL)textFieldShouldClear:(UITextField *)textField {
    
    if ([textField isEqual:_txtActivity]) {
        autocompleteTableView.hidden = YES;
        return YES;
    }
    return YES;
}

- (IBAction)dissmissKeyboardOnTap:(id)sender{
    autocompleteTableView.hidden = YES;
    [[self view]endEditing:YES];
}

- (void)slideValueChanged:(id)control
{
    NSLog(@"Slider value changed: (%.2f,%.2f)",
          _rangeSlider.lowerValue, _rangeSlider.upperValue);
    
    sStartTime = [NSString stringWithFormat:@"%@", [self floatToTime:_rangeSlider.lowerValue]];
    sEndTime = [NSString stringWithFormat:@"%@", [self floatToTime:_rangeSlider.upperValue]];
    
    lblStart.text = [@"Start Time : " stringByAppendingString:sStartTime];
    lblEnd.text = [@"End Time : " stringByAppendingString:sEndTime];
}

- (NSString*)floatToTime:(float)floatTime {

    NSInteger iHour = floatTime;
    CGFloat floatMin = floatTime - iHour;
    
    NSString *sHour = [NSString stringWithFormat:@"%li", (long)iHour];
    
    if (floatMin == 0.99) {  //=== When the float is 0.99, convert it to 0, if not 60*0.99 = 59.4, will never get to 0
        floatMin = 0;
    }else{
    
        floatMin = floatMin * 60;
    }
    
    NSInteger iMin = floatMin; //=== Take the integer part of floatMin
    
    NSString *sMin = [[NSString alloc] init];
    if (iMin <10){ //=== Take care if 0,1,2,3,4,5,6,7,8,9 to be 00,01,02,03...
        sMin = [NSString stringWithFormat: @"0%li", iMin];
    }else{
        sMin = [NSString stringWithFormat: @"%li", iMin];
    }
    
    NSString *strFloatTime = [NSString stringWithFormat:@"%@:%@", sHour,sMin];
    return strFloatTime;
}

- (void)updateState
{
    _rangeSlider.trackHighlightColour = [UIColor blueColor];
    _rangeSlider.curvatiousness = 5.0;
}

- (IBAction)btnSearch:(UIButton *)sender {
    
    self.tabBarController.selectedIndex = 1;

    if ([_txtPlaceSearch hasText]) {
        sURL = @"lat=";
        sURL = [sURL stringByAppendingString:sSelectedLat];
        sURL = [sURL stringByAppendingString:@"&long="];
        sURL = [sURL stringByAppendingString:sSelectedLong];
    }else{
        sURL = @"lat=";
        sURL = [sURL stringByAppendingString:@"&long="];
    }
    sURL = [sURL stringByAppendingString:@"&cat="];
    sURL = [sURL stringByAppendingString:_txtActivity.text];
    sURL = [sURL stringByAppendingString:@"&Start="];
    sURL = [sURL stringByAppendingString:sStartTime];
    sURL = [sURL stringByAppendingString:@"&End="];
    sURL = [sURL stringByAppendingString:sEndTime];
    
    NSLog(@"This is the URL To send to Classes VC %@", sURL);
    
    //=== Strore into session and send over to Classes VC
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:sURL forKey:@"txtURLFromSearch"];
    [defaults synchronize];
    
    //=== This is to call Classes VC
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabView = [storyboard instantiateViewControllerWithIdentifier:@"profileView"];
    tabView.selectedIndex=1; //=== This is to choose which Tab, starts with 0,1,2,3,4
    [self presentViewController:tabView animated:YES completion:nil];
    
    //UINavigationController* classesNav = (UINavigationController*)self.tabBarController.viewControllers[1];
    //Classes *classesViewController = [classesNav.viewControllers firstObject];
    //[classesViewController fromSearch:sURL];
    
    //Classes *vc = [[Classes alloc] init];
    
    //[vc fromSearch:sURL];
}

@end

