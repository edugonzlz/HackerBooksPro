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

@synthesize tagsString = _tagsString;
@synthesize authorsString = _authorsString;

-(NSString *)tagsString{

    NSMutableArray *allTags = [[NSMutableArray alloc]init];

    for (BookTag *bookTag in self.bookTags) {
        [allTags addObject:bookTag.tag.name];
    }
    return [[allTags valueForKey:@"description"] componentsJoinedByString:@", "];
}

-(NSString *)authorsString{

    NSMutableArray *authors = [[NSMutableArray alloc]init];
    if (self.authors == nil) {
        return @"...";
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

// TODO: - en las busquedas de autor y tag a veces se cae la app,
    // sobre todo si es la primera vez que arracanca, porque cambia el NSSet sobre la marcha
    for (NSString *name in authors) {

        NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Author entityName]];
        req.predicate = [NSPredicate predicateWithFormat:@"name == %@", name];

        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:req
                                                  error:&error];

        if (results == nil) {

            NSLog(@"Error en la busqueda del Autor: %@", name);
        }else{

            NSManagedObject *object = [results lastObject];

            if (object == nil) {

                //Si hay resultados pero no hay Autor lo creamos
                Author *author = [Author authorWithName:name inContext:context];
                [book addAuthorsObject:author];

            } else {
                // Existe el autor, pero tenemos que relacionarlo
                Author *existingAuthor = (Author *)object;
                [book addAuthorsObject:existingAuthor];
            }
        }

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

            if (object == nil) {

                //Si hay resultados pero no hay tag la creamos
                Tag *tag = [Tag tagWithName:name inContext:context];
                [BookTag bookTagWithBook:book andTag:tag];

            } else {

                Tag *existingTag = (Tag *)object;
                // El bookTag no existe, lo creamos
                [BookTag bookTagWithBook:book andTag:existingTag];
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
