//
//  ViewController.m
//  QBImagePickerController
//
//  Created by Katsuma Tanaka on 2013/01/23.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (IBAction)pickSinglePhoto:(id)sender
{
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (IBAction)pickMultiplePhotos:(id)sender
{
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (IBAction)pickWithLimitation:(id)sender
{
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    
    imagePickerController.limitsMinimumNumberOfSelection = YES;
    imagePickerController.minimumNumberOfSelection = 6;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (BOOL)saveFile:(NSData *)data toPath:(NSString *)path
{
    return [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
}


#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    if(imagePickerController.allowsMultipleSelection) {
        NSArray *assets = info;
        
        NSLog(@"Selected %d photos", assets.count);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            
            NSLog(@"Save photos to disk…");
            
            // Path: `Library/Caches/fileName`
            NSArray *cachesSearchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cachesDirectory = [cachesSearchPaths count] == 0 ? nil : [cachesSearchPaths objectAtIndex:0];
            NSString *defaultFileName = [[NSDate date] description];
            
            NSUInteger count = 0;
            
            for (ALAsset *asset in assets) {
                count ++;
                UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                NSData *data = UIImageJPEGRepresentation(image, 1.0f);
                NSString *fileName = [defaultFileName stringByAppendingFormat:@"%d.jpg", count + 1];
                NSString *filePath = [cachesDirectory stringByAppendingPathComponent:fileName];
                
                // Save it to disk
                if ([self saveFile:data toPath:filePath]) {
                    NSLog(@"Saved: %d [Path: %@]", count, filePath);
                } else {
                    NSLog(@"Failed: %d", count);
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                NSLog(@"Main thread, did finish saving.");
            });
        });
        
    } else {
        ALAsset *asset = info;
        NSLog(@"Selected: %@", asset);
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"Cancelled");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)descriptionForSelectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"すべての写真を選択";
}

- (NSString *)descriptionForDeselectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"すべての写真の選択を解除";
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos
{
    return [NSString stringWithFormat:@"写真%d枚", numberOfPhotos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"ビデオ%d本", numberOfVideos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"写真%d枚、ビデオ%d本", numberOfPhotos, numberOfVideos];
}

@end
