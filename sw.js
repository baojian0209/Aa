/* 离线缓存：第一次打开后把页面存到手机里，以后断网也能打开 */
var CACHE_NAME = 'baizhujiji-v2';
var CACHE_FILES = [
  './',
  './index.html',
  './manifest.json',
  './icon-192.png',
  './icon-512.png',
  './icon-512-maskable.png'
];

/* 安装：把要用的文件先存进缓存 */
self.addEventListener('install', function(event){
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(function(cache){ return cache.addAll(CACHE_FILES); })
      .then(function(){ return self.skipWaiting(); })
  );
});

/* 激活：清掉旧版本的缓存 */
self.addEventListener('activate', function(event){
  event.waitUntil(
    caches.keys().then(function(keys){
      return Promise.all(keys.filter(function(k){ return k !== CACHE_NAME; })
        .map(function(k){ return caches.delete(k); }));
    }).then(function(){ return self.clients.claim(); })
  );
});

/* 取文件：
   页面本体 → 先联网拿最新的（这样改了功能你打开就是新版），断网时用缓存兜底；
   图标这类不常变的文件 → 先用缓存，快一些。 */
self.addEventListener('fetch', function(event){
  var req = event.request;
  if(req.method !== 'GET') return;

  var isPage = (req.mode === 'navigate') ||
               ((req.headers.get('accept') || '').indexOf('text/html') >= 0);

  if(isPage){
    event.respondWith(
      fetch(req).then(function(res){
        var copy = res.clone();
        caches.open(CACHE_NAME).then(function(cache){ cache.put('./index.html', copy); });
        return res;
      }).catch(function(){ return caches.match('./index.html'); })
    );
    return;
  }

  event.respondWith(
    caches.match(req).then(function(hit){
      if(hit) return hit;
      return fetch(req).then(function(res){
        var copy = res.clone();
        caches.open(CACHE_NAME).then(function(cache){ cache.put(req, copy); });
        return res;
      });
    })
  );
});
