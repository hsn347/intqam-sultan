local backToTopCtrl = SoraDGetCtrl("backToTopCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewServerReturn/Com_list", Com_list)
function Com_list:onInit()
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRender))
	self.fields.Btn_go:addClickListener(handler(self, self.onClickTask))
	self:fixChildrenPos()
end
function Com_list:onItemRender(index, obj)
	local data = self.data.award[index + 1]
	obj:initData(data.id, data.count)
end
function Com_list:onShow()
end
function Com_list:initData(data)
	self.data = data
	_ENV = nil
	;(nil).lv = fguiHelper.getColorString("#FFC864", self.data.taskDes.lv)
	;(nil).num = fguiHelper.getColorString("#FFC864", string.formatnumberthousands(self.data.aim))
	self.fields.Text_dsc:setString(i18n(self.data.taskDes[1], nil))
	if self.data.taskStatus == gBtnTargetStatusDef.GO then
		self.fields.Text_rem:setString(fguiHelper.getColorString("#CE0000", string.formatnumberthousands(self.data.progress)) .. "/" .. fguiHelper.getColorString("#D7C39B", string.formatnumberthousands(self.data.aim)))
		self.fields.Btn_go:setBtnColorIndex(2)
		self.fields.Btn_go:setTitle(i18n("common_text_477"))
		self.fields.Btn_go:setEnabled(true)
	elseif self.data.taskStatus == gBtnTargetStatusDef.GOT then
		self.fields.Text_rem:setString(fguiHelper.getColorString("#FFEBB9", string.formatnumberthousands(self.data.progress)) .. "/" .. fguiHelper.getColorString("#FFEBB9", string.formatnumberthousands(self.data.aim)))
		self.fields.Btn_go:setTitle(i18n("common_text_1892"))
		self.fields.Btn_go:setEnabled(false)
	else
		self.fields.Text_rem:setString(fguiHelper.getColorString("#D7C39B", string.formatnumberthousands(self.data.progress)) .. "/" .. fguiHelper.getColorString("#D7C39B", string.formatnumberthousands(self.data.aim)))
		self.fields.Btn_go:setBtnColorIndex(0)
		self.fields.Btn_go:setTitle(i18n("common_text_1146"))
		self.fields.Btn_go:setEnabled(true)
	end
	self.fields.List_award:setNumItems(#self.data.award)
end
function Com_list:onClickTask()
	SoraDPlaySound()
	if self.data.taskStatus == gBtnTargetStatusDef.GET then
		backToTopCtrl:sendClaimTask(self.data.taskID)
	elseif self.data.taskStatus == gBtnTargetStatusDef.GO then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		local tbParam = mildGuideManager:splitGuideParam(self.data.guideId)
		if tbParam.id == gNewPLayerTaskType.POP_TIP then
			SoraDShowMsgTip(i18n(self.data.taskDes))
		end
		if self.data.guideId then
			local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(self.data.guideId)
			if not notNeedClose then
				SoraDRemoveAllPanelFromManager()
			end
		end
	end
end
return Com_list
