#!/bin/bash
echo -e "Commit message: \c"
read commit_msg

cd ~/ejnahc.github.io \
&& git add --all \
&& git commit -m "$commit_msg" \
&& git push \
&& cd _site \
&& git add --all \
&& git commit -m "$commit_msg" \
&& git push \
&& cd ..
