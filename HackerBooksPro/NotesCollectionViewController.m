//
//  NotesCollectionViewController.m
//  HackerBooksPro
//
//  Created by Edu González on 14/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import "NotesCollectionViewController.h"
#import "Note.h"
#import "NoteViewCell.h"
#import "NoteViewController.h"
#import "Book.h"

@interface NotesCollectionViewController ()

@end

static NSString *cellId = @"noteCell";

@implementation NotesCollectionViewController

// MARK: - Inits
-(id)initWithBook:(Book *)book{

    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Note entityName]];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:NoteAttributes.modificationDate ascending:NO]];

    req.predicate = [NSPredicate predicateWithFormat:@"book == %@", book];

    NSFetchedResultsController *frC = [[NSFetchedResultsController alloc]initWithFetchRequest:req
                                                                         managedObjectContext:book.managedObjectContext
                                                                           sectionNameKeyPath:nil
                                                                                    cacheName:nil];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake(140, 150);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);

    if (self = [super initWithFetchedResultsController:frC
                                                layout:layout]) {
        self.fetchedResultsController = frC;
        self.book  = book;
    }
    return self;
}

// MARK: - LifeCycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    // Notificacion cuando se selecciona book en SplitView
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didSelectedBook:)
                                                name:@"lastBookSelected"
                                              object:nil];

    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];

    [self registerCell];

    UIBarButtonItem *addNote = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(addNote:)];
    self.navigationItem.rightBarButtonItem = addNote;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

// MARK: - DataSource
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    Note *note = [self.fetchedResultsController objectAtIndexPath:indexPath];

    NoteViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellId
                                                                        forIndexPath:indexPath];
    [cell observeNote:note];

    return cell;
}

// MARK: - CollectionDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    Note *note = [self.fetchedResultsController objectAtIndexPath:indexPath];

    NoteViewController *nVC = [[NoteViewController alloc]initWithModel:note];

    [self.navigationController pushViewController:nVC animated:true];
}

// MARK: - Utils
-(void)didSelectedBook:(NSNotification *)notification{

    Book *book = [notification.userInfo objectForKey:@"lastBookSelected"];
    self.book = book;

    [self.collectionView reloadData];
}

-(void)registerCell{

    UINib *nib = [UINib nibWithNibName:@"NoteViewCell"
                                bundle:nil];

    [self.collectionView registerNib:nib
          forCellWithReuseIdentifier:cellId];
}

-(void)addNote:(id)sender{

    NoteViewController *nVC = [[NoteViewController alloc]initNewNoteForBook:self.book];

    [self.navigationController pushViewController:nVC animated:true];
}
@end
