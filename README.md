# Kargoyu Kırmadan Getir — Gün 1–6

Godot 4.x için temel 3D prototip. Compatibility renderer kullanır.

## Çalıştırma ve kontroller

Godot editöründe bu klasördeki `project.godot` dosyasını açıp **F5**'e basın.

- **W / A / S / D**: ileri / sol / geri / sağ hareket
- **Q**: koliyi bırak
- **R** veya ekrandaki düğme: koli düşünce parkuru yeniden başlat

Oyuncu hızı, yerçekimi ve kolinin ani harekete hassasiyeti `scenes/player.tscn` içindeki `Player` düğümünün Inspector alanlarından değiştirilebilir. Kamera oyuncuyu yumuşak biçimde takip eder. Parkur başlangıç çizgisi, düz yol, yana alınmış kasa engeli, rampalar, dar geçit ve bitiş alanından oluşur. Oyuncu önündeki koli fizik bağlantısıyla taşır; Q ile bırakabilir. Keskin yön değişimlerinde veya koli bir engele çarptığında koli düşer; ekranda uyarı çıkar ve R tuşu ya da düğmeyle baştan denenebilir. Bitiş alanına koliyi taşırken ulaşıldığında tamamlanma mesajı çıkar ve aynı yöntemle tekrar oynanabilir.

Mobil dokunmatik kontroller henüz eklenmedi. Hareket eylemleri Input Map üzerinden tanımlı olduğundan ileride ekrandaki joystick veya düğmeler aynı eylemleri tetikleyebilir.
