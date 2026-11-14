local resDesRead = include("resDesRead")
local activity_9001558_Read = include("activity_9001558_Read")
local activity_9001558_Ctrl = SoraDGetCtrl("activity_9001558_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local box_bar = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001558/box_bar", box_bar)
function box_bar:onInit()
	local itemID = gIDDef.STELLAR_ODYSSEY_POINT
	local itemName = resDesRead.getName(itemID)
	_ENV = nil
	;(nil).name = itemName
	self.fields.Text_des:setString(i18n("Stellar_Odyssey_text_02", nil))
	self.fields.Com_item:initData(itemID)
	self.fields.Com_item:hideFrameAndQuality()
	local constantRead = include("constantRead")
	local times = constantRead.getConstValue("STELLAR_ODYSSEY_TASK_REWARD", 1)
	local totalNum = activity_9001558_Read.getTotalQuestNum() * times
	self.fields.bar:setMax(totalNum)
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.Text_time:setTimeLast(function(strTime)
		_ENV = nil
		_ENV, _ENV, (nil).time = "\n", strTime .. "\n", strTime .. "\n"
		;(strTime .. "\n").time, ("\n").color = "\n", "#F5EBC9"
		return i18n_html("common_text_3722", nil, strTime .. "\n")
	end)
	self.Text_time:setTimeEndListener(function()
		self:initData(self.parent)
	end)
	self.fields.Com_item:setClickCallback(handler(self, self.onClickItem))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.bar:fixChildrenPos()
	end
end
function box_bar:onShow()
end
function box_bar:initData(parent)
	self.parent = parent
	local remainTime = activity_9001558_Ctrl:getReceiveStageRemainTime()
	if 0 < remainTime then
		self.Text_time:beginTime(remainTime)
	end
	local constantRead = include("constantRead")
	local times = constantRead.getConstValue("STELLAR_ODYSSEY_TASK_REWARD", 1)
	local num = activity_9001558_Ctrl:getFinishedQuestNum() * times
	self.getNum = num
	self.fields.Text_red:setString(num)
	self.fields.Text_red:setVisible(0 < num)
	self.fields.Frame_red:setVisible(0 < num)
	self.fields.bar:setValue(num)
	self.status = activity_9001558_Ctrl:getBoxStatus()
	if self.status == gBtnTargetStatusDef.GO then
		self.controllers.c1:setSelectedIndex(0)
	elseif self.status == gBtnTargetStatusDef.GET then
		self.controllers.c1:setSelectedIndex(1)
		if 0 < self.getNum then
			self.fields.Text_claim:setString(i18n("Bright_night_activity_tips_0003"))
		else
			self.fields.Text_claim:setString(i18n("Stellar_Odyssey_text_08"))
		end
	elseif self.status == gBtnTargetStatusDef.GOT then
		self.controllers.c1:setSelectedIndex(2)
		self.fields.Text_claim:setString(i18n("common_text_1892"))
	end
end
function box_bar:onClickItem()
	if self.status == gBtnTargetStatusDef.GO then
		local remainTime = activity_9001558_Ctrl:getReceiveStageRemainTime()
		_ENV = nil
		;(nil).time = SoraDConvertSecondToString(remainTime)
		SoraDShowMsgTip(i18n("common_text_3722", nil))
		return
	end
	if self.status == gBtnTargetStatusDef.GOT then
		SoraDShowMsgTip(i18n("Stellar_Odyssey_text_03"))
		return
	end
	if self.status == gBtnTargetStatusDef.GET and self.getNum > 0 then
		SoraDShowLoading(self.parent:displayObject())
		activity_9001558_Ctrl:reqReceive()
	end
end
return box_bar
