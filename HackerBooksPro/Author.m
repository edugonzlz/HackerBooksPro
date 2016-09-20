#import "Author.h"
#import "Book.h"

@interface Author ()

// Private interface goes here.

@end

@implementation Author

+(instancetype)authorWithName:(NSString *)name inContext:(NSManagedObjectContext *)context{

    Author *author = [NSEntityDescription insertNewObjectForEntityForName:[Author entityName]
                                                   inManagedObjectContext:context];

    return author;
}

@end
