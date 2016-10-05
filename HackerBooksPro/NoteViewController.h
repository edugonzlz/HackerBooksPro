//
//  NoteViewController.h
//  HackerBooksPro
//
//  Created by Edu González on 14/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Book;
@class Note;

@interface NoteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)displayPhoto:(id)sender;
- (IBAction)displayMap:(id)sender;
- (IBAction)deleteNote:(id)sender;
- (IBAction)shareNote:(id)sender;

-(id)initWithModel:(id)model;

-(id)initNewNoteForBook:(Book *)book;

@end
