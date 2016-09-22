//
//  MapViewController.m
//  HackerBooksPro
//
//  Created by Edu González on 22/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import "MapViewController.h"
#import "Location.h"

@interface MapViewController () <MKMapViewDelegate>

@property (strong, nonatomic)Location *model;

@end

@implementation MapViewController

-(id)initWithLocation:(Location *)location{

    if (self = [super initWithNibName:nil bundle:nil]) {

        _model = location;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.mapView addAnnotation:self.model];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    // Asignar rgion y animar
}

// MARK: - MKMapViewDelegate

//-(MKAnnotationView *)mapView:(MKMapView *)mapView
//           viewForAnnotation:(id<MKAnnotation>)annotation{
//
//
//}

@end
