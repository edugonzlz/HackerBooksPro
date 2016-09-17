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

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *photoFromCamera = [UIAlertAction actionWithTitle:@"Take photo from Camera"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {

                                                                // Comprobar si esta disponible
                                                                if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                                                                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                } else {
                                                                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                                }
                                                                [self presentViewController:picker animated:true completion:^{
                                                                }];

                                                            }];

    UIAlertAction *photoFromLibrary = [UIAlertAction actionWithTitle:@"Take photo from Library"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {

                                                                 picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                                 [self presentViewController:picker animated:true completion:^{
                                                                 }];

                                                             }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {

                                                   }];
    [alert addAction:photoFromCamera];
    [alert addAction:photoFromLibrary];
    [alert addAction:cancel];
    [self presentViewController:alert animated:true completion:^{

    }];



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
    self.model.photo.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:true completion:^{

    }];
}

@end
