local limitTimeDiscountShopAPI = include("limitTimeDiscountShopAPI")
local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Btn_discount = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://bagView/Btn_discount", Btn_discount)
function Btn_discount:onInit()
	self.fields.Text_discount:setString(i18n("common_text_3172"))
	self.fields.timer:setTimeUpdateListener(function(time)
		local status = limitTimeDiscountShopAPI:getActivityInfo()
		if status and not allianceDesRead.getPlayerConquestWarMigration(false) and not allianceDesRead.getPlayerBattleGroundMigration(false) then
			self:setVisible(true)
		else
			self:setVisible(false)
		end
	end)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_discount:onShow()
end
function Btn_discount:setTime(time)
	self.fields.timer:beginTime(time)
end
function Btn_discount:onBtnClick()
	SoraDPlaySound()
	if not allianceDesRead.getPlayerConquestWarMigration() and not allianceDesRead.getPlayerBattleGroundMigration() then
		uiManager:show("discountShopView")
	end
end
return Btn_discount
