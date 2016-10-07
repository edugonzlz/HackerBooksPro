//
//  AppDelegate.m
//  HackerBooksPro
//
//  Created by Edu González on 10/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import "AppDelegate.h"
#import "AGTCoreDataStack.h"
#import "Book.h"
#import "Tag.h"
#import "LibraryTableViewController.h"
#import "BookViewController.h"

#define IS_IPHONE UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone
#define SAVE_IN_COREDATA_COMPLETED @"Save in CoreData completed"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.model = [AGTCoreDataStack coreDataStackWithModelName:@"Model"];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

//    [self.model zapAllData];

    [self autoSaveData];

    NSURL *JSONUrl = [NSURL URLWithString:@"https://t.co/K9ziV0z3SJ"];

    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *lastUrl = [[fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *fileUrl = [lastUrl URLByAppendingPathComponent:JSONUrl.lastPathComponent];

    __block NSData *data = nil;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];


    // Miramos si estan los libros en el disco para marcarlo
    NSError *error = nil;
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Book entityName]];
    NSArray *res = [self.model.context executeFetchRequest:req error:&error];

    if (res == nil) {
        NSLog(@"no hay resultados: %@ - error: %@", res, error.localizedDescription);
    } else {
        if (res.count > 0) {

            NSLog(@"Parece que hay datos en la DB");
            [def setBool:YES forKey:SAVE_IN_COREDATA_COMPLETED];

        } else {
            NSLog(@"No hay books en la DB: %@", res);
            [def setBool:NO forKey:SAVE_IN_COREDATA_COMPLETED];
        }
    }


    // Mirar si tenemos JSON en local
    if (![fm fileExistsAtPath:fileUrl.path]) {

        // NO esta en local -  descargamos JSON en segundo plano
        dispatch_queue_t download = dispatch_queue_create("json", 0);

        dispatch_async(download, ^{

            NSLog(@"Descargando JSON");
            data = [NSData dataWithContentsOfURL:JSONUrl];

            [data writeToFile:fileUrl.path atomically:YES];
            NSLog(@"JSON guardado en: %@", fileUrl);

            dispatch_async(dispatch_get_main_queue(), ^{

                // TODO: - lo paso a primer plano, pero el metodo se ejecuta en un contexto de background, esta bien??

                [self JSONSerialization:[NSData dataWithContentsOfURL:fileUrl]];
            });
        });

    } else {

        // El JSON SI esta en local
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        if (![def boolForKey:SAVE_IN_COREDATA_COMPLETED]) {
            NSLog(@"Parece que NO estan los datos en disco, Vamos a serializar de nuevo y guardar");

            [self JSONSerialization:[NSData dataWithContentsOfURL:fileUrl]];

        } else {

            NSLog(@"Los datos estan guardados en CoreData, no hacemos nada");
        }
    }


    // Dependiendo del dispositivo presentamos splitView o no
    UIViewController *rootVC = nil;
    if (!(IS_IPHONE)) {
        rootVC = [self rootViewControllerForPadWithContext:self.model.context];
    } else {
        rootVC = [self rootViewControllerForPhoneWithContext:self.model.context];
    }

    self.window.rootViewController = rootVC;

    [self.window makeKeyAndVisible];

    return YES;
}

-(void)JSONSerialization:(NSData *)JSONData{

    [self.model performBackgroundTask:^(NSManagedObjectContext *worker) {
        NSError *error;
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];

        if (JSONData != nil) {
            // Si todo esta bien serializamos
            NSArray *JSONObjects = [NSJSONSerialization JSONObjectWithData:JSONData
                                                                   options:kNilOptions
                                                                     error:&error];

            // Si todo va bien convertimos sacamos cada diccionario/book y lo inicializamos
            if (JSONObjects != nil) {
                for (NSDictionary *dict in JSONObjects) {

                    [Book bookWithDict:dict inContext:self.model.context];
                }

                // Creamos la tag Favorite si no existe
                [Tag uniqueObjectWithValue:@"favorites" forKey:@"name" inManagedObjectContext:self.model.context];

            }else{
                // Se ha producido un error al parsear el JSON
                NSLog(@"Error al parsear JSON: %@", error.localizedDescription);
            }


            // Guardamos en el disco
            [self.model saveWithErrorBlock:^(NSError *error) {

                NSLog(@"Error guardando en CoreData despues de serializacion: %@", error.localizedDescription);

                // Si hay un error es que no hemos conseguido guardar los datos
                [def setBool:NO forKey:SAVE_IN_COREDATA_COMPLETED];
            }];

            NSLog(@"JSONSerial finalizado con exito");

        }else{
            // Error al descargar los datos del servidor
            NSLog(@"Error al descargar datos del servidor: %@", error.localizedDescription);
        }
    }];
}

-(UIViewController *)rootViewControllerForPhoneWithContext:(NSManagedObjectContext *)context{

    LibraryTableViewController *lVC = [[LibraryTableViewController alloc]initWithContext:context];

    UINavigationController *libraryNav = [[UINavigationController alloc]initWithRootViewController:lVC];

    return libraryNav;

}
-(UIViewController *)rootViewControllerForPadWithContext:(NSManagedObjectContext *)context{

    LibraryTableViewController *lVC = [[LibraryTableViewController alloc]initWithContext:context];
    UINavigationController *libraryNav = [[UINavigationController alloc]initWithRootViewController:lVC];

    BookViewController *bVC = [[BookViewController alloc]initWithModel:[lVC lastSelectedBook]];
    UINavigationController *bookNav = [[UINavigationController alloc]initWithRootViewController:bVC];

    UISplitViewController *splitVC = [[UISplitViewController alloc]init];
    splitVC.viewControllers = @[libraryNav, bookNav];

    return splitVC;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.

    [self saveData];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    [self saveData];
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

// MARK: - Utils
-(void)saveData{
    
    [self.model saveWithErrorBlock:^(NSError *error) {
        
        NSLog(@"Error guardando los datos en CoreData durante el autoSave: %@", error.localizedDescription);
    }];
}
-(void)autoSaveData{
    
    [self saveData];
    [self performSelector:@selector(autoSaveData)
               withObject:nil
               afterDelay:5];
    
}
@end
