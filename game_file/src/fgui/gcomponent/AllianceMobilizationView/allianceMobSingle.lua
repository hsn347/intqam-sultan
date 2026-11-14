local MAX_AWARD_NUM = 5
local mobilizationltCtrl = gModuleMgr.sharedMgr("mobilizationltCtrl")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
local playerMobilizationCtrl = SoraDGetCtrl("playerMobilizationCtrl")
local baseComponent = require("fgui.base.baseComponent")
local allianceMobSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceMobilizationView/allianceMobSingle", allianceMobSingle)
function allianceMobSingle:onInit()
	self.awardArray, _ENV = nil, nil
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onBtnGoClick))
	self.fields.List_items:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
end
function allianceMobSingle:onShow()
end
function allianceMobSingle:onItemRenderer(index, obj)
	obj:initData(self.awardArray[index + 1].id, self.awardArray[index + 1].count)
end
function allianceMobSingle:initData(data, parent)
	self.data = data
	self.parent = parent
	if self.data.des[1] == "NA" then
		self.fields.Text_des:setString(self.data.des[1])
	else
		local numStr = self.data.target
		if type(self.data.target) == "number" then
			numStr = string.formatnumberthousands(self.data.target)
		end
		_ENV = nil
		;(nil).num = numStr
		_ENV, _ENV, (nil).lv = nil, self.data.lv, self.data.lv
		;(nil).color = "#ffff00"
		_ENV, self.data.lv.num, (nil).i = nil, nil, "true"
		;(nil).color = "#ffff00"
		_ENV, self.data.lv.lv, (nil).i = nil, nil, "true"
		self.data.lv.__default, (nil).color = nil, "#d7c39b"
		self.fields.Text_des:setString(i18n_html(self.data.des[1], nil, self.data.lv))
	end
	local targetStr = self.data.target
	if type(self.data.target) == "number" then
		targetStr = string.formatnumberthousands(self.data.target)
	end
	_ENV = i18n_html(self.data.des[1], nil, self.data.lv)
	i18n_html(self.data.des[1], nil, self.data.lv).count = string.formatnumberthousands(self.data.curnum)
	_ENV, i18n_html(self.data.des[1], nil, self.data.lv).total = string.formatnumberthousands(self.data.curnum), targetStr
	if self.data.taskstatus == gMobilizationTaskStatus.TASK_STATUS_COMPLETE then
		_ENV = self.data.taskstatus
		self.data.taskstatus.color = "#d7c39b"
		if self.data.taskstatus then
			goto lbl_96
		end
	end
	_ENV = self.data.taskstatus
	_ENV, string.formatnumberthousands(self.data.curnum).count, self.data.taskstatus.color = self.data.taskstatus, self.data.taskstatus, "#be2828"
	::lbl_96::
	_ENV, string.formatnumberthousands(self.data.curnum).total, self.data.taskstatus.color = self.data.taskstatus, self.data.taskstatus, "#d7c39b"
	string.formatnumberthousands(self.data.curnum).__default, self.data.taskstatus.color = self.data.taskstatus, "#d7c39b"
	self.fields.Text_schedule:setString(i18n_html("common_text_3683", i18n_html(self.data.des[1], nil, self.data.lv)))
	self.taskStatus = gBtnTargetStatusDef.GO
	if self.data.taskstatus == gMobilizationTaskStatus.TASK_STATUS_COMPLETE then
		self.taskStatus = gBtnTargetStatusDef.GET
	end
	if tonumber(self.data.isTurn) == 0 and self.taskStatus ~= gBtnTargetStatusDef.GET then
		self.fields.Button_go:setVisible(false)
	else
		self.fields.Button_go:setVisible(true)
	end
	self:setBtnStatus()
	self:setAward()
end
function allianceMobSingle:setBtnStatus()
	self.fields.Button_go:setString(self.taskStatus == gBtnTargetStatusDef.GO and i18n("common_text_477") or i18n("common_text_1146"))
	self.fields.Button_go:setBtnColorIndex(self.taskStatus == gBtnTargetStatusDef.GO and 2 or 0)
end
function allianceMobSingle:setAward()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.awardArray = serviceFunctions.tableFormat(self.data.award, nil)
	self.fields.List_items:setNumItems(math.min(#self.awardArray, MAX_AWARD_NUM))
end
function allianceMobSingle:onBtnGoClick()
	SoraDPlaySound()
	if self.taskStatus == gBtnTargetStatusDef.GET then
		SoraDShowLoading(self.parent)
		playerMobilizationCtrl:reqMissionComplete(self.data.tasktypeid)
	elseif self.taskStatus == gBtnTargetStatusDef.GO then
		local guideId = mobilizationltCtrl:getGuideId(self.data.tasktypeid)
		if guideId then
			local ret = mildGuideManager:starMildByNewPlayerStringParam(guideId)
			if ret ~= false then
				SoraDRemoveAllPanelFromManager()
			end
		end
	end
end
return allianceMobSingle
