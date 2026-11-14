local activity_9001624_Read = include("activity_9001624_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001624_Single = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001624/Com_9001624_Single", Com_9001624_Single)
function Com_9001624_Single:onInit()
	self:fixChildrenPos()
	_ENV = self.fixChildrenPos
	self.fixChildrenPos.unlock = false
	self.fixChildrenPos.gotNormal = false
	self.fixChildrenPos.gotExtra = false
	self.state, self.fixChildrenPos.isCanGet = self.fixChildrenPos, false
	self.fields.List_normal:setItemRenderer(handler(self, self.onItemRendererNormal))
	self.fields.List_extra:setItemRenderer(handler(self, self.onItemRendererExtra))
	self.fields.bg_normal:fix()
	self.fields.bg_gold:fix()
end
function Com_9001624_Single:onShow()
end
function Com_9001624_Single:initData(activityID, data, isCurIndex, isAct)
	self.activityID = activityID
	self.activity_Ctrl = activity_9001624_Read.getActivityCtrl(self.activityID)
	self:updateRoleAni(isCurIndex, isAct)
	if next(data) == nil then
		self.controllers.c1:setSelectedIndex(3)
		return
	end
	self.rewardID = data.rewardID
	self.point = data.point
	self.normalData = data.normalReward
	self.extralData = data.advanceReward
	self.isCanGet = self.point <= self.activity_Ctrl:getPoint()
	self:setData()
	if #self.normalData > 0 and #self.extralData > 0 then
		self.controllers.c1:setSelectedIndex(2)
	elseif #self.normalData > 0 then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
	if #self.normalData > 0 then
		self:updateNormalData()
	end
	if #self.extralData > 0 then
		dump(self.extralData, "self.extralData")
		self:updateAdvanceData()
	end
end
function Com_9001624_Single:updateRoleAni(isCurIndex, isAct)
	if isCurIndex then
		local Ani_role
		if self.activityID == gActivityTimeActivityID.CELEBRATE_CORBAN then
			self.controllers.c_role:setSelectedIndex(2)
			Ani_role = self.fields.Ani_role_9001637
			Ani_role:setAllFrameNameOnce("fhxj_yd_n_%02d.png", 1, true)
		else
			self.controllers.c_role:setSelectedIndex(1)
			Ani_role = self.fields.Ani_role
			Ani_role:setAllFrameNameOnce("UIkzjs_yd_n_%02d.png", 1, true)
		end
		if isAct then
			Ani_role:stopActionByTag(999)
			Ani_role:setPositionY(200)
			Ani_role:runAction(ffa.moveTo(1, Ani_role:getPositionX(), 70))
		end
	else
		self.controllers.c_role:setSelectedIndex(0)
	end
end
function Com_9001624_Single:updateNormalData()
	if self.activityID == gActivityTimeActivityID.CELEBRATE_CORBAN then
		self.fields.Text_num_normal:setString(string.formatnumberthousands(self.point))
	else
		self.fields.Text_num_normal:setString(string.formatnumberthousands(self.point) .. "M")
	end
	self.fields.List_normal:setNumItems(#self.normalData)
end
function Com_9001624_Single:updateAdvanceData()
	if self.activityID == gActivityTimeActivityID.CELEBRATE_CORBAN then
		self.fields.Text_num_gold:setString(string.formatnumberthousands(self.point))
	else
		self.fields.Text_num_gold:setString(string.formatnumberthousands(self.point) .. "M")
	end
	self.fields.List_extra:setNumItems(#self.extralData)
end
function Com_9001624_Single:setData()
	self.state.unlock = self.activity_Ctrl:getIsAdvanceRewardUnlock()
	self.state.gotNormal = self.activity_Ctrl:isGotNormal(self.rewardID)
	self.state.gotExtra = self.activity_Ctrl:isGotAdvance(self.rewardID)
end
function Com_9001624_Single:onItemRenderer(index, obj)
end
function Com_9001624_Single:onItemRendererNormal(index, object)
	object:initData(index + 1, self.normalData[index + 1], self.state.gotNormal, true, self.isCanGet)
end
function Com_9001624_Single:onItemRendererExtra(index, object)
	dump(self.extralData, "self.extralData")
	object:initData(index + 1, self.extralData[index + 1], self.state.gotExtra, self.state.unlock, self.isCanGet)
end
return Com_9001624_Single
