@class NSData, NSDate, NSNumber, NSString, NSURL, NoteBodyObject, NoteStoreObject;

@interface NoteObject : NSObject
{
}

@property(retain, nonatomic) NSString *externalContentRef;
@property(retain, nonatomic) NSData *externalRepresentation;
@property(readonly, nonatomic) BOOL hasValidServerIntId;
@property(nonatomic) long long serverIntId;
@property(nonatomic) unsigned long long flags;
@property(readonly, nonatomic) NSURL *noteId;
@property(readonly, nonatomic) BOOL isMarkedForDeletion;
- (void)markForDeletion;
@property(nonatomic) BOOL isPlainText;
- (id)contentAsPlainTextPreservingNewlines;
@property(readonly, nonatomic) NSString *contentAsPlainText;
@property(retain, nonatomic) NSString *content;

// Remaining properties
@property(retain, nonatomic) NSString *author; // @dynamic author;
@property(retain, nonatomic) NoteBodyObject *body; // @dynamic body;
@property(retain, nonatomic) NSNumber *containsCJK; // @dynamic containsCJK;
@property(retain, nonatomic) NSNumber *contentType; // @dynamic contentType;
@property(retain, nonatomic) NSDate *creationDate; // @dynamic creationDate;
@property(retain, nonatomic) NSString *guid; // @dynamic guid;
@property(retain, nonatomic) NSNumber *integerId; // @dynamic integerId;
@property(retain, nonatomic) NSNumber *isBookkeepingEntry; // @dynamic isBookkeepingEntry;
@property(retain, nonatomic) NSDate *modificationDate; // @dynamic modificationDate;
@property(retain, nonatomic) NSString *serverId; // @dynamic serverId;
@property(retain, nonatomic) NoteStoreObject *store; // @dynamic store;
@property(retain, nonatomic) NSString *summary; // @dynamic summary;
@property(retain, nonatomic) NSString *title; // @dynamic title;

@end

@interface NoteDateView : UIView {
	NSDate* _date;
	UILabel* _userFriendlyLabel;
	UILabel* _dateLabel;
	float _marginLeft;
	unsigned _setToNil : 1;
}
-(void)fadeOutFinished;
-(void)setMarginLeft:(float)left;
-(void)setDate:(id)date;
-(void)updateLabels;
-(void)layoutSubviews;
-(void)dealloc;
-(id)initWithFrame:(CGRect)frame;
-(void)addSubview:(UIView *)view;
@end

@interface NotesDisplayController : UIViewController {
	NoteDateView* _dateView;
	NoteObject* _note;
}
-(id)getCurrentContext;
-(id)note;
-(void)rightButtonClicked;
-(void)leftButtonClicked;
+(id)animationLock;
@end

@interface NoteContentLayer : UIView <UITextViewDelegate> {
}
@property(readonly, assign) UITextView* textView;
@property(readonly, assign, nonatomic) NSString* summary;
@property(readonly, assign, nonatomic) NSString* title;
-(id)contentAsPlainText:(BOOL)text;
@end

@interface NotesListController : UIViewController {
}
-(UINavigationController *)navigationController;
@end

@interface NotesApp : NSObject {
}
-(UIView *)contentView;
@end
