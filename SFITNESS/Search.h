//
//  Search.h
//  SFITNESS
//
//  Created by BRO on 25/01/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVPlaceSearchTextField.h"

@interface Search : UIViewController <PlaceSearchTextFieldDelegate,UISearchBarDelegate,UITextFieldDelegate,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblStart;
@property (strong, nonatomic) IBOutlet UILabel *lblEnd;
@property (nonatomic, weak) IBOutlet UILabel *lblLocation;
@property (nonatomic, weak) IBOutlet UILabel *lblActivity;
@property (nonatomic, weak) IBOutlet UILabel *lblrangeSlider;
@property (weak, nonatomic) IBOutlet MVPlaceSearchTextField *txtPlaceSearch;
@property (strong, nonatomic) IBOutlet UITextField *txtActivity;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSMutableArray *categoryMArray;
@property (strong, nonatomic) UITableView *autocompleteTableView;
@property (strong, nonatomic) NSMutableArray *autocompleteMArray;
@property (strong, nonatomic) NSString *sSelectedAdd;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;

- (IBAction)btnSearch:(id)sender;
- (IBAction)dissmissKeyboardOnTap:(id)sender;

@end
