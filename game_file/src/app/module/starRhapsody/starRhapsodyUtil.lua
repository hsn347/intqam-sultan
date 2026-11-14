local _ENV, starRhapsodyUtil
local starRhapsodyDef = include("starRhapsodyDef")
if starRhapsodyDef.isStar then
	_ENV, _ENV = nil, starRhapsodyDef.isStar
	;(nil).bg = "star_lamp_01.png"
	_ENV, starRhapsodyDef.isStar[1], (nil).light = nil, nil, "starRhapsodyLamp1"
	;(nil).bg = "star_lamp_03.png"
	_ENV, starRhapsodyDef.isStar[2], (nil).light = nil, nil, "starRhapsodyLamp3"
	;(nil).bg = "star_lamp_02.png"
	_ENV, starRhapsodyDef.isStar[3], (nil).light = nil, nil, "starRhapsodyLamp2"
	starRhapsodyUtil.lampCfg, starRhapsodyDef.isStar[4], (nil).bg = starRhapsodyDef.isStar, nil, "star_lamp_04.png"
else
	_ENV, _ENV = nil, starRhapsodyDef.isStar
	;(nil).bg = "icon_gemactivity_purple.png"
	;(nil).light = "starRhapsodyLamp2"
	_ENV, starRhapsodyDef.isStar[1], (nil).icon = nil, nil, "icon_bskxq_03.png"
	;(nil).bg = "icon_gemactivity_blue.png"
	;(nil).light = "starRhapsodyLamp1"
	_ENV, starRhapsodyDef.isStar[2], (nil).icon = nil, nil, "icon_bskxq_02.png"
	;(nil).bg = "icon_gemactivity_yellow.png"
	;(nil).light = "starRhapsodyLamp3"
	_ENV, starRhapsodyDef.isStar[3], (nil).icon = nil, nil, "icon_bskxq_01.png"
	;(nil).bg = "icon_gemactivity_black.png"
	;(nil).light = "starRhapsodyLamp4"
	starRhapsodyUtil.lampCfg, starRhapsodyDef.isStar[4], (nil).icon = starRhapsodyDef.isStar, nil, "icon_bskxq_03.png"
end
function starRhapsodyUtil:getLampImgBg(index, icon)
	local cfg = self.lampCfg[index]
	if cfg then
		if icon and cfg.icon then
			return cfg.icon
		end
		return cfg.bg
	end
end
function starRhapsodyUtil:getLampImgLight(index)
	local cfg = self.lampCfg[index]
	if cfg then
		return cfg.light
	end
end
function starRhapsodyUtil:isStar()
	return starRhapsodyDef.isStar
end
function starRhapsodyUtil:getDefaultImg()
end
return starRhapsodyUtil
