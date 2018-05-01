//
//  About.h
//  SFITNESS
//
//  Created by JASON OOI on 13/04/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface About : UIViewController

@property(strong, nonatomic) NSString *urlString;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
