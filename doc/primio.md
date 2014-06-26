Primio / TjcoinV2 / JH-256 kernel
---------------------------------

by teknohog -- http://iki.fi/teknohog/contact.php

## Solo mining

Simply use the "primio" kernel. This works for any coin that uses JH-256 as the proof of work, including Primio and TjcoinV2.

For best performance, set the GPU core speed high, and memory speed
low. For example on a HD5870, 975/300 MHz is faster than 975/900 MHz.

## Stratum pools

Primio and TjcoinV2 use different hash functions for the Merkle root. For Stratum mining, Primio works by default, and TjcoinV2 needs the additional "--tjcoin" option.

In addition, most pools require a --difficulty-multiplier number. These may vary by the pool even for the same coin, but common numbers are

0.00390625 (= 1/256) for Primio

1.52587890625e-05 (= 1/65536) for TjcoinV2

For other coins using the same kernel, try both numbers, with and
without the --tjcoin option.