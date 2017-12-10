---
layout: post
title:  "Socket.io with Elastic Beanstalk"
date:   2017-12-10 19:00 +0900
categories: programming aws
comments: true
---

Elastic Beanstalk을 이용하여 Socket.io 서버 운영 시, 제대로 연결이 안 되거나 wss를 타지 못해 xhr polling으로 대체되는 문제가 생길 수 있는데, 이 때 이렇게 하면 된다.

1. `.ebextension/socketupgrade.config` 파일에 다음과 같이 추가

{% highlight plain %}
container_commands:
  enable_websockets:
    command: |
     sed -i '/\s*proxy_set_header\s*Connection/c \
              proxy_set_header Upgrade $http_upgrade;\
              proxy_set_header Connection "upgrade";\
      ' /tmp/deployment/config/#etc#nginx#conf.d#00_elastic_beanstalk_proxy.conf
{% endhighlight %}

2. Elastic Beanstalk에 물려 있는 Classic Load Balancer의 Listener 설정을 아래와 같이 변경한다.
![캡쳐 4](/images/20171210/alb_listener_setting.png)

웹소켓이 정상적으로 물리는 것을 확인할 수 있다.
