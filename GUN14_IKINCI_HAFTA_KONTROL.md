# Gün 14 — İkinci hafta kontrolü

## Kontrol kapsamı

Karakter, takip kamerası, parkur, tek koli taşıma, başarısızlık ve yeniden başlatma akışı Godot 4.7.2 ile kontrol edildi. Bu kontrol Gün 11–13 yerel değişikliklerini de içeren mevcut proje haline uygulandı. Çoklu koli prototipi kararsız kaldığı için ana oyunda tek koli sistemi korunuyor.

## Otomatik kontroller

`Godot_v4.7.2-stable_win64_console.exe --headless` ile geçici bir uçtan uca test çalıştırıldı:

- W basılı tutularak başlangıçtan bitiş alanına gidildi; başarı ekranı `Parkur tamamlandı!` oldu.
- Parkur boyunca koli taşıma bağlantısı korundu.
- Kamera etkin kaldı, oyuncuyu izledi ve test sonunda beklenen takip mesafesine yerleşti.
- Başarı ekranındayken R tuşu yeni bir oyun sahnesi başlattı.
- Yeni oyunda Q ile koli bırakma başarısızlık ekranını açtı; ekrandaki yeniden deneme düğmesi yeni sahne başlattı.
- Godot editörün başsız proje taraması tamamlandı ve `git diff --check` temiz sonuçlandı.

## Sonuç

İkinci hafta kabul ölçütündeki ana akış — koliyi taşıyarak parkuru geçme, sonucu anlama ve yeniden oynama — otomatik uçtan uca kontrolde geçti. Oyun kodunda Gün 14 için ek değişiklik gerekmedi; test akışını anlatan bu rapor eklendi. GitHub'a aktarım yapılmadı.

## Ortam notu

Godot proje taraması ve oyun testi kod hatası vermeden tamamlandı. Ancak bu çalışma ortamı `AppData/Roaming/Godot/editor_settings-4.7.tres` dosyasına yazmayı engelledi; ayrıca Windows sertifika deposu ve `user://logs` için erişim uyarıları çıktı. Bunlar oyun projesi içindeki bir dosya hatası olarak görünmüyor, fakat Godot'u kendi bilgisayarınızda açıp bir kez elle çalıştırarak editörün normal açıldığını da kontrol edin.

## Elle kontrol listesi

`GUN7_MANUEL_TEST.md` listesini iki kişi ayrı ayrı uygulayabilir. Özellikle şu adımların editörde ve normal oyun penceresinde doğrulanması önerilir:

1. `project.godot` dosyasını açıp F5 ile çalıştırın.
2. WASD ile kameranın oyuncuyu izlediğini kontrol edin.
3. Koli taşırken parkuru bitiş çizgisine kadar geçin ve tamamlanma yazısını görün.
4. Tamamlanma ekranında R ile yeniden başlayın.
5. Q ile koliyi bırakın; düşme mesajını görün ve hem R hem ekrandaki düğmeyle yeniden deneyin.
6. Hafif ve ağır koli türlerini Inspector'dan seçip hareket farklarını gözlemleyin.
