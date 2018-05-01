//
//  RootViewController.h
//  Mytest
//
//  Created by Dimitris Bouzikas on 2/19/14.
//  Copyright (c) 2014 com.bloomarank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import <DownPicker/UIDownPicker.h>

@protocol LoginViewProtocol <NSObject>

- (void)dismissAndLoginView;

@end

@interface RootViewController : UIViewController <UITextFieldDelegate,UITableViewDelegate>

@property (nonatomic, weak) id <LoginViewProtocol> delegate;
@property (nonatomic, retain) LoginViewController *loginView;
@property (strong, nonatomic) IBOutlet UITextField *txtCountry;
@property (weak, nonatomic) IBOutlet UIDownPicker *downCountry;
@property (strong, nonatomic) IBOutlet UITextField *txtCode;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIButton *btnSendVeri;

@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSMutableArray *countryMArray;
@property (strong, nonatomic) NSMutableArray *codeMArray;
@property (nonatomic) DownPicker *pickerCountry;


- (IBAction)btnSendVeri:(UIButton *)sender;
- (IBAction)btnRegister:(UIButton *)sender;

@end
