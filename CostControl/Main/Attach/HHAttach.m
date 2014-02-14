//
//  HHAttach.m
//  Huhoo
//
//  Created by Jason Chong on 13-3-13.
//  Copyright (c) 2013年 Huhoo. All rights reserved.
//

#import "HHAttach.h"



@implementation HHAttach

- (void)setFileType:(NSString *)fileType
{
    _fileType = [fileType lowercaseString];
    if ([[HHAttach validAttachTypes] indexOfObject:_fileType] == NSNotFound) {
        self.fileIcon = [UIImage imageNamed:@"attach_file"];
    }
    else
    {
        self.fileIcon = [UIImage imageNamed:[NSString stringWithFormat:@"attach_%@", _fileType]];
    }
    
}

+ (NSArray*)validAttachTypes
{
    static NSArray* _sharedValidAttachTypes = nil;
    if (_sharedValidAttachTypes == nil) {
        _sharedValidAttachTypes = [NSArray arrayWithObjects:
                                   @"bmp",
                                   @"csv",
                                   @"doc",
                                   @"docx",
                                   @"gif",
                                   @"jpeg",
                                   @"jpg",
                                   @"pdf",
                                   @"png",
                                   @"ppt",
                                   @"pptx",
                                   @"rar",
                                   @"rtf",
                                   @"tif",
                                   @"txt",
                                   @"xls",
                                   @"xlsx",
                                   @"zip",
                                   nil];
    }
    return _sharedValidAttachTypes;
}

@end
