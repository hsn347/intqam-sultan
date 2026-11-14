local itemDesRead = include("itemDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://DesertSecretTreasure/Com_itemSingle", Com_itemSingle)
local LONG_EVENT_TIME = 0.1
function Com_itemSingle:onInit()
	self:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onToucBeginShow))
	self:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onToucEndShow))
	self.fields.Usm_get:setCompleteCallback(function()
		self.fields.Usm_get:setVisible(false)
		self.fields.Icon_get:setVisible(true)
		self.fields.mask:setVisible(true)
	end)
end
function Com_itemSingle:initData(data, getFlag)
	self.itemId = data.itemid
	self.fields.icon:setURL(itemDesRead.getIcon(data.itemid))
	self:setSpecialNum(data.itemid)
	self.fields.Icon_rare:setVisible(data.rare == 1)
	if data.rare == 1 then
		self.transitions.rare:play(-1, 0, 0, -1)
	end
	if getFlag then
		self.fields.Icon_get:setVisible(true)
		self.fields.mask:setVisible(true)
	end
end
function Com_itemSingle:setSpecialNum(itemid)
	local specialNum = itemDesRead.getNumByID(itemid)
	if specialNum then
		self.fields.Text_num:setVisible(true)
		self.fields.sheer:setVisible(true)
		self.fields.Text_num:setString(specialNum and specialNum or "")
	end
end
function Com_itemSingle:onToucBeginShow(context)
	self._touchStartPos = context:getInput():getPosition()
	self._input = context:getInput()
	self.target = self._input:getTarget()
	_ENV = self._input
	self._input.msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
	SoraDSendMessage(self._input)
	self:removeTouchTimer()
	local longTime = 0
	self.showTimer = SoradCreateTimer(self, function(dt)
		if longTime >= LONG_EVENT_TIME then
			if self._input and self.target == self._input:getTarget() then
				local pos = self._input:getPosition()
				local distance = cc.pGetDistance(self._touchStartPos, pos)
				if tonumber(distance) <= TOUCH_MOVED_ERROR_VALUE then
					SoraDPlaySound()
					longTime = TOUCH_MOVED_ERROR_VALUE
					TOUCH_MOVED_ERROR_VALUE.msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
					TOUCH_MOVED_ERROR_VALUE.id = self.itemId
					TOUCH_MOVED_ERROR_VALUE.num = nil
					TOUCH_MOVED_ERROR_VALUE.pos = self._touchStartPos
					TOUCH_MOVED_ERROR_VALUE.customName = nil
					TOUCH_MOVED_ERROR_VALUE.customTip = nil
					SoraDSendMessage(TOUCH_MOVED_ERROR_VALUE)
				end
			end
			self:removeTouchTimer()
			return
		end
	end, true)
end
function Com_itemSingle:removeTouchTimer()
	if self.showTimer then
		SoraDManagerRemoveTimer(self, self.showTimer)
		self.showTimer = nil
	end
end
function Com_itemSingle:onToucEndShow()
	self:removeTouchTimer()
end
function Com_itemSingle:showUsm()
	self.fields.Usm_get:setVisible(true)
end
function Com_itemSingle:onShow()
end
return Com_itemSingle
