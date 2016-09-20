#import "PhotoCover.h"
#import "Book.h"

@interface PhotoCover ()

// Private interface goes here.

@end

@implementation PhotoCover

-(void)setImage:(UIImage *)image{

    self.imageData = UIImagePNGRepresentation(image);
}
-(UIImage *)image{

    // Si no existe la imagen la descargamos
    if (self.imageData == nil) {

        dispatch_queue_t download = dispatch_queue_create("photoCover", 0);

        dispatch_async(download, ^{

            // que nos observen por KVO para ver cuando hemos cambiado y refresquen??
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]];
            UIImage *image = [UIImage imageWithData:data];
            self.imageData = UIImageJPEGRepresentation(image, 0.9);

        });

        // Mientras se descarga hemos enviado una por defecto
        return [UIImage imageNamed:@"bookIcon.png"];
    }else{

        return [UIImage imageWithData:self.imageData];
    }
}

+(instancetype)photoCoverWithURL:(NSString *)photoCoverURL inContext:(NSManagedObjectContext *)context{

    PhotoCover *cover = [NSEntityDescription insertNewObjectForEntityForName:[PhotoCover entityName]
                                                      inManagedObjectContext:context];


    cover.imageURL = photoCoverURL;

    return cover;
}

@end
