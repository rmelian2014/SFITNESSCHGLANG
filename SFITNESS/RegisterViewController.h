//
//  RegisterViewController.h
//  SFITNESS
//
//  Created by BRO on 08/02/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import <DownPicker/UIDownPicker.h>

@protocol LoginViewProtocol <NSObject>

- (void)dismissAndLoginView;

@end

@interface RegisterViewController : UIViewController

@property (nonatomic, weak) id <LoginViewProtocol> delegate;
@property (nonatomic, retain) LoginViewController *loginView2;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;
@property (strong, nonatomic) IBOutlet UITextField *txtCode;
@property (strong, nonatomic) IBOutlet UITextField *txtCountry;
@property (weak, nonatomic) IBOutlet UIDownPicker *downCountry;
@property (strong, nonatomic) IBOutlet UITextField *txtReferCode;

@property (strong, nonatomic) IBOutlet UILabel *lblTermPolicy;
@property (strong, nonatomic) IBOutlet UILabel *lblPolicy;


@property (strong, nonatomic) IBOutlet UIButton *btnCheck;

@property (strong, nonatomic) IBOutlet UIButton *btnSendVeri;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSMutableArray *countryMArray;
@property (strong, nonatomic) NSMutableArray *codeMArray;

@property (nonatomic) DownPicker *pickerCountry;

@property (strong,nonatomic) NSTextContainer *textContainer;
@property (strong,nonatomic) NSLayoutManager *layoutManager;
//@property (strong,nonatomic) NSTextStorage *textStorage;
- (IBAction)btnCheck:(id)sender;

- (IBAction)btnSendVeri:(id)sender;

@end
