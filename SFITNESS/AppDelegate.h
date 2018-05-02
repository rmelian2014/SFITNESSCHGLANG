//
//  AppDelegate.h
//  SFITNESS
//
//  Created by BRO on 24/01/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    CLLocationManager *locationManager;
    UITabBar *tabBar;
    UITabBarItem *tabBarItem1;
    UITabBarItem *tabBarItem2;
    UITabBarItem *tabBarItem3;
    UITabBarItem *tabBarItem4;
    UITabBarItem *tabBarItem5;
}

@property (nonatomic, strong) NSString *slatitude;
@property (nonatomic, strong) NSString *slongitude;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSString *gURL;
@property (nonatomic) BOOL authenticated;
@property (nonatomic,strong)UITabBarController *tabBarController;

-(void)setupTabBar;

+ (NSString*)getLocalizedText:(NSString*)toLocalize;

@end

