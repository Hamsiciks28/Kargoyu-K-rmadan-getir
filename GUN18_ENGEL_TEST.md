# Gün 18 — Engel çeşitleri kontrolü

## Mevcut parkur

Parkurda istenen üç basit engel türü zaten yer alıyordu; fazladan engel eklemeden mevcut düzen korundu:

- **Rampa:** çıkış, üst platform ve iniş bölümü.
- **Sabit engel:** yana alınmış kasa.
- **Dar geçit:** iki sabit duvar.

Kahverengi rampalar, turuncu kasa ve gri duvarlar birbirinden görsel olarak ayrılıyor.

## Godot 4.7.2 testleri

- Fizik sorguları rampanın, kasanın ve dar geçidin çarpışma şekillerini doğruladı.
- Oyuncu ve koli için geçidin ortasındaki açıklık kontrol edildi; ikisi de duvarlara çarpmadan sığıyor.
- W ile tam parkur geçildi; karakter rampanın üzerinde yükseldi (en yüksek konum yaklaşık 1,04 m) ve bitiş alanına ulaştı.
- Godot başsız test çıktısı: ramp, kasa ve iki geçit duvarı çarpışma sorgusunda bulundu; parkur başarı ekranıyla tamamlandı.

## Sonuç

Her engelin etkin çarpışması var ve oyuncunun izleyebileceği bir rota açık. Çarpışma alanlarında Gün 18 için değişiklik gerekmedi.

## Elle kontrol

F5 ile açıp rampadan geçin, kasanın yanından dolaşın ve dar geçitte koliyle ortadan yürüyün. Duvara hafifçe sürtündüğünüzde koli düşme eşiği önceki ayarlarla aynı kalmalı.
