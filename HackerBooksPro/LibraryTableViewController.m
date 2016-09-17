//
//  LibraryTableViewController.m
//  HackerBooksPro
//
//  Created by Edu González on 13/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import "LibraryTableViewController.h"
#import "Book.h"
#import "PhotoCover.h"
#import "Tag.h"
#import "BookViewController.h"

#define IS_IPHONE UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone

@implementation LibraryTableViewController

// MARK: - Inits
-(id)initWithContext:(NSManagedObjectContext *)context{

    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Book entityName]];

    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:BookAttributes.title ascending:YES]];

    NSFetchedResultsController *fr = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                                         managedObjectContext:context
                                                                           sectionNameKeyPath:@"tagsString"
                                                                                    cacheName:nil];

    if (self = [super initWithFetchedResultsController:fr
                                                 style:UITableViewStylePlain]) {
        self.fetchedResultsController = fr;
        self.context = context;
        self.title = @"Books";
    }

    return self;

}

// MARK: - DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *cellId = @"bookCell";
    //book
    Book *book = [self.fetchedResultsController objectAtIndexPath:indexPath];

    //celda
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:cellId];
    }

    cell.textLabel.text = book.title;
    cell.imageView.image = book.photoCover.image;
    cell.detailTextLabel.text = book.tagsString;

    return cell;
}

// MARK: - TableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    Book *book = [self.fetchedResultsController objectAtIndexPath:indexPath];

    BookViewController *bVC = [[BookViewController alloc]initWithModel:book];

    [self saveLastBookSelected: book];


    if (IS_IPHONE) {

        [self.navigationController pushViewController:bVC animated:true];
    } else {
        
        [self postNotificationForBook:book];
    }
}

// MARK: - Utils
-(void)postNotificationForBook:(Book *)book{


    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    NSNotification *notif = [NSNotification notificationWithName:@"lastBookSelected"
                                                          object:self
                                                        userInfo:@{@"lastBookSelected": book}];
    [nc postNotification:notif];
}

// MARK: - LastBookSelected
-(void)saveLastBookSelected:(Book *)book{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSURL *bookUri = [book.objectID URIRepresentation];
    NSData *bookData = [NSKeyedArchiver archivedDataWithRootObject:bookUri];

    [defaults setObject:bookData forKey:@"lastSelectedBook"];

    [defaults synchronize];
}

-(Book *)lastSelectedBook{

    NSData *bookData = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastSelectedBook"];
    if (bookData == nil) {
        bookData = [self setDefaultSelectedBook];
    }
    NSURL *bookUri = [NSKeyedUnarchiver unarchiveObjectWithData:bookData];
    NSManagedObjectID *id = [self.context.persistentStoreCoordinator managedObjectIDForURIRepresentation:bookUri];

    NSManagedObject *bookManaged = [self.context objectWithID:id];
    if (bookManaged.isFault) {
        Book *book = (Book *)bookManaged;
        // TODO: - el objeto esta vacio por alguna razon
        return book;
    } else {
        NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Book entityName]];
        req.predicate = [NSPredicate predicateWithFormat:@"SELF = %@", bookManaged];

        NSError *error;
        NSArray *res = [self.context executeFetchRequest:req
                                                   error:&error];

        if (res == nil) {
            return nil;
        } else {
            return [res lastObject];
        }
    }
}

-(NSData *)setDefaultSelectedBook{

    // Guardamos el primer libro por defecto. Es posible que este vacio
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    // TODO: - no me permite hacer el fetched
    //    Book *book = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Book *book = [Book bookWithTitle:@"titulo"
                              author:@"autor"
                                tags:@"tags"
                            coverURL:nil
                              pdfURL:nil
                           inContext:self.context];
    [self saveLastBookSelected:book];

    // Recuperamos
    NSData *bookData = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastSelectedBook"];
    
    return bookData;
}

@end
