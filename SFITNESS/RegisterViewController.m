//
//  RegisterViewController.m
//  SFITNESS
//
//  Created by BRO on 08/02/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "TermPolicy.h"

@interface RegisterViewController (){
    
    AppDelegate *appDelegate;
    NSString *sURL,*sResponseData, *sRemaining;
    NSString *strResult;
    NSString *fullString;
    NSString *sGoWhere;
    NSString *sMemCode;
    NSString *sCode;
    BOOL checked;
}

@end

@implementation RegisterViewController

@synthesize loginView2;
@synthesize txtName,txtCountry,txtCode,txtPhone,txtReferCode;
@synthesize countryMArray;
@synthesize codeMArray;
@synthesize btnSendVeri;
@synthesize btnCheck;
@synthesize lblTermPolicy;
@synthesize lblPolicy;
//@synthesize agreeTextContainerView;
//@synthesize layoutManager;

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.spinner stopAnimating];

    //=== Set the navigation Back < color
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor : [ UIColor blackColor]];
    //=== Set the navigation Bar text color
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    //=== Customize the btnUpdate
    btnSendVeri.layer.cornerRadius = 7.0f;
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

    //=== Pass the string to web and get the return Country response.write
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sURL = appDelegate.gURL;
    sURL = [sURL stringByAppendingString:@"/apps/getcountry.asp?"];

    NSURLRequest *requestCountry = [NSURLRequest requestWithURL:[NSURL URLWithString:sURL]];

    (void) [[NSURLConnection alloc] initWithRequest:requestCountry delegate:self];

    //=== Pass the string to web and get the return Code response.write
    sURL = appDelegate.gURL;
    sURL = [sURL stringByAppendingString:@"/apps/getctcode.asp?"];

    NSURLRequest *requestCode = [NSURLRequest requestWithURL:[NSURL URLWithString:sURL]];

    (void) [[NSURLConnection alloc] initWithRequest:requestCode delegate:self];

    self.pickerCountry = [[DownPicker alloc] initWithTextField:self.txtCountry withData:countryMArray];

    [self.pickerCountry addTarget:self
                       action:@selector(pickerClicked:)
             forControlEvents:UIControlEventValueChanged];
    
    checked = NO;
    
    
    //===== For lblTermPolicy ======================================
    NSString *sTerms = @"I agree to the Terms of Use and";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:sTerms];
    
    NSString *sPrivatePolicy = @"Privacy Policy";
    
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:sPrivatePolicy];
    
    //=== For underline
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:[sTerms rangeOfString:@"Terms"]];
    
     [attributedString2 addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:[sPrivatePolicy rangeOfString:@"Policy"]];
    //=== For Color blue
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.05 green:0.4 blue:0.65 alpha:1.0] range:[sTerms rangeOfString:@"Terms"]];
    
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.05 green:0.4 blue:0.65 alpha:1.0] range:[sPrivatePolicy rangeOfString:@"Policy"]];
    
    //===Setting attributed string to textview
    lblTermPolicy.attributedText = attributedString;
    lblPolicy.attributedText = attributedString2;
    
    lblTermPolicy.userInteractionEnabled = YES;
    [lblTermPolicy addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnlblTerm:)]];
    
    lblPolicy.userInteractionEnabled = YES;
    [lblPolicy addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnlblPolicy:)]];
}

- (void)handleTapOnlblTerm:(UITapGestureRecognizer *)tapGesture {
    
    sGoWhere = @"Term";
    [self performSegueWithIdentifier:@"TermPolicy" sender:self];
}

- (void)handleTapOnlblPolicy:(UITapGestureRecognizer *)tapGesture {
    
    sGoWhere =@"Policy";
    [self performSegueWithIdentifier:@"TermPolicy" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    TermPolicy *target = segue.destinationViewController;
    
    NSLog(@"sGowhere ===@%=== ",sGoWhere);
    
    if ([segue.identifier isEqualToString:@"TermPolicy "] || [sGoWhere isEqualToString:@"Term"]) {
        
        target.urlString = @"https://www.share-fitness.com/term.asp";
        
    } else if ([segue.identifier isEqualToString:@"TermPolicy "] || [sGoWhere isEqualToString:@"Policy"]) {
        
        target.urlString = @"https://www.share-fitness.com/policy.asp";;
    }
}

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

- (IBAction)btnCheck:(id)sender {
    
    if(!checked){
        [btnCheck setImage:[UIImage imageNamed:@"icons8-checked-checkbox-24.png"] forState:UIControlStateNormal];
        checked = YES;
    }else{
        [btnCheck setImage:[UIImage imageNamed:@"icons8-unchecked-checkbox-24.png"] forState:UIControlStateNormal];
        checked = NO;
    }
}

- (IBAction)btnSendVeri:(id)sender {
    
    if ([txtName hasText] &&[txtCode hasText] && [txtPhone hasText] && checked)
    {
        self.responseData = [NSMutableData data];
        [self.spinner startAnimating];
        
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        sURL = appDelegate.gURL;
        sURL = [sURL stringByAppendingString:@"/apps/signup.asp?"];
        sURL = [sURL stringByAppendingString:@"fullname="];
        sURL = [sURL stringByAppendingString:self.txtName.text];
        sURL = [sURL stringByAppendingString:@"&country="];
        sURL = [sURL stringByAppendingString:sCode];
        sURL = [sURL stringByAppendingString:@"&phone="];
        sURL = [sURL stringByAppendingString:self.txtPhone.text];
        sURL = [sURL stringByAppendingString:@"&referral="];
        sURL = [sURL stringByAppendingString:self.txtReferCode.text];
        
        sURL = [sURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSLog(@" Send sURL signup :===%@==== ", sURL);
        
        NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:sURL]];
        
        (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
    } else if (!checked) {
        
        UIAlertController *alert;
        alert = [UIAlertController
                 alertControllerWithTitle:@"Terms of Use and Private Policy"
                 message:@"Please check the Terms of Use and Private Policy"
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
    else
    {
        UIAlertController *alert;
        alert = [UIAlertController
                 alertControllerWithTitle:@"Oops..."
                 message:@"Name or Country Code or Phone number cannot be empty"
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
    
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    sResponseData = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"===REGISTERVIEWCONTROLLER This Response.write stuff %@", sResponseData);
       
    NSString *sSeparator= @"|";
    
    NSRange range = [sResponseData rangeOfString:sSeparator];
    NSInteger position = range.location + range.length;
    NSString *sWhatIsIt = [sResponseData substringToIndex:position-1];
    sRemaining = [sResponseData substringFromIndex:position];
    
    if ([sWhatIsIt isEqualToString:@"ERR"]) {
        
        UIAlertController *alert; alert = [UIAlertController alertControllerWithTitle:@"Oops..." message:sRemaining preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok; ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                         {
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             
                                             //*** Go to RootNavigationControllerID storyboard after click OK ***
                                                 //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                 //UIViewController *tabView = [storyboard instantiateViewControllerWithIdentifier:@"RootNavigationControllerID"];
                                                 //[self presentViewController:tabView animated:YES completion:nil];
                                             
                                            }];
        //*** For the modal ***
        [alert addAction:ok ];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    } else if ([sWhatIsIt isEqualToString:@"OK"]) {
        
        sMemCode = sRemaining;
       
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:sMemCode forKey:@"txtMemCode"];
        [defaults setObject:@"EN" forKey:@"txtLanguage"];
        [defaults setBool:NO forKey:@"registered"];
        
        [defaults synchronize];
        
        UIAlertController * alert; alert = [UIAlertController alertControllerWithTitle:@"Register Sucessfully!" message:self.txtPhone.text preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancel; cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                         {
                                             
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             [self performSegueWithIdentifier:@"fromRegToLogin" sender:self];
                                             
                                         }];
       
        [alert addAction:cancel ];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if ([sWhatIsIt isEqualToString:@"ACT"]) {
        
        range = [sRemaining rangeOfString:sSeparator];
        position = range.location + range.length;
        sMemCode = [sRemaining substringToIndex:position-1];
        sRemaining = [sRemaining substringFromIndex:position];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:sMemCode forKey:@"txtMemCode"];
        [defaults setObject:@"EN" forKey:@"txtLanguage"];
        [defaults setBool:NO forKey:@"registered"];
        
        [defaults synchronize];
        
        UIAlertController * alert; alert = [UIAlertController alertControllerWithTitle:@"Already Registered!" message:sRemaining preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancel; cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                         {
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             
                                             [self performSegueWithIdentifier:@"fromRegToLogin" sender:self];
                                         }];
        
        [alert addAction:cancel ];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if ([sWhatIsIt isEqualToString:@"CD"]){
        
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
    }
     [self.spinner stopAnimating];

}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault]; self.navigationController.navigationBar.shadowImage = nil; self.navigationController.navigationBar.translucent = NO;
}

-(void)dismissKeyboard
{
    [txtName resignFirstResponder];
    [txtCountry resignFirstResponder];
    [txtCode resignFirstResponder];
    [txtPhone resignFirstResponder];
    [txtReferCode resignFirstResponder];
}

-(void)viewDidLayoutSubviews{
    
    
    //=== Customize the UITextField
    [self SetTextFieldBorder:txtName];
    [self SetTextFieldBorder:txtCode];
    [self SetTextFieldBorder:txtPhone];
    [self SetTextFieldBorder:txtReferCode];
    
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
