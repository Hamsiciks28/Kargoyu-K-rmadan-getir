# Koli modelleri — kontrol notları

## Oluşturulan sahneler

- `scenes/boxes/standard_box.tscn`: 0.6 × 0.6 × 0.6 m, karton gövde, üst ve ön bant, kargo etiketi, 1.5 kütle.
- `scenes/boxes/large_box.tscn`: 0.82 × 0.82 × 0.82 m; standart görsel dili, daha büyük çarpışma kutusu ve 3.0 kütle.
- `scenes/boxes/fragile_box.tscn`: standart ölçü ve kütle; kırmızı uyarı şeridiyle “KIRILIR! DIKKAT” etiketi. Hasar sistemi içermez.
- `scenes/boxes/box_test.tscn`: üç varyantı aynı sahnede gösteren, fizik ile düşürüp denemeye uygun sahne.

Materyaller `materials/box_cardboard.tres`, `materials/box_tape.tres`, `materials/box_label.tres` ve hassas koli için ek `materials/box_fragile_accent.tres` dosyalarında.

## Gerçekleştirilen kontroller

- Godot 4.7.2 headless editör taraması tamamlandı; yeni sahneler ve kaynaklar tarandı.
- Otomatik kontrol betiği üç sahneyi yükleyip çarpışma ölçülerini, kütleleri, ana görsel düğümünü ve koli etiketlerini doğruladı. Üçü de geçti.
- Test sahnesinin açılıp üç varyantı içerdiği doğrulandı.
- Ana oyun sahnesi Godot headless ile çalıştırıldı ve sahne yükleme hatası vermedi.

Bu ortam Godot kullanıcı günlüklerini ve editör ayarlarını AppData altına yazamıyor; CA sertifika deposu uyarısı da verdi. Bu uyarılar proje dosyalarının taranmasını veya sahne testlerini durdurmadı.

## Elle bakılacaklar

Godot'ta `scenes/boxes/box_test.tscn` dosyasını açıp **F6** ile çalıştırın. Üç koli bandının ve etiketlerin görünüşünü, büyük kolinin taşıma dengesine etkisini ve kutuların zeminde kararlı durmasını kontrol edin. Kırılabilir koli şu anda yalnızca görsel çeşit; hasar veya kırılma mekaniği yok.
