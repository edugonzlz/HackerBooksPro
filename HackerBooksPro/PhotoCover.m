#import "PhotoCover.h"

@interface PhotoCover ()

// Private interface goes here.

@end

@implementation PhotoCover

-(void)setImage:(UIImage *)image{

    self.imageData = UIImagePNGRepresentation(image);
}
-(UIImage *)image{

// TODO: - si imageData es nil, retornar una foto generica
    return [UIImage imageWithData:self.imageData];
}

+(instancetype)photoCoverWithURL:(NSString *)photoCoverURL inContext:(NSManagedObjectContext *)context{

    PhotoCover *cover = [NSEntityDescription insertNewObjectForEntityForName:[PhotoCover entityName]
                                                      inManagedObjectContext:context];

    // TODO: - enviar a segundo plano
    // enviar con un completion block
    // el completion block pide que se guarde el data en el modelo
    // el controlador por KVO observara esa propiedad y cuando cambie refresca
    cover.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoCoverURL]];

    return cover;
}

+(instancetype)photoCoverWithURL:(NSString *)photoCoverURL forBook:(Book *)book inContext:(NSManagedObjectContext *)context{

    PhotoCover *cover = [PhotoCover photoCoverWithURL:photoCoverURL
                                            inContext:context];
    cover.book = book;

    return cover;
}

@end
