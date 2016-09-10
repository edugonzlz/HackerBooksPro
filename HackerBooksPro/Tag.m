#import "Tag.h"

@interface Tag ()

// Private interface goes here.

@end

@implementation Tag

+(instancetype)initWithName:(NSString *)name context:(NSManagedObjectContext *)context{

    Tag *tag = [NSEntityDescription insertNewObjectForEntityForName:[Tag entityName]
                                             inManagedObjectContext:context];

    tag.name = name;
    
    return tag;
}

@end
