local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local hero_bubing = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/hero_bubing", hero_bubing)
fgui.register_extension("ui://NewHeroView/hero_qibing", hero_bubing)
fgui.register_extension("ui://NewHeroView/hero_gongbing", hero_bubing)
function hero_bubing:onInit()
end
function hero_bubing:onShow()
end
function hero_bubing:initData(palaceType)
	self.cfgHeroID = heroltCtrl:getHerosByPalaceType(palaceType)
	for k, v in ipairs(self:getChildren()) do
		local tb = SoraDStringsSplit(v:getName(), "_")
		local heroID = tonumber(tb[2])
		if SoraDisInList(heroID, self.cfgHeroID) then
			v:setGrayed(not heroCtrl:isHeroSuitCrown(heroID))
			v:setVisible(true)
		else
			v:setVisible(false)
		end
	end
end
function hero_bubing:getHeroNums()
	local ownCount = 0
	for k, v in ipairs(self:getChildren()) do
		local tb = SoraDStringsSplit(v:getName(), "_")
		local heroID = tonumber(tb[2])
		if heroCtrl:getHeroInfoByID(heroID) and heroCtrl:isHeroSuitCrown(heroID) and SoraDisInList(heroID, self.cfgHeroID) then
			ownCount = ownCount + 1
		end
	end
	return ownCount, #self.cfgHeroID
end
return hero_bubing
