# Gün 13 — Denge ve fizik geri bildirimi

Koli düştüğünde artık sonuç ekranı olayı açıklıyor ve kısa bir öneri veriyor. Ani yön değişimi, ani hızlanma, sert çarpışma, taşıma bağlantısının kopması, koliyi elle bırakma ve parkurdan düşme için ayrı metinler kullanılıyor. Bazı mesajlar hafif mizah içeriyor; her biri oyuncuya neyi değiştireceğini de söylüyor.

## Godot 4.7.2 headless testi

- Aynı ileri-geri ani yön değiştirme hareketi üç kez tekrarlandı. Her seferinde aynı düşme durumu ve aynı mesaj çıktı.
- Koliye engel yönünde 3 birim hızla yavaş temas verildi; koli taşınmaya devam etti.
- Aynı yönde 5 birim hızla sert çarpışma denemesi yapıldı; koli düştü ve ekranda engel çarpışmasını anlatan mesaj çıktı.
- Q ile koliyi bırakma, “Koliyi sen bıraktın” mesajını gösterdi.

Düşme eşikleri bu gün değiştirilmedi; önceki günlerde ayarlanmış değerler korunarak geri bildirim eklendi. Düşme anındaki itiş sabit kaldı, rastgele savrulma eklenmedi.

## Elle kontrol

Parkuru başlatıp önce engellere yavaşça dokunun, sonra daha sert çarpışmayı ve ani yön değiştirmeyi deneyin. Koli düşerse ekrandaki mesajın sebebi doğru açıklayıp açıklamadığını ve önerinin anlaşılır olup olmadığını kontrol edin.
