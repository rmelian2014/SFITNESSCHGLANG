//
//  ReferFriend.h
//  SFITNESS
//
//  Created by JASON OOI on 13/04/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ReferFriend : UIViewController <MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblInvite;
@property (strong, nonatomic) IBOutlet UILabel *lblWhatsApp;
@property (strong, nonatomic) IBOutlet UILabel *lblSMS;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblLink;
@property (weak, nonatomic) IBOutlet UILabel *lblReferral;

- (IBAction)btnWhatsApp:(id)sender;

- (IBAction)btnSMS:(id)sender;

- (IBAction)btnEmail:(id)sender;

- (IBAction)btnLink:(id)sender;

@end
