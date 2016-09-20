#import "_Tag.h"

@interface Tag : _Tag

+(instancetype)tagWithName:(NSString *)name inContext:(NSManagedObjectContext *)context;

@end
