#import <oak/oak.h>
#import <regexp/find.h> // for find::options_t

extern PUBLIC NSString* const OakPasteboardDidChangeNotification;

extern PUBLIC NSString* const kUserDefaultsFindWrapAround;
extern PUBLIC NSString* const kUserDefaultsFindIgnoreCase;

extern PUBLIC NSString* const OakFindIgnoreWhitespaceOption;
extern PUBLIC NSString* const OakFindFullWordsOption;
extern PUBLIC NSString* const OakFindRegularExpressionOption;

PUBLIC @interface OakPasteboardEntry : NSObject
@property (nonatomic, readonly) NSString* string;
@property (nonatomic, readonly) NSArray<NSString*>* strings;
@property (nonatomic, readonly) NSDictionary* options;
@property (nonatomic, getter = isFlagged) BOOL flagged;
@property (nonatomic, readonly) NSUInteger historyId; // This is only to be used by OakPasteboardChooser

@property (nonatomic, readonly) BOOL fullWordMatch;
@property (nonatomic, readonly) BOOL ignoreWhitespace;
@property (nonatomic, readonly) BOOL regularExpression;

@property (nonatomic, readonly) find::options_t findOptions;
@end

PUBLIC @interface OakPasteboard : NSObject
@property (class, readonly) OakPasteboard* generalPasteboard;
@property (class, readonly) OakPasteboard* findPasteboard;
@property (class, readonly) OakPasteboard* replacePasteboard;

- (void)addEntryWithString:(NSString*)aString;
- (void)addEntryWithString:(NSString*)aString options:(NSDictionary*)someOptions;
- (OakPasteboardEntry*)addEntryWithStrings:(NSArray<NSString*>*)someStrings options:(NSDictionary*)someOptions;
- (void)removeEntries:(NSArray<OakPasteboardEntry*>*)pasteboardEntries;
- (void)removeAllEntries;
- (NSArray<OakPasteboardEntry*>*)entries;

- (void)updatePasteboardWithEntry:(OakPasteboardEntry*)pasteboardEntry;
- (void)updatePasteboardWithEntries:(NSArray<OakPasteboardEntry*>*)pasteboardEntries;

- (OakPasteboardEntry*)previous;
- (OakPasteboardEntry*)current;
- (OakPasteboardEntry*)next;

@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) OakPasteboardEntry* currentEntry;
@property (nonatomic) NSDictionary* auxiliaryOptionsForCurrent;

- (void)selectItemForControl:(NSView*)controlView;
@end
