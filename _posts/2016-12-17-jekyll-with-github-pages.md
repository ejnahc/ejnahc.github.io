---
layout: post
title:  "Jekyll with Github Pages"
date:   2016-12-17 22:43:03 +0900
categories: programming jekyll
comments: true
---

일단 첫 글은 이 Jekyll을 어떻게 설치했는지에 대해 적어보고자 한다.

Github Pages에서는 기본적으로 Jekyll을 설치하여 호스팅이 가능하지만 Paginate 등의 Plugin은 설치가 불가능하다. github-pages 라는 gem이 있지만 여기에서도 Paginate 플러그인은 설치되어 있지 않다. 따라서 **local에서 직접 사이트를 build 한 다음, _site 폴더를 github page에 호스팅 하는 방법을 사용해야 한다.** 

사용중인 Ruby 버전은 2.3.3p222, Jekyll 버전은 3.3.1 이다.

{% highlight bash %}
gem install jekyll bundler
jekyll new ejnahc.github.io
cd ejnahc.github.io
bundle
bundle exec jekyll serve --watch --host=0.0.0.0
{% endhighlight %}

이후 `http://SITE:4000/` 으로 접속하여 정상적으로 나오는지 확인한다. `_config.yml` 에서 필요한 설정을 바꿀 수 있다.

daemon을 켜놓고 파일을 바꾸게 되면 자동으로 html 파일을 build해 주는 원리이다.

## 스킨 씌우기
[Jekyll Themes](http://jekyllthemes.org)에 다양한 테마들이 있다. 마음에 드는 것을 고르면 된다. [Zetsu](http://jekyllthemes.org/themes/zetsu/)를 사용한다. [다운로드 링크](https://github.com/nandomoreirame/zetsu/archive/master.zip)를 눌러 다운받아서 루트에 덮어 씌운다.

스킨마다 다르기 때문에 확실히 어떻게 해야 한다고 적을 수는 없지만 기존 파일들과 비교하여 눈치껏 잘 알아서 수정하면 된다. 그러기 귀찮으면 그냥 폴더 싹 날려버리고 스킨 폴더로 시작하는 것도 방법이다.

위 스킨의 경우 새로운 gem을 설치해야 하는데 `Gemfile`에 아래 두 줄을 추가한다.
{% highlight ruby %}
gem "rake"
gem "sass"
{% endhighlight %}

이후 `bundle install` 로 추가된 gem을 설치한다.

## 글 쓰기
글 쓰는 것은 _posts 안에 `시간-제목.md` 로 작성하면 된다. 이미 샘플 문서 파일이 있을건데 파일 이름을 따라 지어주면 된다. 파일 이름은 중요하니 잘 따라 짓는게 좋다.

글의 첫 부분에 아래와 같은 부분이 있는데 이걸 Front Matter이라 부른다.
{% highlight plain %}
---
layout: post
title:  "Jekyll with Github Pages"
date:   2016-12-17 22:43:03 +0900
categories: programming jekyll
comments: true
---
{% endhighlight %}

여러 항목들에 대한 설명을 [여기](https://jekyllrb.com/docs/frontmatter/)에서 볼 수 있다. `published` 라는 것도 있는데 false로 두면 표시되지 않게 하는 파라미터다.

글 양식은 Markdown을 사용한다. 기본적인 사용 방법은 [Markdown Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)에서 확인한다.

## jekyll-paginate 플러그인 설치
Gemfile 파일에서 아래에 다음과 같이 삽입

{% highlight ruby %}
# If you have any plugins, put them here!
group :jekyll_plugins do
   gem "jekyll-feed", "~> 0.6"
   gem "jekyll-paginate" # 새로 추가한다.
{% endhighlight %}

`bundle install` 로 설치한다.

`_config.yml` 을 열어 아래 두 줄을 추가한다..

{% highlight plain %}
paginate: 10
gems:
  - jekyll-paginate
{% endhighlight %}

내가 위에서 쓰는 스킨에는 이미 paginate snippet이 있어 작업할 필요가 없지만 필요한 경우 pagination 부분을 스킨에 추가해야 한다. 예제 Snippet을 [여기](https://jekyllrb.com/docs/pagination/)에서 확인할 수 있다. 어떻게 적용하는지 모르겠으면 내가 적용한 스킨을 받아서 확인해 보면 된다.

내 스킨은 오래되어서 경로가 잘못되어 있는데 이전, 다음 링크를 아래와 같이 변경한다.

{% highlight html %}
<li><a class="newer-posts" href="{{ paginator.previous_page_path }}/">&laquo;</a></li>
<li><a class="older-posts" href="{{ paginator.next_page_path }}/">&raquo;</a></li>
{% endhighlight %}

## Disqus 댓글 달기
스킨에 따라 다르지만 위의 스킨같은 경우에는 각 문서의 Front Matter에서 `comments` 변수를 `true`로 설정해야 한다.

[Disqus](http://disqus.com)에서 설치 페이지를 들어가서 댓글 위젯을 추가한 다음, `_includes/comments.html` 에 있는 Disqus 소스를 아래와 같이 수정한다.

{% highlight html %}
{% raw %}
<div id="disqus_thread"></div><script>var disqus_config = function () {this.page.url = '{{ page.id | prepend: site.url }}';this.page.identifier = '{{page.id}}';};(function() {var d = document, s = d.createElement('script');s.src = '//blog-chan-je.disqus.com/embed.js';s.setAttribute('data-timestamp', +new Date());(d.head || d.body).appendChild(s);})();</script><noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
{% endraw %}
{% endhighlight %}

주소가 같으면 같은 댓글 주소가 보여지게 되는 경우가 있으니 스킨에 추가한 다음 `this.page.url` 과 `this.page.identifier` 가 제대로 설정되어 있는지를 확인한다.

## Github Page에 올리기
이정도면 Jekyll 설정은 다 된거 같다. Github Page에 올리는데 아까 말한것과 같이 `_site` 폴더를 `master` 브랜치로 설정하여 접속 시 보이게 하고 나머지 폴더들은 글 내용의 변동 사항 등을 저장해 두기 위해 역시나 repo에 올려둘려고 한다. 먼저 `_site` 폴더부터 master 브랜치로 올린다.

{% highlight bash %}
cd _site
git init
git add --all
git commit -m "first commit"
git remote add origin git@github.com:ejnahc/ejnahc.github.io.git
git push -u origin master
{% endhighlight %}

그 상위 폴더 또한 올리되, dev 브랜치를 만들어 올리기로 한다.
{% highlight bash %}
cd ../
git init
git add --all
git commit -m "first commit"
git remote add origin git@github.com:ejnahc/ejnahc.github.io.git
git checkout -b dev
git branch -d master
git checkout dev
git push -u origin dev
{% endhighlight %}

