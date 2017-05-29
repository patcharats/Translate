//
//  AppDelegate.h
//  Translate
//
//  Created by CBK-Admin on 5/29/2560 BE.
//  Copyright © 2560 CBK-Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

