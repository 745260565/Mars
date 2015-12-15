//
//  CHAnootation.h
//  Mars
//
//  Created by jiamai on 15/11/18.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface CHAnootation : NSObject<MKAnnotation>
@property (nonatomic)CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
//自定义属性,大头什的显示图片
@property (nonatomic, strong)UIImage *image;
@end
