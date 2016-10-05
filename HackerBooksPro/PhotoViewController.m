//
//  PhotoViewController.m
//  HackerBooksPro
//
//  Created by Edu González on 17/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoNote.h"
#import "Note.h"
#import "UIImage+Resize.h"
@import CoreImage;

#define IS_IPHONE UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone

@interface PhotoViewController ()

@end

@implementation PhotoViewController

// MARK: - Inits
-(id)initWithNote:(Note *)note{

    if (self = [super initWithNibName:nil bundle:nil]) {

        _model = note;
    }

    return self;
}

// MARK: - LifeCycle
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

// TODO: - ya la he pasado al modelo en el metodo del delegado,,, la vuelvo a pasar al modelo?
//    self.model.photo.image = self.photoView.image;
}

// MARK: - Actions
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


    // Aunque en este caso y con mi telefono (iphone 6S) no tengo mucho consumo de memoria
    // implementamos el cambio de tamaño de la imagen para practicar y usar la libreria de Trevorrrr

    // extraemos la foto del diccionario
    __block UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];

    // calculamos el tamaño de la pantalla
    CGRect screenBounds = [[UIScreen mainScreen]bounds];
    CGFloat screenScale = [[UIScreen mainScreen]scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);

    // Redimensionamos proporcionalmente con respecto al ancho de la pantalla
    CGSize imageSize = image.size;
    CGSize newImageSize = CGSizeMake(screenSize.width, ((imageSize.height * screenSize.width) / imageSize.width));

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        // Redimensinamos la imagen
        image = [image resizedImage:newImageSize interpolationQuality:kCGInterpolationMedium];

        dispatch_async(dispatch_get_main_queue(), ^{

            self.photoView.image = image;
            self.model.photo.image = image;

        });
    });

    [self dismissViewControllerAnimated:true completion:nil];
}

@end
