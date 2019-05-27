//
//  MapVC.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/16.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "MapVC.h"
#import <MAMapKit/MAMapKit.h>

@interface MapVC ()

@property (weak, nonatomic) IBOutlet MAMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation MapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"位置";
    [self setUpMap];
}

- (void)setUpMap {
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(self.locationModel.latitude.floatValue, self.locationModel.longitude.floatValue);
    
    self.mapView.centerCoordinate = coor;
    self.mapView.zoomLevel = 17;
    MAPointAnnotation *a = [[MAPointAnnotation alloc] init];
    a.coordinate = coor;
    [self.mapView addAnnotation:a];
    
    self.locationLabel.text = self.locationModel.locationName;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
