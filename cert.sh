#!/bin/bash

# Tell dnsdist to reload the config
dnsdist -c -e 'reloadAllCertificates()'

# Save last run time
date +%s > last_cert_reload.txt