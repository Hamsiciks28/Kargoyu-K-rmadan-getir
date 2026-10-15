# Gün 16 — Skor sistemi

## Puan kuralı

- Oyun başlarken skor **0**.
- Koliyi düşürmeden bitişe ulaştırınca teslimat için **1000 puan** verilir.
- Koli düşmesi denemeyi bitirdiğinden, başarısız teslimata puan verilmez; skor **0** kalır.
- Bu sürümde süre skoru değiştirmez. Süreyi ölçüp sonuca eklemek Gün 17 kapsamındadır.

Bu kural bilinçli olarak basit tutuldu: oyuncu teslimat tamamlanana kadar puan kazanmaz; deneme sonunda temiz teslimatın değerini görür. Koli düşmesi mevcut oyun akışında zaten doğrudan başarısızlık olduğu için ek düşme sayacı veya puan cezası eklenmedi.

## Godot 4.7.2 testleri

Başsız uçtan uca testte:

- Oyun başında sol üstte **Skor: 0** görünür durumdaydı.
- Q ile koliyi bırakınca başarısızlık ekranı açıldı ve skor **0** kaldı.
- Ekrandaki yeniden deneme düğmesi oyunu yeniden başlattı; skor tekrar **0** ve koli bağlı durumdaydı.
- Koliyi taşıyarak bitişe ulaşınca başarı ekranı çıktı ve gösterge **Skor: 1000** oldu.

`git diff --check` ve Godot başsız proje taraması da çalıştırıldı.

## Elle kontrol

Oyunu F5 ile açın. Sol üstteki skorun okunabildiğini, Q ile bırakınca sıfır kaldığını ve sağlam teslimat sonunda 1000'e çıktığını kontrol edin.
