//
//  Contact.m
//  SFITNESS
//
//  Created by JASON OOI on 13/04/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "Contact.h"

@interface Contact (){
    
    //AppDelegate *appDelegate;
    NSString *sEmail, *sLanguage;
}

@end

@implementation Contact
@synthesize webView;
@synthesize lblEmail;
@synthesize lblPhone;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //=== Call the stored txtMemCode, something like session ---
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    sLanguage = [defaults objectForKey:@"txtLanguage"];
    

    NSDictionary *linkAttributes = @{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.05 green:0.4 blue:0.65 alpha:1.0],
                                      NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
    
    //===== For lbl Email ======================================
    if ([sLanguage isEqualToString:@"CN"]){
        _lblHaveAny.text = @"有任何技术问题?";
        _lblTellUs.text = @"有任何疑问关于SHARE FITNESS？";
        _lblQuestions.text = @"告诉我们你有什么想法，我们会尽快回复你。";
        NSMutableAttributedString *attributedStringEmail = [[NSMutableAttributedString alloc] initWithString:@"邮件: support@share-fitness.com" attributes:nil];
        
        NSRange linkRangeEmail = NSMakeRange(4, 25); //=== for the word "support@share-fitness.com" in the string above
        
        [attributedStringEmail setAttributes:linkAttributes range:linkRangeEmail];
        
        // Assign attributedText to UILabel
        lblEmail.attributedText = attributedStringEmail;
        
    }else{
        NSMutableAttributedString *attributedStringEmail = [[NSMutableAttributedString alloc] initWithString:@"Email: support@share-fitness.com" attributes:nil];
        
        NSRange linkRangeEmail = NSMakeRange(7, 25); //=== for the word "ask@share-fitness.com" in the string above
        [attributedStringEmail setAttributes:linkAttributes range:linkRangeEmail];
        
        // Assign attributedText to UILabel
        lblEmail.attributedText = attributedStringEmail;
        
    }

    lblEmail.userInteractionEnabled = YES;
    [lblEmail addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnLabelEmail:)]];
     
    //====== For lbl Phone ==================================================
    
    if ([sLanguage isEqualToString:@"CN"]){
        
        NSMutableAttributedString *attributedStringPhone = [[NSMutableAttributedString alloc] initWithString:@"电话: 03-95439643" attributes:nil];
        NSRange linkRangePhone = NSMakeRange(4, 11); //=== for the word "03-95439643" in the string above
        
        [attributedStringPhone setAttributes:linkAttributes range:linkRangePhone];
        // Assign attributedText to UILabel
        lblPhone.attributedText = attributedStringPhone;
        
    } else {
        
        NSMutableAttributedString *attributedStringPhone = [[NSMutableAttributedString alloc] initWithString:@"Tel: 03-95439643" attributes:nil];
        NSRange linkRangePhone = NSMakeRange(5, 11); //=== for the word "03-95439643" in the string above
        
        [attributedStringPhone setAttributes:linkAttributes range:linkRangePhone];
        // Assign attributedText to UILabel
        lblPhone.attributedText = attributedStringPhone;
    }

    lblPhone.userInteractionEnabled = YES;
    [lblPhone addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnLabelPhone:)]];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //====Make the navigation Bar appear===
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault]; self.navigationController.navigationBar.shadowImage = nil; self.navigationController.navigationBar.translucent = NO;
    //=== Set the navigation Back < color
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor : [ UIColor grayColor]];
    //=== Set the navigation Bar text color
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    if ([sLanguage isEqualToString:@"CN"]){
        
        self.navigationController.navigationBar.topItem.title = @"联系我们";
        
    }
}

- (void)handleTapOnLabelPhone:(UITapGestureRecognizer *)tapGesture{
    
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString: @"tel:+60395439643"] options:@{} completionHandler:nil];
}

- (void)handleTapOnLabelEmail:(UITapGestureRecognizer *)tapGesture{
//check mail service is configure to your device or not.
if ([MFMailComposeViewController canSendMail]) {
    
    // get a new new MailComposeViewController object
    MFMailComposeViewController * composeVC = [MFMailComposeViewController new];
    
    // his class should be the delegate of the composeVC
    composeVC.mailComposeDelegate = self;
    
    // set a mail subject ... but you do not need to do this :)
    //[composeVC setSubject:@"Join us at Share Fitness!"];
    
    // set some basic plain text as the message body ... but you do not need to do this :)
    //[composeVC setMessageBody:sMessage isHTML:NO];
    
    // set some recipients ... but you do not need to do this :)
    [composeVC setToRecipients:[NSArray arrayWithObjects:@"ask@share-fitness.com", nil]];
    
    // Present the view controller modally.
    
    [self presentViewController:composeVC animated:true completion:nil];
} else {
    
    NSLog(@"Mail services are not available or configure to your device");
    
    UIAlertController * alert; alert = [UIAlertController alertControllerWithTitle:@"ERROR!" message:@"Mail services are not available or configure to your device" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel; cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         //=== Go back one VC
                                         [self.navigationController popViewControllerAnimated:YES];
                                     }];
    
    [alert addAction:cancel ];
    [self presentViewController:alert animated:YES completion:nil];
}
}

// delegate function callback
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // switchng the result
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled.");
            /*
             Execute your code for canceled event here ...
             */
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved.");
            /*
             Execute your code for email saved event here ...
             */
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent.");
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Sent" message:@"Send Succesfully"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send error: %@.", [error localizedDescription]);
            /*
             Execute your code for email send failed event here ...
             */
            break;
            
        default:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error :-("
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
    // Dismiss the mail compose view controller.
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}

@end
