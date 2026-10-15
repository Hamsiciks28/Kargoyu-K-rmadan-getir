# Kurye karakteri — entegrasyon ve test notları

## Uygulanan model

`scenes/player.tscn` içindeki oyuncunun görünür kapsül görünümü, Godot'un temel geometrileriyle hazırlanmış stilize bir kuryeyle değiştirildi. Kısa gövde, büyük kafa, kahverengi saç ve basit yüz; sarı (#F4B942) ceket/şapka, krem şapka önü, mavi (#3478C8) pantolon ve koyu tabanlı açık renk ayakkabılar kullanıldı. Sırt çantası, omuz kayışları ve paket işaretleri eklendi. Materyaller tekrar kullanılıyor; harici model, eklenti veya shader gerekmiyor.

Görsel düğümler `VisualRoot` altındadır. Hareket kodu görsel parçalardan ayrı kalır. Karakter yön tuşlarıyla hareket yönüne yumuşakça döner; bacaklar basit bir adım salınımı yapar. Çarpışma kapsülü 0.35 yarıçap ve 2.0 yüksekliktedir. Önceki koli taşıma mafsalı korunmuştur.

`CarryPoint`, taşıma konumunu belirleyen `Marker3D` olarak eklendi. Fizik taşıma noktası ve mafsal konumları bu marker'dan alınır. Godot Inspector'da `Player/CarryPoint` seçilerek konumu ayarlanabilir. Görsel modelin tamamı ileride `VisualRoot` altında bir Blender modeliyle değiştirilebilir.

## Dosyalar

- `scenes/player.tscn` — kurye modeli, materyaller, çarpışma kapsülü ve taşıma marker'ı.
- `scripts/player_controller.gd` — taşıma marker entegrasyonu, yumuşak yön dönüşü ve basit yürüyüş hareketi.
- `scenes/player_test.tscn` — karakter, koli, zemin, kamera, ışık ve ölçek referansı bulunan bağımsız deneme sahnesi.
- `README.md` — karakterin çalıştırılması ve ayarlanması.

## Otomatik testler

Godot 4.7.2 başsız testlerinde:

- Proje editör taraması ve sahne/script yüklemesi tamamlandı.
- Karakter modeli, kafa/şapka/çanta düğümleri ve çarpışma şekli yüklendi.
- `CarryPoint` Marker3D ile fizik taşıma noktasının konumları eşleşti.
- Sağa hareket ederken karakterin yön değiştirdiği ve bacak animasyonunun çalıştığı doğrulandı.
- Yön değişirken koli taşıma bağlantısının korunduğu doğrulandı.
- Koli bırakılınca kolların görünürlüğünün kapandığı doğrulandı.
- Önceki haftalık test tekrar geçti: timer, bitiş, başarısızlık ve yeniden başlatma akışları bozulmadı.
- `git diff --check` temiz tamamlandı.

## Elle kontrol

Godot'ta `scenes/player_test.tscn` dosyasını açıp **F6**'ya basın. Karakterin yüzünü, kıyafet renklerini, çantayı ve kolinin kadrajdaki yerini kontrol edin; WASD ile dönme/yürüyüşü, Q ile koli bırakmayı deneyin. Çarpışma kapsülü normal oyun penceresinde ayrıca gözle kontrol edilmelidir.

Başsız testler görsel kaliteyi veya kadrajı ölçmez. Godot ortamı Windows sertifika deposuna ve kullanıcı log klasörüne erişim uyarısı verdi; proje taraması ve oyun testleri başarılı çıkış koduyla bitti.

## Bilinen sınırlar

Bu, hızlı değiştirilebilir Low Poly prototip modelidir; rig'lenmiş Blender karakteri değildir. Yüz şu an sabit gülümser. Koşma, denge kurma, düşme pozları ve yüz ifadeleri için ayrı animasyonlar eklenmedi.
