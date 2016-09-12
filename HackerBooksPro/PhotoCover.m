#import "PhotoCover.h"

@interface PhotoCover ()

// Private interface goes here.

@end

@implementation PhotoCover

-(void)setImage:(UIImage *)image{

    self.imageData = UIImagePNGRepresentation(image);
}
-(UIImage *)image{

    // Si no existe la imagen la descargamos
    if (!self.imageData) {

        dispatch_queue_t download = dispatch_queue_create("pdf", 0);

        dispatch_async(download, ^{

            // que nos observen por KVO para ver cuando hemos cambiado y refresquen??
            self.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]];

        });

        // Mientras se descarga hemos enviado una por defecto
        return [UIImage imageNamed:@"bookIcon.png"];
    }

    return [UIImage imageWithData:self.imageData];
}

+(instancetype)photoCoverWithURL:(NSString *)photoCoverURL inContext:(NSManagedObjectContext *)context{

    PhotoCover *cover = [NSEntityDescription insertNewObjectForEntityForName:[PhotoCover entityName]
                                                      inManagedObjectContext:context];


    cover.imageURL = photoCoverURL;

    return cover;
}

+(instancetype)photoCoverWithURL:(NSString *)photoCoverURL forBook:(Book *)book inContext:(NSManagedObjectContext *)context{

    PhotoCover *cover = [PhotoCover photoCoverWithURL:photoCoverURL
                                            inContext:context];
    cover.book = book;

    return cover;
}

@end
