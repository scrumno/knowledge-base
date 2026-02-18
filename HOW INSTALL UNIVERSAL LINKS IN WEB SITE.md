#universal-links
Нужно просто создать папку в корне проекта: 
- .well-known
в ней разместить три файла:
- .htaccess
- assetlinks.json // android
- apple-app-site-association // apple

В .htaccess нужно написать:
```htaccess 
<Files "apple-app-site-association">  
    Header set Content-Type "application/json"  
    Header set Cache-Control "public, max-age=3600"  
</Files>
```

[[Разбор assetslinks.json]]
[[Разбор apple-app-site-association]]

![[Pasted image 20260218165557.png]]