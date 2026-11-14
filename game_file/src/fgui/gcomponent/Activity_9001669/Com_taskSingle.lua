local activityCommonKitchenCtrl = SoraDGetCtrl("activityCommonKitchenCtrl")
local itemDesRead = include("itemDesRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityCommonKitchenRead = include("activityCommonKitchenRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_taskSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001669/Com_taskSingle", Com_taskSingle)
function Com_taskSingle:onInit()
	self.controllers.c_state:setSelectedIndex(1)
	self.fields.Text_state:setString(i18n("herotrain_text_01"))
	self.fields.Label_time:setTimeEndListener(function(...)
		self:initData(self.taskID, self.data)
	end)
	self.fields.Button_refresh:setString(i18n("common_text_911"))
	self.fields.Button_refresh:addClickListener(handler(self, self.onClickBtnRefresh))
	self.fields.Button_click:addClickListener(handler(self, self.onClickBtnItem))
end
function Com_taskSingle:onShow()
end
function Com_taskSingle:onClickBtnRefresh(...)
	SoraDPlaySound()
	local itemCount = backpackCtrl:getItemCount(self.refreshItemID)
	if itemCount <= 0 then
		local itemName = itemDesRead.getName(self.refreshItemID)
		_ENV = nil
		;(nil).item = itemName
		SoraDShowMsgTip(i18n("explore_ore_text7", nil))
		_ENV = i18n("explore_ore_text7", nil)
		i18n("explore_ore_text7", nil).itemID = self.refreshItemID
		uiManager:show("CommonSourceGuide", i18n("explore_ore_text7", nil))
		return
	end
	activityCommonKitchenCtrl:reqRefreshTask(self.activityID, self.taskID)
end
function Com_taskSingle:onClickBtnItem(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	;(nil).taskID = self.taskID
	uiManager:show("Activity_9001669_Task", nil)
end
function Com_taskSingle:initData(taskID, data)
	self.taskID = taskID
	self.data = data
	local nextTime = data.nextTime
	if nextTime and nextTime > serviceFunctions.systemTime() then
		self.controllers.c_state:setSelectedIndex(1)
		local time = nextTime - serviceFunctions.systemTime()
		self.fields.Label_time:beginTime(time)
		self:updateItemCount()
	else
		self.controllers.c_state:setSelectedIndex(0)
	end
	local likeItemID = data.likeItemID
	local itemIcon = itemDesRead.getIcon(likeItemID)
	self.fields.Load_item:setURL(itemIcon)
	local starIcon = string.format("frame_9001669_%dxing.png", data.taskType)
	self.fields.Load_star:setURL(starIcon)
	self:updateSpine(data.roleID or 1)
end
function Com_taskSingle:updateSpine(roleID)
	local cfg = activityCommonKitchenRead:getSpineConfig(self.activityID, roleID)
	local effectPath = cfg.effectPath
	if effectPath then
		self.fields.Spine:setEffectPath(effectPath)
	end
	local offsetY = cfg.offsetY
	self.fields.Spine:setPositionY(260 + offsetY)
	self.fields.Load_icon:setVisible(false)
	self:setOpacity(0)
	_ENV = nil
	;(nil)[1] = ffa.delay(0.3)
	;(nil)[2] = ffa.fadeIn(0.3)
	;(nil)[3] = ffa.fadeIn(0.3)
	;(nil)[4] = ffa.fadeIn(0.3)
	;(nil)[5] = ffa.fadeIn(0.3)
	;(nil)[6] = ffa.fadeIn(0.3)
	;(nil)[7] = ffa.fadeIn(0.3)
	self:runAction(ffa.seq(nil))
	local spine = self.fields.Spine:getSpine()
	spine:setOpacity(0)
	spine:runAction(cca.fadeIn(0.3))
	local offset = cc.p(0, 0)
	local _index = (self.taskID - 1) % 3 + 1
	if _index == 1 then
		offset = cc.p(50, 0)
	elseif _index == 2 then
		offset = cc.p(0, -30)
	elseif _index == 3 then
		offset = cc.p(-50, 0)
	end
	local posX, posY = spine:getPosition()
	spine:setPosition(posX + offset.x, posY + offset.y)
	spine:runAction(cca.moveTo(0.3, posX, posY))
end
function Com_taskSingle:updateItemCount(...)
	local itemCount = backpackCtrl:getItemCount(self.refreshItemID)
	self.fields.Button_refresh:setCostNum("1/" .. itemCount)
end
function Com_taskSingle:initActivityID(activityID)
	self.activityID = activityID
	self.refreshItemID = activityCommonKitchenCtrl:getRefreshItemID(self.activityID)
	self.fields.Button_refresh:setCostIcon(self.refreshItemID)
end
return Com_taskSingle
