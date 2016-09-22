#import "_Location.h"
@import CoreLocation;
@import MapKit;

@interface Location : _Location <MKAnnotation>

+(instancetype)locationForNote:(Note *)note withCLLocation:(CLLocation *)location;

//-(instancetype)initLocationForNote:(Note *)note;

@end
