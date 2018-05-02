//
//  AppDelegate.m
//  SFITNESS
//
//  Created by BRO on 24/01/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "AppDelegate.h"
#import "User.h"
//#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>

@import Firebase;
@import UserNotifications;
@import FirebaseMessaging;

@implementation AppDelegate

NSString *const kGCMMessageIDKey = @"gcm.message_id";

@synthesize gURL;
@synthesize slatitude;
@synthesize slongitude;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	//=== Get current location ===
	if (locationManager == nil)
	{
		locationManager = [[CLLocationManager alloc] init];
		locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
		locationManager.delegate = self;
		
		//-- Pop up authrorization to use current location ---
		[locationManager requestAlwaysAuthorization];
	}
	
	[locationManager startUpdatingLocation];
	
	//=== FireBase Begin===
	// [FIRApp configure];
	
	if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
		UIUserNotificationType allNotificationTypes =
		(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
		UIUserNotificationSettings *settings =
		[UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
		//[[UIApplication sharedApplication] registerUserNotificationSettings:settings];
		[application registerUserNotificationSettings:settings];
	} else {
		// iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
		// For iOS 10 display notification (sent via APNS)
		[UNUserNotificationCenter currentNotificationCenter].delegate = self;
		UNAuthorizationOptions authOptions =
		UNAuthorizationOptionAlert
		| UNAuthorizationOptionSound
		| UNAuthorizationOptionBadge;
		[[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
		}];
		
		
		// For iOS 10 data message (sent via FCM)
		//[[FIRMessaging messaging] setDelegate:self];
		//[FIRMessaging messaging].delegate = self;
		
#endif
	}
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
												 name:kFIRInstanceIDTokenRefreshNotification object:nil];
	[application registerForRemoteNotifications];
	//==== END Firebase ====
	
	//--- Set ALL Status Bar Background color to White
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	[application setStatusBarHidden:NO];
	UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
	if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
		statusBar.backgroundColor = [UIColor whiteColor];
	}
	
	//gURL = @"http://192.168.0.28";
	
	gURL = @"https://www.share-fitness.com";
	
	//--- This is to authenticate User whether registered or not registered
	User *userObj = [[User alloc] init];
	self.authenticated = [userObj userAuthenticated];
	
	//[GMSServices provideAPIKey:@"AIzaSyBJvZbCA-BiAE3HBgdrm6TTjAiVkYTU9Kk"];
	[GMSPlacesClient provideAPIKey:@"AIzaSyBJvZbCA-BiAE3HBgdrm6TTjAiVkYTU9Kk"];
	
	[self setupTabBar];
	
	return YES;
}

+ (NSString*)getCurrentLang {
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *sLanguage = [defaults objectForKey:@"txtLanguage"];
	if(sLanguage == nil) {
		return @"EN";
	}else{
		return sLanguage;
	}
}

+ (NSString*)getLocalizedTableName {
	return [NSString stringWithFormat:@"Localizable_%@",[[self getCurrentLang]lowercaseString]];
}

+ (NSString*)getLocalizedText:(NSString*)toLocalize {
	return NSLocalizedStringFromTable(toLocalize, [AppDelegate getLocalizedTableName], @"");
}


- (void)setupTabBar {
	
	UITabBarController * tabBarController = (UITabBarController*)[self.window rootViewController];
	
	if(tabBarController != nil) {
		((UIViewController*)[tabBarController.viewControllers objectAtIndex:1]).tabBarItem.title = [AppDelegate getLocalizedText:@"CLASS"];
		((UIViewController*)[tabBarController.viewControllers objectAtIndex:2]).tabBarItem.title = [AppDelegate getLocalizedText:@"GYM"];
		((UIViewController*)[tabBarController.viewControllers objectAtIndex:3]).tabBarItem.title = [AppDelegate getLocalizedText:@"SEARCH"];
		((UIViewController*)[tabBarController.viewControllers objectAtIndex:4]).tabBarItem.title =  [AppDelegate getLocalizedText:@"MORE"];
	}
}

- (void)locationManager: (CLLocationManager *)manager didUpdateToLocation: (CLLocation *)newLocation fromLocation: (CLLocation *)oldLocation
{
	
	float latitude = newLocation.coordinate.latitude;
	slatitude = [NSString stringWithFormat:@"%f",latitude];
	float longitude = newLocation.coordinate.longitude;
	slongitude = [NSString stringWithFormat:@"%f", longitude];
	
	//NSLog(@"App:This is the latitude%@", slatitude);
	//NSLog(@"App:This is the longitude%@", slongitude);
	
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	NSLog(@"Cannot find the location.");
}



- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	[self connectToFcm];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//===== Firebase Stuff ======

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	// If you are receiving a notification message while your app is in the background,
	// this callback will not be fired till the user taps on the notification launching the application.
	// TODO: Handle data of notification
	
	// Print message ID.
	if (userInfo[kGCMMessageIDKey]) {
		NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
	}
	
	// Print full message.
	NSLog(@" **1 : %@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
	// If you are receiving a notification message while your app is in the background,
	// this callback will not be fired till the user taps on the notification launching the application.
	// TODO: Handle data of notification
	
	// Print message ID.
	if (userInfo[kGCMMessageIDKey]) {
		NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
	}
	
	// Print full message.
	NSLog(@"**2 : %@", userInfo);
	
	completionHandler(UIBackgroundFetchResultNewData);
}
// [END receive_message]

// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
	   willPresentNotification:(UNNotification *)notification
		 withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
	// Print message ID.
	NSDictionary *userInfo = notification.request.content.userInfo;
	if (userInfo[kGCMMessageIDKey]) {
		NSLog(@"**3 :  Message ID: %@", userInfo[kGCMMessageIDKey]);
	}
	
	// Print full message.
	NSLog(@" **4 : %@", userInfo);
	
	// Change this to your preferred presentation option
	completionHandler(UNNotificationPresentationOptionNone);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response
#if defined(__IPHONE_11_0)
		 withCompletionHandler:(void(^)(void))completionHandler {
#else
withCompletionHandler:(void(^)())completionHandler {
#endif
	NSDictionary *userInfo = response.notification.request.content.userInfo;
	if (userInfo[kGCMMessageIDKey]) {
		NSLog(@" **5 : Message ID: %@", userInfo[kGCMMessageIDKey]);
	}
	
	// Print full message.
	NSLog(@" **6 :  %@", userInfo);
	
	completionHandler();
}
#endif
	// [END ios_10_message_handling]
	
	// [START refresh_token]
	- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
		NSLog(@"FCM AppleDelegate registration token: %@", fcmToken);
		
		// TODO: If necessary send token to application server.
		// Note: This callback is fired at each app startup and whenever a new token is generated.
	}
	// [END refresh_token]
	
	// [START ios_10_data_message]
	// Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
	// To enable direct data messages, you can set [Messaging messaging].shouldEstablishDirectChannel to YES.
	- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage {
		NSLog(@" **7  Received data message: %@", remoteMessage.appData);
	}
	// [END ios_10_data_message]
	
	// [START refresh_token]
	- (void)tokenRefreshNotification:(NSNotification *)notification {
		// Note that this callback will be fired everytime a new token is generated, including the first
		// time. So if you need to retrieve the token as soon as it is available this is where that
		// should be done.
		NSString *refreshedToken = [[FIRInstanceID instanceID] token];
		NSLog(@" **8 : InstanceID token: %@", refreshedToken);
		
		// Connect to FCM since connection may have failed when attempted before having a token.
		[self connectToFcm];
		
		// TODO: If necessary send token to application server.
	}
	// [END refresh_token]
	
	// [START connect_to_fcm]
	- (void)connectToFcm {
		// Won't connect since there is no token
		if (![[FIRInstanceID instanceID] token]) {
			return;
		}
		
		// Disconnect previous FCM connection if it exists.
		[[FIRMessaging messaging] disconnect];
		
		[[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
			if (error != nil) {
				NSLog(@" **10 : Unable to connect to FCM. %@", error);
			} else {
				NSLog(@" **11 Connected to FCM.");
				
				
				// Subscribe Topic is here because FIREBASE need to be fully loaded
				// before topic can be subscribed.
				NSString *token = [[FIRInstanceID instanceID] token];
				NSLog(@" **12 InstanceID token: %@", token);
				
				// [START subscribe_topic]
				[[FIRMessaging messaging] subscribeToTopic:@"/topics/GXLM"];
				NSLog(@"Subscribed to news topic");
				// [END subscribe_topic]
			}
		}];
		
		
	}
	// [END connect_to_fcm]
	
	- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
		NSLog(@" **13 : Unable to register for remote notifications: %@", error);
	}
	
	// This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
	// If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
	// the InstanceID token.
	- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
		NSLog(@" **14 : APNs token retrieved: %@", deviceToken);
		
		// With swizzling disabled you must set the APNs token here.
		[[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeSandbox];
		
	}
	
	
	
	
	
	
	@end
