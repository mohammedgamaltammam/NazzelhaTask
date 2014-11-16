//
//  FlickrPhotosParser.m
//  NazzelhaTask
//
//  Created by Mohammed Gamal on 11/5/14.
//  Copyright (c) 2014 Mohammed Gamal. All rights reserved.
//

#import "FlickrPhotosParser.h"
#import "Photo.h"

@implementation FlickrPhotosParser

-(NSMutableArray*)photoObjectsFromPhotosTag:(NSArray*)photos
{
    
    NSMutableArray* photoObjects = [NSMutableArray array];
    // Loop through each entry in the dictionary...
    for (NSDictionary *photo in photos)
    {
        Photo* photoObject = [[Photo alloc]init];
        // Get title of the image
        NSString *title = [photo objectForKey:@"title"];
        photoObject.photoTitle = title;

        // Build the URL to where the image is stored (see the Flickr API)
        // In the format http://farmX.static.flickr.com/server/id_secret.jpg
        // Notice the "_s" which requests a "small" image 75 x 75 pixels
        NSString *photoURLString =
        [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg",
        [photo objectForKey:@"farm"], [photo objectForKey:@"server"],
        [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
        
        photoObject.photoUrl=photoURLString;
        
        [photoObjects addObject:photoObject];
    }
    return photoObjects;
}
@end
