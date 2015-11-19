#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "TouchView.h"

@interface RootViewController : UIViewController<UINavigationControllerDelegate,UIVideoEditorControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate> {
	TouchView *touchView;
	UIImageView *myTransitionView;
	UIImageView *bottomBarImageView;
	UILabel *lblWatermark;
	UIButton *timerButton;
	UIButton *continuousButton;
	UIImagePickerController *currentPickerController;
	NSMutableArray *tempPictures;
	int timerCount;
	int numberLeft;
}

-(IBAction)showCamera:(id)sender;
-(IBAction)showCamcorder:(id)sender;
-(IBAction)showBoth:(id)sender;
-(IBAction)showSavedPhoto:(id)sender;
-(IBAction)showSavedVideo:(id)sender;
-(IBAction)showPhotoLibrary:(id)sender;

@end