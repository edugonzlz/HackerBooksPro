//
//  PhotoViewController.h
//  HackerBooksPro
//
//  Created by Edu González on 17/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface PhotoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (nonatomic, strong) Note *model;

-(id)initWithNote:(Note *)note;

- (IBAction)takePhoto:(id)sender;
- (IBAction)deletePhoto:(id)sender;


@end
