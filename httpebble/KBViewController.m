//
//  KBViewController.m
//  httpebble
//
//  Created by Katharine Berry on 10/05/2013.
//  Copyright (c) 2013 Katharine Berry. All rights reserved.
//

#import "KBViewController.h"
#import "KBAppDelegate.h"
#import <PebbleKit/PebbleKit.h>

@interface KBViewController ()
- (IBAction)executegeocoding:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *searchStringTextField;
@property (nonatomic, strong) CLPlacemark *placemark;
@end

@implementation KBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self load];
	// Do any additional setup after loading the view, typically from a nib.
#if 0
    // forward geocode request using NSDictionary -
    //
    // geocodeAddressDictionary:completionHandler: takes an address dictionary as defined by the AddressBook framework.
    // You can obtain an address dictionary from an ABPerson by retrieving the kABPersonAddressProperty property.
    // Alternately, one can be constructed using the kABPersonAddress* keys defined in <AddressBook/ABPerson.h>.
    //
    NSDictionary *locationDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"San Francisco", kABPersonAddressCityKey,
                                        @"United States", kABPersonAddressCountryKey,
                                        @"us", kABPersonAddressCountryCodeKey,
                                        @"1398 Haight Street", kABPersonAddressStreetKey,
                                        @"94117", kABPersonAddressZIPKey,
                                        nil];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressDictionary:locationDictionary completionHandler:^(NSArray *placemarks, NSError *error)
     { }];
#endif
    
    
}


- (void)pebbleConnected:(PBWatch *)watch {
    [connectedLabel setText:[NSString stringWithFormat:@"Connected to %@", [watch name], nil]];
}

- (void)pebbleDisconnected {
    [connectedLabel setText:@"Disconnected"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
-(void) save
{
    NSUserDefaults *ips = [NSUserDefaults standardUserDefaults];
    [ips setObject:self.searchStringTextField.text  forKey:@"place"];
}
-(void)load
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSLog(@"Loaded %@", [prefs stringForKey:@"place"]);
    self.searchStringTextField.text = [prefs stringForKey:@"place"];
    //[self.searchStringTextField setText:((UITextField *)[prefs objectForKey:@"place"]).text] ;
    
}
- (IBAction)executegeocoding:(id)sender {
    [self save];
    [self.view endEditing:YES];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.searchStringTextField.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error)
        {
            NSLog(@"Geocode failed with error: %@", error);
            //[self displayError:error];
            return;
        }
        
        NSLog(@"Received placemarks: %@", placemarks );
        float latitude=((CLPlacemark *)placemarks[0]).location.coordinate.latitude;
        float longitude=((CLPlacemark *)placemarks[0]).location.coordinate.longitude;
        KBAppDelegate *appdelegate=(KBAppDelegate *)[[UIApplication sharedApplication] delegate];
        //appdelegate.latlon[0]=placemarks[0];
        appdelegate.pebbleThing.lat=latitude;
        appdelegate.pebbleThing.lon=longitude;
        NSLog(@"Received placemarks: %f,%f", latitude, longitude);
        //[self displayPlacemarks:placemarks];
    }];
     //NSLog(@"Received placemarks: %f,  lon%f", self.placemark.location.coordinate.latitude,self.placemark.location.coordinate.longitude );
    
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
