#!/usr/bin/env bash

# bundle with rollup
NODE_ENV=production rollup -c

# copy SPA to all organizations
\cp -r "public" "../organization/haushalt_a/"
\cp -r "public" "../organization/haushalt_b/"
\cp -r "public" "../organization/haushalt_c/"
\cp -r "public" "../organization/netzbetreiber/"
