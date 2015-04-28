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

-(IBAction)fetchCameras:(id)sender{
    NSLog(@"Fetch cameras");
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
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
        
        //NSURL *urll = [NSURL URLWithString:[jsonArray valueForKeyPath:@"cameras.thumbnail_url"]];
        NSArray* array=[jsonArray valueForKeyPath:@"cameras.thumbnail_url"];
        NSLog(@"%@", array[0]);
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: array[0]]];
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:array[0]]]];
        [_cameraImage setImage:image];

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
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    currentLocation = newLocation;


}
- (void)viewDidLoad {
    [super viewDidLoad];
    _cameraImage.contentMode  = UIViewContentModeScaleAspectFit;
    _cameraImage.clipsToBounds = NO;

    if([CLLocationManager locationServicesEnabled]){
        
        //NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
            [alert show];
        }
    }
    locationManager = [[CLLocationManager alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
