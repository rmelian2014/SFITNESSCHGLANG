//
//  ViewController.m
//  TestTermAndPolicy
//
//  Created by JASON OOI on 20/04/2018.
//  Copyright © 2018 JASON OOI. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize label;
@synthesize layoutManager;
@synthesize textContainer;
@synthesize textStorage;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    //===== For lblTermPolicy ======================================
    NSString *fullString = @"I agree to the Terms and Policy";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:fullString];
    
    //For underline
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:[fullString rangeOfString:@"Terms"]];
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:[fullString rangeOfString:@"Policy"]];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.05 green:0.4 blue:0.65 alpha:1.0] range:[fullString rangeOfString:@"Terms"]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.05 green:0.4 blue:0.65 alpha:1.0] range:[fullString rangeOfString:@"Policy"]];
    
    // Setting attributed string to textview
    label.attributedText = attributedString;
    
    // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:attributedString];
    
    // Configure layoutManager and textStorage
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    
    // Configure textContainer
    textContainer.lineFragmentPadding = 0.0;
    textContainer.lineBreakMode = label.lineBreakMode;
    textContainer.maximumNumberOfLines = label.numberOfLines;
    
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnLabel:)]];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.textContainer.size = self.label.bounds.size;
}

- (void)handleTapOnLabel:(UITapGestureRecognizer *)tapGesture
{
    
    CGPoint locationOfTouchInLabel = [tapGesture locationInView:tapGesture.view];
    CGSize labelSize = tapGesture.view.bounds.size;
    CGRect textBoundingBox = [self.layoutManager usedRectForTextContainer:self.textContainer];
    CGPoint textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                              (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
    CGPoint locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                         locationOfTouchInLabel.y - textContainerOffset.y);
    NSInteger indexOfCharacter = [self.layoutManager characterIndexForPoint:locationOfTouchInTextContainer
                                                            inTextContainer:self.textContainer
                                   fractionOfDistanceBetweenInsertionPoints:nil];
    NSRange termsLinkRange = NSMakeRange(15, 5); // it's better to save the range somewhere when it was originally used for marking link in attributed string
    NSRange policyLinkRange = NSMakeRange(25, 6);
    if (NSLocationInRange(indexOfCharacter, termsLinkRange)) {
        NSLog(@"This is terms");
        
        // Open an URL, or handle the tap on the text TERMS
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://stackoverflow.com/"]];
    }else if(NSLocationInRange(indexOfCharacter, policyLinkRange)){
        NSLog(@"This is policy");
        // Open an URL, or handle the tap on the text POLICY
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://stackoverflow.com/"]];
    }
    
    [self performSegueWithIdentifier:@"Terms" sender:self];
}


@end
