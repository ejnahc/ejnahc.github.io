#!/bin/bash
echo -e "Commit message: \c"
read commit_msg

cd ~/ejnahc.github.io \
&& bundle exec jekyll build \
&& git add --all \
&& git commit -m "$commit_msg" \
&& git push \

cd _site \
&& echo "blog.chan.je" >> CNAME \
&& git add --all \
&& git commit -m "$commit_msg" \
&& git push \
&& cd ..
