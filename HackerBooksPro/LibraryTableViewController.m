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

@end

@implementation LibraryTableViewController

// MARK: - Inits
-(id)initWithContext:(NSManagedObjectContext *)context{

    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[BookTag entityName]];

    req.fetchBatchSize = 40;

    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"tag.name" ascending:YES],
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
        self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    }

    return self;
}

// MARK: - Lifecycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.tableView.tableHeaderView = self.searchBar;
    [self registerCell];

    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search a book...";

    // Ocultamos la barra de busqueda debajo de la navigationBar
//    CGRect newBounds = self.tableView.bounds;
//    newBounds.origin.y = newBounds.origin.y + self.searchBar.bounds.size.height;
//    self.tableView.bounds = newBounds;

    [self.tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
}

// MARK: - DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *cellId = @"bookCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:cellId];
    }

    //book
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];

    // Buscamos bookTag y de ahi el libro
    if ([object isKindOfClass:[BookTag class]]) {

        BookTag *bookTag = (BookTag *)object;
        Book *book = bookTag.book;

        cell.textLabel.text = book.title;
        cell.imageView.image = book.photoCover.image;
        cell.detailTextLabel.text = book.tagsString;

    } else if ([object isKindOfClass:[Book class]]){

        Book *book = (Book *)object;

        cell.textLabel.text = book.title;
        cell.imageView.image = book.photoCover.image;
        cell.detailTextLabel.text = book.tagsString;
    }


//    BookTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[BookTableViewCell cellId]
//                                                                   forIndexPath:indexPath];
//    [cell observeBook:book];

    return cell;
}

// MARK: - TableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    // Buscamos bookTag y de ahi el libro
    BookTag *bookTag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //book
    Book *book = bookTag.book;

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

    [self.searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    self.searchBar.showsCancelButton = YES;

//    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[BookTag entityName]];
//    req.resultType = NSDictionaryResultType;
//    req.propertiesToFetch = @[@"book", @"tag"];
//    req.returnsDistinctResults = YES;
//
//    NSMutableArray *predicates = [[NSMutableArray alloc]init];
//
//    NSPredicate *titlePred = [NSPredicate predicateWithFormat:@"book.title CONTAINS[cd] %@", searchText];
//    [predicates addObject:titlePred];
//
//    NSPredicate *authorPred = [NSPredicate predicateWithFormat:@"ANY book.authors.name CONTAINS[cd] %@", searchText];
//    [predicates addObject:authorPred];
//
//    NSPredicate *tagPred = [NSPredicate predicateWithFormat:@"tag.name CONTAINS[cd] %@", searchText];
//    [predicates addObject:tagPred];

    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Book entityName]];

    NSMutableArray *predicates = [[NSMutableArray alloc]init];

    NSPredicate *titlePred = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchText];
    [predicates addObject:titlePred];
    NSPredicate *authorPred = [NSPredicate predicateWithFormat:@"ANY authors.name CONTAINS[cd] %@", searchText];
    [predicates addObject:authorPred];
    NSPredicate *tagPred = [NSPredicate predicateWithFormat:@"ANY booktags CONTAINS[cd] %@", searchText];
    [predicates addObject:tagPred];

    req.predicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];

    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];

    [self setFetchedResultsControllerWithRequest:req];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{

    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar endEditing:YES];
    self.searchBar.text = nil;

    [self setDefaultFetchedResultsController];
}

-(void)setFetchedResultsControllerWithRequest:(NSFetchRequest *)request{

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];

}
-(void)setDefaultFetchedResultsController{

    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[BookTag entityName]];

    req.fetchBatchSize = 40;

    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"tag.name" ascending:YES],
                            [NSSortDescriptor sortDescriptorWithKey:@"book.title" ascending:YES]];

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                                         managedObjectContext:self.context
                                                                           sectionNameKeyPath:@"tag.name"
                                                                                    cacheName:nil];
}


@end
