---
layout: post
title:  "실전 압축 Django"
date:   2016-12-24 23:00:00 +0900
categories: programming github
comments: true
toc: true
---

[예제로 배우는 Python 프로그래밍](http://pythonstudy.xyz/python/django)을 보고 따라해 봤는데 어느정도 기초 알기에는 많은 도움이 된 거 같다. 순서대로 따라 하면 될 거 같고 빠른 적응을 위해 나에게 필요한 부분만 메모해 두었으며, 중간중간에 추가로 필요한 내용을 메모할 예정

## Quickstart
{% highlight bash %}
$ pip install django
$ django-admin startproject myweb
$ cd myweb && ./manage.py runserver 0.0.0.0:5000
{% endhighlight %}

## App
* 한 프로젝트에 여러 개의 App이 있을 수 있다.
* App은 모듈화할 수 있고 여러 프로젝트에서 재사용할 수 있다.

{% highlight bash %}
$ ./manage.py startapp home
{% endhighlight %}

이후, `settings.py` INSTALLED_APPS 리스트에 `'home'` 을 추가한다. 이후 `urls.py` 파일에 있는에 `urlpatterns` 에 URL 패턴을 추가하면 App으로 접속할 수 있게 된다.

## View
* View는 MVC에서의 Controller와 비슷한 기능을 한다. `views.py` 파일에 정의한다. 
* Django에서는 MTV인데 MVC와의 차이는 View → Template, Controller → View로 변경됨.

{% highlight python %}
from django.http import HttpResponse
from django.shortcuts import render
 
def index(request):
    msg = 'My Message'
    return render(request, 'index.html', {'message': msg})
{% endhighlight %}

## Template
* Template은 CodeIgniter에서의 View를 정하는 HTML 파일이다. 각각의 Django App 폴더 안에 `templates` 폴더를 만든 후 이 안에 템플릿 파일들을 정의한다.
* 여러 템플릿 엔진을 쓸 수 있으며 기본 템플릿 엔진은 `settings.py` 파일에 `TEMPLATES` 섹션에서 `BACKEND`를 `django.template.backends.django.DjangoTemplates`로 설정
* `extends` 와 `block` 을 이용하면 include 기능을 활용할 수 있다. header, footer의 개념이라 보면 될 듯. 
* 아래는 기본적인 Django 템플릿 언어 (Template Language)를 다룬 것들이다.

{% highlight html %}
{% raw %}
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
    <h1>{{message}}</h1>
    <h4>
      Name : {{ name }}
      Type : {{ vip.key }}
    </h4>
    {% if count > 0 %}
        Data Count = {{ count }}
    {% else %}
        No Data
    {% endif %}
     
    {% for item in dataList %}
      <li>{{ item.name }}</li>
    {% endfor %}
     
    {% csrf_token %}
    
    {# 날짜 포맷 지정 #}
    {{ createDate|date:"Y-m-d" }}
     
    {# 소문자로 변경 #}
    {{ lastName|lower }}
</body>
</html>
{% endraw %}
{% endhighlight %}

## Model
* `models.py` 에 정의한다. 여러 개의 모델 클래스 정의가 가능하며, 1개의 모델은 데이터베이스에서 1개의 테이블에 해당한다.

{% highlight python %}
from django.db import models

class Feedback(models.Model):
    name = models.CharField(max_length=100)
    email = models.EmailField()
    comment = models.TextField()
    createDate = models.DateTimeField()

    def __str__(self):
        return self.name

    def __unicode__(self):
        return u'%s' % self.name
{% endhighlight %}

### 필드 타입

| 필드 타입 | 설명 |
| --------- | ---- |
| CharField | 제한된 문자열 필드 타입. 최대 길이를 `max_length` 옵션에 지정해야 한다. 문자열의 특별한 용도에 따라 `CharField`의 파생클래스로서, 이메일 주소를 체크를 하는 `EmailField`, IP 주소를 체크를 하는 `GenericIPAddressField`, 콤마로 정수를 분리한 `CommaSeparatedIntegerField`, 특정 폴더의 파일 패스를 표현하는 `FilePathField`, URL을 표현하는 `URLField` 등이 있다. |
| TextField | 대용량 문자열을 갖는 필드 |
| IntegerField | 32 비트 정수형 필드. 정수 사이즈에 따라 `BigIntegerField`, `SmallIntegerField` 을 사용할 수도 있다. |
| BooleanField | `true`/`false` 필드. `Null` 을 허용하기 위해서는 `NullBooleanField`를 사용한다. |
| DateTimeField | 날짜와 시간을 갖는 필드. 날짜만 가질 경우는 `DateField`, 시간만 가질 경우는 `TimeField`를 사용한다. |
| DecimalField | 소숫점을 갖는 `decimal` 필드 |
| BinaryField | 바이너리 데이타를 저장하는 필드 |
| FileField | 파일 업로드 필드 |
| ImageField | `FileField`의 파생클래스로서 이미지 파일인지 체크한다. |
| UUIDField | `GUID (UUID)`를 저장하는 필드 |

### 필드 간 관계 (Relationship)
* `ForeignKey`
* `ManyToManyField`
* `OneToOneField`

더 자세한 정보는 [Django Docs: Model field reference](https://docs.djangoproject.com/en/1.10/ref/models/fields/)를 확인한다.

### 필드 옵션

| 필드 옵션 | 설명 |
| --------- | ---- |
| null (`Field.null`) | `null=True` 이면, Empty 값을 DB에 `NULL`로 저장한다. DB에서 `Null`이 허용된다. 예: `models.IntegerField(null=True)` |
| blank (`Field.blank`) | `blank=False` 이면, 필드가 Required 필드이다. `blank=True` 이면, Optional 필드이다. 예: `models.DateTimeField(blank=True)` |
| primary_key (`Field.primary_key`) | 해당 필드가 Primary Key임을 표시한다. 예: `models.CharField(max_length=10, primary_key=True)` |
| unique (`Field.unique`) | 해당 필드가 테이블에서 Unique함을 표시한다. 해당 컬럼에 대해 Unique Index를 생성한다. 예: `models.IntegerField(unique=True)` |
| default (`Field.default`) | 필드의 디폴트값을 지정한다. 예: `models.CharField(max_length=2, default="WA")` |
| db_column (`Field.db_column`) | 컬럼명은 디폴트로 필드명을 사용하는데, 만약 다르게 쓸 경우 지정한다. |

### DB Migration

* `settings.py` 파일 안의 `INSTALLED_APPS` 리스트 안에 App 이름을 추가한다.
* 테이블 스키마가 추가/수정된 경우 아래 명령어를 이용하여 실 DB에 적용한다.

{% highlight bash %}
$ ./manage.py makemigrations
$ ./manage.py migrate
{% endhighlight %}

* `App명_ModelClass명`의 형식으로 데이터베이스가 생성된다.
* DB 관리를 하기 위해서 아래 명령어를 입력한다.

{% highlight bash %}
$ ./manage.py dbshell
{% endhighlight %}

MySQL의 경우 `settings.py` 에서 아래와 같이 변수 설정한다.

{% highlight python %}
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'MyDB',
        'USER': 'user1',
        'PASSWORD': 'pwd',
        'HOST': 'localhost',
        'PORT': '3306',
    }
}
{% endhighlight %}

### Model API
{% highlight python %}
from feedback.models import *
from datetime import datetime

# INSERT
fb = Feedback(name = 'Kim', email = 'kim@test.com', comment='Hi', createDate=datetime.now())
fb.save()

for f in Feedback.objects.all():
    s += str(f.id) + ' : ' + f.name + '\n'

# GET
row = Feedback.objects.get(pk=1)
print(row.name)
rows = Feedback.objects.filter(name='Kim')
rows = Feedback.objects.exclude(name='Kim')
n = Feedback.objects.count()
rows = Feedback.objects.order_by('id', '-createData')
rows = Feedback.objects.distinct('name')
rows = Feedback.objects.order_by('name').first()
rows = Feedback.objects.order_by('name').last()
row = Feedback.objects.filter(name='Kim').order_by('-id').first()

# UPDATE
fb = Feedback.objects.get(pk=1)
fb.name = 'Park'
fb.save()

# DELETE
fb = Feedback.objects.get(pk=2)
fb.delete()
{% endhighlight %}

## URL Mapping
Project 메인 URL 파일 `urls.py` 에 정의하며 아래와 같이 프로젝트마다 매핑을 걸어줄 수 있다.

{% highlight python %}
# urls.py
from django.conf.urls import url, include

urlpatterns = [
    url(r'^feedback/', include('feedback.urls')),
    url(r'^home/', include('home.urls')),
]

# home/urls.py
from django.conf.urls import url
from home import views

# app_name = 'test' -> url 'test:list' ...
urlpatterns = [
    url(r'^list', views.list, name='list'),
    url(r'^create', views.create, name='create'),
    url(r'^edit/(?P<id>\d+)/$', views.edit, name='edit'),
]
{% endhighlight %}

Alias 같은 개념이 있는데 `name='list'` 로 정의하여 템플릿에서 {%raw%}`<a href="{% url 'list' %}">`{%endraw%}와 같이 응용할 수 있다. 더 자세한 정보는 [Django Docs: URL dispatcher](https://docs.djangoproject.com/en/1.10/topics/http/urls/)를 확인한다.

## Form
`forms.py` 에 정의한다.

{% highlight python %}
from django.forms import ModelForm
from .models import Feedback
 
class FeedbackFrom(ModelForm):
    class Meta:
        model = Feedback
        fields = ['id', 'name','email','comment']
{% endhighlight %}

`views.py` 에 다음과 같이 Form handling을 할 수 있다.
{% highlight python %}
from django.shortcuts import render, redirect
from .models import *
from .forms import FeedbackFrom
 
def create(request):
    if request.method=='POST':
        form = FeedbackFrom(request.POST)
        if form.is_valid():
            form.save()
        return redirect('/feedback/list')
    else:
        form = FeedbackFrom()
 
    return render(request, 'feedback.html', {'form': form})
{% endhighlight %}

템플릿을 아래와 같이 정의하여 Form을 만들 수 있다.
{% highlight html %}
{% raw %}
{% extends "base.html" %}

{% block content %}
    <p>
        <a href="{% url 'list' %}">Goto Feedback List</a>
    </p>

    <div>
        <form method="POST">
            {% csrf_token %}
            {{ form.as_p }}
            <button type="submit">저장</button>
        </form>
   </div>

{% endblock content %}
{% endraw %}
{% endhighlight %}

## Static File

{% highlight python %}
STATICFILES_DIRS = [
    os.path.join(BASE_DIR, "static"),
]

STATICFILES_FINDERS = (
    'django.contrib.staticfiles.finders.FileSystemFinder',
    'django.contrib.staticfiles.finders.AppDirectoriesFinder',
)
{% endhighlight %}

static 파일 사용은 아래와 같이 한다.

{% highlight html %}
{% raw %}
{% load staticfiles %}

<html lang="en">
<head>
    <link rel="stylesheet" href="{% static 'bootstrap/css/bootstrap.min.css' %}">
</head>
<body>
</body>
</html>
{% endraw %}
{% endhighlight %}

Deploy 시 static 파일을 모아 특정 디렉토리로 옮길 수 있으며 이 작업을 위해 `collectstatic` 명령을 사용한다.

{% highlight bash %}
$ ./manage.py collectstatic
{% endhighlight %}

## Site Deployment - using Nginx + uWSGI
[Django and nginx](http://uwsgi-docs.readthedocs.io/en/latest/tutorials/Django_and_nginx.html) 문서를 참고한다.

우선 uwsgi를 root에 설치한다.

{% highlight bash %}
$ sudo pip install uwsgi
{% endhighlight %}

위 파일을 `uwsgi.ini` 로 저장한다.

{% highlight plain %}
[uwsgi]

# Django-related settings
# the base directory (full path)
chdir           = /home/myweb
# Django's wsgi file
module          = myweb.wsgi
# the virtualenv (full path)
home            = /home/myweb/venv

# process-related settings
# master
master          = true
# maximum number of worker processes
processes       = 10
# the socket (use the full path to be safe
socket          = /tmp/myweb.sock
# ... with appropriate permissions - may be needed
chmod-socket    = 666
# clear environment on exit
vacuum          = true

safe-pidfile = /var/run/myweb.pid
uid = www-data
gid = www-data
{% endhighlight %}

아래 명령어로 정상 동작하는지 확인한다.

{% highlight bash %}
$ uwsgi --ini uwsgi.ini
{% endhighlight %}

제대로 동작하는 경우, (systemd 에 적용)[http://uwsgi-docs.readthedocs.io/en/latest/Systemd.html]한다.

### Pip Package
Deploy 시 현재 사용중인 패키지를 아래와 같이 저장, 설치할 수 있다.

{% highlight bash %}
$ pip install -r requirements.txt
$ pip freeze > requirements.txt
{% endhighlight %}

## Plugin: debug_toolbar
1. `pip install django-debug-toolbar`
2. `settings.py` 파일에 아래와 같이 수정
 * `INSTALLED_APPS` 에 `debug_toolbar` 추가
 * `MIDDLEWARE` 에 `debug_toolbar.middleware.DebugToolbarMiddleware` 추가
 * `INTERNAL_IPS` 에 접속한 IP 주소 추가
3. 프로젝트 `urls.py` 파일에 있는 `urlpatterns` 에 `import debug_toolbar`,  `url(r'^__debug__/', include(debug_toolbar.urls))` 추가

