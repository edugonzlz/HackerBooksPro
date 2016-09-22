#import "_Location.h"
@import CoreLocation;

@interface Location : _Location

+(instancetype)locationForNote:(Note *)note withCLLocation:(CLLocation *)location;

//-(instancetype)initLocationForNote:(Note *)note;

@end
