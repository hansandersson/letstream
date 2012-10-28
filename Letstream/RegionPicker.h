//
//  RegionPicker.h
//  Letstream
//
//  Created by Hans Andersson on 11/06/16.
//  Copyright 2011 Hans Andersson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RegionPicker : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
	BOOL mapViewIsRecentering;
}

@property (readonly) IBOutlet MKMapView *mapView;
@property (readonly) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (readonly) IBOutlet UISwitch *trackingSwitch;
@property (readonly) IBOutlet UILabel *radiusLabel;

@property (readonly) CLLocation *selectedLocation;
@property (readonly) NSNumber *selectedRadiusKM;

- (IBAction)toggleTracking:(id)sender;

@end
