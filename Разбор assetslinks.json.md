#universal-links #android #webdev #backend #reactnative 
Файл является аналогом подтверждения "ассоциативного домена" в мобильном приложении
```json
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.example.droidfood",
      "sha256_cert_fingerprints": [
      "14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:9G:34:FC:64:16:S9:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:44:X5"
        ]
    }
  }
```

 Подробнее:
-  `"relation": ["delegate_permission/common.handle_all_urls"]` - «что именно разрешает сайт приложению делать».
- `"target":` - какие приложения, на 2026 поддерживается только android_app
- `package_name` - название приложения, можно посмотреть в android studio, app/build.gradle в `defaultConfig { applicationId: "" }`
- `ha256_cert_fingerprints` - зашифрованные сертификаты, то-есть откроет приложение которое подписано этим зашифрованным сертификатом

их можно получить по `keytool -list -v -keystore my-release-key.keystore`