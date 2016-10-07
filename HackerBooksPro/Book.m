#import "Book.h"
#import "PhotoCover.h"
#import "Pdf.h"
#import "Tag.h"
#import "Author.h"
#import "BookTag.h"
#import "AGTBaseManagedObject.h"

@interface Book ()

+(NSArray *)observableKeyNames;

@end

@implementation Book

@synthesize tagsString = _tagsString;
@synthesize authorsString = _authorsString;

+(NSArray *)observableKeyNames{
    return @[@"isFavorite"];
}

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

    //    [book setValue:title forKey:BookAttributes.title];

    // Para crear autor y tag primero buscamos si existen ya
    // TODO: - en las busquedas de autor y tag a veces se cae la app,
    // sobre todo si es la primera vez que arranca, porque cambia el NSSet sobre la marcha
    for (NSString *name in authors) {

        Author *author = [Author uniqueObjectWithValue:name forKey:@"name" inManagedObjectContext:context];

        [book addAuthorsObject:author];
    }

    for (NSString *name in tags) {

        Tag *tag = [Tag uniqueObjectWithValue:name forKey:@"name" inManagedObjectContext:context];

        [BookTag bookTagWithBook:book andTag:tag];
    }

    PhotoCover *cover = [PhotoCover photoCoverWithURL:coverURL inContext:context];
    //    [book setValue:cover forKey:BookRelationships.photoCover];
    book.photoCover = cover;
    Pdf *pdf = [Pdf pdfWithURL:pdfURL inContext:context];
    //    [book setValue:pdf forKey:BookRelationships.pdf];
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

// MARK: - Lifecycle
-(void)awakeFromInsert{
    [super awakeFromInsert];

    [self setupKVO];
}
-(void)awakeFromFetch{
    [super awakeFromFetch];

    [self setupKVO];
}
-(void)willTurnIntoFault{
    [super willTurnIntoFault];

    [self tearDownKVO];
}

// MARK: - KVO
-(void)setupKVO{
    for (NSString *key in [Book observableKeyNames]) {
        [self addObserver:self
               forKeyPath:key
                  options:NSKeyValueObservingOptionOld
                  context:NULL];
    }
}

-(void)tearDownKVO{
    for (NSString *key in [Book observableKeyNames]) {
        [self removeObserver:self
                  forKeyPath:key];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{

    // TODO: - me esta llegando dos veces la notificacion
    NSLog(@"notificacion de cambio en propiedad isFavorite");

    // Cuando vemos el cambio en la propiedad favorito añadimos o borramos la relacion con la tag

    // Recupero la tag favorites

    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Tag entityName]];
    req.predicate = [NSPredicate predicateWithFormat:@"name == 'favorites'"];
    req.fetchLimit = 1;

    NSError *error;
    NSArray *res = [self.managedObjectContext executeFetchRequest:req error:&error];

    if ([res count] > 0 && res != nil) {

        Tag *favTag = [res lastObject];
        BOOL fav = self.isFavoriteValue;
        NSSet *favsSet = [self.bookTags filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"tag.name == 'favorites'"]];

        if (fav) {

            // me esta llegando dos veces la notificacion asi que compruebo si ya existe la bookTag favorites
            if ([favsSet count] == 0) {

                [BookTag bookTagWithBook:self andTag:favTag];
                NSLog(@"te hago fav con favTag: %@", favTag.name);
                // la relacion se realiza en el booktag, pero si no lo hago aqui no presenta la tag favorites
                //            [self addBookTagsObject:bookTag];
            }

        } else if (!fav) {

            [self removeBookTags:favsSet];

            // no estoy seguro de que sea necesario borrar del contexto... pero tengo que comprobrar
            if ([favsSet count] != 0){
                [self.managedObjectContext deleteObject:[favsSet anyObject]];
            }
        }
    }
    
}
@end
