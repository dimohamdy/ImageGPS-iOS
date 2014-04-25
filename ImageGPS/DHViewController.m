//
//  DHViewController.m
//  ImageGPS
//
//  Created by BinaryBoy on 4/23/14.
//  Copyright (c) 2014 BinaryBoy. All rights reserved.
//

#import "DHViewController.h"
#import "NSMutableDictionary+ImageMetadata.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "Reachability.h"

@interface DHViewController ()

@end

@implementation DHViewController{
    BOOL canConnect;
}
@synthesize imgPicker,loadingView,siteView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.imgPicker = [[UIImagePickerController alloc] init];
    self.imgPicker.delegate = self;
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    siteView.delegate = self;
    siteView.scalesPageToFit = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissModalViewControllerAnimated:YES];
    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    __block NSDictionary *metaDataDict;

    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        metaDataDict = [representation metadata];
        NSLog(@"%@",[metaDataDict  objectForKey:@"GPS"]);
       NSDictionary*gpsDic= [metaDataDict  objectForKey:@"{GPS}"];
        // Build the url and loadRequest
        NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/?ie=UTF8&hq=&ll=%@,%@&z=13",[gpsDic objectForKey:@"Latitude"],[gpsDic objectForKey:@"Longitude"]];
        
        [self checkBeforeLoadUrl];
        if (canConnect) {
            [self loadSite:urlString];
        }
        
        


    } failureBlock:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
}

- (IBAction)PickImage:(id)sender {
    imgPicker.delegate = self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentModalViewController:imgPicker animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    loadingView.hidden=YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    
    UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Connection" message:@"Check Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [Alert show];
    
    
}
-(void)loadSite:(NSString*)urlString
{
    
    // NSString* url = @"http://mobile.hemohj.gov.sa";
    
    //Load web view data
    //NSString *strWebsiteUlr = [NSString stringWithFormat:@"http://mobile.hemohj.gov.sa"];
    //NSString *strWebsiteUlr = [NSString stringWithFormat:urlString];

    // Load URL
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlString];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [siteView loadRequest:requestObj];
    
    
}
-(void)checkBeforeLoadUrl{
Reachability* wifiReach = [Reachability reachabilityWithHostName: @"www.apple.com"];
NetworkStatus netStatus = [wifiReach currentReachabilityStatus];

switch (netStatus)
{
    case NotReachable:
    {
        NSLog(@"Access Not Available");
        UIAlertView*Alert=[[UIAlertView alloc]initWithTitle:@"Connection" message:@"Check Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];
        canConnect=NO;

        break;
    }
        
    case ReachableViaWWAN:
    {
        NSLog(@"Reachable WWAN");
        //[self loadSite];
        canConnect=YES;
        
        break;
    }
    case ReachableViaWiFi:
    {
        NSLog(@"Reachable WiFi");
        //[self loadSite];
        canConnect=YES;

        
        break;
    }
}

}

@end
