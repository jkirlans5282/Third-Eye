//
//  ViewController.h
//  Third Eye
//
//  Created by Jacob Kirlan-Stout on 4/28/15.
//  Copyright (c) 2015 Jacob Kirlan-Stout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *cameraImage;

- (IBAction)fetchCameras:(id)sender;

@end

