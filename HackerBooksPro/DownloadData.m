//
//  DownloadData.m
//  HackerBooksPro
//
//  Created by Edu González on 14/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import "DownloadData.h"
#import "Book.h"
#import "Tag.h"

@implementation DownloadData

-(void)downloadData{

    self.model = [AGTSimpleCoreDataStack coreDataStackWithModelName:@"Model"];

    // MARK: - Download
    NSURL *JSONUrl = [NSURL URLWithString:@"https://t.co/K9ziV0z3SJ"];

    // TODO: - CARGAR EL MODELO EN OTRO LUGAR?? - QUIZA EN EL CONTROLADOR DE TABLA INICIAL
    // PUEDO DESCARGAR SEGUN SE CARGA LA VISTA,
    // PERO CUANDO INICIALIZO LOS BOOKS??

    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *lastUrl = [[fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *fileUrl = [lastUrl URLByAppendingPathComponent:JSONUrl.lastPathComponent];

    __block NSData *data = nil;

    // Mirar si tenemos JSON en local
    if ([fm fileExistsAtPath:fileUrl.path]) {

        [self JSONSerialization:[NSData dataWithContentsOfURL:fileUrl]];

    }else{
        // Si no lo tenemos descargar JSON

        dispatch_queue_t download = dispatch_queue_create("json", 0);

        dispatch_async(download, ^{

            NSLog(@"Descargando JSON");
            data = [NSData dataWithContentsOfURL:JSONUrl];

            // Guardamos en la ruta
            [data writeToFile:fileUrl.path atomically:YES];

            NSLog(@"JSON guardado en: %@", fileUrl);
            [self JSONSerialization:[NSData dataWithContentsOfURL:fileUrl]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        
    }

}

-(void)JSONSerialization:(NSData *)JSONData{

    NSError *error;
    if (JSONData != nil) {
        // Si todo esta bien serializamos
        NSArray *JSONObjects = [NSJSONSerialization JSONObjectWithData:JSONData
                                                               options:kNilOptions
                                                                 error:&error];

        // Si todo va bien convertimos sacamos cada diccionario/book y lo inicializamos
        if (JSONObjects != nil) {
            for (NSDictionary *dict in JSONObjects) {
                Book *book = [[Book alloc]initWithDict:dict inContext:self.model.context];

                NSString *tags = [dict objectForKey:@"tags"];
                NSArray *arrayOfTags = [tags componentsSeparatedByString:@", "];
                for (NSString *tagName in arrayOfTags) {

                    Tag *tag = [Tag tagWithName:tagName inContext:self.model.context];
                    //                    NSLog(@"%@: %@",tagName, tag.name);
                }
                //                NSLog(@"titulo: %@", book.title);
            }
        }else{
            // Se ha producido un error al parsear el JSON
            NSLog(@"Error al parsear JSON: %@", error.localizedDescription);
        }
    }else{
        // Error al descargar los datos del servidor
        NSLog(@"Error al descargar datos del servidor: %@", error.localizedDescription);
    }
}
@end
