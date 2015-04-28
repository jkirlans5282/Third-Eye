//
//  ViewController.m
//  Third Eye
//
//  Created by Jacob Kirlan-Stout on 4/28/15.
//  Copyright (c) 2015 Jacob Kirlan-Stout. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
-(IBAction)fetchCameras:(id)sender;

@end

@implementation ViewController
@synthesize cameraImage=_cameraImage;
CLLocationManager *locationManager;
CLLocation *currentLocation;
UIImage *image=nil;
NSString *cameraId = nil;
-(IBAction)fetchCameras:(id)sender{
    NSLog(@"Fetch cameras");
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    cameraId = nil;
    if (currentLocation != nil) {
        NSString *requestedURL=[NSString stringWithFormat:@"https://api.evercam.io/v1/public/cameras/nearest?near_to=%lf,%lf&api_id=911566ac&api_key=2af132b6b2c0a9a4baab812b1352a666", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
        NSURL *url = [NSURL URLWithString:[requestedURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSLog([url absoluteString]);
        
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"GET"];
        
        [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
        
        NSError *err;
        
        NSURLResponse *response;
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request   returningResponse:&response error:&err];
        
        //You need to check response.Once you get the response copy that and paste in ONLINE JSON VIEWER.If you do this clearly you can get the correct results.
        
        //After that it depends upon the json format whether it is DICTIONARY or ARRAY

        NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options: NSJSONReadingMutableContainers error: &err];
        NSArray* array=[jsonArray valueForKeyPath:@"cameras.id"];
        NSLog(@"%@", array[0]);
        cameraId = [NSString stringWithFormat:@"https://api.evercam.io/v1/cameras/%@/live/snapshot?api_id=911566ac&api_key=2af132b6b2c0a9a4baab812b1352a666", array[0]];
        
        image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.evercam.io/v1/cameras/%@/live/snapshot?api_id=911566ac&api_key=2af132b6b2c0a9a4baab812b1352a666", array[0]]]]];
        
        
        [_cameraImage setImage:image];
        NSLog(@"done");
    }
   
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error handler");
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];

}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    currentLocation = newLocation;
    
    if(cameraId!=nil){
        NSLog(@"updatingimage");
        image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cameraId]]];
        [_cameraImage setImage:image];
        
    }


}
- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    //NSLog(@"%@",status);
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied||status==NULL) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [locationManager requestAlwaysAuthorization];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _cameraImage.contentMode  = UIViewContentModeScaleAspectFit;
    _cameraImage.clipsToBounds = YES;
    locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
    [self requestAlwaysAuthorization];
    
    //[locationManager startUpdatingLocation];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
