#import "PhotoNote.h"

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

+(instancetype)photoNoteWithNote:(Note *)note
                       inContext:(NSManagedObjectContext *)context{

    PhotoNote *photo = [NSEntityDescription insertNewObjectForEntityForName:[PhotoNote entityName]
                                                     inManagedObjectContext:context];
    photo.notes = [NSSet setWithObject:note];

    return photo;
}

+(instancetype)photoNoteWithNote:(Note *)note
                           image:(UIImage *)image
                       inContext:(NSManagedObjectContext *)context{

    PhotoNote *photo = [PhotoNote photoNoteWithNote:note
                                          inContext:context];

    photo.imageData = UIImageJPEGRepresentation(image, 0.9);

    return photo;
}

@end
