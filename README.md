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

Mobil dokunmatik kontroller henüz eklenmedi. Hareket eylemleri Input Map üzerinden tanımlı olduğundan ileride ekrandaki joystick veya düğmeler aynı eylemleri tetikleyebilir.
