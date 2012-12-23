#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>
#import <QuickLook/QuickLook.h>
#import <AppKit/AppKit.h>

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options);
void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview);

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{
	@autoreleasepool {
		NSFileManager *fm = [NSFileManager defaultManager];
		NSString *path = [(NSURL*)url path];
		if( [[path pathExtension] compare:@"xcodeproj"] == 0 ){
			NSString *dir = [path stringByDeletingLastPathComponent];
			if( ![fm fileExistsAtPath:[dir stringByAppendingPathComponent:@".git"]] ){
				return noErr;
			}
			NSString *cmd = [NSString stringWithFormat:@"cd \"%@\"; git status",dir];
			FILE *pp = popen([cmd UTF8String],"r");
			NSData *data = NULL;
			if( pp ){
				char buff[256];
				NSMutableString *_data = [NSMutableString string];
				while( fgets(buff,256,pp) ){
					[_data appendString:[NSString stringWithUTF8String:buff]];
				}
				data = [_data dataUsingEncoding:NSUTF8StringEncoding];
				QLPreviewRequestSetDataRepresentation(preview,(CFDataRef)data,kUTTypePlainText,NULL);
			}
		}
	}
    return noErr;
}

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview){
    // Implement only if supported
}
