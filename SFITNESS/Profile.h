//
//  Profile.h
//  SFITNESS
//
//  Created by BRO on 02/03/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Profile : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSMutableArray *profileData;
@property (strong, nonatomic) NSMutableArray *arrayForTableView;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblPoints;
@property (strong, nonatomic) IBOutlet UILabel *lblRewards;

@property (strong, nonatomic) IBOutlet UIButton *btnEditProfile;
@property (strong, nonatomic) IBOutlet UIButton *btnChgLang;
@property (strong, nonatomic) IBOutlet UIButton *btnLogOut;

@property (strong, nonatomic) IBOutlet UITableView *profileTableView;

- (IBAction)btnEditProfile:(id)sender;
- (IBAction)btnChgLang:(id)sender;
- (IBAction)btnLogOut:(id)sender;

@end
