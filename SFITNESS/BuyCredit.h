//
//  BuyCredit.h
//  SFITNESS
//
//  Created by BRO on 05/03/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyCredit : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property(strong, nonatomic) NSString *urlString;

- (void)fromClassBook:(NSString*)string;

@end
