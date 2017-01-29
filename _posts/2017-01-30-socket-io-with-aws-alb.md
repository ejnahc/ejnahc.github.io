---
layout: post
title:  "Socket.io with AWS ALB"
date:   2017-01-30 02:30 +0900
categories: programming aws
comments: true
---

요즘 [AWS](https://aws.amazon.com)로 이전하고 있는 프로젝트가 있는데, $$$가 들긴 하지만 진작 쓸 걸 하는 생각을 하고 있다. 다른 것들은 자습서나 문서들이 잘 되어 있어 적용에 크게 어려움이 없었으나, 여러 개의 socket.io를 돌리고 있는 ec2 instance를 만들어 이를 로드밸런싱 하는 과정에서 - 즉, [Socket.io](http://socket.io)에다 [Elastic Load Balancing(ELB)](https://aws.amazon.com/ko/elasticloadbalancing/)를 물리는 부분에서 많은 삽질을 했다. 이후에는 같은 삽질을 하지 않았으면 하는 바람에서 적어둔다.

이 문서는 [WebSocket対応した噂のALB (Application Load Balancer) を試してみた](http://uorat.hatenablog.com/entry/2016/09/26/070000)를 참고하여 쓴 것이며, 보다 자세한 내용을 원한다면 클릭해 보자.


## ELB의 장점
기본적인 목적은 부하, 트래픽 분산이다. 여기에 추가로: 
* 돌아가던 서버가 죽더라도 다른 곳으로 라우팅을 하여 장애 시간을 줄일 수 있음
* Multi-AZ로 구성해 두면 특정 AZ의 장애가 발생하더라도 보다 유연하게 대처할 수 있음
* ELB에 물린 DNS name을 CNAME으로 도메인에 물려두면 인스턴스가 추가/삭제 되더라도 그에 맞추어 따로 IP 작업을 하지 않아도 된다.

## Application 작업
Socket.io Application에 추가로 해야 할 작업은 [socket.io-redis](https://github.com/socketio/socket.io-redis)를 달아 pub/sub가 가능하게끔 하면 된다. 각각의 instance에서 emit 하는 이벤트들이 다른 instance에도 갈 수 있게끔 해주고, 더 나아가 session control도 가능해진다.

## 겪었던 문제들
내가 겪은 가장 큰 문제는 간헐적으로 HTTP 상태 코드가 400 Bad Request를 뿜는 오류였고, "Session ID Unknown"가 오류 메시지였는데, 이 문제는 로드 밸런싱을 하면서 다른 Instance에 접속했을 때 이전 세션 ID를 이용하지 않은 상태에서 접속하여 발생하는 오류로, AWS에서 만들어 둔 Sticky session (고정 세션) 을 해결하면 간단히 해결된다.

또 Nginx proxy 등이 제대로 붙지 않는 오류가 있는데, 삽질을 아주 잘 한다면 이대로 사용해도 괜찮겠지만 앞으로 소개할 ALB를 이용하면 Nginx proxy 등을 만들지 않아도 쉽게 해결할 수 있다.

## Application Load Balancer (ALB)
기존의 Classic Load Balancer가 TCP 등의 좀 더 로우 레벨에서 돌아가는 로드 밸런서라면, ALB는 HTTP/HTTPS 어플리케이션 레이어 상에서 돌아가는 밸런서라 보면 된다. 대부분의 웹 어플리케이션에 적용하기에 큰 무리가 없어서 왠만해서는 그냥 이걸 사용하면 된다. 기존의 로드 밸런서에서는 Instance를 직접 관리하는데, ALB에서는 Target Group을 만들어 관리한다. 

## Make Target Group
참고: [AWS Docs](http://docs.aws.amazon.com/ko_kr/elasticloadbalancing/latest/application/load-balancer-target-groups.html)

* Protocol: HTTP
* Port: 3000 (Application port)
* Health check는 Protocol HTTP, Path /socket.io/socket.io.js 로

**생성한 다음 매우 중요한 부분이 있는데**, 생성한 Target Group에서 오른쪽 클릭 후 Edit Attributes를 눌러 Stickiness 옵션에 **Enable load balancer generated cookie stickiness** 를 선택해 주면 Sticky session이 활성화 되며 위에서 언급한 400 오류가 뜨지 않게 된다. 사실 이 문단이 이 문서에서 가장 중요한 부분이자 이 글을 쓴 이유다.

## Launch ALB 
* Listen Protocol: HTTP, HTTPS (포트 그대로)
* HTTPS를 사용하는 경우 인증서를 선택해 준다.
* AZ는 각각 다른 AZ 2개를 선택 후, 해당 AZ 내 Public Subnet을 하나씩 선택해 준다.
* Target Group에 아까 생성한 Target Group을 지정.

나머지는 적절히 지정해 준 다음 생성된 로드 밸런서의 CNAME으로 도메인을 지정해 주고 잠시 후 접속이 제대로 되는지 확인해 보면 된다.