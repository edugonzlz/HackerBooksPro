#import "BookTag.h"
#import "Book.h"
#import "Tag.h"

@interface BookTag ()

// Private interface goes here.

@end

@implementation BookTag

+(instancetype)bookTagWithBook:(Book *)book andTag:(Tag *)tag{

    BookTag *bookTag = [NSEntityDescription insertNewObjectForEntityForName:[BookTag entityName]
                                                     inManagedObjectContext:book.managedObjectContext];

    bookTag.book = book;
    bookTag.tag = tag;

    return bookTag;
}
// TODO: - nunca pasamos por aqui
- (NSComparisonResult)compare:(BookTag *)otherObject{


    if ([otherObject.tag.name isEqualToString:@"favorites"]) {
        return NSOrderedDescending;
    }

    return [self.tag.name compare:otherObject.tag.name];
    
}

@end
