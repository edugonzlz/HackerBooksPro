//
//  PhotoViewController.m
//  HackerBooksPro
//
//  Created by Edu González on 17/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoNote.h"

#define IS_IPHONE UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone

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


    if (IS_IPHONE) {

        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.allowsEditing = YES;

        picker.delegate = self;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];

        UIAlertAction *photoFromCamera = [UIAlertAction actionWithTitle:@"Take photo from Camera"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {

                                                                    // Comprobar si esta disponible
                                                                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {

                                                                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                    } else {
                                                                        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                                    }

                                                                    [self presentViewController:picker animated:true completion:nil];

                                                                }];

        UIAlertAction *photoFromLibrary = [UIAlertAction actionWithTitle:@"Take photo from Library"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {

                                                                     // TODO: - Si estamos en un ipad tenemos que presentarlo en un popover

                                                                     picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

                                                                     [self presentViewController:picker animated:true completion:nil];

                                                                 }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) {

                                                       }];
        [alert addAction:photoFromCamera];
        [alert addAction:photoFromLibrary];
        [alert addAction:cancel];
        [self presentViewController:alert animated:true completion:nil];
    }

}

- (IBAction)deletePhoto:(id)sender {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"Are You Sure"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete Photo"
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * _Nonnull action) {

                                                       [self.model.managedObjectContext deleteObject:self.model.photo];
                                                       [self.navigationController popViewControllerAnimated:true];
                                                   }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       
                                                   }];
    [alert addAction:delete];
    [alert addAction:cancel];
    [self presentViewController:alert animated:true completion:^{
    }];
}

// MARK: - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    // extraemos la foto del diccionario
    self.model.photo.image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
