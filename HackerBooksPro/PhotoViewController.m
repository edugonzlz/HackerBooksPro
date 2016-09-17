//
//  PhotoViewController.m
//  HackerBooksPro
//
//  Created by Edu González on 17/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoNote.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController


-(id)initWithNote:(Note *)note{

    if (self = [super initWithNibName:nil bundle:nil]) {

        _model = note;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.photoView.image = self.model.photo.image;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    self.model.photo.image = self.photoView.image;
}

- (IBAction)takePhoto:(id)sender {

    // Presentar un alert con dos opciones
    // hacer foto UIImagePickerControllerSourceTypeCamera
    // escoger del carrete UIImagePickerControllerSourceTypePhotoLibrary


    UIImagePickerController *picker = [[UIImagePickerController alloc]init];

    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    picker.delegate = self;

    [self presentViewController:picker animated:true completion:^{
    }];

}

- (IBAction)deletePhoto:(id)sender {
}

// MARK: - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    // extraemos la foto del diccionario
}

@end
