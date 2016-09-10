#import "Book.h"
#import "PhotoCover.h"
#import "Pdf.h"
#import "Tag.h"

@interface Book ()

// Private interface goes here.

@end

@implementation Book

+(instancetype)bookWithTitle:(NSString *)title
                      author:(NSString *)author
                        tags:(NSArray *)tags
                    coverURL:(NSString *)coverURL
                      pdfURL:(NSString *)pdfURL
                     context:(NSManagedObjectContext *)context{

    Book *book = [NSEntityDescription insertNewObjectForEntityForName:[Book entityName]
                                               inManagedObjectContext:context];


    book.title = title;
    book.author = author;

    NSSet<Tag *> *myTags = nil;
    for (NSString *tag in tags) {
        Tag *new = [Tag initWithName:tag context:context];
        [myTags setByAddingObject:new];
    }
    book.tags = myTags;

    book.photoCover.imageURL = coverURL;
    book.pdf.pdfURL = pdfURL;

    return book;
}

@end
