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

//@property (strong, nonatomic)Location *model;
@property (strong, nonatomic)NSArray<id<MKAnnotation>> *model;

@end

@implementation MapViewController

-(id)initWithLocation:(Location *)location{

    if (self = [super initWithNibName:nil bundle:nil]) {

        NSArray *model = [NSArray arrayWithObject:location];
        _model = model;
    }
    return self;
}
-(id)initWithNotes:(NSArray<id<MKAnnotation>>*)notes{

    if (self = [super init]) {
        _model = notes;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.mapView addAnnotations:self.model];
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
