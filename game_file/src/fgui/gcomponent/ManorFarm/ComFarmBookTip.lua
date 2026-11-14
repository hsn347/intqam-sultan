local manorFarmRead = include("manorFarmRead")
local baseComponent = require("fgui.base.baseComponent")
local ComFarmBookTip = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorFarm/ComFarmBookTip", ComFarmBookTip)
function ComFarmBookTip:onInit()
	self.fields.click:setTouchable(false)
	self:setVisible(false)
end
function ComFarmBookTip:onShow()
end
function ComFarmBookTip:initData(seedID, seedName)
	if not seedID then
		self:setVisible(false)
		return
	end
	local seed = manorFarmRead.getSeedInfo(seedID)
	seedName = seedName or seed and seed.name and i18n(seed.name) or tostring(seedID)
	local item = self.fields.item
	if item and item.initData then
		item:initData(seedID)
	end
	if item and item.forbidLongPress then
		item:forbidLongPress()
	end
	if self.fields.txtDesc then
		manorFarmRead = nil
		;(nil).name = seedName
		self.fields.txtDesc:setString(i18n("farmland_text_92", nil))
	end
	self:setVisible(true)
end
return ComFarmBookTip
