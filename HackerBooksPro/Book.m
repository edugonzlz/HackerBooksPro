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

    NSMutableSet<Tag *> *myTags = nil;
    for (NSString *tag in tags) {
        Tag *new = [Tag tagWithName:tag inContext:context];
        [myTags addObject:new];
    }
    book.tags = myTags;

    book.photoCover = [PhotoCover photoCoverWithURL:coverURL inContext:context];
    book.pdf = [Pdf pdfWithURL:pdfURL inContext:context];

    return book;
}

// TODO: - implementar un inicializador con un diccionario
// el diccionario nos lo pasaran despues de serializar el JSON descargado en diccionarios

@end
