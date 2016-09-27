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

//- (NSComparisonResult)compare:(Tag *)otherObject{
//
//  enum {
//        NSOrderedAscending = -1,
//        NSOrderedSame,
//        NSOrderedDescending
//    };
//    typedef NSInteger NSComparisonResult;
//
//}

@end
