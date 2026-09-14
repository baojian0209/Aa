/* 离线缓存：第一次打开后把页面存到手机里，以后断网也能打开 */
var CACHE_NAME = 'baizhujiji-v1';
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

/* 取文件：先看缓存，没有再去网上拿；彻底断网时回到首页 */
self.addEventListener('fetch', function(event){
  if(event.request.method !== 'GET') return;
  event.respondWith(
    caches.match(event.request).then(function(hit){
      if(hit) return hit;
      return fetch(event.request).then(function(res){
        var copy = res.clone();
        caches.open(CACHE_NAME).then(function(cache){ cache.put(event.request, copy); });
        return res;
      }).catch(function(){ return caches.match('./index.html'); });
    })
  );
});
