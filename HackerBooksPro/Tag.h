#import "_Tag.h"

@interface Tag : _Tag

// TODO: - crear inicializador para relacionar con books?
+(instancetype)tagWithName:(NSString *)name inContext:(NSManagedObjectContext *)context;

@end
