#import "_Tag.h"

@interface Tag : _Tag

+(instancetype)initWithName:(NSString *)name context:(NSManagedObjectContext *)context;

@end
