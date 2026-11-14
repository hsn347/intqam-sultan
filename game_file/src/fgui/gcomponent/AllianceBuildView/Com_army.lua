local baseComponent = require("fgui.base.baseComponent")
local Com_army = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceBuildView/Com_army", Com_army)
function Com_army:onInit()
	self.fields.Button_goHome:setString(i18n("common_text_017"))
	self.fields.Button_goHome:addClickListener(handler(self, self.btnBackClick))
end
function Com_army:onShow()
end
function Com_army:setBtnBackClick(callback)
	self.callback = callback
end
function Com_army:btnBackClick()
	if self.callback then
		self.callback()
	end
end
function Com_army:initMemberData(data)
	_UPVALUE0_ = nil
	;(nil).heroInfo = data.heroInfo
	;(nil).armsInfo = data.armsInfo
	;(nil).divineBeastInfo = data.divineBeastInfo
	;(nil).army = data.army
	self.fields.Com_armyDetail:initMemberData(nil)
end
function Com_army:setIsSelfArmy(isSelfArmy)
	if isSelfArmy then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
		self:setHeight(self.fields.Com_armyDetail:getHeight() + 6)
	end
end
function Com_army:setTitleText(str)
	self.fields.Button_goHome:setString(str)
end
return Com_army
