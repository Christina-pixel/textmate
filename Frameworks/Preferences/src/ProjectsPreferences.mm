#import "ProjectsPreferences.h"
#import "Keys.h"
#import <settings/settings.h>
#import <OakAppKit/NSImage Additions.h>
#import <OakAppKit/NSMenuItem Additions.h>
#import <OakTabBarView/OakTabBarView.h>
#import <OakFoundation/NSString Additions.h>
#import <OakFoundation/OakStringListTransformer.h>

@implementation ProjectsPreferences
- (id)init
{
	if(self = [super initWithNibName:@"ProjectsPreferences" label:@"Projects" image:[NSImage imageNamed:@"Projects" inSameBundleAsClass:[self class]]])
	{
		[OakStringListTransformer createTransformerWithName:@"OakFileBrowserPlacementSettingsTransformer" andObjectsArray:@[ @"left", @"right" ]];
		[OakStringListTransformer createTransformerWithName:@"OakHTMLOutputPlacementSettingsTransformer" andObjectsArray:@[ @"bottom", @"right", @"window" ]];

		self.defaultsProperties = @{
			@"foldersOnTop":                 kUserDefaultsFoldersOnTopKey,
			@"showFileExtensions":           kUserDefaultsShowFileExtensionsKey,
			@"disableTabBarCollapsing":      kUserDefaultsDisableTabBarCollapsingKey,
			@"disableAutoResize":            kUserDefaultsDisableFileBrowserWindowResizeKey,
			@"autoRevealFile":               kUserDefaultsAutoRevealFileKey,
			@"fileBrowserPlacement":         kUserDefaultsFileBrowserPlacementKey,
			@"htmlOutputPlacement":          kUserDefaultsHTMLOutputPlacementKey,

			@"allowExpandingLinks":          kUserDefaultsAllowExpandingLinksKey,
			@"fileBrowserSingleClickToOpen": kUserDefaultsFileBrowserSingleClickToOpenKey,
			@"disableTabReordering":         kUserDefaultsDisableTabReorderingKey,
			@"disableTabAutoClose":          kUserDefaultsDisableTabAutoCloseKey,
		};

		self.tmProperties = @{
			@"excludePattern": [NSString stringWithCxxString:kSettingsExcludeKey],
			@"includePattern": [NSString stringWithCxxString:kSettingsIncludeKey],
			@"binaryPattern":  [NSString stringWithCxxString:kSettingsBinaryKey],
		};
	}
	return self;
}

- (void)selectOtherFileBrowserPath:(id)sender
{
	NSOpenPanel* openPanel = [NSOpenPanel openPanel];
	[openPanel setCanChooseFiles:NO];
	[openPanel setCanChooseDirectories:YES];
	[openPanel beginSheetModalForWindow:[self view].window completionHandler:^(NSModalResponse result) {
		if(result == NSModalResponseOK)
			[[NSUserDefaults standardUserDefaults] setObject:[[openPanel URL] absoluteString] forKey:kUserDefaultsInitialFileBrowserURLKey];
		[self updatePathPopUp];
	}];
}

- (void)takeFileBrowserPathFrom:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setObject:[[sender representedObject] absoluteString] forKey:kUserDefaultsInitialFileBrowserURLKey];
	[self updatePathPopUp];
}

- (NSMenuItem*)menuItemForURL:(NSURL*)aURL
{
	NSMenuItem* res = [[NSMenuItem alloc] initWithTitle:[[NSFileManager defaultManager] displayNameAtPath:[aURL path]] action:@selector(takeFileBrowserPathFrom:) keyEquivalent:@""];
	[res setTarget:self];
	[res setRepresentedObject:aURL];
	if([aURL isFileURL])
		[res setIconForFile:[aURL path]];
	return res;
}

- (void)updatePathPopUp
{
	NSMenu* menu = [fileBrowserPathPopUp menu];
	[menu removeAllItems];

	NSArray<NSURL*>* const defaultURLs = @[
		[NSFileManager.defaultManager URLForDirectory:NSDesktopDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil],
		NSFileManager.defaultManager.homeDirectoryForCurrentUser,
		[NSURL fileURLWithPath:@"/" isDirectory:YES],
	];

	NSURL* url = defaultURLs[1];
	if(NSString* urlString = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsInitialFileBrowserURLKey])
		url = [NSURL URLWithString:urlString];

	if(![defaultURLs containsObject:url])
	{
		[menu addItem:[self menuItemForURL:url]];
		[menu addItem:[NSMenuItem separatorItem]];
	}

	for(NSURL* defaultURL in defaultURLs)
	{
		[menu addItem:[self menuItemForURL:defaultURL]];
		if([defaultURL isEqual:url])
			[fileBrowserPathPopUp selectItemAtIndex:[menu numberOfItems]-1];
	}

	[menu addItem:[NSMenuItem separatorItem]];
	[menu addItemWithTitle:@"Other…" action:@selector(selectOtherFileBrowserPath:) keyEquivalent:@""];
}

- (void)loadView
{
	[super loadView];
	[self updatePathPopUp];
}
@end
