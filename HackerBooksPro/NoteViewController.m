//
//  NoteViewController.m
//  HackerBooksPro
//
//  Created by Edu González on 14/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import "NoteViewController.h"

@interface NoteViewController ()

@end

@implementation NoteViewController


-(id)initWithModel:(Note *)model{

    if (self == [super initWithNibName:nil bundle:nil]) {

        _model = model;
    }
    
    return self;
}
-(id)initNewNoteForBook:(Book *)book{

    Note *newNote = [Note noteWithBook:book
                             inContext:book.managedObjectContext];

    return [self initWithModel:newNote];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.title = self.model.text;
}

- (IBAction)displayPhoto:(id)sender {
}

- (IBAction)displayMap:(id)sender {
}

- (IBAction)deleteNote:(id)sender {
}

- (IBAction)addNewNote:(id)sender {
}
@end
