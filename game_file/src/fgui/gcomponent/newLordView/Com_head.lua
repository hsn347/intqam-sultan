local lordLocalData = include("lordLocalData")
local exclusiveVipRead = include("exclusiveVipRead")
local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local lordHeadCtrl = SoraDGetCtrl("lordHeadCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_head = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://newLordView/Com_head", Com_head)
function Com_head:onInit()
	self.fields.lock:setVisible(false)
	self.fields.shadow:setVisible(false)
	self:addClickListener(handler(self, self.btnClick))
end
function Com_head:onShow()
end
function Com_head:initData(headID, index, sIndex, curIndex)
	self.headID = tonumber(headID)
	self.index = index
	self.sIndex = sIndex
	self.fields.Load_head:setSpriteFrame(lordLocalData.getHead(self.headID))
	local headData = lordLocalData.getImageData(self.headID)
	self.fields.lock:setVisible(false)
	self.fields.shadow:setVisible(false)
	if headData.privilege == 1 then
		local curScore = exaltedPrivilegeCtrl:getTotalScores()
		local privilegeID = self.headID ~= 1409 and 100038 or 100039
		if self.headID == 1505 then
			privilegeID = 100045
		end
		local privilegeInfo = exclusiveVipRead:getPrivilegeInfo(privilegeID)
		self.fields.lock:setVisible(curScore < privilegeInfo.grade)
		self.fields.shadow:setVisible(curScore < privilegeInfo.grade)
	elseif headData.privilege == 2 then
		local isUnlock = lordHeadCtrl:getHeadIsUnlock(tostring(self.headID))
		self.fields.lock:setVisible(not isUnlock)
		self.fields.shadow:setVisible(not isUnlock)
	end
	self.controllers.c1:setSelectedIndex(self.index == curIndex and 1 or 0)
end
function Com_head:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_LORD_HEAD_SELECT"
	;(nil).headID = self.headID
	;(nil).index = self.sIndex
	SoraDSendMessage(nil)
end
return Com_head
