//
//  ProfileEdit.m
//  SFITNESS
//
//  Created by BRO on 05/04/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "ProfileEdit.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface ProfileEdit (){
    
    AppDelegate *appDelegate;
    NSString *sURL, *sResponseData, *sRemaining;
    NSString *sMemCode, *sLanguage;
}

@end

@implementation NSString (MyExtensions)

- (NSString *)trimmed {
    return [self stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end

@implementation ProfileEdit

@synthesize profileData;
@synthesize lblName,lblEmail,lblPhone,lblAdd1,lblAdd2,lblAdd3,lblPostCode,lblState,lblCountry,lblGender;
@synthesize txtName,txtEmail,txtPhone,txtAdd1,txtAdd2,txtAdd3,txtPostCode,txtState,txtCountry,txtGender;
@synthesize autocompleteTableView;
@synthesize autocompleteMArray;
@synthesize stateMArray;
@synthesize countryMArray;
@synthesize btnUpdate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //--- Call the stored txtMemCode, something like session ---
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    sMemCode = [defaults objectForKey:@"txtMemCode"];
    sLanguage = [defaults objectForKey:@"txtLanguage"];
    
    if ([sLanguage isEqualToString:@"CN"]){
        lblName.text = @"名称";
        lblEmail.text = @"邮件";
        lblPhone.text = @"电话";
        lblAdd1.text = @"地址1";
        lblAdd2.text = @"地址2";
        lblAdd3.text =@"地址3";
        lblPostCode.text = @"邮编";
        lblState.text = @"州省";
        lblCountry.text = @"国家";
        lblGender.text = @"性别";
        
        [btnUpdate setTitle:@"更新个人资料" forState:UIControlStateNormal];
    }
    
    //=== Insert Data into UITextField
    NSLog(@"The Array : %@ ", self.dataFromProfile);
    txtName.text = [_dataFromProfile objectAtIndex:0];
    txtEmail.text = [_dataFromProfile objectAtIndex:1];
    txtPhone.text = [_dataFromProfile objectAtIndex:2];
    txtAdd1.text = [_dataFromProfile objectAtIndex:3];
    txtAdd2.text = [_dataFromProfile objectAtIndex:4];
    txtAdd3.text = [_dataFromProfile objectAtIndex:5];
    txtPostCode.text = [_dataFromProfile objectAtIndex:6];
    txtState.text = [_dataFromProfile objectAtIndex:7];
    txtCountry.text = [_dataFromProfile objectAtIndex:8];
    txtGender.text = [_dataFromProfile objectAtIndex:9];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    //=== Initiallize the Mutable Array
    stateMArray = [[NSMutableArray alloc] init];
    countryMArray = [[NSMutableArray alloc] init];
    
    //=== Initialize the responseData Mutable Data
    self.responseData = [NSMutableData data];
    
    //=== Pass the string to web and get the return State response.write
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sURL = appDelegate.gURL;
    sURL = [sURL stringByAppendingString:@"/apps/getstate.asp?"];
    sURL = [sURL stringByAppendingString:@"memCode="];
    sURL = [sURL stringByAppendingString:sMemCode];
    
    NSURLRequest *requestState = [NSURLRequest requestWithURL:[NSURL URLWithString:sURL]];
    
    (void) [[NSURLConnection alloc] initWithRequest:requestState delegate:self];
    
    //=== Pass the string to web and get the return Country response.write
    sURL = appDelegate.gURL;
    sURL = [sURL stringByAppendingString:@"/apps/getcountry.asp?"];
    sURL = [sURL stringByAppendingString:@"memCode="];
    sURL = [sURL stringByAppendingString:sMemCode];
    
    NSURLRequest *requestCountry = [NSURLRequest requestWithURL:[NSURL URLWithString:sURL]];
    
    (void) [[NSURLConnection alloc] initWithRequest:requestCountry delegate:self];
    
    //=== Customize the btnUpdate
    btnUpdate.layer.cornerRadius = 7.0f;
    btnUpdate.layer.shadowRadius = 3.0f;
    btnUpdate.layer.shadowColor = [UIColor blackColor].CGColor;
    btnUpdate.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    btnUpdate.layer.shadowOpacity = 0.5f;
    btnUpdate.layer.masksToBounds = NO;
    
    self.pickerState = [[DownPicker alloc] initWithTextField:self.txtState withData:stateMArray];
    self.pickerCountry = [[DownPicker alloc] initWithTextField:self.txtCountry withData:countryMArray];
    
    NSArray *genderArray = @[@"Male", @"Female"];
    self.pickerGender = [[DownPicker alloc] initWithTextField:self.txtGender withData:genderArray];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    if ([sLanguage isEqualToString:@"CN"]){
        
        self.navigationController.navigationBar.topItem.title = @"编辑个人资料";
        
    }else{
        self.navigationController.navigationBar.topItem.title = @"EDIT PROFILE";
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
    
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"=========Succeeded! Received %d bytes of data",[self.responseData length]);
    
    sResponseData = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"=======*************** This Response.write stuff %@", sResponseData);
    
    NSString *sSeparator= @"|";
    
    NSRange range = [sResponseData rangeOfString:sSeparator];
    NSInteger position = range.location + range.length;
    NSString *sWhatIsIt = [sResponseData substringToIndex:position-1];
    sRemaining = [sResponseData substringFromIndex:position];
    
    if ([sWhatIsIt isEqualToString:@"ST"]){
        
        range = [sRemaining rangeOfString:sSeparator];
        position = range.location + range.length;
        NSString *sLoop = [sRemaining substringToIndex:position-1];
        sRemaining = [sRemaining substringFromIndex:position];
        
        for (int i = 0; i< [sLoop intValue]; i++) {
            
            range = [sRemaining rangeOfString:sSeparator];
            position = range.location + range.length;
            
            NSString *sStateName = [sRemaining substringToIndex:position-1];
            sRemaining = [sRemaining substringFromIndex:position];
            
            [stateMArray addObject:sStateName];
        }
        
        NSLog(@"======The State Array : %@ ", stateMArray);
        
    }else if ([sWhatIsIt isEqualToString:@"CT"]){
        
        range = [sRemaining rangeOfString:sSeparator];
        position = range.location + range.length;
        NSString *sLoop = [sRemaining substringToIndex:position-1];
        sRemaining = [sRemaining substringFromIndex:position];
        
        for (int i = 0; i< [sLoop intValue]; i++) {
            
            range = [sRemaining rangeOfString:sSeparator];
            position = range.location + range.length;
            
            NSString *sCountryName = [sRemaining substringToIndex:position-1];
            sRemaining = [sRemaining substringFromIndex:position];
            
            [countryMArray addObject:sCountryName];
        }
        
        NSLog(@"******The Country Array : %@ ", countryMArray);
        
    }else if ([sWhatIsIt isEqualToString:@"ERR"]) {
        
        NSLog(@"This is sRemaining %@", sRemaining);
        
        UIAlertController *alert; alert = [UIAlertController alertControllerWithTitle:@"Oops..." message:sRemaining preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok; ok = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                     //=== Go back to previouse VC
                                     UINavigationController *navigationController = self.navigationController;
                                     [navigationController popViewControllerAnimated:YES];
                                     
                                 }];
        //*** For the modal ***
        [alert addAction:ok ];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    } else if ([sWhatIsIt isEqualToString:@"OK"]) {
        NSLog(@"This is sRemaining %@", sRemaining);
        
        UIAlertController *alert; alert = [UIAlertController alertControllerWithTitle:@"UPDATED SUCCESSFULLY!" message:sRemaining preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok; ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                     //=== Go back to previous VC
                                     UINavigationController *navigationController = self.navigationController;
                                     [navigationController popViewControllerAnimated:YES];
                                     
                                 }];
        //*** For the modal ***
        [alert addAction:ok ];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
}

-(void)viewDidLayoutSubviews{
    
    //=== Customize the UITextField
    [self SetTextFieldBorder:txtName];
    [self SetTextFieldBorder:txtEmail];
    [self SetTextFieldBorder:txtPhone];
    
    [self SetTextFieldBorder:txtAdd1];
    [self SetTextFieldBorder:txtAdd2];
    [self SetTextFieldBorder:txtAdd3];
    [self SetTextFieldBorder:txtPostCode];
    [self SetTextFieldBorder:txtState];
    [self SetTextFieldBorder:txtCountry];
    [self SetTextFieldBorder:txtGender];
    
}

-(void)SetTextFieldBorder :(UITextField *)textField{
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor grayColor].CGColor;
    border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height);
    border.borderWidth = borderWidth;
    [textField.layer addSublayer:border];
    textField.layer.masksToBounds = YES;
    
}

-(void)dismissKeyboard
{
    [txtName resignFirstResponder];
    [txtEmail resignFirstResponder];
    [txtAdd1 resignFirstResponder];
    [txtAdd2 resignFirstResponder];
    [txtAdd3 resignFirstResponder];
    [txtPostCode resignFirstResponder];
    
}

- (IBAction)btnUpdate:(id)sender {
    
    //=== Pass the string to web and get the return Country response.write
    sURL = appDelegate.gURL;
    sURL = [sURL stringByAppendingString:@"/apps/updateProfile.asp?"];
    sURL = [sURL stringByAppendingString:@"memCode="];
    sURL = [sURL stringByAppendingString:sMemCode];
    sURL = [sURL stringByAppendingString:@"&name="];
    sURL = [sURL stringByAppendingString:[txtName.text trimmed]];
    sURL = [sURL stringByAppendingString:@"&email="];
    sURL = [sURL stringByAppendingString:[txtEmail.text trimmed]];
    sURL = [sURL stringByAppendingString:@"&phone="];
    sURL = [sURL stringByAppendingString:[txtPhone.text trimmed]];
    sURL = [sURL stringByAppendingString:@"&add1="];
    sURL = [sURL stringByAppendingString:[txtAdd1.text trimmed]];
    sURL = [sURL stringByAppendingString:@"&add2="];
    sURL = [sURL stringByAppendingString:[txtAdd2.text trimmed]];
    sURL = [sURL stringByAppendingString:@"&add3="];
    sURL = [sURL stringByAppendingString:[txtAdd3.text trimmed]];
    sURL = [sURL stringByAppendingString:@"&postcode="];
    sURL = [sURL stringByAppendingString:[txtPostCode.text trimmed]];
    sURL = [sURL stringByAppendingString:@"&state="];
    sURL = [sURL stringByAppendingString:[txtState.text trimmed]];
    sURL = [sURL stringByAppendingString:@"&country="];
    sURL = [sURL stringByAppendingString:[txtCountry.text trimmed]];
    sURL = [sURL stringByAppendingString:@"&gender="];
    sURL = [sURL stringByAppendingString:[txtGender.text trimmed]];
    
    NSString *sURLEncoded;
    sURLEncoded= [sURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"************** This is the Encoded sURL : %@ ", sURLEncoded);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:sURLEncoded]];
    
    (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

@end
