//
//  MapViewController.m
//  HackerBooksPro
//
//  Created by Edu González on 22/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import "MapViewController.h"
#import "Location.h"
#import "Note.h"

@interface MapViewController () <MKMapViewDelegate>

@property (strong, nonatomic)NSArray<Location *> *model;

@end

@implementation MapViewController

-(id)initWithLocation:(Location *)location{

    if (self = [super initWithNibName:nil bundle:nil]) {

        NSArray *model = [NSArray arrayWithObject:location];
        _model = model;
    }
    return self;
}
-(id)initWithLocations:(NSArray<Location *>*)locations{

    if (self = [super init]) {
        _model = locations;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.mapView.delegate = self;
    [self.mapView addAnnotations:self.model];

    // Lo que se ve al cargar el mapa
    // Centramos el mapa en el ultimo elemento por si solo es uno
    Location *loc = [self.model lastObject];
    MKCoordinateRegion initialRegion = MKCoordinateRegionMakeWithDistance(loc.coordinate, 10000000, 10000000);
    [self.mapView setRegion:initialRegion];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    Location *loc = [self.model lastObject];
    MKCoordinateRegion finalRegion = MKCoordinateRegionMakeWithDistance(loc.coordinate, 1000, 1000);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self.mapView setRegion:finalRegion animated:YES];
    });
}

// MARK: - MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView
           viewForAnnotation:(id<MKAnnotation>)annotation{

    static NSString *annotationId = @"annotationId";

    MKPinAnnotationView *annotationView;
    annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationId];

    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationId];
    }

    annotationView.canShowCallout = YES;

    Location *loc = (Location *)annotation;
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mazinger.png"]];

    annotationView.leftCalloutAccessoryView = image;

    UIButton *goToMapsButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [goToMapsButton setImage:[UIImage imageNamed:@"car"] forState:UIControlStateNormal];
    [goToMapsButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];

    annotationView.rightCalloutAccessoryView = goToMapsButton;

    return annotationView;
}

-(void)mapView:(MKMapView *)mapView
annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control{

// TODO: - molaria crear un addressDictionary para presentrar en AppleMaps
    MKPlacemark *placemark = [[MKPlacemark alloc]initWithCoordinate:[view.annotation coordinate] addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc]initWithPlacemark:placemark];

    NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault};
    [MKMapItem openMapsWithItems:@[mapItem] launchOptions:options];
}

@end
