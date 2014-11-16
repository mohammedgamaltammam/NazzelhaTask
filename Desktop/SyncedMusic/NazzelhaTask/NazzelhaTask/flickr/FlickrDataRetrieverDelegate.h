//
//  FlickrDataRetrieverDelegate.h
//  NazzelhaTask
//
//  Created by Mohammed Gamal on 11/4/14.
//  Copyright (c) 2014 Mohammed Gamal. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FlickrDataRetrieverDelegate <NSObject>

@required
-(void)DidDataReceivedWithPhotos:(NSArray*)photos;

@end
