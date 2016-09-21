#import "_Location.h"
@import CoreLocation;

@interface Location : _Location

+(instancetype)locationForNote:(Note *)note
                       latitude:(double)latitude
                      longitude:(double)longitude;

+(instancetype)locationForNote:(Note *)note withCLLocation:(CLLocation *)location;

+(instancetype)locationForNote:(Note *)note;

@end
