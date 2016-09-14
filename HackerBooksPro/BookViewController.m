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

@interface BookViewController ()

@end

@implementation BookViewController


-(id)initWithModel:(Book *)model{

    if (self = [super initWithNibName:nil bundle:nil]) {

        self.model = model;
    };
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self syncModelWithView];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)switchFav:(UIBarButtonItem *)sender {

// TODO: - esperando respuesta de fernando

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
}

- (IBAction)viewNotesMap:(UIBarButtonItem *)sender {
}

-(void)syncModelWithView{

    self.title = self.model.title;
    self.authorsLabel.text = self.model.author;
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
@end
