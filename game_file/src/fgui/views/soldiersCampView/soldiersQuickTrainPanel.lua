local armyltCtrl = include("armyltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local soldiersQuickTrainPanel = class("soldiersQuickTrainPanel", baseFguiPanel)
function soldiersQuickTrainPanel:ctor(...)
	self.isLRU = true
	soldiersQuickTrainPanel.super.ctor(self, ...)
	print("soldiersQuickTrainPanel:ctor", self.viewName)
end
function soldiersQuickTrainPanel:onInit()
	print("=======soldiersQuickTrainPanel:onInit")
	self.fields.Panel_bg:setString(i18n("soldier_quick_train01"))
	self.fields.Text_msg:setString(i18n("soldier_quick_train03"))
	self.fields.Text_tip:setString(i18n("soldier_quick_train04"))
	self.fields.Label_title:setString(i18n("soldier_quick_train05"))
	self.quickCfg = armyltCtrl.getQuickTrainCfg()
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onResRender))
	self.fields.Button_cancel:setString(i18n("soldier_rush_text_21"))
	self.fields.Button_cancel:addClickListener(handler(self, self.btnCancelClick))
	self.fields.Button_open:setString(i18n("star_cube_03"))
	self.fields.Button_open:addClickListener(handler(self, self.btnOpenClick))
	self.fields.Button_cancel:fixPos()
	self.fields.Button_open:fixPos()
end
function soldiersQuickTrainPanel:onResRender(index, obj)
	local count = self.resList[index + 1].count
	obj:initData(self.resList[index + 1].id, count)
	obj:setIcon(nil, count, count == 0)
end
function soldiersQuickTrainPanel:endShow()
	print("=======soldiersQuickTrainPanel:endShow")
	self.resList, _ENV = print, print
	for k, v in ipairs(self.quickCfg) do
		local count = backpackCtrl:getItemCount(v.item)
		local quality = backpackltCtrl:getItemQuality(v.item)
		_ENV = nil
		;(nil).id = v.item
		;(nil).count = count
		;(nil).quality = quality
		;(nil).type = v.type
		;(nil).priority = v.priority
		table.insert(self.resList, nil)
	end
	table.sort(self.resList, function(a, b)
		if a.count > 0 and b.count > 0 or a.count == 0 and b.count == 0 then
			return a.quality > b.quality
		end
		return a.count > 0
	end)
	self.fields.List:setNumItems(#self.resList)
	self.fields.List:jumpToTop()
end
function soldiersQuickTrainPanel:btnOpenClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_SOLDIER_UI_QUICK_TRAIN"
	;(nil).resList = self.resList
	SoraDSendMessage(nil)
	self:close()
end
function soldiersQuickTrainPanel:btnCancelClick()
	SoraDPlaySound()
	self:close()
end
return soldiersQuickTrainPanel
