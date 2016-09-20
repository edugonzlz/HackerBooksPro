#import "Tag.h"
#import "BookTag.h"

@interface Tag ()

// Private interface goes here.

@end

@implementation Tag

+(instancetype)tagWithName:(NSString *)name andBookTag:(BookTag *)bookTag{

    Tag *tag = [NSEntityDescription insertNewObjectForEntityForName:[Tag entityName]
                                             inManagedObjectContext:bookTag.managedObjectContext];

    tag.name = name;
    [tag addBookTagsObject:bookTag];
    
    return tag;
}

@end
