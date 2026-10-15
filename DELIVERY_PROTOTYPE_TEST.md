# İlk teslimat prototipi — kontrol sonucu

## Yapılanlar

- F5 başlangıç sahnesi `scenes/levels/first_neighborhood.tscn` oldu; mevcut tek kolili mahalle akışını sahne örneği olarak yeniden kullanır.
- Oyuncu E ile kamyondan koli alır; ilk hedefe giderken süre başlar.
- Üç adres sırayla etkinleşir. Her teslimat E ile yapılır; sonraki koli kamyonda belirir.
- Koli düşerse oyuncu yaklaşıp E ile geri alabilir. O teslimatın para ödülünden düşme başına 25 kesilir.
- Ekonomi formülü UI'dan ayrı `delivery_economy.gd` kaynağında; temel değerler Inspector'daki Economy kaynağında düzenlenebilir.
- İlk etapta geniş yola dağılmış üç koni; ikinci etapta iki kaydırılmış dar kapı ve alçak geçiş rampası; üçüncü etapta iki 5° rampa, iki zikzak kapısı ve alçak güvenlik rayları var. Teslimat evleri etaplara göre daha uzak aralıklarla yerleştirildi.
- Sonuç ekranı süreyi, başarılı teslimat sayısını ve toplam parayı gösterir.
- Eski `scenes/main.tscn` parkur denemesi ayrı tutuldu.

## Gerçekleştirilen testler

- Godot 4.7.2 headless editör taraması tamamlandı.
- `first_neighborhood.tscn` başsız yüklendi; oyuncu, kamyon, üç teslimat alanı, koniler ve çarpışmalı rampalar bulundu.
- Godot fizik simülasyonunda koli kamyondan alındı; koniler, Etap B'deki iki dar kapı ve iki yönlü alçak platform, rampalar ve rampadan sonraki zikzak kapıları koli taşınırken geçildi. Ayrı teslimat akışı testi üç adresin sırasını ve tur sonunu doğruladı.
- Otomatik akış testi E etkileşim kolundan kamyondaki koliyi almayı ve kamyon alanı çıkış işleyicisi çalışınca süreyi başlatmayı doğruladı. Başlangıç alanının gerçek klavye hareketiyle terk edilmesi F5'te elle kontrol edilmeli.
- Aynı test koliyi düşürüp yeniden almayı, cezanın ilk ödüle uygulanmasını, üç adresi sıralı teslim etmeyi ve tur sonu ekranı/para toplamını doğruladı.
- Önceki parkurun haftalık kontrolü yeniden çalıştırıldı; başlangıç, bitiş, yeniden başlatma ve eski parkur sahneleri geçti.
- `git diff --check` temiz.

## Elle kontrol edilecekler

Godot'ta projeyi açıp **F5** ile aktif mahalleyi çalıştırın. Görsel yerleşimi ve kameranın evlere giderken oyuncuyu takip etmesini kontrol edin. Başlangıçta E ile koli alın, kamyon alanından çıkınca sayacın başladığını görün, evlere sırayla gidip teslim edin ve üçüncü evden sonra sonuç ekranını kontrol edin. Başsız fizik simülasyonu koliyle parkur geçişlerini doğruladı; görsel okunabilirlik ve mobil dokunmatik kontroller elle kontrol edilmelidir.

Kapasite yükseltmeleri ve kilitli mahalle kartları bu aşamaya dahil edilmedi.
