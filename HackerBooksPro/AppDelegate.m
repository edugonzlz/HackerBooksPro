//
//  AppDelegate.m
//  HackerBooksPro
//
//  Created by Edu González on 10/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import "AppDelegate.h"
#import "AGTSimpleCoreDataStack.h"
#import "Book.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.model = [AGTSimpleCoreDataStack coreDataStackWithModelName:@"Model"];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


// MARK: - Download
    NSURL *JSONUrl = [NSURL URLWithString:@"https://t.co/K9ziV0z3SJ"];

    //
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *lastUrl = [[fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *fileUrl = [lastUrl URLByAppendingPathComponent:JSONUrl.lastPathComponent];

     __block NSData *data = nil;

    // Mirar si tenemos JSON en local
    if ([fm fileExistsAtPath:fileUrl.path]) {

        [self JSONSerialization:[NSData dataWithContentsOfURL:fileUrl]];

    }else{
        // Si no lo tenemos descargar JSON

        // TODO: - realizar en segundo plano con bloque de finalizacion
        // el blque envia toda la serializacion

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


//        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
//        NSURLSessionDownloadTask *task = [session downloadTaskWithURL:JSONUrl completionHandler:^(NSURL * _Nullable location,
//                                                                                                  NSURLResponse * _Nullable response,
//                                                                                                  NSError * _Nullable error) {
//
//            // comprobamos la respuesta
//
//            // si es buena, cambiamos de sitio el archivo guardado en location
//        }];
//        [task resume];

    }



    
//    // Podemos observar cuando existe el fichero y entonces serializar
//    NSData *JSONData = [NSData dataWithContentsOfURL:fileUrl];
//
//    if (JSONData != nil) {
//        // Si todo esta bien serializamos
//        NSArray *JSONObjects = [NSJSONSerialization JSONObjectWithData:data
//                                                               options:kNilOptions
//                                                                 error:&error];
//
//        // Si todo va bien convertimos sacamos cada diccionario/book y lo inicializamos
//        if (JSONObjects != nil) {
//            for (NSDictionary *dict in JSONObjects) {
//                Book *book = [[Book alloc]initWithDict:dict inContext:self.model.context];
//                NSLog(@"titulo: %@", book.title);
//            }
//        }else{
//            // Se ha producido un error al parsear el JSON
//            NSLog(@"Error al parsear JSON: %@", error.localizedDescription);
//        }
//    }else{
//        // Error al descargar los datos del servidor
//        NSLog(@"Error al descargar datos del servidor: %@", error.localizedDescription);
//    }


    // Crear VC y asignar rootVC

//    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[AGTNotebook entityName]];
//    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:AGTNamedEntityAttributes.modificationDate
//                                                          ascending:NO],
//                            [NSSortDescriptor sortDescriptorWithKey:AGTNamedEntityAttributes.name
//                                                          ascending:YES]];
//
//    NSFetchedResultsController *results = [[NSFetchedResultsController alloc] initWithFetchRequest:req
//                                                                              managedObjectContext:self.model.context
//                                                                                sectionNameKeyPath:nil
//                                                                                         cacheName:nil];
//
//    AGTNotebooksViewController *nbVC = [[AGTNotebooksViewController alloc]
//                                        initWithFetchedResultsController:results
//                                        style:UITableViewStylePlain];
//
//
//    self.window.rootViewController = [nbVC wrappedInNavigation];

    [self.window makeKeyAndVisible];

    return YES;
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
                NSLog(@"titulo: %@", book.title);
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
