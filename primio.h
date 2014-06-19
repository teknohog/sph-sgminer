#ifndef PRIMIO_H
#define PRIMIO_H

#include "miner.h"

extern int primio_test(unsigned char *pdata, const unsigned char *ptarget,
			uint32_t nonce);
extern void primio_regenhash(struct work *work);

#endif /* PRIMIO_H */
