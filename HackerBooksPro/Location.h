#import "_Location.h"

@interface Location : _Location

+(instancetype)locationForNote:(Note *)note
                       latitude:(double)latitude
                      longitude:(double)longitude;

+(instancetype)locationForNote:(Note *)note;

@end
