//
//  RootViewController.m
//  Mytest
//
//  Created by Dimitris Bouzikas on 2/19/14.
//  Copyright (c) 2014 com.bloomarank. All rights reserved.
//
#import "RootViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface RootViewController (){
    
    AppDelegate *appDelegate;
    NSString *sURL,*sResponseData, *sRemaining;
    NSString *sCode;

}
@end

@implementation RootViewController

@synthesize loginView;
@synthesize txtCountry,txtCode,txtPhone;
@synthesize btnSendVeri;
@synthesize countryMArray;
@synthesize codeMArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //=== Customize the btnSendVeri
    btnSendVeri.layer.cornerRadius =7.0f;
    btnSendVeri.layer.shadowRadius = 3.0f;
    btnSendVeri.layer.shadowColor = [UIColor blackColor].CGColor;
    btnSendVeri.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    btnSendVeri.layer.shadowOpacity = 0.5f;
    btnSendVeri.layer.masksToBounds = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    //=== Initiallize the Mutable Array
    countryMArray = [[NSMutableArray alloc] init];
    codeMArray = [[NSMutableArray alloc] init];
    
    //=== Initialize the responseData Mutable Data
    self.responseData = [NSMutableData data];
    
    //=== Pass the string to server to get the return Country response.write
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sURL = appDelegate.gURL;
    sURL = [sURL stringByAppendingString:@"/apps/getcountry.asp?"];
    
    NSURLRequest *requestCountry = [NSURLRequest requestWithURL:[NSURL URLWithString:sURL]];
    
    (void) [[NSURLConnection alloc] initWithRequest:requestCountry delegate:self];
    
    //=== Pass the string to server to get the return CountryCode response.write
    sURL = appDelegate.gURL;
    sURL = [sURL stringByAppendingString:@"/apps/getctcode.asp?"];
    
    NSURLRequest *requestCode = [NSURLRequest requestWithURL:[NSURL URLWithString:sURL]];
    
    (void) [[NSURLConnection alloc] initWithRequest:requestCode delegate:self];
    
    //=== Initialie the picker ====
    self.pickerCountry = [[DownPicker alloc] initWithTextField:self.txtCountry withData:countryMArray];
    
    [self.pickerCountry addTarget:self
                           action:@selector(pickerClicked:)
                 forControlEvents:UIControlEventValueChanged];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //==== Hide the NavigationBar ====
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    //==== When View Disappear Unide the NavigationBar
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

//=== Pick the countryCode, when Country is selected based on Array Index
-(void)pickerClicked:(id)dp {
    
    NSString* selectedValue = [self.pickerCountry text];
    
    for ( int i = 0 ; i < countryMArray.count; i++) {
        
        NSString*item = [countryMArray objectAtIndex:i];
        
        if([item isEqualToString:selectedValue])
        {
            sCode = [codeMArray objectAtIndex:i];
            txtCode.text = [@"+"stringByAppendingString:sCode];
            
            break;
        }
        
    }
}


- (IBAction)btnSendVeri:(UIButton *)sender {
    
    if ([txtCode hasText] && [txtPhone hasText])
    {
        //=== Initialize the responseData Mutable Data
        self.responseData = [NSMutableData data];
        
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        sURL = appDelegate.gURL;
        sURL = [sURL stringByAppendingString:@"/apps/signin.asp?"];
        sURL = [sURL stringByAppendingString:@"country="];
        sURL = [sURL stringByAppendingString:sCode];
        sURL = [sURL stringByAppendingString:@"&phone="];
        sURL = [sURL stringByAppendingString:self.txtPhone.text];
    
        //=== Send the URL to the server and SMS will trigger and sent out to the phone number ===
        NSLog(@" This is the sURL : %@ ", sURL);
        
        NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:sURL]];
        
        (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
    }
    else //==== If txtCode or txtPhone is empty
    {
        UIAlertController *alert;
        alert = [UIAlertController
                 alertControllerWithTitle:@"Oops..."
                 message:@"Country Code or Phone number cannot be blank"
                 preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok;
        ok = [UIAlertAction
                  actionWithTitle:@"OK"
                  style:UIAlertActionStyleDefault
                  handler:^(UIAlertAction * action)
                  {
                      [alert
                       dismissViewControllerAnimated:YES
                       completion:nil];
                  }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
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
    NSLog(@"=======*************** This Response.write stuff =%@=", sResponseData);
    
    NSString *sSeparator= @"|";
    
    NSRange range = [sResponseData rangeOfString:sSeparator];
    NSInteger position = range.location + range.length;
    NSString *sWhatIsIt = [sResponseData substringToIndex:position-1];
    sRemaining = [sResponseData substringFromIndex:position];
    
    if ([sWhatIsIt isEqualToString:@"CD"]){ //=== To build up CountryCode Mutable Array
        
        range = [sRemaining rangeOfString:sSeparator];
        position = range.location + range.length;
        NSString *sLoop = [sRemaining substringToIndex:position-1];
        sRemaining = [sRemaining substringFromIndex:position];
        
        for (int i = 0; i< [sLoop intValue]; i++) {
            
            range = [sRemaining rangeOfString:sSeparator];
            position = range.location + range.length;
            
            NSString *sStateName = [sRemaining substringToIndex:position-1];
            sRemaining = [sRemaining substringFromIndex:position];
            
            [codeMArray addObject:sStateName];
        }
        
        NSLog(@"======The State Array : %@ ", codeMArray);
        
    }else if ([sWhatIsIt isEqualToString:@"CT"]){ //=== Build up Country Mutable Array
        
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
        
    }else if ([sWhatIsIt isEqualToString:@"OK"]) { //=== OK Confirmation Code will send. New SMS will only sent after 5 mins. 
    
        NSLog(@"This is strResult %@", sRemaining);
        
        NSString *sMemCode = sRemaining;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:sMemCode forKey:@"txtMemCode"];
        [defaults setObject:@"EN" forKey:@"txtLanguage"];
        [defaults setBool:NO forKey:@"registered"];
        
        [defaults synchronize];
        
        UIAlertController * alert; alert = [UIAlertController alertControllerWithTitle:@"Confirmation Code sent" message:@"Please check your SMS and enter the confirmation code" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancel; cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                         {
                                             [self performSegueWithIdentifier:@"fromRootToVerify" sender:self];
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             
                                         }];
        
        [alert addAction:cancel ];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if ([sWhatIsIt isEqualToString:@"ERR"]) { //--- Modal will pop up.
        
        NSLog(@"This is strResult %@", sRemaining);
        
        UIAlertController * alert; alert = [UIAlertController alertControllerWithTitle:@"ERROR!" message:sRemaining preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancel; cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                         {
                                             
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             
                                         }];
        
        [alert addAction:cancel ];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

//*** Cannot delete this following IBAction even thouogh it does nothing ***
- (IBAction)btnRegister:(UIButton *)sender {
}

-(void)dismissKeyboard
{
    [txtCountry resignFirstResponder];
    [txtCode resignFirstResponder];
    [txtPhone resignFirstResponder];
}

-(void)viewDidLayoutSubviews{
    
    //=== Customize the UITextField
    [self SetTextFieldBorder:txtCode];
    [self SetTextFieldBorder:txtPhone];
    
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

@end
