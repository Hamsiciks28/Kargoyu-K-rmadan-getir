# Gün 15 — Başlangıç ve bitiş sistemi

## Yapılanlar

- Parkurun yeşil başlangıç şeridine kameraya dönük **BAŞLANGIÇ** etiketi eklendi.
- Kırmızı bitiş şeridine **TESLİMAT** etiketi eklendi.
- Teslimat alanı oyuncu gövdesini algıladığında başarı ekranı açılıyor; koli hâlâ sahnede ve oyuncuya bağlı olmalı.
- Oyuncu kolisiz bitiş alanına girerse teslimat başarıya dönüşmüyor. Koli düşmesi zaten başarısızlık ekranını gösterdiği için oyun durumları çakışmıyor.

## Godot 4.7.2 kontrolleri

Başsız uçtan uca testler çalıştırıldı:

- Başlangıç ve bitiş etiketlerinin metinleri doğrulandı.
- Başlangıçtan W ile gidildi; oyuncu ve koli birlikte parkuru geçti, `Parkur tamamlandı!` ve `Koliyi sağlam ulaştırdın.` mesajları gösterildi.
- Oyuncu bitiş alanına koli taşımadan sokuldu; başarı ekranı açılmadı ve oyun devam etti.
- Godot editörün başsız proje taraması tamamlandı; `git diff --check` temiz sonuçlandı.

İlk açılışta görülebilen “Koli sahneden kayboldu” ekranına karşı koli taşıma bağlantısı kurulana kadar ilk fizik adımı bekletiliyor. Bağlantı beklerken sahte düşüş oluşmadığı, koli bağlantısının kurulduğu ve parkurun tamamlandığı ayrıca başsız regresyon testiyle doğrulandı.

## Elle kontrol

Normal Godot penceresinde F5 ile açıp başlangıç/bitiş yazılarının kameradan görünüşünü kontrol edin. Koliyle bitişe yürüyüp teslimat mesajını, sonra Q ile koliyi bırakıp bitişe yürüyerek başarı mesajının çıkmadığını doğrulayın. Başsız test yazıların ve mantığın yüklendiğini doğruluyor, ancak görsel yerleşimi pencere içinde elle incelemedim.

## Ortam notu

Godot testleri kod hatası olmadan geçti. Bu çalışma ortamında Windows sertifika deposu okunamadı ve Godot kullanıcı logu/yazı ayarlarına erişim uyarıları verdi (`AppData/Roaming/Godot/editor_settings-4.7.tres`). Bunlar proje klasöründeki kaynak dosyalarına işaret etmiyor.

GitHub'a yükleme yapılmadı.
