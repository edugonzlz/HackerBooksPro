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

@interface LibraryTableViewController () <UISearchResultsUpdating>

//@property (strong, nonatomic)UISearchBar *searchBar;
@property (strong, nonatomic)UISearchController *searchController;

@end

@implementation LibraryTableViewController

// MARK: - Inits
-(id)initWithContext:(NSManagedObjectContext *)context{

    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[BookTag entityName]];

    req.fetchBatchSize = 40;

    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES],
                            [NSSortDescriptor sortDescriptorWithKey:@"book.title" ascending:YES]];

    NSFetchedResultsController *fr = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                                         managedObjectContext:context
                                                                           sectionNameKeyPath:@"tag.name"
                                                                                    cacheName:nil];

    if (self = [super initWithFetchedResultsController:fr
                                                 style:UITableViewStylePlain]) {
        self.fetchedResultsController = fr;
        self.context = context;
        self.title = @"HackerBooksPro";
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//        self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];

    }

    return self;
}

// MARK: - Lifecycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self registerCell];

//        self.searchBar.delegate = self;
//        self.searchBar.placeholder = @"Search a book...";
//        self.tableView.tableHeaderView = self.searchBar;
//     Ocultamos la barra de busqueda debajo de la navigationBar
//        CGRect newBounds = self.tableView.bounds;
//        newBounds.origin.y = newBounds.origin.y + self.searchBar.bounds.size.height;
//        self.tableView.bounds = newBounds;

    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.placeholder = @"Search a book...";
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;

    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.hidesNavigationBarDuringPresentation = NO;

    [self.tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
}

// MARK: - DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    Book *book = [self getBook:[self.fetchedResultsController objectAtIndexPath:indexPath]];

    //    NSString *cellId = @"bookCell";
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
    //                                     reuseIdentifier:cellId];
    //    }
    //
    //    cell.textLabel.text = book.title;
    //    cell.imageView.image = book.photoCover.image;
    //    cell.detailTextLabel.text = book.tagsString;

    // TODO: - celda personalizada da un error que dice que actualizamos autolayout desde background
    BookTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[BookTableViewCell cellId]
                                                                   forIndexPath:indexPath];
    [cell observeBook:book];

    return cell;
}

// MARK: - TableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    Book *book = [self getBook:[self.fetchedResultsController objectAtIndexPath:indexPath]];

    [self saveLastBookSelected: book];

    BookViewController *bVC = [[BookViewController alloc]initWithModel:book];


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
-(Book *)getBook:(NSManagedObject *)object{

    if ([object isKindOfClass:[BookTag class]]) {

        BookTag *bookTag = (BookTag *)object;
        return bookTag.book;

    }
    if ([object isKindOfClass:[Book class]]){

        return (Book *)object;
    }
    return nil;
}
-(void)postNotificationForBook:(Book *)book{


    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    NSNotification *notif = [NSNotification notificationWithName:@"lastBookSelected"
                                                          object:self
                                                        userInfo:@{@"lastBookSelected": book}];
    [nc postNotification:notif];
}
-(void)registerCell{

    UINib *nib = [UINib nibWithNibName:@"BookTableViewCell" bundle:nil];

    [self.tableView registerNib:nib forCellReuseIdentifier:[BookTableViewCell cellId]];
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

    NSLog(@"bookData: %@, bookUri: %@, id: %@", bookData, bookUri, id);

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

    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Book entityName]];

    // TODO: - por alguna razon no estoy recuperando ningun libro. Se supone que ya se han guardado...
    NSError *error;
    NSArray *res = [self.context executeFetchRequest:req
                                               error:&error];
    NSData *bookData = nil;
    if (!error && res != nil && [res count] > 0) {
        Book *book = [res firstObject];
        [self saveLastBookSelected:book];
    }

    // Recuperamos
    bookData = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastSelectedBook"];

    return bookData;
}

// MARK: - UISearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    [self searchBooksWithText:searchText];

}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{

    [self.searchController.searchBar setShowsCancelButton:NO animated:YES];
    [self setDefaultFetchedResultsController];

}

// MARK: - UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{

//    NSString *searchText = searchController.searchBar.text;
//    
//    if ([searchText isEqualToString:@""] || !searchController.active) {
//        [self setDefaultFetchedResultsController];
//    } else {
//        [self searchBooksWithText:searchText];
//    }
}

-(void)searchBooksWithText:(NSString *)searchText{

    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Book entityName]];

    NSMutableArray *predicates = [[NSMutableArray alloc]init];

    NSPredicate *titlePred = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchText];
    [predicates addObject:titlePred];
    NSPredicate *authorPred = [NSPredicate predicateWithFormat:@"ANY authors.name CONTAINS[cd] %@", searchText];
    [predicates addObject:authorPred];
    NSPredicate *tagPred = [NSPredicate predicateWithFormat:@"ANY bookTags.tag.name CONTAINS[cd] %@", searchText];
    [predicates addObject:tagPred];
    
    req.predicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
    
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    
    [self setFetchedResultsControllerWithRequest:req];
}

// MARK: - utils
-(void)setFetchedResultsControllerWithRequest:(NSFetchRequest *)request{

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];

}

-(void)setDefaultFetchedResultsController{

    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[BookTag entityName]];

    req.fetchBatchSize = 40;

    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES],
                            [NSSortDescriptor sortDescriptorWithKey:@"book.title" ascending:YES]];

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:@"tag.name"
                                                                                   cacheName:nil];
}




@end
