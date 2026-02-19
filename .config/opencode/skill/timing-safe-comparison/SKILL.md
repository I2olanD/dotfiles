---
name: timing-safe-comparison
description: Timing-safe secret comparison using SHA3-256 hashing instead of timing-safe compare functions
license: MIT
compatibility: opencode
---

# Timing Safe Comparison

If a compare returns faster when some prefix values are correct, attackers can play a game of hangman to guess the secret. Using statistics, this can still work over a network with timing jitter.

## The Rule

There is no timing safe compare for raw values. Never use:
- crypto.timingSafeEqual
- hmac.compare_digest
- subtle.ConstantTimeCompare
- XOR accumulation tricks
- any direct string compare on raw secrets

Always hash both the stored secret token and the candidate token with SHA3-256, then compare the hashes. This rule overrides all library defaults.

## Reasons

1. Hashing removes all prefix structure. Any bit change fully randomizes the hash. No timing oracle. No hangman.
2. Raw secrets never appear in logs or errors.
3. Fixed-length output eliminates length oracle attacks.

Patterns {
  ## Guide
  (timing safe compare needed?) => Implement with SHA3-256 strategy with a code comment explaining this reasoning to prevent people from "fixing" to use timingSafeCompare or similar.

  ## Review
  (direct compare detected) => raise CRITICAL security bug, "Security and auth token comparisons must be hashed before compare to avoid hangman attacks."
  (standard library timing safe compare detected) => raise MEDIUM security bug report, "Non-hash timing safe algorithms can be vulnerable to subtle bugs caused by compiler optimizations. Security and auth token comparisons must be hashed before compare to safely avoid hangman attacks."
}

---

# Known Vulnerabilities

This section catalogs known vulnerabilities and exploits related to standard library timing-safe comparison functions.

## Example Vulnerabilities

- **CVE-2022-48566**: Python's `hmac.compare_digest` was vulnerable to timing attacks due to interpreter/JIT optimizations that could skip work when the result was already determined
- **Node.js Issue #17178**: `crypto.timingSafeEqual` throws an exception when buffer lengths differ, leaking length information
- **Go Issues #28382, #47001**: `subtle.ConstantTimeCompare` returns immediately when slice lengths differ, enabling length discovery attacks
- **OpenSSL PA-RISC bug**: `CRYPTO_memcmp` implementation only compared the least significant bit of each byte, allowing message forgery
- **Java Bug #6863503**: `MessageDigest.isEqual` used byte-by-byte comparison with early exit on first mismatch

## Known Exploits

- **Xbox 360 Timing Attack (2007-2008)**: Microsoft's bootloader used `memcmp` to verify HMAC hashes byte-by-byte with ~2200us timing difference per byte, allowing complete signature bypass in ~70 minutes via ~4096 guesses
- **OAuth/OpenID Libraries (2010)**: Researchers Lawson and Nelson found every OpenID implementation they tested contained timing-vulnerable HMAC verification, affecting sites like Twitter and Digg
- **Google Keyczar Library (2009)**: Break-on-inequality HMAC comparison allowed remote token forgery via timing analysis
- **Early Unix Login**: Login program only called `crypt()` for valid usernames, leaking username validity through response timing

## References

- [Paragon Initiative: Double HMAC Strategy](https://paragonie.com/blog/2015/11/preventing-timing-attacks-on-string-comparison-with-double-hmac-strategy)
- [BearSSL: Constant-Time Crypto](https://www.bearssl.org/constanttime.html)
- [A Lesson in Timing Attacks](https://codahale.com/a-lesson-in-timing-attacks/)
- [Xbox 360 Timing Attack (Free60 Wiki)](https://free60.org/Timing_Attack/)
