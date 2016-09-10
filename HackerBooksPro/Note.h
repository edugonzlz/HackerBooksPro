#import "_Note.h"
#import "Book.h"

@interface Note : _Note

+(instancetype)noteWithBook:(Book *)book inContext:(NSManagedObjectContext *)context;

@end
