//
//  AppDelegate.h
//  TableSearchExample
//
//  Created by hemant kumar on 03/01/13.
//  Copyright (c) 2013 hemant kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

{
    
UINavigationController	*navController;
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (strong, nonatomic) TableViewController *viewController;

@end
