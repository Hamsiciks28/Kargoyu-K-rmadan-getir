# Gün 20 — Oyun akışı ve yeniden başlatma

## Akış

Başlangıç sahnesi oynanışa geçer; koli düşmesi başarısızlık ekranına, taşınan kolinin bitişe ulaşması başarı ekranına geçer. Her iki sonuç ekranı R tuşu ve yeniden oynama düğmesiyle yeni tur açar. Sahne yeniden yüklendiği için skor, süre, oyuncu, koli ve taşıma mafsalı yeni örneklerden kurulur.

## Godot 4.7.2 çoklu tur testi

Başsız uçtan uca testte dört tur art arda oynandı:

1. Koli düşürüldü; başarısızlık ve 0 skor gösterildi; düğmeyle yeniden başlatıldı.
2. Parkur tamamlandı; başarı ve 1000 skor gösterildi; R ile yeniden başlatıldı.
3. Koli tekrar düşürüldü; R ile yeniden başlatıldı.
4. Parkur tekrar tamamlandı; başarı ekranındaki düğmeyle yeni tur açıldı.

Her yeni turda skor 0'a döndü, süre sıfırdan başladı, koli taşıma bağlantısı kuruldu ve sonuç ekranı kapandı. Önceki turun sahne/oyuncu/koli nesnelerinin geçersiz hale geldiği ve sahne ağacında yalnızca birer oyuncu ve koli kaldığı doğrulandı. Dört tur da hata vermeden tamamlandı.

## Sonuç

Başlangıç, oynanış, başarı, başarısızlık ve tekrar deneme akışı kabul ölçütünü karşıladı. Gün 16–20 özellikleriyle Godot başsız proje taraması ve `git diff --check` de çalıştırıldı.

## Elle kontrol

Normal Godot penceresinde birkaç tur oynayıp sonuç ekranı, sayaç, skor ve koli görünümünün yenilendiğini kontrol edin. Bu test Godot penceresinin görsel yerleşimini değil oyun mantığını otomatik olarak doğrular.

## Ortam notu

Başsız Godot çalışmaları `user://logs`, Windows sertifika deposu ve editör ayarlarını kaydetme erişimi hakkında ortam uyarıları verdi; oyun akışı testleri başarıyla tamamlandı. GitHub'a aktarım yapılmadı.
