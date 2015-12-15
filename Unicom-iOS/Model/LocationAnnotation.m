//
//  LocationAnnotation.m
//  Unicom-iOS
//
//  Created by Franklin Zhang on 15/12/3.
//  Copyright © 2015年 Runsdata. All rights reserved.
//

#import "LocationAnnotation.h"

@implementation LocationAnnotation
- (id) initWithTitle:(NSString *)title andSubtitle:(NSString *) subtitle forCoordinate:(CLLocationCoordinate2D) coordinate
{
    if(self = [super init])
    {
        annotationTitle = title;
        annotationSubtitle = subtitle;
        annotationCoordinate = coordinate;
    }
    return self;
}
- (NSString *) title
{
    return annotationTitle;
}
- (NSString *) subtitle
{
    return annotationSubtitle;
}
- (CLLocationCoordinate2D) coordinate
{
    return annotationCoordinate;
}
@end
