#import "Tag.h"
#import "BookTag.h"

@interface Tag ()

// Private interface goes here.

@end

@implementation Tag

+(instancetype)tagWithName:(NSString *)name inContext:(NSManagedObjectContext *)context{

    Tag *tag = [NSEntityDescription insertNewObjectForEntityForName:[Tag entityName]
                                             inManagedObjectContext:context];

    tag.name = name;
    
    return tag;
}

// TODO: - cuando no persistia funcionaba esto,,, ahora que persisto no funciona, genial!!
- (NSComparisonResult)compare:(Tag *)otherObject{


    if ([otherObject.name isEqualToString:@"favorites"]) {
        return NSOrderedDescending;
    }

    return [self.name compare:otherObject.name];

}

@end
