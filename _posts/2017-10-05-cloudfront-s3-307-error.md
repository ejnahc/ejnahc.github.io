---
layout: post
title: "CloudFront + S3 에서 307 Error 해결하기"
date: 2017-10-05 18:00:00 +0900
categories: programming aws
comments: true
---

S3에 Asset들을 올려놓고 CloudFront를 이용하여 Serving 하게끔 설정해 두었는데, XXXXXX.s3.ap-northeast-2.amazonaws.com 와 같은 URL로 리다이렉트 되면서 제대로 표시되지 않을 수 있고, 이 때 307 redirect 코드가 뜨는 것을 확인할 수 있다.

해결 방법은 그냥 **기다리면 된다**. 보통 이런 경우 S3 bucket과 CloudFront를 갓 만든 경우인데, 모든 edge에 배포되는데 시간이 걸리기 때문에 정상적으로 리다이렉트 되지 않는 경우가 생긴다. 아무리 길어도 3시간 내지 1일 안에는 해결되므로 기다리면 됨.

만약 그 사이에 CloudFront 도메인에 접속하였다면 307 redirect 결과가 캐싱되어버려 추후 배포되었음에도 똑같은 오류가 발생할 수 있는데, 이 때 CloudFront 콘솔의 Invalidation 탭에 들어가 해당 URL을 갱신해 주면 됨.

셋팅할때마다 긴가민가 해서 기억 저장 겸 보관해둔다. 추석 기념 포스팅!
