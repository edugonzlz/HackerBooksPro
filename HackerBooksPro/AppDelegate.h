//
//  AppDelegate.h
//  HackerBooksPro
//
//  Created by Edu González on 10/9/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AGTSimpleCoreDataStack;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) AGTSimpleCoreDataStack *model;

-(void)JSONSerialization:(NSData *)JSONData;

@end

