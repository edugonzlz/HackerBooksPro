#import "Book.h"
#import "PhotoCover.h"
#import "Pdf.h"
#import "Tag.h"

@interface Book ()

// Private interface goes here.

@end

@implementation Book

-(NSString *)tagsString{

    NSString *allTags = @"";
    for (Tag *tag in self.tags) {
        allTags = [[allTags stringByAppendingString:tag.name]stringByAppendingString:@", "];
    }
    return allTags;
}
-(void)setTagsString:(NSString *)tags{

    self.tagsString = tags;
}

+(instancetype)bookWithTitle:(NSString *)title
                      author:(NSString *)author
                        tags:(NSArray *)tags
                    coverURL:(NSString *)coverURL
                      pdfURL:(NSString *)pdfURL
                     inContext:(NSManagedObjectContext *)context{

    Book *book = [NSEntityDescription insertNewObjectForEntityForName:[Book entityName]
                                               inManagedObjectContext:context];


    book.title = title;
    book.author = author;

    NSMutableSet<Tag *> *myTags = [[NSMutableSet alloc]init];
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
-(instancetype)initWithDict:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context{

    NSString *tags = [dict objectForKey:@"tags"];
    NSArray *arrayOfTags = [tags componentsSeparatedByString:@", "];
    
    return [Book bookWithTitle:[dict objectForKey:@"title"]
                        author:[dict objectForKey:@"authors"]
                          tags:arrayOfTags
                      coverURL:[dict objectForKey:@"image_url"]
                        pdfURL:[dict objectForKey:@"pdf_url"]
                       inContext:context];


}

@end
