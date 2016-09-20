//
//  NoteViewController.m
//  HackerBooksPro
//
//  Created by Edu González on 14/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import "NoteViewController.h"
#import "Book.h"
#import "Note.h"
#import "PhotoNote.h"
#import "PhotoViewController.h"

@interface NoteViewController ()

@property (nonatomic)BOOL newNote;
@property (nonatomic)BOOL deleteNote;

@end

@implementation NoteViewController

// MARK: - Inits
-(id)initWithModel:(id)model{

    if (self = [super initWithNibName:nil bundle:nil]) {

        _model = model;
    }
    
    return self;
}
-(id)initNewNoteForBook:(Book *)book{

    Note *newNote = [Note noteWithBook:book
                             inContext:book.managedObjectContext];

    // marcamos la propiedad newNote para añadir un boton de cancelar
    _newNote = YES;

    return [self initWithModel:newNote];
}

// MARK: - Lifecycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
// TODO: - añadir un boton OK en la navigation o en una toolbar en el teclado para cerrar el teclado

    // Si es una nota nueva damos la posibilidad de cancelarla con un boton
    if (self.newNote){

        self.title = @"New Note";

        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                     target:self
                                                                                     action:@selector(cancelNote:)];
        self.navigationItem.rightBarButtonItem = cancelButton;

    }else{

        self.title = self.model.text;
        self.textView.text = self.model.text;

        UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                              target:self action:@selector(shareNote:)];
        self.navigationItem.rightBarButtonItem = share;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    if (self.deleteNote) {
        [self.model.managedObjectContext deleteObject:self.model];

    }else{
        self.model.text = self.textView.text;
    }
}

// MARK: - Actions
- (IBAction)displayPhoto:(id)sender {

    PhotoViewController *pVC = [[PhotoViewController alloc]initWithNote:self.model];

    [self.navigationController pushViewController:pVC animated:true];
}

- (IBAction)displayMap:(id)sender {
}

- (IBAction)deleteNote:(id)sender {
    self.deleteNote = YES;
    [self.navigationController popViewControllerAnimated:true];
}


- (IBAction)addNewNote:(id)sender {
}

- (void)shareNote:(id)sender {

    UIActivityViewController *aVC = [[UIActivityViewController alloc]initWithActivityItems:[self arrayOfItems]
                                                                     applicationActivities:nil];

    [self presentViewController:aVC animated:true completion:nil];
}

-(NSArray *)arrayOfItems{

    NSMutableArray *items = [NSMutableArray array];
    if (self.model.text) {
        [items addObject:self.model.text];
    }
    if (self.model.photo.image) {
        [items addObject:self.model.photo.image];
    }

    return items;
}

-(void)cancelNote:(id)sender{

    // si cancelamos la nota, la marcamos para borrarla y volvemos a la pantalla anterior
    self.deleteNote = YES;
    [self.navigationController popViewControllerAnimated:true];
}

@end
