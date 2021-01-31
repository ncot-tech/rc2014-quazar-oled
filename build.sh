BIN=test
zcc +rc2014 -subtype=basic -clib=sdcc_iy -v -m --c-code-in-asm --list @sources.lst -o build/$BIN -create-app

# -SO3 --max-allocs-per-node200000