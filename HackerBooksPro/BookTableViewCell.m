//
//  BookTableViewCell.m
//  HackerBooksPro
//
//  Created by Edu González on 20/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import "BookTableViewCell.h"
#import "Book.h"
#import "Author.h"
#import "PhotoCover.h"

@interface BookTableViewCell ()

@property (strong, nonatomic)Book *book;

@end

@implementation BookTableViewCell

// MARK: - Class Methods
+(NSString *)cellId{
    return NSStringFromClass(self);
}

+(NSArray *)observableKeys{

    return @[@"photoCover.imageData", @"authors"];
}

+(CGFloat)cellHeight{
    return 72.0f;
}

// MARK: - Init
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

// MARK: - Utils
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)observeBook:(Book *)book{

    self.book = book;

    for (NSString *key in [BookTableViewCell observableKeys]) {
        [self.book addObserver:self
                    forKeyPath:key
                       options:NSKeyValueObservingOptionNew
                       context:NULL];
    }

    [self syncModelView];
}
-(void)prepareForReuse{
    for (NSString *key in [BookTableViewCell observableKeys]) {
        [self.book removeObserver:self
                       forKeyPath:key];
    }

    // Reseteamos la celda para que la usen de nuevo
    self.book = nil;
    [self syncModelView];
}
-(void)syncModelView{

    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];

    self.titleLabel.text = self.book.title;
    self.subTitleLabel.text = self.book.authorsString;
    self.imageView.image = self.book.photoCover.image;
}

// MARK: - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{

    [self syncModelView];
}



@end
