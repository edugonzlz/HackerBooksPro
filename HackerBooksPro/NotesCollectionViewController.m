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

@interface NotesCollectionViewController ()

@end

static NSString *cellId = @"noteCell";

@implementation NotesCollectionViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self registerCell];

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

@end
