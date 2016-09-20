#import "Author.h"
#import "Book.h"

@interface Author ()

// Private interface goes here.

@end

@implementation Author

+(instancetype)authorWithName:(NSString *)name forBook:(Book *)book{

    Author *author = [NSEntityDescription insertNewObjectForEntityForName:[Author entityName]
                                                   inManagedObjectContext:book.managedObjectContext];

    [author addBooksObject:book];

    return author;
}

@end
