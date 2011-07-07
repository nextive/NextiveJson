#!/bin/sh
appledoc --create-html --create-docset --install-docset --clean-output --output docs -verbose xcode --project-name "Nextive Json" --project-company "Nextive LLC"  --company-id Nextive --search-undocumented-doc  --merge-categories --prefix-merged-sections  --keep-merged-sections --keep-intermediate-files --ignore "*.m" --ignore Tests --ignore External --ignore build .

