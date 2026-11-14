local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local starCubeCtrl = SoraDGetCtrl("starCubeCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_key = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarEnergyCube/Com_key", Com_key)
_UPVALUE3_, Com_key.onInit = function(self)
	self.fields.touch:addClickListener(handler(self, self.onBtnClick))
	self.fields.touch:addLongPressListener(handler(self, self.onPressItemnfo))
end, function(self)
	self.fields.touch:addClickListener(handler(self, self.onBtnClick))
	self.fields.touch:addLongPressListener(handler(self, self.onPressItemnfo))
end
;(function(self)
	self.fields.touch:addClickListener(handler(self, self.onBtnClick))
	self.fields.touch:addLongPressListener(handler(self, self.onPressItemnfo))
end)[1] = -120
;(function(self)
	self.fields.touch:addClickListener(handler(self, self.onBtnClick))
	self.fields.touch:addLongPressListener(handler(self, self.onPressItemnfo))
end)[2] = 10
local (function(self)
	self.fields.touch:addClickListener(handler(self, self.onBtnClick))
	self.fields.touch:addLongPressListener(handler(self, self.onPressItemnfo))
end)[3], keyRotation = 90, function(self)
	self.fields.touch:addClickListener(handler(self, self.onBtnClick))
	self.fields.touch:addLongPressListener(handler(self, self.onPressItemnfo))
end
function Com_key:initData(index, itemID, state, boxName)
	self:setTag(index)
	self.index = index
	self.itemID = itemID
	self.boxName = boxName
	self.fields.icon:setURL(publicRead.getIcon(itemID))
	self.fields.icon:setGrayed(false)
	self.fields.title:setString(backpackCtrl:getItemCount(itemID))
	self.fields.title:setColor(backpackCtrl:getItemCount(itemID) == 0 and cc.c3b(255, 0, 0) or cc.c3b(255, 255, 255))
	self.fields.pointTo:setRotation(keyRotation[index])
	if state == 3 then
		self.controllers.c1:setSelectedIndex(1)
	elseif state == 2 then
		self.controllers.c1:setSelectedIndex(index == 1 and 1 or 0)
		if backpackCtrl:getItemCount(itemID) > 0 then
			self.controllers.c1:setSelectedIndex(1)
		end
	else
		self.controllers.c1:setSelectedIndex(index == 1 and 0 or 2)
	end
	if backpackCtrl:getItemCount(self.itemID) == 0 then
		self.fields.icon:setGrayed(true)
	else
		self.fields.icon:setGrayed(false)
	end
	self.state = state
	self.controllers.state:setSelectedIndex(state - 1)
end
function Com_key:onPressItemnfo(button, startPos, endPos)
	if backpackCtrl:getItemCount(self.itemID) > 0 then
		backpackCtrl = backpackCtrl
		backpackCtrl.msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
		backpackCtrl.id = self.itemID
		backpackCtrl.num = 1
		backpackCtrl.pos = startPos
		backpackCtrl.customName = nil
		backpackCtrl.customTip = nil
		SoraDSendMessage(backpackCtrl)
	end
end
function Com_key:onBtnClick()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.itemID) == 0 then
		if self.state == 1 and self.index ~= 1 then
			_ENV = nil
			;(nil).name1 = i18n(self.boxName)
			;(nil).name2 = i18n(self.boxName)
			;(nil).num = self.index
			SoraDShowMsgTip(i18n("star_cube_11", nil))
		elseif self.state == 2 and self.index ~= 1 then
			self:onClickGet()
		elseif self.state == 1 and self.index == 1 then
			self:onClickGo()
		end
	end
end
function Com_key:onClickGo()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.itemID
	uiManager:show("StarEnergyGetWay", nil):setOwnerKey(self)
end
function Com_key:onClickGet()
	SoraDPlaySound()
	starCubeCtrl:reqStarCubeEnter(self.itemID)
end
function Com_key:onShow()
end
return Com_key
