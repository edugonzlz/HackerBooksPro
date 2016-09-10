#import "Note.h"
#import "PhotoNote.h"
#import "Location.h"

@interface Note ()

// Private interface goes here.

@end

@implementation Note

+(instancetype)noteWithBook:(Book *)book inContext:(NSManagedObjectContext *)context{

    Note *note = [NSEntityDescription insertNewObjectForEntityForName:[Note entityName]
                                               inManagedObjectContext:context];

    note.book = book;
    note.creationDate = [NSDate date];
    note.modificationDate = [NSDate date];
// TODO: - Añadir la localizacion
    note.location = [Location locationWithNote:self
                                      latitude:@""
                                     longitude:@""
                                     inContext:context];
    note.photo = [PhotoNote photoNoteWithNote:self
                                    inContext:context];

    return note;
}

@end
