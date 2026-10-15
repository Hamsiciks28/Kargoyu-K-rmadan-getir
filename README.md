# Kargoyu Kırmadan Getir — Godot 4.x prototip

İlk oynanabilir prototip. Gün 7 ilk hafta kontrolü için iki kişilik manuel test listesi `GUN7_MANUEL_TEST.md` dosyasındadır. Etkileşimli kontroller tamamlanana kadar Gün 7 kabulü beklemededir.

Godot 4.x için temel 3D prototip. Compatibility renderer kullanır.

## Çalıştırma ve kontroller

Godot editöründe bu klasördeki `project.godot` dosyasını açıp **F5**'e basın.

- **W / A / S / D**: ileri / sol / geri / sağ hareket
- **Shift + W / A / S / D**: düz giderken hızlanma; Shift'i basılı tutmak tek başına koliyi düşürmez
- **Q**: koliyi bırak
- **R** veya ekrandaki düğme: koli düşünce parkuru yeniden başlat

Oyuncu hızı, ani hızlanma hızı, taşıma noktası ve kolinin düşme hassasiyeti `scenes/player.tscn` içindeki `Player` düğümünün Inspector alanlarından değiştirilebilir. Kamera oyuncuyu yumuşak biçimde takip eder. Parkur başlangıç çizgisi, düz yol, yana alınmış kasa engeli, rampalar, dar geçit ve bitiş alanından oluşur. Oyuncu önündeki koli fizik bağlantısıyla taşır; Q ile bırakabilir. Shift ile düz giderken hızlanmak koliyi düşürmez; çok keskin ve ani yön değişimi düşürebilir. Koli yeterince sert bir çarpışma yaşarsa düşer; hafif sürtünme veya yavaş temas tek başına düşürmez. Taşıma bağı koparsa veya koli parkur sınırlarını aşarsa da başarısızlık ekranı açılır ve yeniden deneme düğmesi gösterilir. Koli ağırlığı ve yüzey sürtünmesi ayarlandı, sekme kapatıldı; kayma ve fırlama riski azaltıldı. R tuşuyla veya ekrandaki düğmeyle baştan denenebilir. Bitiş alanına koliyi taşırken ulaşıldığında tamamlanma mesajı çıkar ve aynı yöntemle tekrar oynanabilir.

Oyuncunun görünür modeli `scenes/player.tscn` içinde düşük poligonlu kurye parçalarından oluşur: sarı üniforma ve şapka, mavi pantolon, sırt çantası, paket logoları, yüz ve kutuyu kavrayan eller. Modelin hareket çarpışması eski kapsül şeklini korur; görünüş değişikliği taşıma fiziğini değiştirmez.

Modeli tek başına görmek veya hareketini denemek için Godot'ta `scenes/player_test.tscn` dosyasını açıp **F6**'ya basın. Koli konumunu ayarlamak için sahne ağacında `Player/CarryPoint` Marker3D düğümünü seçip Inspector'daki **Position** değerlerini değiştirin. Görsel parçalar `VisualRoot` altında tutulur; ileride Blender modeli bu düğümün altına eklenerek fizik ve hareket kodundan ayrı değiştirilebilir.

Koli türünü değiştirmek için `scenes/main.tscn` içindeki `Cargo` düğümünü seçip Inspector'daki **Koli türü** alanından **Hafif**, **Normal** veya **Ağır** seçin. Değerler ve renkler aynı düğümün **Kütle** ve **Görünüm** gruplarından ayarlanabilir. Her denemede aynı anda tek koli taşınır; çoklu koli denemesi kararlı olmadığı için ana oyuna alınmadı. Koli türleri ve test sonucu `GUN12_KOLI_TURLERI_TEST.md` dosyasında açıklanmıştır.

Koli düştüğünde sonuç ekranı nedeni ve kısa bir öneriyi gösterir. Ani dönüş, sert çarpışma, taşıma bağlantısının kopması, koliyi elle bırakma ve parkurdan düşme için ayrı mesajlar vardır. Mesajlar aynı hareket için tutarlı kalır; düşme tepkisine rastgele fizik eklenmemiştir.

Parkur başında yeşil **BAŞLANGIÇ**, sonunda kırmızı **TESLİMAT** işareti görünür. Bitiş alanına oyuncu koliyi taşımaya devam ederken girerse başarılı teslimat ekranı açılır; koli düşmüşse bitiş başarı vermez.

Parkur zorluğu kademeli artar: kolay bölüm rampayı, orta bölüm sabit kasanın yanından geçmeyi, zor bölüm ise koliyle dar geçitten ilerlemeyi içerir. Renkli bölüm etiketleri her kısmı önceden belirtir.

Ekranın sol üstünde skor ve geçen süre görünür. Sayaç yeşil başlangıç alanından çıkınca başlar. Sağlam teslimatta skor **1000** olur; koli düşen başarısız denemede skor **0** kalır. Sonuç ekranı geçen süreyi saniyenin onda biri hassasiyetinde gösterir. Süre skoru değiştirmez.

Mobil dokunmatik kontroller henüz eklenmedi. Hareket eylemleri Input Map üzerinden tanımlı olduğundan ileride ekrandaki joystick veya düğmeler aynı eylemleri tetikleyebilir.

## Koli modelleri

Üç fizik tabanlı koli sahnesi `scenes/boxes/` altındadır: `standard_box.tscn` (0.6 m küp, 1.5 kütle), `large_box.tscn` (0.82 m küp, 3.0 kütle) ve `fragile_box.tscn` (standart ölçü, yalnızca görsel kırılabilir etiketi). Ana oyun ve karakter test sahnesi standart koli sahnesini kullanır. Karton, bant ve etiket materyalleri `materials/` klasöründedir. Üç modeli yan yana görmek ve fiziklerini denemek için `scenes/boxes/box_test.tscn` dosyasını açıp **F6**'ya basın. Hassas koli için hasar/kırılma davranışı eklenmedi.
