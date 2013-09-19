//
//  PostDoc.m
//  Posts
//
//  Created by MEGHA GULATI on 9/10/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import "PostDoc.h"
#import "PostData.h"

@implementation PostDoc

-(id)initWithUserName:(NSString *)userName title:(NSString*)title content:(NSString*)content imageFilename:(NSString *)imageFilename postColor:(UIColor*)postColor{
    if ((self = [super init])) {
        self.data = [[PostData alloc] initWithTimeStamp];
        self.data.userName = userName;
        self.data.title = title;
        self.data.content = content;
        self.data.imageFilename = imageFilename;
        self.data.postColor = postColor;
    }
    return self;
}

@end
