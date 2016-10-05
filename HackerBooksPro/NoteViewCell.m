//
//  NoteViewCell.m
//  HackerBooksPro
//
//  Created by Edu González on 14/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import "NoteViewCell.h"
#import "Note.h"
#import "PhotoNote.h"

@interface NoteViewCell ()

@property (strong, nonatomic)Note *note;

@end

@implementation NoteViewCell

// MARK: - Class Methods
+(NSArray *)observableKeys{

    return @[@"text", @"modificationDate", @"photo.imageData"];
}

// MARK: - Utils
-(void)observeNote:(Note *)note{

    self.note = note;

    for (NSString *key in [NoteViewCell observableKeys]) {
        [self.note addObserver:self
                    forKeyPath:key
                       options:NSKeyValueObservingOptionNew
                       context:NULL];
    }

    [self syncModelView];
}
-(void)prepareForReuse{
    for (NSString *key in [NoteViewCell observableKeys]) {
        [self.note removeObserver:self
                       forKeyPath:key];
    }

    // Reseteamos la celda para que la usen de nuevo
    self.note = nil;
    [self syncModelView];
}

-(void)syncModelView{

    self.titleLabel.text = self.note.text;

    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.dateFormat = @"HH:mm - dd/MM/yyyy";
    self.subtitleLabel.text = [formater stringFromDate: self.note.modificationDate];

    // si no tenemos foto devolvemos una por defecto
    UIImage *image;
    if (self.note.photo.image == nil) {
        image = [UIImage imageNamed:@"noImage.png"];
    }else{
        image = self.note.photo.image;
    }
    self.photoView.image = image;
}

// MARK: - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{

    [self syncModelView];
}


@end
