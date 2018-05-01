//
//  Gym.h
//  SFITNESS
//
//  Created by BRO on 25/01/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<CoreLocation/CoreLocation.h>

@interface Gym : UIViewController<CLLocationManagerDelegate,UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, retain) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UISearchBar *txtGym;

@end
