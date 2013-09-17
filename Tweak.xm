#import "Characount.h"
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>

int count = 0;
static UILabel *countLabel = nil;
BOOL Left;
BOOL Right;

%hook NoteDateView
-(void)layoutSubviews
{
	%orig;

	[countLabel removeFromSuperview];
	[countLabel release];
	countLabel = nil;	

	UILabel *label = MSHookIvar<UILabel *>(self, "_userFriendlyLabel");

	CGRect originalRect = label.frame;
	CGPoint originalPoint = originalRect.origin;
	CGFloat x = originalPoint.x;
	CGFloat y = originalPoint.y;

	CGSize originalSize = originalRect.size;
	CGFloat width = originalSize.width;
	CGFloat height = originalSize.height;

	CGSize textSize = [@"666666666" sizeWithFont:label.font	constrainedToSize:CGSizeMake(6666.0f, 6666.0f) lineBreakMode:label.lineBreakMode];
	CGRect labelRect = CGRectMake(x + width + 6.0f, y, textSize.width, height);

	countLabel = [[UILabel alloc] initWithFrame:labelRect];

	// UILabel properties
	countLabel.text = [NSString stringWithFormat:@"(%d)", count];
	countLabel.tag = 66;
	countLabel.font = label.font;
	countLabel.textColor = label.textColor;
	countLabel.textAlignment = label.textAlignment;
	countLabel.lineBreakMode = label.lineBreakMode;
	countLabel.adjustsFontSizeToFitWidth = label.adjustsFontSizeToFitWidth;	
	countLabel.baselineAdjustment = label.baselineAdjustment;
	countLabel.minimumFontSize = label.minimumFontSize;
	countLabel.numberOfLines = label.numberOfLines;
	countLabel.highlightedTextColor = label.highlightedTextColor;
	countLabel.highlighted = label.highlighted;
	countLabel.shadowColor = label.shadowColor;
	countLabel.shadowOffset = label.shadowOffset;
	countLabel.userInteractionEnabled = label.userInteractionEnabled;

	// UIView properties
	countLabel.backgroundColor = label.backgroundColor;
	countLabel.hidden = label.hidden;
	countLabel.alpha = label.alpha;
	countLabel.opaque = label.opaque;
	countLabel.clipsToBounds = label.clipsToBounds;
	countLabel.clearsContextBeforeDrawing = label.clearsContextBeforeDrawing;
	countLabel.transform = label.transform;
	countLabel.autoresizingMask = label.autoresizingMask;
	countLabel.autoresizesSubviews = label.autoresizesSubviews;
	countLabel.contentMode = label.contentMode;
	countLabel.contentStretch = label.contentStretch;
	countLabel.contentScaleFactor = label.contentScaleFactor;

	[self addSubview:countLabel];
}
%end

static NotesDisplayController *displayController = nil;

@interface CharacountDelegate: NSObject <UIGestureRecognizerDelegate>
- (void)last:(UISwipeGestureRecognizer *)recognizer;
- (void)next:(UISwipeGestureRecognizer *)recognizer;
@end

@implementation CharacountDelegate
- (void)last:(UISwipeGestureRecognizer *)recognizer
{
	[displayController leftButtonClicked];
	[displayController release];
	displayController = nil;
}

- (void)next:(UISwipeGestureRecognizer *)recognizer
{
	[displayController rightButtonClicked];
	[displayController release];
	displayController = nil;
}
@end

static CharacountDelegate *delegate = nil;

%hook NotesDisplayController
- (void)setNote:(NoteObject *)note
{
	%orig;

	count = [note.contentAsPlainText length];
}

- (void)_updateTitle // switch to another note
{
	%orig;

	for (UIView *view in self.view.subviews)	
		if ([view isKindOfClass:[%c(NoteContentLayer) class]])
			count = [[(NoteContentLayer *)view contentAsPlainText:YES] length];

	NoteDateView *dateView = MSHookIvar<NoteDateView *>(self, "_dateView");
	UILabel *countLabel = (UILabel *)[dateView viewWithTag:66];
	if (countLabel)
		countLabel.text = [NSString stringWithFormat:@"(%d)", count];
}

- (void)saveNote // save the current note
{
	%orig;

	for (UIView *view in self.view.subviews)	
		if ([view isKindOfClass:[%c(NoteContentLayer) class]])
			count = [[(NoteContentLayer *)view contentAsPlainText:YES] length];

	NoteDateView *dateView = MSHookIvar<NoteDateView *>(self, "_dateView");
	UILabel *countLabel = (UILabel *)[dateView viewWithTag:66];
	if (countLabel)
		countLabel.text = [NSString stringWithFormat:@"(%d)", count];
}

- (void)viewWillAppear:(BOOL)view
{
	%orig;

	[displayController release];
	displayController = nil;
	displayController = [self retain];

	for (UIView *view in self.view.subviews)
		if ([view isKindOfClass:[%c(NoteContentLayer) class]])
		{
			[delegate release];
			delegate = nil;
			delegate = [[CharacountDelegate alloc] init];

			if (Left)
			{
				UISwipeGestureRecognizer *lastRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:delegate action:@selector(last:)];
				lastRecognizer.delegate = delegate;
				lastRecognizer.numberOfTouchesRequired = 1;
				[lastRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
				[((NoteContentLayer *)view).textView addGestureRecognizer:lastRecognizer];
				[lastRecognizer release];
			}

			if (Right)
			{
				UISwipeGestureRecognizer *nextRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:delegate action:@selector(next:)];
				nextRecognizer.delegate = delegate;
				nextRecognizer.numberOfTouchesRequired = 1;
				[nextRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
				[((NoteContentLayer *)view).textView addGestureRecognizer:nextRecognizer];
				[nextRecognizer release];
			}

			if (!Left && !Right && displayController != nil)
			{
				[displayController release];
				displayController = nil;
			}
		}
}
%end

%hook NotesListController
- (void)shouldEnableLeftButton:(BOOL *)button rightButton:(BOOL *)button2 forNote:(id)note
{
	%orig;

	Left = *button;
	Right = *button2;
}
%end
