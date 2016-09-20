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

//     TODO: - como recuperar los nombres de los autores y tags en una cadena??

@synthesize tagsString = _tagsString;
@synthesize authorsString = _authorsString;

-(NSString *)tagsString{

    NSMutableArray *allTags = [[NSMutableArray alloc]init];
    for (Tag *tag in self.bookTags) {
        [allTags addObject:tag.name];
    }
    return [[allTags valueForKey:@"description"] componentsJoinedByString:@", "];;
}

-(NSString *)authorsString{

    NSString *autores;
    NSMutableArray *authors = [[NSMutableArray alloc]init];
    if (self.authors == nil) {
        autores  = @"...";
    } else {
        for (Author *author in self.authors) {
            [authors addObject:author.name];
        }
    }
    return [[authors valueForKey:@"description"] componentsJoinedByString:@", "];
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

// TODO: - comprobar si el autor esta creado ya
    for (NSString *name in authors) {
        Author *author = [Author authorWithName:name inContext:context];

        [book addAuthorsObject:author];
    }

    for (NSString *name in tags) {

        //Buscamos un tag con ese nombre
        NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Tag entityName]];
        req.predicate = [NSPredicate predicateWithFormat:@"name == %@", name];

        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:req
                                                  error:&error];

        if (results == nil) {

            NSLog(@"Error en la busqueda del Tag: %@", name);
        }else{

            NSManagedObject *object = [results lastObject];

            //Si hay resultados pero no hay tag la creamos
            if (object == nil) {

//                NSLog(@"Tag %@ no encontrada. La creamos", name);
                Tag *tag = [Tag tagWithName:name inContext:context];
                BookTag *bookTag = [BookTag bookTagWithBook:book andTag:tag];

                // TODO: - es necesario esto?
                [book addBookTagsObject:bookTag];
                [tag addBookTagsObject:bookTag];

            } else {


                Tag *existingTag = (Tag *)object;
                // El bookTag no existe, lo creamos
                BookTag *bookTag = [BookTag bookTagWithBook:book andTag:existingTag];

                //                NSLog(@"La Tag %@ ya existe",existingTag.name);

                // Relacionamos
                [book addBookTagsObject:bookTag];
                [existingTag addBookTagsObject:bookTag];
            }
        }
        
    }

    PhotoCover *cover = [PhotoCover photoCoverWithURL:coverURL inContext:context];
    book.photoCover = cover;
    Pdf *pdf = [Pdf pdfWithURL:pdfURL inContext:context];
    book.pdf = pdf;

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
