//
//  RegionPicker.m
//  Letstream
//
//  Created by Hans Andersson on 11/06/16.
//  Copyright 2011 Hans Andersson. All rights reserved.
//

#import "RegionPicker.h"


@interface RegionPicker()

- (NSString *)radiusDescription;

@end

@implementation RegionPicker

@synthesize mapView, activityIndicator, trackingSwitch, radiusLabel;
@synthesize selectedLocation, selectedRadiusKM;

- (id)init { return [super initWithNibName:@"RegionPicker" bundle:nil]; }

- (void)dealloc
{
	[selectedLocation release];
	[selectedRadiusKM release];
	
	[mapView release];
	[activityIndicator release];
	[trackingSwitch release];
	[radiusLabel release];
	
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	//[[self locationManager] startUpdatingLocation];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[radiusLabel setText:[self radiusDescription]];
	[self toggleTracking:self];
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[mapView setShowsUserLocation:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)mapView:(MKMapView *)caller didUpdateUserLocation:(MKUserLocation *)userLocation
{
	if ([[self activityIndicator] isAnimating])
	{
		[[self activityIndicator] stopAnimating];
		[caller setRegion:MKCoordinateRegionMake([[userLocation location] coordinate], MKCoordinateSpanMake((CLLocationDegrees) 0.1, (CLLocationDegrees) 0.0)) animated:YES];
	}
}

- (NSString *)radiusDescription { return [NSString stringWithFormat:@"radius %.1f km", (([mapView region].span.latitudeDelta/2.0f) * 111.12f)]; }

- (IBAction)toggleTracking:(id)sender
{
	[mapView setShowsUserLocation:[trackingSwitch isOn]];
	if ([trackingSwitch isOn]) [mapView setCenterCoordinate:[[[mapView userLocation] location] coordinate] animated:YES];
}

- (void)mapView:(MKMapView *)caller regionDidChangeAnimated:(BOOL)animated
{
	if ([trackingSwitch isOn] && !mapViewIsRecentering)
	{
		CLLocation *locationCenter = [[CLLocation alloc] initWithLatitude:[caller centerCoordinate].latitude longitude:[caller centerCoordinate].longitude];
		mapViewIsRecentering = YES;
		[caller setCenterCoordinate:[[[caller userLocation] location] coordinate] animated:YES];
		mapViewIsRecentering = NO;
		[locationCenter release];
	}
	[radiusLabel setText:[self radiusDescription]];
}

@end
