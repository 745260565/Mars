//
//  BadgeView.m
//  TabPageController
//
//  Created by Franklin Zhang on 12/8/15.
//  Copyright © 2015 macrame. All rights reserved.
//

#import "BadgeView.h"

@implementation BadgeView
@synthesize badgeLabel = badgeLabel;
- (instancetype)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    if (self) {
        // Custom initialization
        
        
        self.backgroundColor = [UIColor redColor];
        
        //                badgeLabelArray
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = aRect.size.height/2;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:0.8] CGColor];
        //self.userInteractionEnabled = YES;
        
        badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, aRect.size.width - 2, aRect.size.height - 2)];
        badgeLabel.textColor = [UIColor whiteColor];
        badgeLabel.font = [UIFont systemFontOfSize:12];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:badgeLabel];
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
