#import "Book.h"
#import "PhotoCover.h"
#import "Pdf.h"
#import "Tag.h"

@interface Book ()

// Private interface goes here.

@end

@implementation Book

-(NSString *)tagsString{

// TODO: - corregir que no nos entreguen una coma al final
    NSString *allTags = @"";
    for (Tag *tag in self.tags) {
        allTags = [[allTags stringByAppendingString:tag.name]stringByAppendingString:@", "];
    }

    return allTags;
}
//-(void)setTagsString:(NSString *)tags{
//
//    self.tagsString = tags;
//}


// MARK: - inicializador de clase
+(instancetype)bookWithTitle:(NSString *)title
                      author:(NSString *)author
                        tags:(NSString *)tags
                    coverURL:(NSString *)coverURL
                      pdfURL:(NSString *)pdfURL
                     inContext:(NSManagedObjectContext *)context{

    Book *book = [NSEntityDescription insertNewObjectForEntityForName:[Book entityName]
                                               inManagedObjectContext:context];

    book.title = title;
    book.author = author;

    NSArray *arrayOfTags = [tags componentsSeparatedByString:@", "];
    NSMutableSet<Tag *> *myTags = [[NSMutableSet alloc]init];

    for (NSString *tag in arrayOfTags) {
        Tag *new = [Tag tagWithName:tag inContext:context];
        [myTags addObject:new];
    }
    book.tags = myTags;
//    book.tagsString = tags;

    // TODO: - usar el inicializador con book? para photoCover y pdf
    book.photoCover = [PhotoCover photoCoverWithURL:coverURL inContext:context];
    book.pdf = [Pdf pdfWithURL:pdfURL inContext:context];

    return book;
}

+(instancetype)bookWithDict:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context{

    Book *book = [Book bookWithTitle:[dict objectForKey:@"title"]
                              author:[dict objectForKey:@"authors"]
                                tags:[dict objectForKey:@"tags"]
                            coverURL:[dict objectForKey:@"image_url"]
                              pdfURL:[dict objectForKey:@"pdf_url"]
                           inContext:context];

    return book;
}
@end
