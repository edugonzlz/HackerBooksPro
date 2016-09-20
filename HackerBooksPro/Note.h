#import "_Note.h"
#import "Book.h"

@interface Note : _Note

+(instancetype)noteForBook:(Book *)book;

@end
