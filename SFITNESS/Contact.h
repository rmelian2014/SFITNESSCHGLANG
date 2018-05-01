//
//  Contact.h
//  SFITNESS
//
//  Created by JASON OOI on 13/04/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface Contact : UIViewController <UINavigationControllerDelegate,MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UILabel *lblHaveAny;
@property (strong, nonatomic) IBOutlet UILabel *lblQuestions;
@property (strong, nonatomic) IBOutlet UILabel *lblTellUs;

@property(strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;

@end
