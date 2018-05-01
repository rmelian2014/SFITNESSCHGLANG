//
//  LoginViewController.m
//  Mytest
//
//  Created by Dimitris Bouzikas on 2/19/14.
//  Copyright (c) 2014 com.bloomarank. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController (){
    
    AppDelegate *appDelegate;
    NSString *sURL,*sMemCode;
    NSString *strResult,*sRemaining;
    BOOL resendCode;
}

@end

@implementation LoginViewController

@synthesize txtVerification;
@synthesize btnSubmit;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //=== Set the navigation Back < color
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor : [ UIColor blackColor]];
    //=== Set the navigation Bar text color
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
	
    //=== Customize the btnSendVeri
    btnSubmit.layer.cornerRadius =7.0f;
    btnSubmit.layer.shadowRadius = 3.0f;
    btnSubmit.layer.shadowColor = [UIColor blackColor].CGColor;
    btnSubmit.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    btnSubmit.layer.shadowOpacity = 0.5f;
    btnSubmit.layer.masksToBounds = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.responseData = [NSMutableData data];
    
    resendCode = NO;
    
}

- (IBAction)btnSubmit:(id)sender {
    
    resendCode = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Here you can get the data from login form
    // and proceed to authenticate process
    sMemCode = [defaults objectForKey:@"txtMemCode"];
    NSString *sVerification = self.txtVerification.text;
    
    if ([txtVerification hasText])
    {
        [self.spinner startAnimating];
        
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        sURL = appDelegate.gURL;
        
        sURL = [sURL stringByAppendingString:@"/apps/verification.asp?"];
        sURL = [sURL stringByAppendingString:@"concode="];
        sURL = [sURL stringByAppendingString:sVerification];
        sURL = [sURL stringByAppendingString:@"&memcode="];
        sURL = [sURL stringByAppendingString:sMemCode];
        
        NSLog(@" This is the verification sUR :===%@=== ", sURL);
        
        NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:sURL]];
        
        (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
    }
    else
    {
        UIAlertController *alert;
        alert = [UIAlertController
                 alertControllerWithTitle:@"Oops..."
                 message:@"Confirmation code cannot be empty"
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
    //NSLog(@"connectionDidFinishLoading");
    //NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    strResult = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"***************This is the return stuff %@", strResult);
    
    //NSString *newstr;
    //newstr = [strResult substringToIndex:3];
    //NSLog(@"This is %@", newstr);
    
    NSString *sSeparator= @"|";
    
    NSRange range = [strResult rangeOfString:sSeparator];
    NSInteger position = range.location + range.length;
    NSString *sWhatIsIt = [strResult substringToIndex:position-1];
    sRemaining = [strResult substringFromIndex:position];
    
    if (!resendCode){
        
        if ([sWhatIsIt isEqualToString:@"OK"]) {  //--- If it is OK, straight away to profileView, no more confirmation Modal.
            
            sMemCode = sRemaining;
            NSLog(@"This is sRemaining %@", sRemaining);
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:sMemCode forKey:@"txtMemCode"];
            [defaults setObject:@"EN" forKey:@"txtLanguage"];
            [defaults setBool:YES forKey:@"registered"];
            
            [defaults synchronize];
            [self dismissLoginAndShowProfile];
            
        } else if ([sWhatIsIt isEqualToString:@"ERR"]) { //--- Modal will pop up.
            
            NSLog(@"==== This is ERR strResult : ===== %@", sRemaining);
            
            UIAlertController * alert; alert = [UIAlertController alertControllerWithTitle:@"ERROR!" message:sRemaining preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancel; cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                             {
                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                                 
                                             }];
            
            [alert addAction:cancel ];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    }else{  //=== ResendCode = YES
        
        if ([sWhatIsIt isEqualToString:@"OK"]) {  //--- OK Resend code send.
            
            NSLog(@"==== This is OK FROM RESEND CODE : ===== %@", sRemaining);
            
            UIAlertController * alert; alert = [UIAlertController alertControllerWithTitle:@"OK!" message:sRemaining preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancel; cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                             {
                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                                 
                                             }];
            
            [alert addAction:cancel ];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else if ([sWhatIsIt isEqualToString:@"ERR"]) { //
            
            NSLog(@"==== This is ERR from RESEND CODE : ===== %@", sRemaining);
            
            UIAlertController * alert; alert = [UIAlertController alertControllerWithTitle:@"ERR!" message:sRemaining preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancel; cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                             {
                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                                 
                                             }];
            
            [alert addAction:cancel ];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }
    
    [self.spinner stopAnimating];
}

- (void)dismissLoginAndShowProfile {
    
    AppDelegate *authObj = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    authObj.authenticated = YES;
    
    [self dismissViewControllerAnimated:NO completion:^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabView = [storyboard instantiateViewControllerWithIdentifier:@"profileView"];
        [self presentViewController:tabView animated:YES completion:nil];
        
    }];
    
}

-(void)dismissKeyboard
{
    [txtVerification resignFirstResponder];
}

-(void)viewDidLayoutSubviews{

    //=== Customize the UITextField
    [self SetTextFieldBorder:txtVerification];
    
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
- (IBAction)btnResend:(id)sender {
    
    //==== From Rsend =====
    resendCode = YES;
    
    //--- Call the stored txtMemCode, something like session ---
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    sMemCode = [defaults objectForKey:@"txtMemCode"];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sURL = appDelegate.gURL;
    sURL = [sURL stringByAppendingString:@"/apps/resendcode.asp?"];
    sURL = [sURL stringByAppendingString:@"memcode="];
    sURL = [sURL stringByAppendingString:sMemCode];
    
    //=== Send the URL to the server ===
    NSLog(@" This is the sURL :===%@=== ", sURL);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:sURL]];
    
    (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


@end
