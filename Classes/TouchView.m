#import "TouchView.h"

@implementation TouchView

@synthesize targetView;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.targetView=[[UIImageView alloc] initWithFrame:CGRectMake(128, 183, 64, 64)];
		targetView.image=[UIImage imageNamed:@"Target.png"];
		[self addSubview:targetView];
		self.backgroundColor=[UIColor clearColor];
		self.userInteractionEnabled=YES;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	CGPoint destination=[[touches anyObject] locationInView:self];
	targetView.center=destination;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	CGPoint destination=[[touches anyObject] locationInView:self];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.0];
	[UIView setAnimationBeginsFromCurrentState:YES];
	targetView.center=destination;
	[UIView commitAnimations];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
}

- (void)dealloc {
	[targetView release];
    [super dealloc];
}

@end
