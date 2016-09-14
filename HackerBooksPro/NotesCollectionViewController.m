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

@interface NotesCollectionViewController ()

@end

static NSString *cellId = @"noteCell";

@implementation NotesCollectionViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];

    [self registerCell];

    UIBarButtonItem *addNote = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(addNote:)];
    self.navigationItem.rightBarButtonItem = addNote;


}

-(void)addNote:(id)sender{

    NoteViewController *nVC = [[NoteViewController alloc]initNewNoteForBook:self.book];

    [self.navigationController pushViewController:nVC animated:true];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    Note *note = [self.fetchedResultsController objectAtIndexPath:indexPath];

    NoteViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellId
                                                                        forIndexPath:indexPath];
    [cell observeNote:note];

    return cell;
}

-(void)registerCell{

    UINib *nib = [UINib nibWithNibName:@"NoteViewCell"
                                bundle:nil];
    [self.collectionView registerNib:nib
          forCellWithReuseIdentifier:cellId];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    Note *note = [self.fetchedResultsController objectAtIndexPath:indexPath];

    NoteViewController *nVC = [[NoteViewController alloc]initWithModel:note];

    [self.navigationController pushViewController:nVC animated:true];
}

@end
