#import "_Author.h"

@interface Author : _Author

+(instancetype)authorWithName:(NSString *)name inContext:(NSManagedObjectContext *)context;

@end
