# Gün 21 — Üçüncü hafta kontrolü

## Kapsam

Gün 16–20'deki skor, süre, parkur engelleri, sonuç ekranları ve yeniden başlatma; ayrıca sayaç başlangıcının yeşil başlangıç alanından çıkışa bağlanması kontrol edildi. Gün 22'ye geçilmedi.

## Yapılan değişiklik

Süre, oyuncu başlangıç alanını terk ettiğinde başlıyor. Oyuncu başlangıç alanında beklerken sayaç `0.0 sn` kalıyor. Bu davranış `StartZone` alanının `body_exited` olayıyla yönetiliyor. Yeniden başlatılan her tur yeni sahneyle, sıfır skorla ve sıfır süreyle başlıyor.

## Godot 4.7.2 başsız uçtan uca testi

- Yeşil alanda 120 fizik karesi beklendi: sayaç başlamadı ve sıfır kaldı.
- W ile başlangıç alanından çıkıldı: sayaç başladı ve ilerledi.
- Koli bitişe taşındı: başarı ekranı, 1000 skor ve süre göründü; sonuçta sayaç durdu.
- Başarı ekranında R ile yeniden başlatıldı: eski oyuncu/koli/sahne temizlendi; yeni tur başlangıçta sıfır skor ve sayaçla açıldı.
- İkinci turda başlangıç alanında bekleme sayacı başlatmadı; alan çıkışında başlattı.
- Koli bırakılarak başarısızlık oluşturuldu: 0 skor ve geçen süre gösterildi; sonuçta sayaç durdu.
- Başarısızlık düğmesiyle yeniden başlatma eski nesneleri temizledi ve yeni turu başlattı.
- Kolay, Orta ve Zor parkur işaretlerinin sahnede bulunduğu ve rota boyunca sıralandığı doğrulandı.

Otomatik akış sonucu: tüm kontroller geçti (çıkış kodu 0). `git diff --check` temiz tamamlandı. Godot editörün başsız proje taraması tamamlandı (çıkış kodu 0).

## Elle kontrol listesi

Normal Godot penceresinde projeyi açıp şu görsel/oynanış kontrollerini yapın:

1. Oyunu başlatın ve yeşil alanda birkaç saniye bekleyin; sayaç 0.0'da kalmalı.
2. Yeşil alandan çıkın; sayaç artmaya başlamalı.
3. Koliyi bitişe ulaştırıp başarı ekranı ve süreyi kontrol edin.
4. Başarı ekranında R ile yeniden başlayıp sayaç ve skorun sıfırlandığını görün.
5. Koli düşünce başarısızlık ekranını, süreyi ve ekrandaki yeniden deneme düğmesini kontrol edin.
6. Kolay / Orta / Zor etiketlerinin konumunu ve okunabilirliğini kontrol edin.

## Ortam notu

Godot'un başsız çalışmaları Windows kök sertifika deposuna ve kullanıcı `user://logs` dizinine erişemediğini bildirdi. Editör taraması yine de tamamlandı; ayrıca Godot kullanıcı ayarlarını AppData'ya kaydedemedi (bu çalışma alanının izin kısıtlaması). Bunlar oyun içi kaynak hatası olarak görünmüyor. Testler başsız yapıldı; normal penceredeki görsel yerleşim ve Android cihaz kontrolü elle yapılmalı.

GitHub'a hiçbir işlem yapılmadı.
