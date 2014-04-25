//
//  DHViewController.h
//  ImageGPS
//
//  Created by BinaryBoy on 4/23/14.
//  Copyright (c) 2014 BinaryBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHViewController : UIViewController<UIImagePickerControllerDelegate,UIWebViewDelegate>{
    UIImagePickerController *imgPicker;
}
- (IBAction)PickImage:(id)sender;
@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (weak, nonatomic) IBOutlet UIWebView *siteView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@end
