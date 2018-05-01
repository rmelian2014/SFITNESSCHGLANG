//
//  ProfileChgLang.h
//  SFITNESS
//
//  Created by JASON OOI on 19/04/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileChgLang : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *btnEnglish;
@property (strong, nonatomic) IBOutlet UIButton *btnChinese;

- (IBAction)btnEnglish:(id)sender;
- (IBAction)btnChinese:(id)sender;

@end
