//
//  LocationAnnotation.h
//  Unicom-iOS
//
//  Created by Franklin Zhang on 15/12/3.
//  Copyright © 2015年 Runsdata. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>
@interface LocationAnnotation : NSObject<MKAnnotation>
{
    NSString *annotationTitle;
    NSString *annotationSubtitle;
    CLLocationCoordinate2D annotationCoordinate;
}
- (id) initWithTitle:(NSString *)title andSubtitle:(NSString *) subtitle forCoordinate:(CLLocationCoordinate2D) coordinate;

@end
