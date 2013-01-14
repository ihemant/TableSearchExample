//
//  DetailViewController.h
//  TableSearchExample
//
//  Created by hemant kumar on 04/01/13.
//  Copyright (c) 2013 hemant kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property(strong,nonatomic) NSString *labelStr;

@property (weak, nonatomic) IBOutlet UILabel *labelTxt;
@end
