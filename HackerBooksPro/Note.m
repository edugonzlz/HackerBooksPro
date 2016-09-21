#import "Note.h"
#import "PhotoNote.h"
#import "Location.h"
#import "Book.h"

@interface Note ()

+(NSArray *)observableKeyNames;

@end

@implementation Note

+(NSArray *)observableKeyNames{
    return @[@"text", @"creationDate", @"photo.imageData"];
}

+(instancetype)noteForBook:(Book *)book{

    Note *note = [NSEntityDescription insertNewObjectForEntityForName:[Note entityName]
                                               inManagedObjectContext:book.managedObjectContext];

    // TODO: - sumar a la fecha [NSTimeZone systemTimeZone]
//    note.book = book;
    note.creationDate = [NSDate date];
    note.modificationDate = [NSDate date];

    PhotoNote *photo = [PhotoNote photoNoteForNote:note];
    note.photo = photo;
    // TODO: -
    //location

    return note;
}

// MARK: - KVO
-(void)setupKVO{
    for (NSString *key in [Note observableKeyNames]) {
        [self addObserver:self
               forKeyPath:key
                  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionOld
                  context:NULL];
    }
}

-(void)tearDownKVO{
    for (NSString *key in [Note observableKeyNames]) {
        [self removeObserver:self
                  forKeyPath:key];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{

    // Cuando nos informen del cambio de las propiedades indicadas cambiamos la fecha de modificacion
    self.modificationDate = [NSDate date];
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

@end
