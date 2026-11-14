local activity_9001661_Ctrl = SoraDGetCtrl("activity_9001661_Ctrl")
local activity_9001661_Read = include("activity_9001661_Read")
local lordLocalData = include("lordLocalData")
local baseComponent = require("fgui.base.baseComponent")
local Com_farmItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001661/Com_farmItem", Com_farmItem)
function Com_farmItem:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Com_farmItem:onShow()
end
function Com_farmItem:initData(data, parent)
	self.data = data
	self.parent = parent
	local curLv = activity_9001661_Ctrl:getGrowthLv(self.data)
	self.fields.Text_lv:setString(curLv)
	self.fields.icon:setSpriteFrame(activity_9001661_Read.getFarmSmallIcon(curLv))
	self.fields.lord:setSpriteFrame(lordLocalData.getBust(self.data.iconID))
	if self.data.uid ~= SoraDGetPlayerID() or not i18n("bubble_farm_text16") then
		activity_9001661_Ctrl = lordLocalData.getBust(self.data.iconID)
		lordLocalData.getBust(self.data.iconID).name = self.data.nickName
	end
	self.fields.Text_name:setString((i18n("bubble_farm_text11", lordLocalData.getBust(self.data.iconID))))
end
function Com_farmItem:btnClick()
	_ENV = nil
	;(nil).msg = "MESSAGE_ACTIVITY_9001661_UI_MAP_JUMP"
	;(nil).uid = self.data.uid
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).member = self.data
	;(nil).from = "map"
	uiManager:show("Activity_9001661_Main", nil)
	self.parent:close()
end
return Com_farmItem
