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

// TODO: - cuando hago un sortDescriptor en el Library que ordena por Tag funciona
// Si ordeno por tag.name en el primer arranque ordenamos bien los tags
// En lo siguientes arranque no pasamos por aqui y favorites no aparece al inicio
- (NSComparisonResult)compare:(Tag *)otherObject{


    if ([otherObject.name isEqualToString:@"favorites"]) {
        return NSOrderedDescending;
    }

    return [self.name compare:otherObject.name];

}

@end
