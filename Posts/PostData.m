//
//  PostData.m
//  Posts
//
//  Created by MEGHA GULATI on 9/10/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import "PostData.h"

@implementation PostData

- (id)initWithTimeStamp{
    if(self = [super init]){
        
        NSDateFormatter *formatter;
        NSString        *dateString;
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
        
        dateString = [formatter stringFromDate:[NSDate date]];
        _timeStamp = dateString;
    }
    return self;
}

@end
