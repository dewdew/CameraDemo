#import "RootViewController.h"

@interface RootViewController()
-(void)savePhotos:(int)index;
@end

@implementation RootViewController

- (void)dealloc {
	[touchView release];
	[myTransitionView release];
	[bottomBarImageView release];
	[lblWatermark release];
	[timerButton release];
	[continuousButton release];
	[tempPictures release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)myNibName bundle:(NSBundle *)myNibBundle {
    if (self = [super initWithNibName:myNibName bundle:myNibBundle]) {
		self.title=@"bobgreen";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	timerCount = 3;
	numberLeft = 0;
	
	timerButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	timerButton.backgroundColor = [UIColor clearColor];
	timerButton.frame = CGRectMake(20, 80, 50, 24);
	[timerButton setTitle:@"Timer" forState:UIControlStateNormal];
	[timerButton addTarget:self action:@selector(timerAction:) forControlEvents:UIControlEventTouchUpInside];
	
	continuousButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	continuousButton.backgroundColor = [UIColor clearColor];
	continuousButton.frame = CGRectMake(75, 80, 50, 24);
	[continuousButton setTitle:@"连拍" forState:UIControlStateNormal];
	[continuousButton addTarget:self action:@selector(continuousAction:) forControlEvents:UIControlEventTouchUpInside];
	
	tempPictures = [[NSMutableArray alloc] init];
	
	UIImage *image=[[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Background.png"]];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	[self.view insertSubview:imageView atIndex:0];
	[image release];
	
	touchView=[[TouchView alloc] initWithFrame:CGRectMake(0, 0, 320, 427)];
	
	myTransitionView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	image=[[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Shutter.png"]];
	myTransitionView.image=image;
	[image release];
	
	bottomBarImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 427, 320, 53)];
	image=[[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"BottomBar.png"]];
	bottomBarImageView.image=image;
	[image release];
	
	lblWatermark=[[UILabel alloc] initWithFrame:CGRectMake(20, 40, 150, 40)];
	lblWatermark.text=@"bobgreen";
	lblWatermark.textColor=[UIColor orangeColor];
	lblWatermark.backgroundColor=[UIColor clearColor];
	lblWatermark.font=[UIFont systemFontOfSize:32];
}

#pragma mark get/show the UIView we want
//Find the view we want in camera structure.
- (UIView *)findView:(UIView *)aView withName:(NSString *)name {
	Class cl = [aView class];
	NSString *desc = [cl description];
	
	if ([name isEqualToString:desc])
		return aView;
	
	for (NSUInteger i = 0; i < [aView.subviews count]; i++) {
		UIView *subView = [aView.subviews objectAtIndex:i];
		subView = [self findView:subView withName:name];
		if (subView)
			return subView;
	}
	return nil;	
}

#pragma mark addSomeElements
- (void)addSomeElements:(UIViewController *)viewController {
	//Add the motion view here, PLCameraView and picker.view are both OK
	UIView *PLCameraView=[self findView:viewController.view withName:@"PLCameraView"];
	[PLCameraView addSubview:touchView];//[viewController.view addSubview:self.touchView];//You can also try this one.
	
	//Add button for Timer capture
	[PLCameraView addSubview:timerButton];
	[PLCameraView addSubview:continuousButton];
	
	[PLCameraView insertSubview:bottomBarImageView atIndex:1];
	
	//Used to hide the transiton, last added view will be the topest layer
	[PLCameraView addSubview:myTransitionView];
	
	//Add label to cropOverlay
	UIView *cropOverlay=[self findView:PLCameraView withName:@"PLCropOverlay"];
	[cropOverlay addSubview:lblWatermark];
	
	//Get Bottom Bar
	UIView *bottomBar=[self findView:PLCameraView withName:@"PLCropOverlayBottomBar"];
	
	//Get ImageView For Save
	UIImageView *bottomBarImageForSave = [bottomBar.subviews objectAtIndex:0];
	
	//Get Button 0
	UIButton *retakeButton=[bottomBarImageForSave.subviews objectAtIndex:0];
	[retakeButton setTitle:@"重拍" forState:UIControlStateNormal];
	
	//Get Button 1
	UIButton *useButton=[bottomBarImageForSave.subviews objectAtIndex:1];
	[useButton setTitle:@"保存" forState:UIControlStateNormal];
	
	//Get ImageView For Camera
	UIImageView *bottomBarImageForCamera = [bottomBar.subviews objectAtIndex:1];
	
	//Set Bottom Bar Image
	UIImage *image=[[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"BottomBar.png"]];
	bottomBarImageForCamera.image=image;
	[image release];
	
	//Get Button 0(The Capture Button)
	UIButton *cameraButton=[bottomBarImageForCamera.subviews objectAtIndex:0];
	[cameraButton addTarget:self action:@selector(hideTouchView) forControlEvents:UIControlEventTouchUpInside];
	
	//Get Button 1
	UIButton *cancelButton=[bottomBarImageForCamera.subviews objectAtIndex:1];	
	[cancelButton setTitle:@"取消" forState:UIControlStateNormal];
	[cancelButton addTarget:self action:@selector(hideTouchView) forControlEvents:UIControlEventTouchUpInside];
}

-(void)hideTongkong:(NSTimer *)theTimer{
	myTransitionView.hidden=YES;
}

-(void)hideTouchView{
	lblWatermark.hidden = YES;
	timerButton.hidden = YES;
	continuousButton.hidden = YES;
	touchView.hidden = YES;
}
- (void)choose{
    currentPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}
#pragma mark UINavigationControllerDelegate
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//	[self addSomeElements:viewController];
//	
//	touchView.hidden=NO;
//	
//	[NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(hideTongkong:) userInfo:viewController repeats:NO];
//}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    @autoreleasepool {
        if (currentPickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIView* PLCameraView;
            UIView* bottomBar;
            UIImageView* bottomBarImageForCamera;
            PLCameraView = [self findView:viewController.view withName:@"PLCameraView"];
            if (PLCameraView) {
                bottomBar = [self findView:PLCameraView withName:@"PLCropOverlayBottomBar"];
                if (bottomBar) {
                    //NSLog(@"bottomBar.subviews.count:%d",bottomBar.subviews.count);
                    if (bottomBar.subviews.count == 0) {
                        return;
                    }
                    
                    UIButton* choosePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
                    choosePhoto.frame = CGRectMake(245, 20, 70, 41);
                    [choosePhoto setTitle:@"Choose" forState:UIControlStateNormal];
                    choosePhoto.titleLabel.font = [UIFont systemFontOfSize:17];
                    [choosePhoto addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
                    
                    if (bottomBar.subviews.count > 1) {//lower version ios7.0
                        bottomBarImageForCamera = [bottomBar.subviews objectAtIndex:1];
                        
                        [bottomBarImageForCamera addSubview:choosePhoto];
                    }else{//ios7.0
                        
                        bottomBarImageForCamera = [bottomBar.subviews objectAtIndex:0];
                        [bottomBar addSubview:choosePhoto];
                        [bottomBar bringSubviewToFront:bottomBarImageForCamera];
                        bottomBarImageForCamera.backgroundColor = [UIColor blackColor];
                    }
                    
                }
            }
            
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex==0) {
		[self dismissModalViewControllerAnimated:YES];
	}
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	if ([mediaType isEqualToString:@"public.image"]){
		UIImage *originalImage;
		if ([[picker title] isEqualToString:@"Photo Albums"]) {
			originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
			UIImageView *imageView = [[UIImageView alloc] initWithImage:originalImage];
			UIScrollView *scrollView = [[UIScrollView alloc] init];
			[scrollView setScrollEnabled:YES];
			[scrollView setClipsToBounds:YES];
			[scrollView setBackgroundColor:[UIColor blackColor]];
			[scrollView setCanCancelContentTouches:NO];
			[scrollView setContentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height)];
			[scrollView addSubview:imageView];
			[imageView release];
			UIViewController *showImageController = [[UIViewController alloc] init];
			[showImageController setView:scrollView];
			[scrollView release];
			[picker pushViewController:showImageController animated:YES];
			[showImageController release];
		}
		else {
			/*
			//Add a label here
			UIView *cropOverlay=[self findView:picker.view withName:@"PLCropOverlay"];
			UILabel *label=(UILabel *)[self findView:cropOverlay withName:@"UILabel"];
			UIImageView *photo;
			if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
				originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
				photo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, originalImage.size.width, originalImage.size.height)];
				[photo addSubview:label];
			}
			else {
				originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
				photo = [[UIImageView alloc] initWithFrame:[[info objectForKey:UIImagePickerControllerCropRect] CGRectValue]];
			}
			photo.image=originalImage;
			
			//I wanna save my strange photo here.
			UIGraphicsBeginImageContext(photo.bounds.size);//current image size
			[photo.layer renderInContext:UIGraphicsGetCurrentContext()];//render to current context
			UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//get the image from current context
			UIGraphicsEndImageContext();
			
			*/
			UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
			[tempPictures addObject:image];
			
			if (numberLeft <= 1)
				[self savePhotos:0];
			else {
				numberLeft -= 1;
				currentPickerController.showsCameraControls = NO;
				bottomBarImageView.hidden = NO;
				lblWatermark.hidden = NO;
				[currentPickerController takePicture];
			}

		}
	}
	else if ([mediaType isEqualToString:@"public.movie"]){
		NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
		NSString *tempFilePath = [videoURL path];
		
		if ([[picker title] isEqualToString:@"Photo Albums"]) {
			UIVideoEditorController *videoEditorController = [[UIVideoEditorController alloc] init];
			videoEditorController.delegate = self;
			videoEditorController.videoPath = tempFilePath;
			[self presentModalViewController:videoEditorController animated:YES];
		}
		else {
			UISaveVideoAtPathToSavedPhotosAlbum(tempFilePath,self, @selector(errorVideoCheck:didFinishSavingWithError:contextInfo:),picker);
		}
	}
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[picker dismissModalViewControllerAnimated:YES];
}

#pragma mark UIVideoEditorControllerDelegate

- (void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error{
	UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error!"
												  message:[error localizedDescription]
												 delegate:self
										cancelButtonTitle:@"OK"
										otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath{
	UISaveVideoAtPathToSavedPhotosAlbum(editedVideoPath,self, @selector(errorVideoCheck:didFinishSavingWithError:contextInfo:),editor);
}

- (void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor{
	[editor dismissModalViewControllerAnimated:YES];
}

#pragma mark Error Check

- (void)errorCheck:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
	NSString *informText;
	NSNumber *number = (NSNumber *)contextInfo;
	int index = [number intValue];
	
	if(error)
		informText = [error localizedDescription];
	else
		informText = @"Finished!";
	
	if (index >= [tempPictures count] - 1) {
		lblWatermark.text = @"bobgeen";
		[currentPickerController dismissModalViewControllerAnimated:NO];
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Inform"
													  message:informText
													 delegate:self
											cancelButtonTitle:@"OK"
											otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else {
		[self savePhotos:index+1];
	}
}

- (void)errorVideoCheck:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
	NSString *informText;
	
	UIVideoEditorController * editor = contextInfo;
	
	if(error)
		informText = [error localizedDescription];
	else
		informText = @"Video edited & saved successfully!";
	
	UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Inform"
												  message:informText
												 delegate:self
										cancelButtonTitle:@"OK"
										otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	[editor dismissModalViewControllerAnimated:NO];
}

#pragma mark IBActions

-(IBAction)showCamera:(id)sender{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		myTransitionView.hidden=NO;
		timerButton.hidden = NO;
		continuousButton.hidden = NO;
		lblWatermark.hidden = NO;
		UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
		imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
		imagePickerController.delegate = self;
		imagePickerController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
		currentPickerController = imagePickerController;
        [self presentViewController:imagePickerController animated:YES completion:nil];
		//[self presentModalViewController:imagePickerController animated:YES];
		//[imagePickerController release];
	}
}

-(IBAction)showCamcorder:(id)sender{
	NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	if([mediaTypes containsObject:@"public.movie"]){
		UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
		myTransitionView.hidden=NO;
		timerButton.hidden = YES;
		continuousButton.hidden = YES;
		lblWatermark.hidden = NO;
		imagePickerController.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
		imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
		imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
		imagePickerController.delegate = self;
		imagePickerController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
		currentPickerController = imagePickerController;
		[self presentModalViewController:imagePickerController animated:YES];
		[imagePickerController release];
	}
}

-(IBAction)showBoth:(id)sender{
	NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	if([mediaTypes containsObject:@"public.movie"]){
		UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
		myTransitionView.hidden=NO;
		timerButton.hidden = YES;
		continuousButton.hidden = YES;
		lblWatermark.hidden = NO;
		imagePickerController.mediaTypes =  [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
		imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
		imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
		imagePickerController.delegate = self;
		imagePickerController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
		currentPickerController = imagePickerController;
		[self presentModalViewController:imagePickerController animated:YES];
		[imagePickerController release];
	}
}

-(IBAction)showSavedPhoto:(id)sender{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
		UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
		imagePickerController.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeImage];
		imagePickerController.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
		imagePickerController.allowsEditing = YES;
		imagePickerController.delegate = self;
		imagePickerController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
		currentPickerController = imagePickerController;
		[self presentModalViewController:imagePickerController animated:YES];
		[imagePickerController release];
	}	
}

-(IBAction)showSavedVideo:(id)sender{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
		UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
		imagePickerController.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeMovie];
		imagePickerController.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
		imagePickerController.allowsEditing = YES;
		imagePickerController.delegate = self;
		imagePickerController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
		currentPickerController = imagePickerController;
		[self presentModalViewController:imagePickerController animated:YES];
		[imagePickerController release];
	}	
}

-(IBAction)showPhotoLibrary:(id)sender{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
		imagePickerController.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeImage,(NSString*)kUTTypeMovie,nil];
		imagePickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
		imagePickerController.delegate = self;
		imagePickerController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
		currentPickerController = imagePickerController;
		[self presentModalViewController:imagePickerController animated:YES];
		[imagePickerController release];
	}	
}

-(IBAction)timerAction:(id)sender{
	timerButton.hidden = YES;
	continuousButton.hidden = YES;
	[NSTimer scheduledTimerWithTimeInterval: 1
									 target: self
								   selector: @selector(handleTimer:)
								   userInfo: nil
									repeats: YES];
}

-(IBAction)continuousAction:(id)sender{
	timerButton.hidden = YES;
	continuousButton.hidden = YES;
	numberLeft = 3;
	
	currentPickerController.showsCameraControls = NO;
	bottomBarImageView.hidden = NO;
	[currentPickerController takePicture];
}

#pragma mark Timer

- (void) handleTimer:(NSTimer *)timer{
	if(timerCount > 0){
		if(timerCount <= 1)
			lblWatermark.text = @"Smile :)";
		else {
			lblWatermark.text = [NSString stringWithFormat:@"%d sec left",timerCount-1];
		}
		timerCount -= 1;
	}
	else {
		[timer invalidate];
		timerCount = 3;
		lblWatermark.text = @"bobgreen";
		currentPickerController.showsCameraControls = NO;
		bottomBarImageView.hidden = NO;
		[currentPickerController takePicture];
	}
}

#pragma mark Save Photos

-(void)savePhotos:(int)index{
	lblWatermark.hidden = NO;
	lblWatermark.text = @"Saving...";
	UIImageWriteToSavedPhotosAlbum([tempPictures objectAtIndex:index],self, @selector(errorCheck:didFinishSavingWithError:contextInfo:),[NSNumber numberWithInt:index]);
}

@end