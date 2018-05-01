//
//  More.h
//  SFITNESS
//
//  Created by BRO on 01/02/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface More : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property(strong, nonatomic) NSString *urlString;
@property (nonatomic, strong)UIView *statusBarBackGroundView;

@end
