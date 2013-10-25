//
//  MenuItem.h
//  dragAndDrop
//
//  Created by xcode on 10/23/13.
//  Copyright (c) 2013 xcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject

@property NSString *name;        // aka, textLabel
@property NSString *parentName;
@property NSString *destination;
@property NSString *text;
@property NSString *type;
@property NSString *viewLevel;
@property NSString *receives;

@property float ht;
@property float wd;
@property float xDefault;
@property float yDefault;

@property NSString *imageLocation;

@end