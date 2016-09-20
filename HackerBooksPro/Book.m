#import "Book.h"
#import "PhotoCover.h"
#import "Pdf.h"
#import "Tag.h"
#import "Author.h"
#import "BookTag.h"

@interface Book ()

// Private interface goes here.

@end

@implementation Book

-(NSString *)tagsString{

    return self.tagsString;
}

-(void)setTagsString:(NSString *)tags{

    self.tagsString = tags;
}


// MARK: - inicializador de clase
+(instancetype)bookWithTitle:(NSString *)title
                      authors:(NSArray *)authors
                        tags:(NSArray *)tags
                    coverURL:(NSString *)coverURL
                      pdfURL:(NSString *)pdfURL
                     inContext:(NSManagedObjectContext *)context{

    Book *book = [NSEntityDescription insertNewObjectForEntityForName:[Book entityName]
                                               inManagedObjectContext:context];


    book.title = title;


    for (NSString *name in authors) {
        Author *author = [Author authorWithName:name forBook:book];

        [book addAuthorsObject:author];
    }
// TODO: - bucle tag bookTag... que necesito para crear cada uno??
//    for (NSString *name in tags) {
//        BookTag *bookTag = [BookTag bookTagWithBook:book andTag:<#(Tag *)#>];
//        Tag *tag = [Tag tagWithName:name andBookTag:<#(BookTag *)#>];
//
//        [book addBookTagsObject:bookTag];
//    }


    [book addBookTags:[NSSet setWithArray:tags]];

    book.tagsString = [[tags valueForKey:@"description"] componentsJoinedByString:@", "];

    book.photoCover = [PhotoCover photoCoverWithURL:coverURL forBook:book];

    book.pdf = [Pdf pdfWithURL:pdfURL forBook:book];

    return book;
}

+(instancetype)bookWithDict:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context{

    NSArray *tagsArray = [[dict objectForKey:@"tags"] componentsSeparatedByString:@", "];
    NSArray *authorsArray = [[dict objectForKey:@"authors"] componentsSeparatedByString:@", "];
    
    Book *book = [Book bookWithTitle:[dict objectForKey:@"title"]
                              authors:authorsArray
                                tags:tagsArray
                            coverURL:[dict objectForKey:@"image_url"]
                              pdfURL:[dict objectForKey:@"pdf_url"]
                           inContext:context];

    return book;
}
@end
