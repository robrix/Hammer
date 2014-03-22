//  Copyright (c) 2014 Rob Rix. All rights reserved.

#define HMROnce(...) \
	({ \
		static __typeof__(^{return __VA_ARGS__;}()) instance; \
		static dispatch_once_t onceToken; \
		dispatch_once(&onceToken, ^{ \
			instance = (__VA_ARGS__); \
		}); \
		instance; \
	})
