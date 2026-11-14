local baseFguiPanel = require("fgui.base.baseFguiPanel")
local publicRead = include("publicRead")
local divineBeastMarkRead = include("divineBeastMarkRead")
local DivineBeastMarkChangeChoosePanel = class("DivineBeastMarkChangeChoosePanel", baseFguiPanel)
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
function DivineBeastMarkChangeChoosePanel:ctor(...)
	self.isLRU = true
	DivineBeastMarkChangeChoosePanel.super.ctor(self, ...)
	print("DivineBeastMarkChangeChoosePanel:ctor", self.viewName)
end
function DivineBeastMarkChangeChoosePanel:onInit()
	print("=======DivineBeastMarkChangeChoosePanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("Divine_beast_mark_change_01"))
	self.fields.list_marks:setVirtual()
	self.fields.list_marks:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Txt_tip:setString(i18n("mark_optimal_text_03"))
	self.fields.Txt_title:setString(i18n("Divine_beast_mark_text_109"))
	self.fields.btn_change:setTitle(i18n("Divine_beast_mark_change_01"))
	self.fields.btn_change:addClickEventListener(handler(self, self.onChangeClick))
	self.fields2 = fguiHelper.get_fields(self.fields.Com_MC_Recycle)
	self.fields2.Txt_recount:setString(i18n("Divine_beast_mark_text_110"))
	self.fields2.list:setItemRenderer(handler(self, self.onRecycleItemRenderer))
	self.fields2.item_icon:setURL(publicRead.getIcon(gIDDef.DIVINE_BEAST_MARK_EXP))
	self.fields2.item_icon2:setURL(publicRead.getIcon(gIDDef.DIVINE_BEAST_MARK_ENERGY))
end
function DivineBeastMarkChangeChoosePanel:endShow()
	print("=======DivineBeastMarkChangeChoosePanel:endShow")
	self.selectedMarkID = nil
	self.controllers.c1:setSelectedIndex(0)
	self:updateView()
end
function DivineBeastMarkChangeChoosePanel:updateView()
	local bagMarkData = divineBeastMarkCtrl:getBagMarkList()
	self.markList, divineBeastMarkCtrl = divineBeastMarkCtrl, divineBeastMarkCtrl
	for _, v in pairs(bagMarkData) do
		local cfg = v.markCfg
		if v.slot == nil and v.isCanChange then
			divineBeastMarkCtrl = v.isCanChange
			local v.isCanChange.data, markData = v, v.isCanChange
			markData.order = (v.slot ~= nil and 1000000 or 0) + v.lv * 100 + cfg.quality * 10 + v.lock
			table.insert(self.markList, markData)
		end
	end
	table.sort(self.markList, function(a, b)
		if a.order ~= b.order then
			return a.order > b.order
		end
		return a.data.markId > b.data.markId
	end)
	self.selectedMarkID = nil
	self.selectedMark = nil
	self.fields.list_marks:setNumItems(#self.markList)
	self.fields.Txt_tip:setVisible(#self.markList == 0)
	self.fields.btn_change:setEnabled(self.selectedMarkID ~= nil)
end
function DivineBeastMarkChangeChoosePanel:onItemRenderer(index, obj)
	local mark = self.markList[index + 1].data
	obj:initData(mark, nil)
	obj:showLongPress()
	obj:setSelected(self.selectedMarkID == mark.bagMarkId)
	obj:setClickCallback(handler(self, self.onMarkClick))
	if self.selectedMarkID == mark.bagMarkId then
		self.selectedMark = obj
	end
end
function DivineBeastMarkChangeChoosePanel:onMarkClick(sender, mark)
	if mark == nil then
		return
	end
	if mark.lock == 1 then
		SoraDShowMsgTip(i18n("Divine_beast_mark_text_55"))
		return
	end
	self.selectedMarkID = self.selectedMarkID ~= mark.bagMarkId and mark.bagMarkId or nil
	sender:setSelected(self.selectedMarkID == mark.bagMarkId)
	if self.selectedMarkID == mark.bagMarkId then
		if self.selectedMark ~= nil and self.selectedMark ~= sender then
			self.selectedMark:setSelected(false)
		end
		self.selectedMark = sender
	else
		self.selectedMark = nil
	end
	self.fields.btn_change:setEnabled(self.selectedMarkID ~= nil)
	if self.selectedMarkID ~= nil then
		_UPVALUE1_ = self.selectedMarkID
		self.selectedMarkID[1] = mark
		if self.selectedMarkID then
			goto lbl_65
		end
	end
	self.selectedMarks, _ENV = self.selectedMarkID, self.selectedMarkID
	::lbl_65::
	self:recountNum()
end
function DivineBeastMarkChangeChoosePanel:onChangeClick()
	SoraDPlaySound()
	local mark = divineBeastMarkCtrl:getMarkByBagMarkId(self.selectedMarkID)
	_ENV = nil
	;(nil).mark = mark
	uiManager:show("DivineBeastMarkChange", nil)
end
function DivineBeastMarkChangeChoosePanel:recountNum()
	local isVisible = table.nums(self.selectedMarks) > 0 and 0 < self.selectedMarks[1].lv
	self.fields.Com_MC_Recycle:setVisible(isVisible)
	self.controllers.c1:setSelectedIndex(isVisible and 1 or 0)
	if not isVisible then
		return
	end
	local recountNum, recountNum2, recycleMarkMap = divineBeastMarkRead.getRecycleData(self.selectedMarks, true)
	self.recycleMarks = recycleMarkMap
	self.fields2.Txt_num:setString(recountNum)
	self.fields2.Txt_num2:setString(recountNum2)
	self.fields2.Txt_num2:setVisible(false)
	self.fields2.item_icon2:setVisible(false)
	self.fields2.list:setNumItems(#self.recycleMarks)
	self.fields2.list:setWidth(self.fields2.list:getScrollPane():getContentWidth())
	self.fields2.group:ensureBoundsCorrect()
end
function DivineBeastMarkChangeChoosePanel:onRecycleItemRenderer(index, obj)
	if not obj.fields then
		obj.fields = fguiHelper.get_fields(obj)
	end
	local data = self.recycleMarks[index + 1]
	obj.fields.item:initData(data.markId)
	obj.fields.item:getSetupItemUI():hideLv()
	obj.fields.Txt_num:setString(data.count)
end
return DivineBeastMarkChangeChoosePanel
