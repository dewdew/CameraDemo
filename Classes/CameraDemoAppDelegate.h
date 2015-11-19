//
//  CameraDemoAppDelegate.h
//  CameraDemo
//
//  Created by WANG Mengke on 09-12-2.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@interface CameraDemoAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

