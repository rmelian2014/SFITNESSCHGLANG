//
//  ProfileEdit.h
//  SFITNESS
//
//  Created by BRO on 05/04/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DownPicker/DownPicker.h>
#import <DownPicker/UIDownPicker.h>

@interface ProfileEdit : UIViewController <UITextFieldDelegate,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *profileData;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;
@property (strong, nonatomic) IBOutlet UILabel *lblAdd1;
@property (strong, nonatomic) IBOutlet UITextField *txtAdd1;
@property (strong, nonatomic) IBOutlet UILabel *lblAdd2;
@property (strong, nonatomic) IBOutlet UITextField *txtAdd2;
@property (strong, nonatomic) IBOutlet UILabel *lblAdd3;
@property (strong, nonatomic) IBOutlet UITextField *txtAdd3;
@property (strong, nonatomic) IBOutlet UILabel *lblPostCode;
@property (strong, nonatomic) IBOutlet UITextField *txtPostCode;
@property (strong, nonatomic) IBOutlet UILabel *lblState;
@property (strong, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UIDownPicker *downState;
@property (strong, nonatomic) IBOutlet UILabel *lblCountry;
@property (strong, nonatomic) IBOutlet UITextField *txtCountry;
@property (weak, nonatomic) IBOutlet UIDownPicker *downCountry;
@property (strong, nonatomic) IBOutlet UILabel *lblGender;
@property (strong, nonatomic) IBOutlet UITextField *txtGender;
@property (weak, nonatomic) IBOutlet UIDownPicker *downGender;

@property (nonatomic) DownPicker *pickerState;
@property (nonatomic) DownPicker *pickerCountry;
@property (nonatomic) DownPicker *pickerGender;

@property (strong, nonatomic) NSMutableData *responseData;

@property (strong, nonatomic) NSMutableArray *stateMArray;
@property (strong, nonatomic) NSMutableArray *countryMArray;
@property (strong, nonatomic) NSMutableArray *dataFromProfile;
@property (strong, nonatomic) UITableView *autocompleteTableView;
@property (strong, nonatomic) NSMutableArray *autocompleteMArray;

@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;

- (IBAction)btnUpdate:(id)sender;

@end
