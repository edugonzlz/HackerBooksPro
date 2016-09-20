#import "PhotoNote.h"
#import "Note.h"

@interface PhotoNote ()

// Private interface goes here.

@end

@implementation PhotoNote

-(void)setImage:(UIImage *)image{

    self.imageData = UIImagePNGRepresentation(image);
}
-(UIImage *)image{

    return [UIImage imageWithData:self.imageData];
}

+(instancetype)photoNoteForNote:(Note *)note{

    PhotoNote *photo = [NSEntityDescription insertNewObjectForEntityForName:[PhotoNote entityName]
                                                     inManagedObjectContext:note.managedObjectContext];
    [photo addNotesObject:note];

    return photo;
}

+(instancetype)photoNoteForNote:(Note *)note withImage:(UIImage *)image{

    PhotoNote *photo = [PhotoNote photoNoteForNote:note];

    photo.imageData = UIImageJPEGRepresentation(image, 0.9);

    return photo;
}

@end
