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
#import "MapViewController.h"

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

    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];

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
        self.model.isFavoriteValue = YES;

    } else if (fav){
        self.model.isFavoriteValue = NO;
    }

    [self syncModelWithView];
}

- (IBAction)readPdf:(UIBarButtonItem *)sender {

    PdfViewController *pdfVC = [[PdfViewController alloc]initWithModel:self.model];

    [self.navigationController pushViewController:pdfVC animated:YES];
}

- (IBAction)readNotes:(UIBarButtonItem *)sender{

    NotesCollectionViewController *notesVC = [[NotesCollectionViewController alloc]initWithBook:self.model
                                                                                      inContext:self.model.managedObjectContext];
    [self.navigationController pushViewController:notesVC animated:true];
}

- (IBAction)viewNotesMap:(UIBarButtonItem *)sender {

    // TODO: - estamos mostrando todas las localizaciones?
    // hacer un req con las notas de este libro
    // enviar un array de las locations de las notas

    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Note entityName]];
    req.predicate = [NSPredicate predicateWithFormat:@"book == %@", self.model];

    NSError *error;
    NSArray *res = [self.model.managedObjectContext executeFetchRequest:req
                                                                  error:&error];
    NSAssert(res, @"Error buscando notas");

    if (res != nil && [res count] >0) {

        NSMutableArray *locArray = [[NSMutableArray alloc]init];
        for (Note *note in res) {
            if (note.location) {

                [locArray addObject:note.location];
            }
        }

        MapViewController *mapVC = [[MapViewController alloc]initWithLocations:locArray];

        [self.navigationController pushViewController:mapVC animated:YES];
    }
}

// MARK: - Utils
-(void)syncModelWithView{

    self.title = self.model.title;
    self.authorsLabel.text = self.model.authorsString;
    self.tagsLabel.text = self.model.tagsString;
    self.coverImage.image = self.model.photoCover.image;

    // Favorito
    BOOL fav = self.model.isFavoriteValue;
    if (fav) {
        self.favButton.tintColor = [UIColor orangeColor];

    } else if (!fav){
        self.favButton.tintColor = [UIColor grayColor];

    }
}

// MARK: - lastBookSelectedNotification
-(void)didSelectedBook:(NSNotification *)notification{
    
    Book *book = [notification.userInfo objectForKey:@"lastBookSelected"];
    self.model = book;
    [self syncModelWithView];
}
@end
