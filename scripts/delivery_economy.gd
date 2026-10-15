class_name DeliveryEconomy
extends Resource

@export_group("Teslimat ödülü")
@export_range(0, 500, 5) var temel_teslimat_odulu := 100
@export_range(0, 200, 5) var en_yuksek_hiz_bonusu := 50
@export_range(0, 200, 5) var hasarsiz_teslimat_bonusu := 25
@export_range(0, 200, 5) var koli_dusme_cezasi := 25
@export_range(5.0, 120.0, 1.0) var hiz_bonusu_suresi := 30.0

func calculate_delivery_reward(leg_seconds: float, dropped_count: int) -> Dictionary:
	var speed_ratio := clampf(1.0 - leg_seconds / hiz_bonusu_suresi, 0.0, 1.0)
	var speed_bonus := roundi(float(en_yuksek_hiz_bonusu) * speed_ratio)
	var careful_bonus := hasarsiz_teslimat_bonusu if dropped_count == 0 else 0
	var penalty := dropped_count * koli_dusme_cezasi
	var total := maxi(0, temel_teslimat_odulu + speed_bonus + careful_bonus - penalty)
	return {
		"base": temel_teslimat_odulu,
		"speed": speed_bonus,
		"careful": careful_bonus,
		"penalty": penalty,
		"total": total,
	}
