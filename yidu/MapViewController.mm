//
//  MapViewController.m
//  yidu
//
//  Created by 智超 常 on 12-3-21.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "MapViewController.h"
#import "MapPointAnnotion.h"



@interface MapViewController ()

@end

@implementation MapViewController
@synthesize _search;
@synthesize _mapView;
@synthesize key;
@synthesize temp;
@synthesize cafeResult;
@synthesize libResult;
@synthesize bSResult;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _search = [[BMKSearch alloc]init];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - 百度地图

#pragma mark-
#pragma mark 定位委托
//开始定位
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView{
    
    NSLog(@"开始定位");
    
}

//更新坐标

-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation{
    
    NSLog(@"更新坐标");
    
    
    //给view中心定位
    BMKCoordinateRegion region;
    region.center.latitude  = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    
    //地图缩放程度
    region.span.latitudeDelta  = 0.02;
    region.span.longitudeDelta = 0.02;
    _mapView.region   = region;
    NSLog(@"经度:%g纬度:%g",region.center.latitude,region.center.longitude);
    
    //加个当前坐标的小气泡
    //[_search reverseGeocode:userLocation.location.coordinate];

    _mapView.showsUserLocation = NO; 
    
}

//定位失败

-(void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    
    NSLog(@"定位错误%@",error);
    
    [_mapView setShowsUserLocation:NO];
    
}

//定位停止

-(void)mapViewDidStopLocatingUser:(BMKMapView *)mapView{
    
    NSLog(@"定位停止");  
}

#pragma mark-
#pragma mark 区域改变

/**
 *地图区域即将改变时会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"地图区域即将改变");
}

/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"地图区域改变完成");

    if (self.changeKeyCheck) {
        [self poiResultCheck:key];
    }
    

}

#pragma mark-
#pragma mark 标注
/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    NSLog(@"生成标注");
    
    BMKAnnotationView *annotationView =[mapView viewForAnnotation:annotation];
    
    if (annotationView==nil&&[annotation isKindOfClass:[MapPointAnnotion class]]) 
    {
        MapPointAnnotion* pointAnnotation=(MapPointAnnotion*)annotation;
        NSString *AnnotationViewID = [NSString stringWithFormat:@"iAnnotation-%i",pointAnnotation.tag];
		annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation 
                                                          reuseIdentifier:AnnotationViewID]; 
        
        if ([[pointAnnotation subtitle] isEqualToString:@"我的位置"])
        {
            ((BMKPinAnnotationView*) annotationView).pinColor = BMKPinAnnotationColorRed;   
        }
        else if([[pointAnnotation subtitle] isEqualToString:@"目标位置"]){
            ((BMKPinAnnotationView*) annotationView).pinColor = BMKPinAnnotationColorPurple;  
        }
        else{
            ((BMKPinAnnotationView*) annotationView).pinColor = BMKPinAnnotationColorGreen; 
        }
        
		((BMKPinAnnotationView*)annotationView).animatesDrop = YES;// 设置该标注点动画显示
        
        
        annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
        annotationView.annotation = annotation;
        
        annotationView.canShowCallout = TRUE;
        annotationView.tag=pointAnnotation.tag;
        
        
        
	}
	return annotationView ; 
}

/**
 *当mapView新添加annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 新添加的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"添加多个标注");
}

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"选中标注");
}

/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 取消选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"取消选中标注");
}

#pragma mark-
#pragma mark 地理编码和反地理编码

- (void)onGetTransitRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
}

- (void)onGetDrivingRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
}

- (void)onGetWalkingRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
}

//poi返回结果数据集
- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
	if (error == BMKErrorOk) {
        libResult = [[NSMutableArray alloc]initWithArray:poiResultList];
		BMKPoiResult* result = [poiResultList objectAtIndex:0];
		for (int i = 0; i < result.poiInfoList.count; i++) {
			BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
			BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
			item.coordinate = poi.pt;
			item.title = poi.name;
			[_mapView addAnnotation:item];
		}
        if (key==@"图书馆") {
            libResult = [[NSMutableArray alloc]initWithArray:poiResultList];
        }
        if (key==@"cafe") {
            cafeResult = [[NSMutableArray alloc]initWithArray:poiResultList];
        }
        if (key==@"书店") {
            bSResult = [[NSMutableArray alloc]initWithArray:poiResultList];
        }

        
	}
}

- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
	if (error == 0) {
		MapPointAnnotion* item = [[MapPointAnnotion alloc]init];
		item.coordinate = result.geoPt;
		item.title = result.strAddr;
        item.subtitle=@"我的位置";
		[_mapView addAnnotation:item];
        
        NSLog(@"添加地名名称标注");
	}
    
}
#pragma mark - fun
-(void)cleanMap
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    
    for (MapPointAnnotion* ann in array) {
        [_mapView removeAnnotation:ann];
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.view = _mapView;
    _search.delegate = self;
    _mapView.delegate=self;
    temp = @"图书馆";
    
    [_mapView setShowsUserLocation:YES];
        sleep(10);
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark-
#pragma mark 搜索结果返回

- (void)poiResultCheck:(NSString *)key
{
    //查找周围信息
    NSArray *array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array =[NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    
    BOOL flag = [_search poiSearchNearBy:key center:_mapView.region.center radius:5000 pageIndex:0];
    if (flag) {
        NSLog(@"查找失败！！！");
    }
}
- (BOOL)changeKeyCheck{

    if (temp == key) {
        temp=key;
        return FALSE;
    }
    else {
        temp=key;
        return TRUE;
    }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (void)getLibResult
{
    NSLog(@"线程1结束");
}
- (void)getCafeResult
{
    NSLog(@"线程2结束");
}

@end
