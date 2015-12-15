//
//  GenericCollectionViewCell.h
//  MicroBo
//
//  Created by Franklin Zhang on 1/29/15.
//  Copyright (c) 2015 Macrame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenericCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIView *overlayView;
- (void) loadImage:(NSString*)imageUrl;
@end
