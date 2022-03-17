This repo demonstrates that closure size for a haskell program gets very
large if the program imports an "paths" module exported by a library.

# Demonstration

To demonstrate, build `app` and `big-app` using nix, and inspect the resulting closure for each. (This
output was captured with nix-pkgs revision 3e644bd62489b516292c816f70bf0052c693b3c7).

Here is `app`, which has a pretty small closure:

```
$ nix-store --query --include-outputs -R $(nix-build -A app)
/nix/store/nzq2nk6h535p2lbgbdgf563swm6l5z24-libcxxabi-11.1.0
/nix/store/7i2vs7a2wphiq7xa5i84sc23rcxadq5b-libcxx-11.1.0
/nix/store/1r52s1bjnyshgs95037d6z37mkjlx562-zstd-1.5.2
/nix/store/22l8r8rd0r1gwkgh885l3aszavq5hhhq-libffi-3.4.2
/nix/store/2r6pwl5f1s8xhq9d3l4g35cxl7fw5dbg-zlib-1.2.11
/nix/store/z12qbpid3n9dwqggvzbfl9gcvgkz7cjy-libiconv-50
/nix/store/325286if932n0gvx5v23s7kgfnyc0lyx-libunistring-0.9.10
/nix/store/3vcnz9kdk857pg87515xhlz1kfp10c9b-nghttp2-1.43.0-lib
/nix/store/53nmd95wljahv3r30ay97f5lpi87fqwm-gmp-6.2.1
/nix/store/ci3f9q46hfk7jcvqi3a6ssazfmq963yw-ICU-66108
/nix/store/qz60pk8wf34gbgzq5j6pimjp7kd913hh-openssl-1.1.1m
/nix/store/98fbv4py0fwrr0jpkdlj04cmh6kwr3ba-libssh2-1.10.0
/nix/store/aljqh5wz8gnx652mkyf8vszn39hsg1xs-brotli-1.0.9-lib
/nix/store/c5jrszdq2hy3hj9rpyx3hk9gba60wd1d-Libsystem-1238.60.2
/nix/store/ivr648zwcsg95jfjqxsdg5lqrp1d5qfy-libidn2-2.3.2
/nix/store/vssrny41k0mr33jclrrn67rxhbdpwrr0-bash-5.1-p12
/nix/store/l1pqih6lvjb81kbl20s670hd0wpgmz53-libkrb5-1.19.2
/nix/store/i702vq1dar8lpsysd0jpf75xcvijnr5a-curl-7.81.0
/nix/store/q1ndbvjgmfalmv37km6hwbnq1hzi4bir-libxml2-2.9.12
/nix/store/xl2s63shkj95wnrv992hyf19g2r7i740-swift-corefoundation-unstable-2018-09-14
/nix/store/8vgn8ayzswizsfy4kymmrcjbz9snqbii-app-0.1.0.0
```

Here is `big-app`, which is no different than `app` except that it imports the `Paths_library` module
from the `library` package. Notice the closure is much larger, and includes both `ghc-8.10.7` and its documentation (ghc-8.10.7-doc)!

```
$ nix-store --query --include-outputs -R $(nix-build -A big-app)
/nix/store/nzq2nk6h535p2lbgbdgf563swm6l5z24-libcxxabi-11.1.0
/nix/store/7i2vs7a2wphiq7xa5i84sc23rcxadq5b-libcxx-11.1.0
/nix/store/2bkqgfi81587pafjmfhp8d5k096k39kp-libcxx-11.1.0-dev
/nix/store/53nmd95wljahv3r30ay97f5lpi87fqwm-gmp-6.2.1
/nix/store/6pjf7rxdnb136a7cn9yj2mhy1wqm1qhq-coreutils-9.0
/nix/store/2r6pwl5f1s8xhq9d3l4g35cxl7fw5dbg-zlib-1.2.11
/nix/store/vssrny41k0mr33jclrrn67rxhbdpwrr0-bash-5.1-p12
/nix/store/z12qbpid3n9dwqggvzbfl9gcvgkz7cjy-libiconv-50
/nix/store/c1qz0g6cv70svywi944q1vbba8baxf1v-gettext-0.21
/nix/store/fmg75y564m0n76w25nrbc602dgdykb3h-binutils-2.35.2
/nix/store/22l8r8rd0r1gwkgh885l3aszavq5hhhq-libffi-3.4.2
/nix/store/hnsbw22x8djbq0p70m2llq4qb3gbwmmi-ncurses-6.3
/nix/store/q1ndbvjgmfalmv37km6hwbnq1hzi4bir-libxml2-2.9.12
/nix/store/gz12s68wl1x2q2sp83xvxbhwsck84780-llvm-11.1.0-lib
/nix/store/sw9il8pnmz96k3n1jp7hmj4s6s3zg1dn-llvm-11.1.0
/nix/store/nvqqfgl0p8mzvmd5yf6720l5w9q32v30-libtapi-1100.0.11
/nix/store/xykzfz4myqwd9cgnh5rdj1iixhfgfrz4-cctools-port-949.0.1
/nix/store/c5dc1cqfdjmfp3039y4bb4w1hlz98j17-cctools-binutils-darwin-949.0.1
/nix/store/c5jrszdq2hy3hj9rpyx3hk9gba60wd1d-Libsystem-1238.60.2
/nix/store/h1cj8rmrg7zm496ss82d3lyhf8pfcvsa-expand-response-params
/nix/store/55c4w75mryn57p7vmfy25wmzp4z6p91n-cctools-binutils-darwin-wrapper-949.0.1
/nix/store/g9jhj4m3wi0pagmvzzb78xhxp4fa1wbl-compiler-rt-libc-11.1.0
/nix/store/7jlmd88jd1bqy5jjxvwyxp7ppgjy0wdy-compiler-rt-libc-11.1.0-dev
/nix/store/qsq3l0fplrk3mgxz86d31q7rqq1n7bgk-pcre-8.45
/nix/store/85aw0z1f8x07qws64d49kmgx4b9r09yf-gnugrep-3.7
/nix/store/9742y574liw347wp9vdvwpaa8jlv63fd-clang-11.1.0-lib
/nix/store/a65laibvivl4ahwm16h93yyi28z73lnv-clang-11.1.0
/nix/store/qn0w6s8a6wr25w6qz3clxjh9vm48v2gm-libcxxabi-11.1.0-dev
/nix/store/18i795dcmzx2jlc7560nf65qybp0y41p-clang-wrapper-11.1.0
/nix/store/1r52s1bjnyshgs95037d6z37mkjlx562-zstd-1.5.2
/nix/store/2k7q0xz5vfws29v8s6drw47raf4qg388-libffi-3.4.2-dev
/nix/store/325286if932n0gvx5v23s7kgfnyc0lyx-libunistring-0.9.10
/nix/store/3vcnz9kdk857pg87515xhlz1kfp10c9b-nghttp2-1.43.0-lib
/nix/store/4ycwcc6rmyx2bchr7zbigfiyklqdkfik-ghc-8.10.7-doc
/nix/store/qz60pk8wf34gbgzq5j6pimjp7kd913hh-openssl-1.1.1m
/nix/store/98fbv4py0fwrr0jpkdlj04cmh6kwr3ba-libssh2-1.10.0
/nix/store/aljqh5wz8gnx652mkyf8vszn39hsg1xs-brotli-1.0.9-lib
/nix/store/ci3f9q46hfk7jcvqi3a6ssazfmq963yw-ICU-66108
/nix/store/ivr648zwcsg95jfjqxsdg5lqrp1d5qfy-libidn2-2.3.2
/nix/store/l1pqih6lvjb81kbl20s670hd0wpgmz53-libkrb5-1.19.2
/nix/store/i702vq1dar8lpsysd0jpf75xcvijnr5a-curl-7.81.0
/nix/store/qlcrbcy2la79hkz81wggdrwh720k7yhj-library-0.1.0.0-doc
/nix/store/xkb3c43mmkjghi8nlkl3bcgb6z2p0agh-gmp-6.2.1-dev
/nix/store/xl2s63shkj95wnrv992hyf19g2r7i740-swift-corefoundation-unstable-2018-09-14
/nix/store/qmcdw0bq6590082f3g6sqflqvlyvap5g-ghc-8.10.7
/nix/store/jkndj3lpq6256xyrx2miqglllpqiv4sm-library-0.1.0.0
/nix/store/j17x9cwaj4japr0mwk8nqvjgx7i6aysf-app-0.1.0.0
```

# Impact

This behavior is particularly surprising when building docker images. Witht the two builds above, the first is 24M, while the second is 425m!

```
$ ls -lah $(nix-build -A docker-app)
-r--r--r--  1 justin.bailey  admin    26M Dec 31  1969 /nix/store/kbs7i25jnnlfcd0i9wxq68q3i829323m-docker-image-docker-app.tar.gz

$ ls -lah $(nix-build -A docker-big-app)
-r--r--r--  1 justin.bailey  admin   475M Dec 31  1969 /nix/store/0bvvq9sdw9bwiqbwyaidxj0wwkjmdif5-docker-image-docker-big-app.tar.gz
```