//
//  FirstViewController.m
//  TestNSNotification
//
//  Created by JASON OOI on 18/04/2018.
//  Copyright © 2018 JASON OOI. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (IBAction)btnSend:(id)sender {
    
    self.tabBarController.selectedIndex = 1;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"TestNotification"
     object:self];
}


@end
