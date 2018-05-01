//
//  Classes.h
//  SFITNESS
//
//  Created by BRO on 24/01/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<CoreLocation/CoreLocation.h>

@interface Classes : UIViewController<CLLocationManagerDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UIView *selectionBar;
@property (nonatomic, strong)NSMutableArray *dtDate;
@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic) BOOL hasAppearedFlag; //%%% prevents reloading (maintains state)
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong)UIView *navigationView;
@property (nonatomic, strong)NSString *sURL;
@property (nonatomic, strong)NSString *sURLFromSearch;
@property (nonatomic, strong)NSString *sCordinatesFromSearch;

@property(strong, nonatomic) NSString *data;


- (void)fromSearch:(NSString*)string;

@end

