//  Copyright (c) 2014 Rob Rix. All rights reserved.

#define HMRMemoize(var, initial, recursive) \
	((var) ?: ((var = (initial)), (var = (recursive))))
