//
//  FlickrPhotosParser.h
//  NazzelhaTask
//
//  Created by Mohammed Gamal on 11/5/14.
//  Copyright (c) 2014 Mohammed Gamal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrPhotosParser : NSObject

-(NSArray*)photoObjectsFromPhotosTag:(NSArray*)photos;
@end
