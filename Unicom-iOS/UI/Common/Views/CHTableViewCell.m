//
//  CHTableViewCell.m
//  Mars
//
//  Created by jiamai on 15/11/12.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "CHTableViewCell.h"

@implementation CHTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
