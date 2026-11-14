local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local nebulaEmperorRead = include("nebulaEmperorRead")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaAllStarRead = include("nebulaAllStarRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_boxList = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaEmperor/Com_boxList", Com_boxList)
function Com_boxList:onInit()
	self.statusMap, _ENV = nil, nil
	if not SoraDFIsRA() then
		self.fields.List:setPivot(SoraDFPosX(0, 1), 1, false)
		self.fields.bar:setPivot(SoraDFPosX(0, 1), 1, false)
		self:fixChildrenPos()
		self.fields.bar:getChild("bar"):fixPos()
	end
	self.fields.List:setItemRenderer(handler(self, self.onBoxItemRenderer))
	self.scrollBar = self:getScrollPane()
end
function Com_boxList:onShow()
end
function Com_boxList:onBoxItemRenderer(index, obj)
	local grade = index + 1
	local needGold = self:getRead().getDonateRewardNeedGold(grade)
	obj:setString(string.formatnumberthousands(needGold))
	if not obj.isInit then
		obj.isInit = true
		obj:addClickListener(handler(self, self.onClickBtnBox))
	end
	obj.grade = grade
	local _controllers = fguiHelper.get_controllers(obj)
	local status = self.statusMap[grade] or gBtnTargetStatusDef.GO
	obj.status = status
	_controllers.c1:setSelectedIndex(status - 1)
	_ENV = _controllers.c1.setSelectedIndex
	_controllers.c1.setSelectedIndex[gBtnTargetStatusDef.GET] = "open"
	_controllers.c1.setSelectedIndex[gBtnTargetStatusDef.GOT] = "FullyOpen"
	local _controllers.c1.setSelectedIndex[gBtnTargetStatusDef.GO], config = "closed", _controllers.c1.setSelectedIndex
	local strEnd = config[status]
	local frame = self:getRead().getDonateRewardFrame(grade)
	obj:setIcon(string.format("icon_lshs_common_%02d_%s.png", frame, strEnd))
end
function Com_boxList:onClickBtnBox(EventContext)
	SoraDPlaySound()
	local Com_box = EventContext:getSender()
	_ENV = nil
	;(nil).grade = Com_box.grade
	;(nil).status = Com_box.status
	;(nil).activityID = self.activityID
	uiManager:show("NebulaEmperorDonateReward", nil)
end
function Com_boxList:updateTotalGold(totalGold)
	local percent = self:getRead().getDonateRewardGoldPercent(totalGold)
	self.fields.bar:setValue(percent * 100)
	self.statusMap, _ENV = self.fields.bar.setValue, self.fields.bar.setValue
	local rewardIndex, ctrl
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		ctrl = nebulaAllStarCtrl
	else
		ctrl = nebulaEmperorCtrl
	end
	for grade = 1, self.gradeMax do
		local status = ctrl:getDonateBoxStatus(grade)
		self.statusMap[grade] = status
		if not rewardIndex and status == gBtnTargetStatusDef.GET then
			rewardIndex = grade
		end
	end
	self.fields.List:setNumItems(self.gradeMax)
	local percX = 1 - (rewardIndex or 0) / self.gradeMax
	self.scrollBar:setPercX(SoraDFPosX(percX, 1), true)
end
function Com_boxList:setActivityID(activityID)
	self.activityID = activityID
	self.gradeMax = self:getRead().getDonateRewardMax()
	self.fields.List:setNumItems(self.gradeMax)
	self.fields.List:resizeToFit(self.gradeMax)
end
function Com_boxList:getRead(...)
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		return nebulaAllStarRead
	else
		return nebulaEmperorRead
	end
end
return Com_boxList
