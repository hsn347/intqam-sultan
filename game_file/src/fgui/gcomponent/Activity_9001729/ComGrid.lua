local activity_9001729_Read = include("activity_9001729_Read")
local activity_9001729_Ctrl = SoraDGetCtrl("activity_9001729_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local ComGrid = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Activity_9001729/ComGrid", ComGrid)
function ComGrid:onInit()
	self:addClickListener(handler(self, self.onClickGrid))
	self.activityID = gActivityTimeActivityID.CRESCENT_TREASURE_ACTIVITY
end
function ComGrid:onShow()
end
function ComGrid:onClickGrid(context)
	local eventType = self.data.type
	SoraDPlaySound()
	if eventType == gCrescentTreasureBlockType.NORMAL then
		_ENV = nil
		;(nil).gridIndex = self.data.id
		uiManager:show("Activity_9001729_Reward", nil)
	elseif eventType == gCrescentTreasureBlockType.EVENT then
		SoraDShowMsgTip(i18n("Ramadan_treasure_hunt_text_04"))
	elseif eventType == gCrescentTreasureBlockType.START then
		SoraDShowMsgTip(i18n("Ramadan_treasure_hunt_text_03"))
	end
end
function ComGrid:initData(data)
	self.data = data
	self:updateLv()
	self.controllers.ctrlEvent:setSelectedIndex(data.type - 1)
	self.fields.prefabEx:setEffectPath("fx_9001729_dizuo.prefab")
	self.fields.prefabEx:setVisible(false)
end
function ComGrid:updateLv()
	local gridLv = activity_9001729_Ctrl:getGridLv(self.data.id) or 0
	if self.data.type == gCrescentTreasureBlockType.NORMAL then
		self.controllers.ctrlLv:setSelectedIndex(gridLv)
		local curLv = activity_9001729_Ctrl:getGridLv(self.data.id) or 0
		local curLvData = activity_9001729_Read.getLvData(self.data.id, curLv, self.activityID)
		local nextLvData = activity_9001729_Read.getLvData(self.data.id, curLv + 1, self.activityID)
		if nextLvData then
			self.fields.txtExp:setVisible(true)
			activity_9001729_Ctrl = nil
			;(nil).num1 = activity_9001729_Ctrl:getGridExp(self.data.id) - curLvData.realExp
			;(nil).num2 = nextLvData.exp
			self.fields.txtExp:setString(i18n("%{num1}/%{num2}", nil))
		else
			self.fields.txtExp:setVisible(false)
		end
	else
		self.controllers.ctrlLv:setSelectedIndex(4)
	end
end
function ComGrid:ShowEffect(delay, callback)
	_UPVALUE3_ = nil
	;(nil)[1] = ffa.delay(delay or 0)
	;(nil)[2] = ffa.callFunc(function()
		self.fields.prefabEx:setVisible(true)
	end)
	;(nil)[3] = ffa.delay(1.0)
	;(nil)[4] = ffa.callFunc(function()
		self.fields.prefabEx:setVisible(false)
		if callback then
			callback()
		end
	end)
	;(nil)[5] = ffa.callFunc(function()
		self.fields.prefabEx:setVisible(false)
		if callback then
			callback()
		end
	end)
	self:runAction(ffa.seq(nil))
end
return ComGrid
