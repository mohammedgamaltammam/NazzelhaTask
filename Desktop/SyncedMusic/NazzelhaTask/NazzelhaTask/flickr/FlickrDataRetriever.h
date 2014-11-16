//
//  FlickrDataRetriever.h
//  NazzelhaTask
//
//  Created by Mohammed Gamal on 11/4/14.
//  Copyright (c) 2014 Mohammed Gamal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrDataRetrieverDelegate.h"
@interface FlickrDataRetriever : NSObject <NSURLConnectionDataDelegate>


@property (nonatomic,strong)NSArray *photos;
@property (nonatomic,strong)id <FlickrDataRetrieverDelegate> delegate;


-(void)initializeRequestWithKey:(NSString*)flickrAPIKey Page:(NSInteger)page SearchWord:(NSString*)word;
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
@end
