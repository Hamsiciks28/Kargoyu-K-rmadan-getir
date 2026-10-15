# Gün 19 — Parkur zorluğu

## Yapılanlar

Parkura üç renkli, kameraya dönük bölüm etiketi eklendi:

- **Kolay:** rampaya yaklaşım ve rampayı aşma.
- **Orta:** yana alınmış sabit kasanın yanından geçme.
- **Zor:** koliyle dar geçitten ilerleme.

Bölümler başlangıçtan bitişe doğru artan sırada; orta ve zor etiketleri ilgili engellerden önce konumlandı. Yeni engel veya gereksiz parkur uzunluğu eklenmedi.

## Godot 4.7.2 testleri

- Etiket metinleri ve kolay → orta → zor konum sırası doğrulandı.
- Orta etiketin sabit kasadan, zor etiketin dar geçitten önce olduğu doğrulandı.
- Etiketlerden sonra W ile parkur baştan sona yeniden tamamlandı; başarı ekranında **1000** puan görüldü.
- Test parkuru yaklaşık 6,9 saniyede tamamladı. Bu yalnızca test koşusunun ölçümüdür; süre hedefi eklenmedi.

## Elle kontrol

F5 ile başlatıp üç etiketin oyuncunun görüş alanında olup olmadığını ve renk/metinlerinin anlaşılır görünüp görünmediğini kontrol edin. Etiketler fizik gövdesi değildir; hareket alanını daraltmaz.
