//
//  MapLocationViewController.m
//  Unicom-iOS
//
//  Created by Franklin Zhang on 15/12/3.
//  Copyright © 2015年 Runsdata. All rights reserved.
//

#import "MapLocationViewController.h"

@interface MapLocationViewController ()
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentLocation,destinationCoordinate2D;
    LocationAnnotation *locationAnnotation;
    
    NSString *locationTitle, *locationSubtitle;
    
    MKPointAnnotation *lastPointAnnotation;
    UIView *rootModalView;
    UIView *datePicker;
    NSString *targetDate;
    UIBarButtonItem *dateSelectButton;
    NSDateFormatter *dateFormatter;
    MKMapCamera *currentCamera;
    UIButton *centerButton, *dimensionButton;
}
@end

@implementation MapLocationViewController


- (id)initWithCoordinate:(CLLocationCoordinate2D)destinationCoordinate
{
    self = [super init];
    destinationCoordinate2D = destinationCoordinate;
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithCoordinate:(CLLocationCoordinate2D)destinationCoordinate withLocationTitle:(NSString *)titleString withLocationSubtitle:(NSString *)subtitleStrig
{
    self = [super init];
    if (self) {
        // Custom initialization
        destinationCoordinate2D = destinationCoordinate;
        locationTitle = titleString;
        locationSubtitle = subtitleStrig;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (locationTitle != nil && locationSubtitle != nil) {
        locationAnnotation = [[LocationAnnotation alloc] initWithTitle:locationTitle andSubtitle:locationSubtitle forCoordinate:destinationCoordinate2D];
    }else{
        locationAnnotation = [[LocationAnnotation alloc] initWithTitle:@"" andSubtitle:@"" forCoordinate:destinationCoordinate2D];
    }
    
    [mainMapView addAnnotation:locationAnnotation];
    
    mainMapView.showsUserLocation = YES;
    
    
    
    
    MKMapItem *sourcePosition = [MKMapItem mapItemForCurrentLocation];
    
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoordinate2D addressDictionary:nil];
    MKMapItem *destinationPosition = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    
    //[MKMapItem openMapsWithItems:[NSArray arrayWithObject:fromPosition] launchOptions:[NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithMKCoordinate:region.center], MKLaunchOptionsMapCenterKey, [NSValue valueWithMKCoordinateSpan:region.span], MKLaunchOptionsMapSpanKey, nil]];
    //[self findDirectionsForm:sourcePosition to:destinationPosition];
}
- (void)loadView
{
    [super loadView];
    // Do any additional setup after loading the view.
    [self buildLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) buildLayout
{
    //UIImage *navigationBarImage = [UIImage imageNamed:@"top_bar_background"];
    
    //self.title = windowTitle;
    
    
    
    mainMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainMapView.rotateEnabled = NO;
    mainMapView.showsUserLocation = YES;
    mainMapView.delegate = self;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 100.0f;
    [locationManager startUpdatingLocation];
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    MKCoordinateRegion region;
    //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(fromLocation.coordinate, 10000, 10000);
    region.center = [locationManager location].coordinate;
    region.span = span;
    [mainMapView setRegion:region animated:YES];
    [self.view addSubview:mainMapView];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    

    
    //annotationView se
}

- (void) doneAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}

- (void) findDirectionsForm:(MKMapItem *) sourcePosition to:(MKMapItem *) destinationPosition
{
    MKDirectionsRequest *directionRequest = [[MKDirectionsRequest alloc] init];
    directionRequest.source = sourcePosition;
    directionRequest.destination = destinationPosition;
    //directionRequest.requestsAlternateRoutes = NO;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if(error)
        {
            NSLog(@"Fail to find directions");
            for(NSString *key in error.userInfo){
                NSLog(@"direction error-%@: %@",key,[error.userInfo objectForKey:key]);
            }
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"Common.Failure",nil)
                                  message:[error.userInfo objectForKey:@"NSLocalizedDescription"]
                                  delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Common.OK",nil)
                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            [self showDirectionsOnMap:response];
        }
    }];
}
- (void) showDirectionsOnMap:(MKDirectionsResponse *) response
{
    for(MKRoute *route in response.routes)
    {
        [mainMapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    }
    [mainMapView addAnnotation:response.source.placemark];
    [mainMapView addAnnotation:response.destination.placemark];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    if([annotation isKindOfClass:mapView.userLocation.class])
    {
        return nil;
    }
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ID"];
    if(pinView == nil)
    {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ID"];
        
        pinView.canShowCallout = YES;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 100)];
        pinView.leftCalloutAccessoryView = view;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.rightCalloutAccessoryView = button;
    }
    
    
    return pinView;
}

@end
