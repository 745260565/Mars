//
//  GenericCollectionViewCell.m
//  MicroBo
//
//  Created by Franklin Zhang on 1/29/15.
//  Copyright (c) 2015 Macrame. All rights reserved.
//

#import "GenericCollectionViewCell.h"
#import "UIKit+AFNetworking.h"

@implementation GenericCollectionViewCell
- (instancetype)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    if (self) {
        // Custom initialization
        //NSLog(@"rect :%f, %f",aRect.size.width, aRect.size.height);
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, aRect.size.width - 10, aRect.size.width - 10)];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, aRect.size.width, aRect.size.width , 12)];
        _label.font = [UIFont systemFontOfSize:12];
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_label];
        
        _overlayView = [[UIView alloc] initWithFrame:_imageView.frame];
        _overlayView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
        UIImageView *overlayImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_indicator"]];
        overlayImage.frame = CGRectMake(aRect.size.width - 40, aRect.size.width-40, 24, 24);
        [_overlayView addSubview:overlayImage];
        [self.contentView addSubview:_overlayView];
        _overlayView.hidden = YES;
    }
    return self;
}
- (void) loadImage:(NSString*)imageUrl {
    [_imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"grid_image_placeholder"]];
}
#pragma mark - Custom action
- (void) action:(UIMenuController *)menuController
{
    
}
- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    return YES;
}
@end
