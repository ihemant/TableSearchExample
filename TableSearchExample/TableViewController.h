//
//  TableViewController.h
//  TableSearchExample
//
//  Created by hemant kumar on 03/01/13.
//  Copyright (c) 2013 hemant kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController<UISearchDisplayDelegate, UISearchBarDelegate>
{
    NSString *savedSearchTerm;
    NSMutableArray *contentsList;
	NSMutableArray *searchResults;
    BOOL found;
    NSString *key;
    NSMutableDictionary *totalSections;
    NSMutableArray *cellCount;
    
    
}
@property(strong,nonatomic)  NSString *savedSearchTerm;
@property(strong,nonatomic)NSMutableArray *contentsList;

@property(strong,nonatomic)NSMutableArray *sectionArray;
@property (nonatomic, strong) UILocalizedIndexedCollation *collation;

@property(strong,nonatomic)NSMutableArray *searchResults;
+ (NSArray *)countryNames;
+ (NSArray *)countryCodes;
+ (NSDictionary *)countryNamesByCode;
+ (NSDictionary *)countryCodesByName;
@end
