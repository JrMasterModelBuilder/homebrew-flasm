#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

page="$(curl -f -L -s 'http://www.nowrap.de/flasm.html')"
source='http://www.nowrap.de/download/flasm16src.zip'
expected='bb37695bccc8c03616b877779c6d659005f5ad0f2d6d0ab3937c38b2c0c6fa58'

if [[ "${page}" == *"${source}"* ]]; then
	echo "Verified source on page"
else
	echo "Source not on page"
	exit 1
fi

sha256="$(curl -f -L -s "${source}" | shasum -a 256 -b | cut -d' ' -f1)"
if [[ "${sha256}" == "${expected}" ]]; then
	echo "Verified sha256"
else
	echo "Unexpect sha256: ${sha256}"
	exit 1
fi
