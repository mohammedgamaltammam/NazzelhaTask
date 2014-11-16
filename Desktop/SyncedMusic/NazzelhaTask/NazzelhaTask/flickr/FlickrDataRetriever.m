//
//  FlickrDataRetriever.m
//  NazzelhaTask
//
//  Created by Mohammed Gamal on 11/4/14.
//  Copyright (c) 2014 Mohammed Gamal. All rights reserved.
//

#import "FlickrDataRetriever.h"

@implementation FlickrDataRetriever


-(void)initializeRequestWithKey:(NSString*)flickrAPIKey Page:(NSInteger)page SearchWord:(NSString*)word
{
    NSString *urlString =
    [NSString stringWithFormat:
     @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=50&page=%d&format=json&nojsoncallback=1",flickrAPIKey,word,(int)page ];
    
    // Create NSURL string from formatted string
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Setup and start async download
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Create a dictionary from the JSON string
    NSDictionary* results = [NSJSONSerialization
                                   JSONObjectWithData:data options:0 error:nil];
    
    // Build an array from the dictionary for easy access to each entry
    NSArray *photos = [[results objectForKey:@"photos"] objectForKey:@"photo"];
    [self.delegate DidDataReceivedWithPhotos:photos];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
    
    NSInteger errorCode = httpResponse.statusCode;
    
    NSString *fileMIMEType = [[httpResponse MIMEType] lowercaseString];
    
    NSLog(@"response is %d, %@", (int)errorCode, fileMIMEType);
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {    
    NSLog(@"Connection failed! Error - %@ %@",[error localizedDescription],[[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
}
@end
