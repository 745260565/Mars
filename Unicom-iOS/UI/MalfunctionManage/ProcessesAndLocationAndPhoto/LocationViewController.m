//
//  LocationViewController.m
//  Mars
//
//  Created by jiamai on 15/11/17.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "LocationViewController.h"
#import "CHAnootation.h"
#import "Constant.h"
#import "AppDelegate.h"

@import CoreLocation;
@import MapKit;

@interface LocationViewController ()<MKMapViewDelegate>

@end

@implementation LocationViewController
{
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
    CLLocationDegrees i;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dealLongitude = 114.07;
    self.dealLatutude = 22.62;
    [self createUI];
}

- (void)createUI{
    _mapView = [[MKMapView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_mapView];
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;//地图类型，是一个枚举：MKMapTypeStandard :标准地图，一般情况下使用此地图即可满足；MKMapTypeSatellite ：卫星地图；MKMapTypeHybrid ：混合地图，加载最慢比较消耗资源；
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, 40, 40)];
    [button setImage:[UIImage imageNamed:@"iconfont-close"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeMap) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:button];
    UIButton *plusButton = [[UIButton alloc]initWithFrame:CGRectMake(10, kScreenHeight-50, 40, 40)];
    [plusButton setImage:[UIImage imageNamed:@"iconfont-add"] forState:UIControlStateNormal];
    [plusButton addTarget:self action:@selector(plusMap) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:plusButton];
    UIButton *minusButton = [[UIButton alloc]initWithFrame:CGRectMake(10, kScreenHeight-100, 40, 40)];
    [minusButton setImage:[UIImage imageNamed:@"iconfont-move"] forState:UIControlStateNormal];
    [minusButton addTarget:self action:@selector(minusMap) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:minusButton];
    
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-40, 30, 80, 25)];
    labelTitle.text = @"站点位置";
    labelTitle.textColor = [AppDelegate sharedApplicationDelegate].tintColor;
    [_mapView addSubview:labelTitle];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    
    _locationManager = [[CLLocationManager alloc]init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if (![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!= kCLAuthorizationStatusAuthorizedWhenInUse) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    //    if (![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!= kCLAuthorizationStatusAuthorizedWhenInUse) {
    //        [_locationManager requestWhenInUseAuthorization];
    //    }
    _mapView.userTrackingMode = MKUserTrackingModeFollow;//跟踪用户位置跟踪类型，是一个枚举：MKUserTrackingModeNone :不进行用户位置跟踪；MKUserTrackingModeFollow :跟踪用户位置；MKUserTrackingModeFollowWithHeading :跟踪用户位置并且跟踪用户前进方向；
    CLLocation *location = [[CLLocation alloc]initWithLatitude:self.dealLatutude longitude:self.dealLongitude];
    i = 0.05;
    MKCoordinateSpan span = MKCoordinateSpanMake(i, i);
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
    [_mapView setRegion:region animated:NO];
    [_mapView setShowsUserLocation:NO];//定位小蓝点关闭
    [self addAnnotation];
}

- (void)addAnnotation{
    //1.创建大头针对象
    CHAnootation *annotation = [[CHAnootation alloc]init];
    annotation.coordinate = CLLocationCoordinate2DMake(self.dealLatutude, self.dealLongitude);
    annotation.title = self.siteName;
    annotation.subtitle = self.siteCode;
    annotation.image = [UIImage imageNamed:@"icon_paopao_waterdrop_streetscape"];
    //2. 添加到地图
    [_mapView addAnnotation:annotation];//添加大头针，对应的有添加大头针数组
}

//当需要显示大头针时自动调用,返回的视图就是大头针的样子
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[CHAnootation class]]){
        static NSString *annotationIdentifier = @"AnnotaitonID";
        //从队列中dequeue一个大头针视图
        MKAnnotationView *annotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        //如果没有拿到视图，则创建
        if(annotationView == nil){
            annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        }
        //是否允许用户点击,YES为可以点
        annotationView.canShowCallout = YES;
        annotationView.leftCalloutAccessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon"]];
        //大头针的显示视图绑定自己的大头针
        annotationView.annotation = annotation;
        annotationView.image = ((CHAnootation*)annotation).image;
        return annotationView;
    }else{
        //如果返回为nil,大头针使用默认方式显示
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"大头针被点击之后的回调方法");
    
}


- (void)closeMap{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)plusMap{
    i = i/2;
    [_mapView setRegion:MKCoordinateRegionMake(_mapView.centerCoordinate, MKCoordinateSpanMake(i, i)) animated:NO];
}

- (void)minusMap{
    i = 2*i;
    [_mapView setRegion:MKCoordinateRegionMake(_mapView.centerCoordinate, MKCoordinateSpanMake(i, i)) animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
