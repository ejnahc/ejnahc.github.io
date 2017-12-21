---
layout: post
title:  "588,800원 짜리 부등호 하나"
date:   2017-12-21 23:00 +0900
categories: programming php
comments: true
---

Toss를 통해 인터넷 결제를 받는 상점을 개발하고 있었다. 근데 나중에 정산하면서 확인해 보니 누락된 건이 있었다. 상점의 DB에는 결제가 완료된 것으로 처리되어 있는데, 실제 Toss에서는 결제 내역이 없는 경우를 발견했다. 전체 결제에서 1%도 안되는 적은 수치였지만, 처음에는 Toss에서 제대로 결과값을 보내주지 않거나 오류가 난 것이 아닌가 생각했다. 이제 와서 돌이켜 보면 "내 코드가 틀릴 리 없어"라는 정말 오만한 생각임이 분명했다.

기본적인 아이디어만을 따오자면 결제 루틴은 이런 식으로 되어 있었다. [Toss의 API 문서](http://tossdev.github.io/api.html#execute) 를 참고했다.

{% highlight php %}
$arrayBody = array();
$arrayBody["payToken"] = "test_token1234567890a";
$arrayBody["apiKey"] = "sk_test_apikey1234567890a";
$jsonBody = json_encode($arrayBody);

$ch = curl_init('https://toss.im/tosspay/api/v1/execute');
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_POSTFIELDS, $jsonBody);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, array(
    'Content-Type: application/json',
    'Content-Length: ' . strlen($jsonBody))
);
 
$result = json_decode(curl_exec($ch));
curl_close($ch);

if ($result->code == 0) {
  // 결제 진행
} else {
  // 결제 실패
}
{% endhighlight %}

결제 요청을 PG에 보내서, 그 결과로 받아온 값의 `code` 가 0이면 결제가 성공한 것으로 처리하고 주문을 완료처리 하면 되는 간단한 루틴이다.
그러나, 추측건대 저 curl 요청이 타임아웃이나 네트워크 단절 등 여러 이유로 제대로 요청되지 않았을 때, 즉 response의 http code가 200이 아닐 때는 `curl_exec($ch)` 의 값은 `NULL` 이 되고, 놀랍게도 `$result->code == 0`은 `TRUE`가 된다.

![그런데 그것이 실제로 일어났습니다](/images/20171221/3v4l_results.png)

따라서, 정확한 값이 0인지를 확인하기 위해서는 `$result->code === 0` 을 사용해야 한다. 이 오류로 내가 입은 손실을 따져보면, 나에게 = 하나는 적어도 588,000원 짜리의 가치는 할 것 같다. 이후에도 같은 결제 누락이 발생할 지는 모르겠지만, 앞으로는 더 이런 사태가 발생하지 않길 바라며...
그리고 개발자로서 엄청 쪽팔리고 과거의 내가 정말 밉지만, 이렇게 박제해 놔야 나중에 이런 실수 안 할 것 같다.

* [PHP: The Right Way](http://modernpug.github.io/php-the-right-way/pages/The-Basics.html)
