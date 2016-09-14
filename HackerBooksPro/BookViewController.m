//
//  BookViewController.m
//  HackerBooksPro
//
//  Created by Edu González on 14/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import "BookViewController.h"
#import "PhotoCover.h"

@interface BookViewController ()

@end

@implementation BookViewController


-(void)initWithModel:(Book *)model{


    if (self == [super initWithNibName:nil bundle:nil]) {

        self.model = model;
    };
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.authorsLabel.text = self.model.author;
    self.tagsLabel.text = self.model.tagsString;
    self.coverImage.image = self.model.photoCover.image;

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
}

- (IBAction)readPdf:(UIBarButtonItem *)sender {
}

- (IBAction)readNotes:(UIBarButtonItem *)sender {
}

- (IBAction)viewNotesMap:(UIBarButtonItem *)sender {
}
@end
