//
//  ScanIn.m
//  SFITNESS
//
//  Created by BRO on 28/02/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"
#import "ScanIn.h"
#import "AppDelegate.h"
#import "More.h"

@interface ScanIn (){
    
    AppDelegate *appDelegate;
    NSString *sURL, *sMemCode, *sLanguage;
    NSString *strResult;
}

@property (strong, nonatomic) NSMutableData *responseData;

@end

@implementation ScanIn

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    static QRCodeReaderViewController *vc = nil;
    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    vc                   = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:NO showTorchButton:NO];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    
    vc.delegate = self;
    
    [vc setCompletionWithBlock:^(NSString *resultAsString) {
        NSLog(@"%@", resultAsString);
    }];
    
    [self presentViewController:vc animated:NO completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)loadQRScanner{
 
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *vc = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
           
        });
        vc.delegate = self;
        
        [vc setCompletionWithBlock:^(NSString *resultAsString) {
            
            NSLog(@"Completion with result: %@", resultAsString);
            
            self.responseData = [NSMutableData data];
            
            //--- Call the stored txtMemCode, something like session ---
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            sMemCode = [defaults objectForKey:@"txtMemCode"];
            sLanguage = [defaults objectForKey:@"txtLanguage"];
            
            appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            sURL = appDelegate.gURL;
            sURL = [sURL stringByAppendingString:@"/apps/checkin.asp?"];
            sURL = [sURL stringByAppendingString:@"memcode="];
            sURL = [sURL stringByAppendingString:sMemCode];
            sURL = [sURL stringByAppendingString:@"&lang="];
            sURL = [sURL stringByAppendingString:sLanguage];
            sURL = [sURL stringByAppendingString:@"&fccode="];
            sURL = [sURL stringByAppendingString:resultAsString];
            NSURLRequest *request = [NSURLRequest requestWithURL:
                                     [NSURL URLWithString:sURL]];
            
            NSLog(@" This is the sURL : %@ ", sURL);
            
            (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
        }];
        
        [self presentViewController:vc animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [reader stopScanning];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    //[self dismissViewControllerAnimated:YES completion:^{
    //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
    //}];
    
    self.responseData = [NSMutableData data];
    
    //--- Call the stored txtMemCode, something like session ---
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    sMemCode = [defaults objectForKey:@"txtMemCode"];
    sLanguage = [defaults objectForKey:@"txtLanguage"];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    sURL = appDelegate.gURL;
    sURL = [sURL stringByAppendingString:@"/apps/checkin.asp?"];
    sURL = [sURL stringByAppendingString:@"memcode="];
    sURL = [sURL stringByAppendingString:sMemCode];
    sURL = [sURL stringByAppendingString:@"&lang="];
    sURL = [sURL stringByAppendingString:sLanguage];
    sURL = [sURL stringByAppendingString:@"&fccode="];
    sURL = [sURL stringByAppendingString:result];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:sURL]];
    
    NSLog(@" This is the sURL : %@ ", sURL);
    
    (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
  
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popViewControllerAnimated:YES];
    
    
    //[self.navigationController popToViewController:[self.navigationController. objectAtIndex:1] animated:YES];
        //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //More *initView =  (More*)[storyboard instantiateViewControllerWithIdentifier:@"MoreNavContID"];
    //[initView setModalPresentationStyle:UIModalPresentationFullScreen];
    //[self presentViewController:initView animated:NO completion:nil];
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
    
    strResult = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"This is the return stuff %@", strResult);
    
    if ([strResult rangeOfString:@"OK"].length > 0) {
        
        strResult = [strResult substringFromIndex:3];
        NSLog(@"This is strResult %@", strResult);
        
        UIAlertController *alert; alert = [UIAlertController alertControllerWithTitle:@"Welcome" message:strResult preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok; ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                 {
                                     [self.navigationController popViewControllerAnimated:YES];
                                     
                                 }];
        //*** For the modal ***
        [alert addAction:ok ];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if ([strResult rangeOfString:@"ERR"].length > 0) {
        
        strResult = [strResult substringFromIndex:4];
        NSLog(@"This is strResult %@", strResult);
        
        UIAlertController * alert; alert = [UIAlertController alertControllerWithTitle:@"Error!" message:strResult preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancel; cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                         {
                                             [self.navigationController popViewControllerAnimated:YES];
                                             
                                         }];
        
        [alert addAction:cancel ];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    //[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

@end
