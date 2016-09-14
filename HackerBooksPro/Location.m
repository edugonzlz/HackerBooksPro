#import "Location.h"

@interface Location ()

// Private interface goes here.

@end

@implementation Location

+(instancetype)locationWithNote:(Note *)note
                       latitude:(NSString *)latitude
                      longitude:(NSString *)longitude
                      inContext:(NSManagedObjectContext *)context{

    Location *loc = [NSEntityDescription insertNewObjectForEntityForName:[Location entityName]
                                                  inManagedObjectContext:context];

    loc.note = note;
    loc.latitude = latitude;
    loc.longitude = longitude;

    return loc;
}

@end
