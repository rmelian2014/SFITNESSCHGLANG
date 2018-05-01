//
//  GymDet.h
//  SFITNESS
//
//  Created by BRO on 25/01/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GymDet : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property(strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) UIBarButtonItem *btnFav;

@end
