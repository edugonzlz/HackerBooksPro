//
//  MapViewController.h
//  HackerBooksPro
//
//  Created by Edu González on 22/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class Location;


@interface MapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

-(id)initWithLocation:(Location *)location;

// Crear un inicializador
-(id)initWithNotes:(NSArray<id<MKAnnotation>>*)notes;

@end
