//
//  twoColumnTableViewCell.m
//  SFITNESS
//
//  Created by BRO on 04/04/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "twoColumnTableViewCell.h"

@implementation twoColumnTableViewCell

@synthesize lblProfileName;
@synthesize lblProfileData;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
