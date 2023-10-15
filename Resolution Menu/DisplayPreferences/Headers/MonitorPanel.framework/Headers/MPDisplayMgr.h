//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@class MPDisplay, NSArray, NSMutableArray;

@interface MPDisplayMgr : NSObject
{
    NSMutableArray *_displays;
    MPDisplay *_mainDisplay;
    BOOL _hwChanged;
    struct os_unfair_lock_s _hwChangeLock;
    struct os_unfair_lock_s _dataLock;
    struct os_unfair_lock_s _accessLock;
    BOOL _hasBuiltinRetina;
    BOOL _hasSmallBuiltinRetina;
    BOOL _safeMode;
}

+ (id)sharedMgr;
@property(readonly) BOOL runningInSafeMode; // @synthesize runningInSafeMode=_safeMode;
@property(readonly) MPDisplay *mainDisplay; // @synthesize mainDisplay=_mainDisplay;
@property(readonly) BOOL hasSmallBuiltinRetina; // @synthesize hasSmallBuiltinRetina=_hasSmallBuiltinRetina;
@property(readonly) BOOL hasBuiltinRetina; // @synthesize hasBuiltinRetina=_hasBuiltinRetina;
@property(readonly) BOOL hasNightShiftCabableDisplays;
- (BOOL)tryLockAccess;
- (void)unlockAccess;
- (void)lockAccess;
- (void)stopAllMirroring;
- (void)createMirrorSet:(id)arg1;
- (void)stopMirroringForDisplay:(id)arg1;
- (id)mirrorMasterForDisplay:(id)arg1;
- (id)mirrorSetForDisplay:(id)arg1;
- (BOOL)isAnyDisplayMirrored;
- (void)setMirrorState:(BOOL)arg1 useBestMode:(BOOL)arg2;
- (void)mirrorAllDisplaysTo:(id)arg1 useBestMode:(BOOL)arg2;
- (void)setMirrorMaster:(id)arg1 useBestMode:(BOOL)arg2;
- (void)setMirrorMasterMode:(id)arg1;
- (void)notifyWillReconfigure;
- (void)notifyHardwareChange;
- (void)notifyReconfigure;
- (void)postNotification:(id)arg1;
- (void)serviceReconfigure:(id)arg1;
- (void)refreshDisplays;
- (id)displayWithID:(int)arg1;
@property(readonly) NSArray<MPDisplay*> *displays;
- (void)updateDisplaysList;
- (void)nameDisplays:(id)arg1;
- (void)dealloc;
- (void)removeNotifications;
- (id)init;

@end

