//
//  ShareAPI.h
//  APmenu
//
//  Created by Alfredo E. Pérez L. on 3/7/15.
//  Copyright (c) 2015 Alfredo E. Pérez L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareAPI : NSObject{
    
}
@property (strong, nonatomic) NSString *mainURL;
@property (strong, nonatomic) NSString *row;
@property (strong, nonatomic) NSString *tableTitle;
@property (strong, nonatomic) NSString *section;
@property (strong, nonatomic) NSArray *Category;
@property (strong, nonatomic) NSDictionary *Categories;
+(ShareAPI*)sharedInstance;



@end
