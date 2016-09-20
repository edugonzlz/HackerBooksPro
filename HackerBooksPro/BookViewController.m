//
//  BookViewController.m
//  HackerBooksPro
//
//  Created by Edu González on 14/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import "BookViewController.h"
#import "PhotoCover.h"
#import "PdfViewController.h"
#import "Book.h"
#import "Note.h"
#import "NotesCollectionViewController.h"

@interface BookViewController ()

@end

@implementation BookViewController

// MARK: - Inits
-(id)initWithModel:(Book *)model{

    if (self = [super initWithNibName:nil bundle:nil]) {

        _model = model;
    };
    return self;
}

// MARK: - LifeCycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didSelectedBook:)
                                                name:@"lastBookSelected"
                                              object:nil];


    [self syncModelWithView];
}

-(void)viewDidDisappear:(BOOL)animated{

// TODO: - no voy a dar de baja para no implementar delegado
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// MARK: - Actions
- (IBAction)switchFav:(UIBarButtonItem *)sender {

    BOOL fav = self.model.isFavoriteValue;
    if (!fav) {
        self.model.isFavorite = [NSNumber numberWithBool:YES];

    } else if (fav){
        self.model.isFavorite = [NSNumber numberWithBool:NO];
    }

    [self syncModelWithView];
}

- (IBAction)readPdf:(UIBarButtonItem *)sender {

    PdfViewController *pdfVC = [[PdfViewController alloc]initWithModel:self.model];

    [self.navigationController pushViewController:pdfVC animated:YES];
}

- (IBAction)readNotes:(UIBarButtonItem *)sender {

//    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Note entityName]];
//    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:NoteAttributes.modificationDate ascending:NO]];
//
//    req.predicate = [NSPredicate predicateWithFormat:@"book == %@", self.model];
//
//    NSFetchedResultsController *frC = [[NSFetchedResultsController alloc]initWithFetchRequest:req
//                                                                         managedObjectContext:self.model.managedObjectContext
//                                                                           sectionNameKeyPath:nil
//                                                                                    cacheName:nil];
//
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    layout.minimumLineSpacing = 10;
//    layout.minimumInteritemSpacing = 10;
//    layout.itemSize = CGSizeMake(140, 150);
//    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
//
//    NotesCollectionViewController *notesVC = [NotesCollectionViewController coreDataCollectionViewControllerWithFetchedResultsController:frC
//                                                                                                                                  layout:layout];
//    notesVC.book = self.model;


    NotesCollectionViewController *notesVC = [[NotesCollectionViewController alloc]initWithBook:self.model];

    [self.navigationController pushViewController:notesVC animated:true];
}

- (IBAction)viewNotesMap:(UIBarButtonItem *)sender {
}

// MARK: - Utils
-(void)syncModelWithView{

    self.title = self.model.title;
    self.authorsLabel.text = self.model.author;
//    self.tagsLabel.text = self.model.tagsString;
    self.coverImage.image = self.model.photoCover.image;

    // Favorito
    BOOL fav = self.model.isFavoriteValue;
    if (fav) {
        self.favButton.tintColor = [UIColor orangeColor];

    } else if (!fav){
        self.favButton.tintColor = [UIColor grayColor];

    }
}

-(void)didSelectedBook:(NSNotification *)notification{

    Book *book = [notification.userInfo objectForKey:@"lastBookSelected"];
    self.model = book;
    [self syncModelWithView];
}
@end
