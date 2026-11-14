local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_heroProgressSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity2112/Com_heroProgressSingle", Com_heroProgressSingle)
function Com_heroProgressSingle:onInit()
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_btn:addClickListener(handler(self, self.onClickGo))
	self:fixChildrenPos()
end
function Com_heroProgressSingle:initData(parent, cfg)
	self.cfg = cfg
	self.parent = parent
	self.itemList = self.cfg.award
	self.fields.List_award:setNumItems(table.nums(self.itemList))
	local str = self.cfg.taskDes[1]
	_ENV = table.nums(self.itemList)
	table.nums(self.itemList).num = fguiHelper.getColorString("#FFC864", self.cfg.taskDes.num)
	self.fields.Text_dsc:setString(i18n(str, table.nums(self.itemList)))
	local cur = ""
	self.cfg.count = math.max(0, self.cfg.count)
	if self.cfg.count >= cfg.total then
		self.cfg.count = cfg.total
		cur = fguiHelper.getColorString("#FFEBB9", string.formatnumberthousands(self.cfg.count))
	else
		cur = fguiHelper.getColorString("#FF0000", string.formatnumberthousands(self.cfg.count))
	end
	_ENV = string.formatnumberthousands(self.cfg.count)
	string.formatnumberthousands(self.cfg.count).count = cur
	string.formatnumberthousands(self.cfg.count).total = string.formatnumberthousands(self.cfg.total)
	self.fields.Text_rem:setString(i18n("common_text_3683", string.formatnumberthousands(self.cfg.count)))
	if self.cfg.taskStatus == gBtnTargetStatusDef.GET then
		self.fields.Button_btn:setBtnColorIndex(0)
		self.fields.Button_btn:setTitle(i18n("common_text_1146"))
		self.fields.Button_btn:setEnabled(true)
		self.controllers.state:setSelectedIndex(0)
	elseif self.cfg.taskStatus == gBtnTargetStatusDef.GO then
		self.fields.Button_btn:setBtnColorIndex(2)
		self.fields.Button_btn:setTitle(i18n("common_text_477"))
		self.fields.Button_btn:setEnabled(true)
		self.controllers.state:setSelectedIndex(0)
	elseif self.cfg.taskStatus == gBtnTargetStatusDef.GOT then
		self.fields.Text_finish:setString(i18n("common_text_2601"))
		self.controllers.state:setSelectedIndex(1)
	end
end
function Com_heroProgressSingle:onItemRenderer(index, obj)
	local item = self.itemList[index + 1]
	obj:initData(item.id, item.count)
end
function Com_heroProgressSingle:onClickGo()
	SoraDPlaySound()
	print("点击按钮====")
	if self.cfg.taskStatus == gBtnTargetStatusDef.GET then
		activityTaskComponentCtrl:reqRuestClaimReward(self.cfg.taskID, self.cfg.activityID)
	elseif self.cfg.taskStatus == gBtnTargetStatusDef.GO then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		local tbParam = mildGuideManager:splitGuideParam(self.cfg.guideId)
		if tbParam.id == gNewPLayerTaskType.POP_TIP then
			SoraDShowMsgTip(i18n(self.cfg.taskDes))
		end
		if self.cfg.guideId then
			local _, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(self.cfg.guideId)
			if not notNeedClose then
				SoraDRemoveAllPanelFromManager()
			end
		end
	end
end
function Com_heroProgressSingle:onShow()
end
return Com_heroProgressSingle
