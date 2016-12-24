---
layout: post
title:  "오픈소스에 기여해 보기"
date:   2016-12-23 23:16:00 +0900
categories: programming github
comments: true
---
하릴없이 인터넷 서핑 하며 시간만 축내다 [voca](https://github.com/panzerdp/voca)라는 라이브러리를 발견했다. 재밌어보이는데 하면서 둘러보다가 뭔가 오타를 발견해서 지금까지 내부적으로 쓰기만 했지 오픈소스에 기여한 적이 없어서 한번 간단히 기여해 보기로 했다. 사실 오타 1바이트 수정하는게 얼마나 오픈소스에 기여할지는 모르겠지만 ;p 연습이니까.

## Fork 하기
[github fork 에서 pull request 까지 그리고 merge](http://blog.axisj.com/archives/514)를 참고하여 자신의 Repo에 Fork 한다. Fork 한 저장소를 가져온다.

{% highlight bash %}
$ git clone git@github.com:ejnahc/voca.git
{% endhighlight %}

## 새로운 Branch 만들기
패치를 적용할 브랜치를 만든다. 브랜치 이름은 적당히 `patch-1`로 지어 줬다.

{% highlight bash %}
$ git checkout -b patch-1
{% endhighlight %}

## 변경 사항 Commit 하기
변경 사항을 Commit 한다. [Git 커밋 메시지 작성법](https://item4.github.io/2016-11-01/How-to-Write-a-Git-Commit-Message/)을 참고하면 많은 도움이 된다.
{% highlight bash %}
$ git commit -m "Fix typo"
{% endhighlight %}

## 자신의 repo에 패치 올리기
`git push`를 이용하여 패치를 올린다. 

{% highlight bash %}
$ git push --set-upstream origin patch-1
{% endhighlight %}

## Pull request 날리기
패치를 올리고 Github에 가 보면 **Compare & pull request**가 생기는데 눌러준다.

![캡쳐 1](/images/20161223/capture1.png)

어떤 점을 고쳤는지를 적어 준다. 영어로 적어야 해서 긴장되지만 정성스레 적어 준다.

![캡쳐 2](/images/20161223/capture2.png)

Pull request가 만들어 지고 Travis CI가 PR된 코드의 테스트를 자동으로 진행하는 것을 확인할 수 있다. 테스트가 완료될 때까지 기다려 준다.

![캡쳐 3](/images/20161223/capture3.png)

언제 테스트가 완료되나 기다리고 있었는데 주인장이 그냥 merge 해 줬다. 

![캡쳐 4](/images/20161223/capture4.png)

이 맛에 오픈소스 기여 하는구나 싶다! 생각보다 쉬우니 오픈소스에 많이 도움을 줘야 겠다는 생각을 했다. 일단은 오타 위주로.. ㅋㅋ