#import "_Location.h"
#import "Note.h"

@interface Location : _Location

+(instancetype)locationWithNote:(Note *)note
                       latitude:(NSString *)latitude
                      longitude:(NSString *)longitude
                      inContext:(NSManagedObjectContext *)context;

@end
