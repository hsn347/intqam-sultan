local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local baseComponent = require("fgui.base.baseComponent")
local MagicHerbSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicHerb/MagicHerbSingle", MagicHerbSingle)
function MagicHerbSingle:onInit()
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_btn:addClickListener(handler(self, self.onClickGo))
	self:fixChildrenPos()
	self.fields.n9:fix()
end
function MagicHerbSingle:onShow()
end
function MagicHerbSingle:initData(cfg, parent)
	self.cfg = cfg
	self.parent = parent
	self.itemList = self.cfg.award
	self.fields.List_award:setNumItems(#self.itemList)
	local lang = self.cfg.taskDes[1]
	_ENV = nil
	;(nil).num = fguiHelper.getColorString("#FFC864", self.cfg.taskDes.num)
	self.fields.Text_dsc:setString(i18n(lang, nil))
	local cur = ""
	self.cfg.count = math.max(0, self.cfg.count)
	if self.cfg.count >= cfg.total then
		cur = fguiHelper.getColorString("#FFEBB9", string.formatnumberthousands(self.cfg.count))
	else
		cur = fguiHelper.getColorString("#FF0000", string.formatnumberthousands(self.cfg.count))
	end
	_ENV = string.formatnumberthousands(self.cfg.count)
	string.formatnumberthousands(self.cfg.count).var = cur
	string.formatnumberthousands(self.cfg.count).var1 = string.formatnumberthousands(self.cfg.total)
	self.fields.Text_rem:setString(i18n("alliance_stronghold_text_070", string.formatnumberthousands(self.cfg.count)))
	if self.cfg.taskStatus == gBtnTargetStatusDef.GET then
		self.fields.Button_btn:setBtnColorIndex(0)
		self.fields.Button_btn:setTitle(i18n("common_text_1146"))
		self.fields.Button_btn:setEnabled(true)
	elseif self.cfg.taskStatus == gBtnTargetStatusDef.GO then
		self.fields.Button_btn:setBtnColorIndex(2)
		self.fields.Button_btn:setTitle(i18n("common_text_477"))
		self.fields.Button_btn:setEnabled(true)
	elseif self.cfg.taskStatus == gBtnTargetStatusDef.GOT then
		self.fields.Button_btn:setTitle(i18n("common_text_1892"))
		self.fields.Button_btn:setEnabled(false)
	end
end
function MagicHerbSingle:onItemRenderer(index, obj)
	local item = self.itemList[index + 1]
	obj:initData(item.id, item.count)
end
function MagicHerbSingle:onClickGo()
	SoraDPlaySound()
	print("点击按钮====")
	if self.cfg.taskStatus == gBtnTargetStatusDef.GET then
		SoraDShowLoading(self.parent:displayObject())
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
return MagicHerbSingle
