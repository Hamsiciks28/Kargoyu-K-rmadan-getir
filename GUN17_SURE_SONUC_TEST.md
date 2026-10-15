# Gün 17 — Süre ve sonuç ekranı

## Yapılanlar

- Oyun başladığında geçen süre sol üstte ondalık saniyeyle gösterilir.
- Başarı ve başarısızlık ekranı sonucu ve o ana kadarki süreyi gösterir.
- Oyun bitince zamanlayıcı donar; yeniden başlatma yeni turu sıfırdan başlatır.
- Önceki günün skor göstergesi ve yeniden deneme düğmesi korunmuştur.

## Godot 4.7.2 testleri

Başsız uçtan uca testte:

- Oyun süresi başlangıçta görünür oldu ve tur oynanırken ilerledi.
- Koli bırakılınca başarısızlık mesajına geçen süre eklendi; sonuç ekranından sonra sayaç artmadı.
- Yeniden başlatma yeni turu sıfır süreyle açtı.
- Koliyi bitişe taşıyınca başarı mesajında geçen süre gösterildi; sayaç dondu ve ekrandaki süre sonuç mesajıyla eşleşti.
- Godot başsız test sürecinde tam parkur yaklaşık 7 saniyede tamamlandı. Bu değer test makinesinin kare zamanlamasına bağlıdır; hedef süre veya süre puanı değildir.

## Elle kontrol

F5 ile oyunu açıp sol üstte sürenin aktığını görün. Q ile koli düşürüp başarısızlık ekranındaki süreyi kontrol edin. Yeniden deneyip bitişe ulaşın; başarı ekranındaki süreyle üstteki sayacın durduğunu doğrulayın.

## Ortam notu

Başsız Godot çalışması `user://logs` ve Windows sertifika deposu erişim uyarıları verdi; oyun testleri başarıyla tamamlandı. GitHub'a aktarım yapılmadı.
