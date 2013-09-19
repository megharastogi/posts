//
//  Post.h
//  Posts
//
//  Created by MEGHA GULATI on 9/16/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSRails/NSRails.h>

@interface Post : NSRRemoteObject
@property (nonatomic) NSString* userName;
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* content;
@property (nonatomic) NSString* createdAt;
@property (nonatomic) NSString* imageFilename;

@property (nonatomic) NSNumber* id;


@end
