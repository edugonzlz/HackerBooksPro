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
#import "BookTableViewCell.h"
#import "Author.h"
#import "BookTag.h"

#define IS_IPHONE UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone

@interface LibraryTableViewController ()

@property (strong, nonatomic)UISearchBar *searchBar;
//@property (strong, nonatomic)NSString *searchText;

@end

@implementation LibraryTableViewController

// MARK: - Inits
-(id)initWithContext:(NSManagedObjectContext *)context{

    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Book entityName]];

    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:BookAttributes.title ascending:YES]];

    NSFetchedResultsController *fr = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                                         managedObjectContext:context
                                                                           sectionNameKeyPath:nil
                                                                                    cacheName:nil];

    if (self = [super initWithFetchedResultsController:fr
                                                 style:UITableViewStylePlain]) {
        self.fetchedResultsController = fr;
        self.context = context;
        self.title = @"HackerBooksPro";
        self.searchBar = [[UISearchBar alloc]init];
    }

    return self;

}

// MARK: - Lifecycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self registerCell];

    self.searchBar.delegate = self;
//    self.searchBar.showsCancelButton = YES;
    self.searchBar.placeholder = @"Search a book...";
    
    self.navigationItem.titleView = self.searchBar;

}
// MARK: - DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //book
    Book *book = [self.fetchedResultsController objectAtIndexPath:indexPath];

//    celda
    NSString *cellId = @"bookCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:cellId];
    }
    cell.textLabel.text = book.title;
    cell.imageView.image = book.photoCover.image;
    //    cell.detailTextLabel.text = book.tagsString;

//    BookTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[BookTableViewCell cellId]
//                                                                   forIndexPath:indexPath];
//    [cell observeBook:book];

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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [BookTableViewCell cellHeight];
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

//    // TODO: - no me permite hacer el fetched
//    Book *book = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    [self saveLastBookSelected:book];

    // Recuperamos
    NSData *bookData = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastSelectedBook"];
    
    return bookData;
}

-(void)registerCell{

    UINib *nib = [UINib nibWithNibName:@"BookTableViewCell" bundle:nil];

    [self.tableView registerNib:nib forCellReuseIdentifier:[BookTableViewCell cellId]];
}
// MARK: - UISearchBarDelegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

    self.searchBar.showsCancelButton = YES;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    self.searchBar.showsCancelButton = YES;

    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Book entityName]];

    NSMutableArray *predicates = [[NSMutableArray alloc]init];

    NSPredicate *titlePred = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchText];
    [predicates addObject:titlePred];
    NSPredicate *authorPred = [NSPredicate predicateWithFormat:@"ANY authors.name CONTAINS[cd] %@", searchText];
    [predicates addObject:authorPred];
    NSPredicate *tagPred = [NSPredicate predicateWithFormat:@"ANY bookTags.tag.name CONTAINS[cd] %@", searchText];
    [predicates addObject:tagPred];

    req.predicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];

    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:BookAttributes.title ascending:YES]];

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{

    self.searchBar.showsCancelButton = NO;

    self.searchBar.text = nil;

    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Book entityName]];

    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:BookAttributes.title ascending:YES]];

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];

}

@end
