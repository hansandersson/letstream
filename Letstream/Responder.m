//
//  Responder.m
//  Letstream
//
//  Created by Hans Andersson on 11/06/18.
//  Copyright 2011 Hans Andersson. All rights reserved.
//

#import "Responder.h"


@implementation UIView (Responder)

- (BOOL)findAndResignFirstResponder
{
    if ([self isFirstResponder])
	{
        [self resignFirstResponder];
        return YES;     
    }
    for (UIView *subView in [self subviews]) if ([subView findAndResignFirstResponder]) return YES;
    return NO;
}

@end
