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
}

@property (weak) IBOutlet NSTextField *searchBox;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _apps = [NSMutableArray array];
    _matchedApps = [NSMutableArray array];

    // Do any additional setup after loading the view.
    [self createTableView];
    [self editSearchBoxView];
    
    [self getFilesUnderApplicationFolder ];
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
}

- (void)createTableView {
    CGSize size = self.view.frame.size;
    //
    _tableView = [[NSTableView alloc] init];
    [_tableView setHeaderView:nil];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    //
    NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"column first"];
    [column setWidth:size.width-2];
    [_tableView addTableColumn:column];
    
    //
    NSScrollView *tableContainerView = [[NSScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height-50)];
    
    [tableContainerView setDocumentView:_tableView];
    
    [self.view addSubview:tableContainerView];
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
    return 30;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *strIdt = @"123";
    NSTextField *cell = [tableView makeViewWithIdentifier:strIdt owner:self];
    if (!cell) {
//        cell = [[NSTableCellView alloc] init];
        cell = [[NSTextField alloc] init];
        cell.identifier = strIdt;
    }
    [cell setEditable:NO];
    cell.wantsLayer = YES;
    [cell setBackgroundColor:[NSColor clearColor]];
    [cell setBordered:NO];
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
