//
//  ViewController.m
//  MapView的使用
//
//  Created by 陈高健 on 15/11/29.
//  Copyright © 2015年 陈高健. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController ()<MKMapViewDelegate>
//mapView
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic,strong)CLLocationManager *locationManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CLLocationManager *locationManager=[[CLLocationManager alloc]init];
    self.locationManager=locationManager;
    
    //请求授权
    [locationManager requestWhenInUseAuthorization];

    /*
     MKUserTrackingModeNone  不进行用户位置跟踪
     MKUserTrackingModeFollow  跟踪用户的位置变化
     MKUserTrackingModeFollowWithHeading  跟踪用户位置和方向变化
     */
    //设置用户的跟踪模式
    self.mapView.userTrackingMode=MKUserTrackingModeFollow;
    /*
     MKMapTypeStandard  标准地图
     MKMapTypeSatellite    卫星地图
     MKMapTypeHybrid      鸟瞰地图
     MKMapTypeSatelliteFlyover
     MKMapTypeHybridFlyover
     */
    self.mapView.mapType=MKMapTypeStandard;
    //实时显示交通路况
    self.mapView.showsTraffic=YES;
    //设置代理
    self.mapView.delegate=self;
    
}

/**
 *  跟踪到用户位置时会调用该方法
 *  @param mapView   地图
 *  @param userLocation 大头针模型
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //创建编码对象
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    //反地理编码
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error!=nil || placemarks.count==0) {
            return ;
        }
        //获取地标
        CLPlacemark *placemark=[placemarks firstObject];
        //设置标题
        userLocation.title=placemark.locality;
        //设置子标题
        userLocation.subtitle=placemark.name;
    }];
    
}
//回到当前位置
- (IBAction)backCurrentLocation:(id)sender {
    
    MKCoordinateSpan span=MKCoordinateSpanMake(0.021251, 0.016093);
    
    [self.mapView setRegion:MKCoordinateRegionMake(self.mapView.userLocation.coordinate, span) animated:YES];
}

//当区域改变时调用
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //获取系统默认定位的经纬度跨度
    NSLog(@"维度跨度:%f,经度跨度:%f",mapView.region.span.latitudeDelta,mapView.region.span.longitudeDelta);
}

//缩小地图
- (IBAction)minMapView:(id)sender {
   
    //获取维度跨度并放大一倍
    CGFloat latitudeDelta = self.mapView.region.span.latitudeDelta * 2;
    //获取经度跨度并放大一倍
    CGFloat longitudeDelta = self.mapView.region.span.longitudeDelta * 2;
    //经纬度跨度
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
    //设置当前区域
    MKCoordinateRegion region = MKCoordinateRegionMake(self.mapView.centerCoordinate, span);
    
    [self.mapView setRegion:region animated:YES];
}
//放大地图
- (IBAction)maxMapView:(id)sender {
    
    //获取维度跨度并缩小一倍
    CGFloat latitudeDelta = self.mapView.region.span.latitudeDelta * 0.5;
    //获取经度跨度并缩小一倍
    CGFloat longitudeDelta = self.mapView.region.span.longitudeDelta * 0.5;
    //经纬度跨度
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
    //设置当前区域
    MKCoordinateRegion region = MKCoordinateRegionMake(self.mapView.centerCoordinate, span);
    
    [self.mapView setRegion:region animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
