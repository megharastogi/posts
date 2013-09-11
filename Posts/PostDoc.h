//
//  PostDoc.h
//  Posts
//
//  Created by MEGHA GULATI on 9/10/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostData.h"
@interface PostDoc : NSObject
    @property (nonatomic) PostData* data;
    -(id)initWithUserName:(NSString *)userName title:(NSString*)title content:(NSString*)content;
@end
