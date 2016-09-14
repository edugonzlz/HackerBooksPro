//
//  BookViewController.h
//  HackerBooksPro
//
//  Created by Edu González on 14/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Book;

@interface BookViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *authorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favButton;
@property (nonatomic, strong) Book *model;

- (IBAction)switchFav:(UIBarButtonItem *)sender;
- (IBAction)readPdf:(UIBarButtonItem *)sender;
- (IBAction)readNotes:(UIBarButtonItem *)sender;
- (IBAction)viewNotesMap:(UIBarButtonItem *)sender;

-(id)initWithModel:(Book *)model;

@end
