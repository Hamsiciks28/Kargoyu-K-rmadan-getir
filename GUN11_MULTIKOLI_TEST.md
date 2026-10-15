# Gün 11 — Çoklu koli prototipi sonucu

## Deneme

Godot 4.7.2 ile mevcut parkura oyuncu hareket etmeden 1, 2 ve 3 koli yerleştirildi. Koliler üst üste hizalanıp her biri ayrı taşıma noktası ve fizik mafsalıyla bağlandı. Her düzen 240 fizik karesi boyunca çalıştırıldı; koli-koli çarpışma sinyalleri de izlendi.

## Sonuç

- Tek koli, 240 kare boyunca bağlı kaldı ve yerinde sabit durdu.
- İki ve üç koli düzeninde ek koliler kısa süre içinde taşıma mafsalından ayrıldı; oyun başarısızlık durumuna geçti. Bu sırada oyuncu hareket etmiyordu.
- Deneme sırasında koli-koli çarpışma sinyali alınmadı. Düzen, çarpışma davranışını güvenilir şekilde değerlendirmeye fırsat vermeden kararsızlaştı.

## Karar

Çoklu taşıma prototipi kabul kriterini karşılamadı. Geçici çoklu-koli kodu kaldırıldı ve oyunun tek koli sistemi korundu. Çoklu koli, ayrı bir taşıma düzeneği tasarlanmadan ana parkura eklenmemeli.

Headless çalıştırma sırasında Windows sertifika deposu ve Godot kullanıcı log klasörü erişim uyarıları çıktı; Godot 4.7.2 yine de test sahnesini çalıştırdı. Bunlar çoklu koli sonucundan bağımsız ortam uyarılarıdır.
