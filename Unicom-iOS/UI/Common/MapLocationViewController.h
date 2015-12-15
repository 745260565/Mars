//
//  MapLocationViewController.h
//  Unicom-iOS
//
//  Created by Franklin Zhang on 15/12/3.
//  Copyright © 2015年 Runsdata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "LocationAnnotation.h"
@interface MapLocationViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>
{
    MKMapView *mainMapView;
}
- (id)initWithCoordinate:(CLLocationCoordinate2D)destinationCoordinate;
- (id)initWithCoordinate:(CLLocationCoordinate2D)destinationCoordinate withLocationTitle:(NSString *)locationTitle withLocationSubtitle:(NSString *)locationSubtitle;
@end
