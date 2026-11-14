local militaryRankRead = include("militaryRankRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_name = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_name", Com_name)
function Com_name:onInit()
	self.fields.Btn_touch:addClickListener(handler(self, self.btnChangeNameClick))
	self.fields.Btn_military:addClickListener(handler(self, self.btnMilitaryClick))
	self:fixChildrenPos()
end
function Com_name:onShow()
end
function Com_name:initData(data, isSelf)
	self.data = data
	self.isSelf = isSelf
	self.controllers.c1:setSelectedIndex(self.isSelf and 0 or 1)
	self.fields.title:setString(textParser.formatPlayerName(self.data.abbr, self.data.base.nickName))
	self.fields.Btn_military:setIcon(militaryRankRead.getRankIconByLv(self.data.militaryRankInfo.level))
end
function Com_name:btnMilitaryClick()
	if self.isSelf then
		SoraDPlaySound()
		uiManager:show("militaryRankView")
	end
end
function Com_name:btnChangeNameClick()
	if self.isSelf then
		SoraDPlaySound()
		uiManager:show("lordRename")
	end
end
return Com_name
