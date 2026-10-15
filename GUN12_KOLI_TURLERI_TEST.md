# Gün 12 — Koli türleri ve test sonucu

Koli sahnesindeki `Cargo Type` alanından **Hafif**, **Normal** veya **Ağır** seçilebilir. Her türün kütlesi ve rengi Inspector'da ayrı ayrı ayarlanabilir. Varsayılan değerler sırasıyla 0,75 kg, 1,5 kg ve 3 kg'dır; koli boyutu ve taşıma noktası aynı kalır.

## Godot 4.7.2 headless testi

- Üç varyantın da seçilen kütlesi ve rengi doğru uygulandı.
- Her koliye eşit 3 birim yatay darbe verildi. Bir sonraki fizik karesindeki yatay hızlar hafif için 3,727; normal için 1,863; ağır için 0,932 oldu. Böylece aynı itiş ağır koliyi daha az hızlandırdı.
- Üç varyant da parkur sahnesinde 120 fizik karesi boyunca bağlı kaldı; bu bekleme denemesinde başarısızlık durumu oluşmadı.

Gün 11'de kararsız bulunan çoklu taşıma düzeni eklenmedi; ana oyunda aynı anda tek koli taşınır.

## Elle kontrol

Godot'ta `scenes/main.tscn` sahnesini açın, `Cargo` düğümünü seçin ve Inspector'daki **Koli türü** alanını değiştirip F6 ile sahneyi çalıştırın. Renk ve hareket tepkisini karşılaştırın. Kütle ve renk varsayılanları Inspector'daki **Kütle** ve **Görünüm** gruplarından değiştirilebilir.
