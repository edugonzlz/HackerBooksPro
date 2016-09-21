#import "_Note.h"

@interface Note : _Note

+(instancetype)noteForBook:(Book *)book inContext:(NSManagedObjectContext *)context;

@end
