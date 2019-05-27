//
//  SelectLocationVC.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/15.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "SelectLocationVC.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SelectLocationVC ()<AMapLocationManagerDelegate, MAMapViewDelegate, UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MAMapView *mapView;
@property (nonatomic, copy) AMapLocatingCompletionBlock locationBlock;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) NSMutableArray *poiArray;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (weak, nonatomic) IBOutlet UITextField *customLocationTextField;
@property (nonatomic, copy) NSString *cityName;

@end

@implementation SelectLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"选择位置";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.mapView.delegate = self;
    [self startLocation];
    self.search = [[AMapSearchAPI alloc]init];
    self.search.delegate = self;
}

- (void)startLocation {
    WEAK(self);
    self.locationBlock  = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error){
        STRONG(self);
        if (error){
            NSLog(@"定位出错");
        }else {
            self.coordinate = location.coordinate;
            self.mapView.zoomLevel = 16;
            self.mapView.centerCoordinate = location.coordinate;
            [self addAnnotation];
            [self startPOISearchWithCoordinate:location.coordinate];
            [self antiEncoderWithCoordinate:location.coordinate];
        }
    };
    
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.locationBlock];
}

- (void)addAnnotation {
    MAPointAnnotation *a = [[MAPointAnnotation alloc] init];
    a.lockedScreenPoint = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_WIDTH*4/7/2.0);
    a.lockedToScreen = YES;
    [self.mapView addAnnotation:a];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation                                                 reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.animatesDrop = YES;
        return annotationView;
    }
    return nil;
}

- (void)startPOISearchWithCoordinate:(CLLocationCoordinate2D)coordinate {
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc]init];
    request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
  /* 汽车服务、汽车销售、汽车维修、摩托车服务、餐饮服务、购物服务、生活服务、体育休闲服务、医疗保健服务、住宿服务、风景名胜、商务住宅、政府机构及社会团体、科教文化服务、交通设施服务、金融保险服务、公司企业、道路附属设施、地名地址信息、公共设施
  */
    request.types = @"100101|110000|150200|150500|141200|150104|190000";
    request.sortrule = 0;
    request.offset = 50;
    [self.search AMapPOIAroundSearch:request];
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count == 0) return;
    self.poiArray = [NSMutableArray arrayWithArray:response.pois];
    [self.tableView reloadData];
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    CLLocationCoordinate2D coor = [mapView convertPoint:mapView.center toCoordinateFromView:mapView];
    self.coordinate = coor;
    [self startPOISearchWithCoordinate:coor];
    [self antiEncoderWithCoordinate:coor];
}

- (void)antiEncoderWithCoordinate:(CLLocationCoordinate2D)coordinate {
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    //创建位置
    CLLocation *location = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    //反地理编码
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //判断是否有错误或者placemarks是否为空
        if (error !=nil || placemarks.count==0) {
            NSLog(@"%@",error);
            return;
        }
        for (CLPlacemark *placemark in placemarks) {
            self.cityName = placemark.locality;
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.poiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    AMapPOI *poi = self.poiArray[indexPath.row];
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = poi.address;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AMapPOI *poi = self.poiArray[indexPath.row];
    if (self.selectBlock) {
        self.selectBlock([NSString stringWithFormat:@" %@ · %@",self.cityName, poi.name], self.coordinate);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)customLocationName:(id)sender {
    if ([self.customLocationTextField.text trim].length == 0) {
        [self showTextHUD:@"你还未输入你的位置"];
        return;
    }
    if (self.selectBlock) {
        self.selectBlock([NSString stringWithFormat:@" %@ · %@",self.cityName, [self.customLocationTextField.text trim]], self.coordinate);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
