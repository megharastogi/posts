//
//  PostData.h
//  Posts
//
//  Created by MEGHA GULATI on 9/10/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostData : NSObject
    @property (nonatomic) NSString* userName;
    @property (nonatomic) NSString* title;
    @property (nonatomic) NSString* content;
    @property (nonatomic) NSString* timeStamp;

    - (id)initWithTimeStamp;

@end
