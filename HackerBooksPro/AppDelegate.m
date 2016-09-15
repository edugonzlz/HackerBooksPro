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
#import "LibraryTableViewController.h"
#import "Tag.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.model = [AGTSimpleCoreDataStack coreDataStackWithModelName:@"Model"];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [self.model zapAllData];

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

// TODO: - Esta responsabilidad la podemos pasar al book?
    // asi con la barra de busqueda o botones de orden cambiamos la tabla

    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Book entityName]];

    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:BookAttributes.title ascending:YES]];

    NSFetchedResultsController *fr = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                                         managedObjectContext:self.model.context
                                                                           sectionNameKeyPath:@"tagsString"
                                                                                    cacheName:nil];

    LibraryTableViewController *lVC = [[LibraryTableViewController alloc]initWithFetchedResultsController:fr
                                                                                                    style:UITableViewStylePlain];

    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:lVC];

    self.window.rootViewController = navVC;
    
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

            // TODO: - es necesario inicializar tags ahora?
                NSString *tags = [dict objectForKey:@"tags"];
                NSArray *arrayOfTags = [tags componentsSeparatedByString:@", "];

                for (NSString *tagName in arrayOfTags) {

                    Tag *tag = [Tag tagWithName:tagName inContext:self.model.context];
                }
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
