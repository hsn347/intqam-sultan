local baseComponent = require("fgui.base.baseComponent")
local Btn_kingdomManager = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_kingdomManager", Btn_kingdomManager)
function Btn_kingdomManager:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_kingdomManager:onShow()
end
function Btn_kingdomManager:initData(data)
	self.controllers.c1:setSelectedIndex(data.index)
	if data.time then
		self.Text_Time:beginTime(data.time)
	end
end
function Btn_kingdomManager:onBtnClick()
	SoraDPlaySound()
	if self.controllers.c1:getSelectedIndex() == 0 then
		worldMapDefine.kingdomStatusManager = true
		local panel = SoraDCreatePanel("worldMapKingdomCityOfficialManagerView")
		panel:initView()
		panel:show()
	elseif self.controllers.c1:getSelectedIndex() == 1 then
		SoraDCreatePanel("worldMapKingdomCityPlayerGiftBag"):show()
	end
end
return Btn_kingdomManager
