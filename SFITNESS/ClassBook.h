//
//  ClassBook.h
//  SFITNESS
//
//  Created by BRO on 24/01/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassBook : UIViewController

@property(strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
