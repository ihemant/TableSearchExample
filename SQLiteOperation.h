//
//  SQLiteOperation.h
//  cococalorie
//
//  Created by Coco on 12-4-10.
//  Copyright 2012 Coco. All rights reserved.
//

//#import "/usr/include/sqlite3.h"
#import <sqlite3.h>
#import "Country.h"

@interface SQLiteOperation : NSObject {
	sqlite3 *mDatabase;
}

+ (SQLiteOperation *)shared;
- (void)addCountry:(Country *)countryobj;




- (NSArray *)getAllCountry;



- (void)cleanAllDataFromCountry;




//- (NSString *)urlEncodeValue:(NSString *)str ;
//- (NSString *)urlEncodeValue:(NSString *)str ;

@end
