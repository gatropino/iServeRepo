//
//  TouchProtocol.h
//  dragAndDrop
//
//  Created by xcode on 10/23/13.
//  Copyright (c) 2013 xcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TouchProtocol <NSObject>

-(void)collisionCheck:(id)sender x:(float)x y:(float)y transactionComplete: (BOOL)dropObject;
-(void)dragCompletedUnhighlightAll;

@end
