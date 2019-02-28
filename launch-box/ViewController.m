//
//  ViewController.m
//  launch-box
//
//  Created by jude on 2019/2/26.
//  Copyright © 2019 jude. All rights reserved.
//

#import "ViewController.h"

@interface ViewController() <NSTextFieldDelegate, NSTableViewDelegate, NSTableViewDataSource> {
    NSTableView *_tableView;
    NSTableCellView *_cellView;
    NSMutableArray *_apps;
    NSMutableArray *_matchedApps;
    NSScrollView *_tableContainerView;
    NSScreen *_screen;
    float _rowHeight;
    float _baseHeight;
}

@property (weak) IBOutlet NSTextField *searchBox;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _apps = [NSMutableArray array];
    _matchedApps = [NSMutableArray array];
    _rowHeight = 30;
    _screen = [NSScreen mainScreen];

    // Do any additional setup after loading the view.
    [self createTableView];
    [self editSearchBoxView];
    
    _baseHeight = self.view.frame.size.height;
    
    [self getFilesUnderApplicationFolder];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(void)controlTextDidChange:(NSNotification *)obj {
    [_matchedApps removeAllObjects];
    
    NSArray *foo;
    for(foo in _apps) {
        if ([[foo objectAtIndex:0] rangeOfString:_searchBox.stringValue].location != NSNotFound) {
            [_matchedApps addObject:foo];
        }
    }
    
    [_tableView reloadData];
    CGPoint oPoint = self.view.window.frame.origin;
    float height = _rowHeight * [_matchedApps count];
    
    [_tableContainerView setFrameSize:CGSizeMake(_tableContainerView.frame.size.width, height)];
    float containerHeight = _tableContainerView.frame.size.height + _baseHeight;
    float yPoint = _screen.frame.size.height - containerHeight - 100;
    [self.view.window setFrame:CGRectMake(oPoint.x, yPoint, self.view.frame.size.width, containerHeight) display:YES];
}

- (void)createTableView {
    CGSize size = self.view.frame.size;
    //
    _tableView = [[NSTableView alloc] init];
    [_tableView setHeaderView:nil];
    [_tableView setBackgroundColor:[NSColor clearColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    //
    NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"column first"];
    [column setWidth:size.width-2];
    [_tableView addTableColumn:column];
    
    //
    _tableContainerView = [[NSScrollView alloc] initWithFrame:CGRectMake(10, 0, size.width-20, size.height-50)];
    [_tableContainerView setDrawsBackground:NO];
    
    [_tableContainerView setDocumentView:_tableView];
    [self.view addSubview:_tableContainerView];
}

- (void)editSearchBoxView {
    [_searchBox setDelegate:self];
    
    [_searchBox setFocusRingType:NSFocusRingTypeNone];
    [_searchBox setBackgroundColor: [NSColor clearColor]];
}

#pragma mark - tableview delegate & tableview datasource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [_matchedApps count];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return _rowHeight;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *strIdt = @"xxxi";
    NSTextField *cell = [tableView makeViewWithIdentifier:strIdt owner:self];
    if (!cell) {
        cell = [[NSTextField alloc] init];
        cell.identifier = strIdt;
    }
    [cell setFont:[NSFont systemFontOfSize:20]];
    [cell setEditable:NO];
    cell.wantsLayer = YES;
    [cell setBordered:NO];
    [cell setBackgroundColor:[NSColor clearColor]];
    cell.stringValue = [[_matchedApps objectAtIndex:row] objectAtIndex:1];
    return cell;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger row = [_tableView selectedRow];
    NSLog(@"%ld", row);
}

- (void)getFilesUnderApplicationFolder {
    NSString *docPath = @"/Applications";
    NSArray *dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docPath error:nil];
    NSString *filename;

    for(filename in dirs) {
        NSArray *_foo = [NSArray arrayWithObjects:[self transChineseStringToPingyin:filename], filename, nil];
        [_apps addObject:_foo];
    }
//    NSLog(@"%@", _apps);
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
    if (commandSelector == @selector(insertNewline:)) {
        NSString *appName = [[_matchedApps objectAtIndex:0] objectAtIndex:1];
        [[NSWorkspace sharedWorkspace] launchApplication:[NSString stringWithFormat:@"/Applications/%@", appName]];
        NSLog(@"%@", [NSString stringWithFormat:@"/Applications/%@", appName]);
        return true;
    }
    return false;
}

-(NSString*)transChineseStringToPingyin:(NSString*)szString{
    if ([szString length]) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:szString];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {}
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {}
        return [[ms stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
    }
    return @"";
}

@end
