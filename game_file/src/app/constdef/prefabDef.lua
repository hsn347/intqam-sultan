local _ENV, _ENV, prefabDef
;(nil)["fx_9001700_min.prefab"] = "Effect/world/prefab/fireworks/fx_9001700_min.prefab"
;(nil)["fx_9001700_max.prefab"] = "Effect/world/prefab/fireworks/fx_9001700_max.prefab"
;(nil)["fx_ui_ysdx_l02_top.prefab"] = "Effect/ui/prefab/ysdx/fx_ui_ysdx_l02_top.prefab"
;(nil)["fx_ui_ysdx_l02_btm.prefab"] = "Effect/ui/prefab/ysdx/fx_ui_ysdx_l02_btm.prefab"
;(nil)["fx_ui_ysdx_l03_top.prefab"] = "Effect/ui/prefab/ysdx/fx_ui_ysdx_l03_top.prefab"
;(nil)["fx_ui_ysdx_l03_btm.prefab"] = "Effect/ui/prefab/ysdx/fx_ui_ysdx_l03_btm.prefab"
;(nil)["fx_ui_ysdx_l04_top.prefab"] = "Effect/ui/prefab/ysdx/fx_ui_ysdx_l04_top.prefab"
;(nil)["fx_ui_ysdx_l04_btm.prefab"] = "Effect/ui/prefab/ysdx/fx_ui_ysdx_l04_btm.prefab"
;(nil)["fx_14bubing_01.prefab"] = "Effect/ui/prefab/14jb/fx_14bubing_01.prefab"
;(nil)["fx_14qibing_01.prefab"] = "Effect/ui/prefab/14jb/fx_14qibing_01.prefab"
;(nil)["fx_14qibing_02.prefab"] = "Effect/ui/prefab/14jb/fx_14qibing_02.prefab"
;(nil)["fx_14chebing_01.prefab"] = "Effect/ui/prefab/14jb/fx_14chebing_01.prefab"
;(nil)["fx_14chebing_02.prefab"] = "Effect/ui/prefab/14jb/fx_14chebing_02.prefab"
;(nil)["fx_14chebing_03.prefab"] = "Effect/ui/prefab/14jb/fx_14chebing_03.prefab"
;(nil)["fx_14chebing_05.prefab"] = "Effect/ui/prefab/14jb/fx_14chebing_05.prefab"
;(nil)["fx_14chebing_06.prefab"] = "Effect/ui/prefab/14jb/fx_14chebing_06.prefab"
;(nil)["fx_14gongbing_01.prefab"] = "Effect/ui/prefab/14jb/fx_14gongbing_01.prefab"
;(nil)["fx_ui_ssly_boom_btm_01.prefab"] = "Effect/ui/prefab/ssly/fx_ui_ssly_boom_btm_01.prefab"
;(nil)["fx_ui_ssly_boom_top_01.prefab"] = "Effect/ui/prefab/ssly/fx_ui_ssly_boom_top_01.prefab"
;(nil)["fx_9001716_glow.prefab"] = "Effect/ui/prefab/ltt/fx_9001716_glow.prefab"
;(nil)["fx_znqhd_bgfx.prefab"] = "Effect/ui/prefab/znqhd/fx_znqhd_bgfx.prefab"
;(nil)["fx_9001718_paopao.prefab"] = "Effect/ui/prefab/ltt/fx_9001718_paopao.prefab"
;(nil)["fx_9001718_paopao_glod.prefab"] = "Effect/ui/prefab/ltt/fx_9001718_paopao_glod.prefab"
;(nil)["fx_farm_zzpy_bg.prefab"] = "Effect/ui/prefab/ltt/fx_farm_zzpy_bg.prefab"
;(nil)["fx_farm_zzpy_paopao.prefab"] = "Effect/ui/prefab/ltt/fx_farm_zzpy_paopao.prefab"
;(nil)["fx_farm_gspy_bg.prefab"] = "Effect/ui/prefab/ltt/fx_farm_gspy_bg.prefab"
;(nil)["fx_farm_gspy_dan.prefab"] = "Effect/ui/prefab/ltt/fx_farm_gspy_dan.prefab"
;(nil)["fx_farm_gspy_dan_01.prefab"] = "Effect/ui/prefab/ltt/fx_farm_gspy_dan_01.prefab"
;(nil)["fx_farm_gspy_liudong.prefab"] = "Effect/ui/prefab/ltt/fx_farm_gspy_liudong.prefab"
;(nil)["fx_9001729_dizuo.prefab"] = "Effect/ui/prefab/ltt/fx_9001729_dizuo.prefab"
;(nil)["fx_bust_big_006_1_top.prefab"] = "Effect/ui/prefab/bust/fx_bust_big_006_1_top.prefab"
;(nil)["fx_bust_big_006_2_top.prefab"] = "Effect/ui/prefab/bust/fx_bust_big_006_2_top.prefab"
;(nil)["fx_bust_big_005_top.prefab"] = "Effect/ui/prefab/bust/fx_bust_big_005_top.prefab"
;(nil)["fx_bust_big_007_1_top.prefab"] = "Effect/ui/prefab/bust/fx_bust_big_007_1_top.prefab"
local (nil)["fx_11znq_bgfx.prefab"], name2path = "Effect/ui/prefab/11znq/fx_11znq_bgfx.prefab", nil
function prefabDef.getPrefabPath(name)
	if name2path[name] then
		return name2path[name]
	end
	local tempName = name .. ".prefab"
	if name2path[tempName] then
		return name2path[tempName]
	end
	return name
end
return prefabDef
