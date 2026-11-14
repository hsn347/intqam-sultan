local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DivineBeastMarkRecyclePanel = class("DivineBeastMarkRecyclePanel", baseFguiPanel)
local publicRead = include("publicRead")
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local constantRead = include("constantRead")
local dailyRemindManager = include("dailyRemindManager")
local divineBeastMarkRead = include("divineBeastMarkRead")
function DivineBeastMarkRecyclePanel:ctor(...)
	DivineBeastMarkRecyclePanel.super.ctor(self, ...)
	self.debug = true
	print("DivineBeastMarkRecyclePanel:ctor", self.viewName)
end
function DivineBeastMarkRecyclePanel:onInit()
	print("=======DivineBeastMarkRecyclePanel:onInit")
	self.recyclePercent = constantRead.getConstValue("DIVINE_BEAST_MARK_EXP_RETAIN")
	self.fields.Panel_bg:setTitle(i18n("common_text_1378"))
	self.fields.list_marks:setVirtual()
	self.fields.list_marks:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Txt_tip:setString(i18n("Divine_beast_mark_text_21"))
	publicRead = self.fields.Txt_tip.setString
	_UPVALUE3_, self.fields.Txt_tip.setString[1] = i18n("Divine_beast_mark_text_29"), i18n("Divine_beast_mark_text_29")
	_UPVALUE3_, self.fields.Txt_tip.setString[2] = i18n("Divine_beast_mark_text_29"), i18n("Divine_beast_mark_text_30")
	_UPVALUE3_, self.fields.Txt_tip.setString[3] = i18n("Divine_beast_mark_text_29"), i18n("Divine_beast_mark_text_31")
	_UPVALUE3_, self.fields.Txt_tip.setString[4] = i18n("Divine_beast_mark_text_29"), i18n("Divine_beast_mark_text_31")
	_UPVALUE3_, self.fields.Txt_tip.setString[5] = i18n("Divine_beast_mark_text_29"), i18n("Divine_beast_mark_text_31")
	_UPVALUE3_, self.fields.Txt_tip.setString[6] = i18n("Divine_beast_mark_text_29"), i18n("Divine_beast_mark_text_31")
	_UPVALUE3_, self.fields.Txt_tip.setString[7] = i18n("Divine_beast_mark_text_29"), i18n("Divine_beast_mark_text_31")
	local _UPVALUE3_, self.fields.Txt_tip.setString[8], items = i18n("Divine_beast_mark_text_29"), i18n("Divine_beast_mark_text_31")
	i18n("Divine_beast_mark_text_29")[1] = 1
	i18n("Divine_beast_mark_text_29")[2] = 2
	local i18n("Divine_beast_mark_text_29")[3], values = 3, i18n("Divine_beast_mark_text_29")
	_ENV = i18n("Divine_beast_mark_text_31")
	i18n("Divine_beast_mark_text_31").items = items
	i18n("Divine_beast_mark_text_31").values = values
	i18n("Divine_beast_mark_text_31").selectedValue = 0
	i18n("Divine_beast_mark_text_31").changedCallback = handler(self, self.onChooseClick)
	self:setComboBox(self.fields.ComboBox_sort, i18n("Divine_beast_mark_text_31"))
	self.fields.ComboBox_sort:setTitle(i18n("Divine_beast_mark_text_28"))
	self.fields2 = fguiHelper.get_fields(self.fields.Com_MC_Recycle)
	self.fields2.Txt_recount:setString(i18n("Divine_beast_mark_text_33"))
	self.fields2.list:setItemRenderer(handler(self, self.onRecycleItemRenderer))
	self.fields.btn_close:setTitle(i18n("common_text_185"))
	self.fields.btn_close:addClickEventListener(handler(self, self.onClearSelectClick))
	self.fields.btn_all:setTitle(i18n("common_text_404"))
	self.fields.btn_all:addClickEventListener(handler(self, self.onSelectAllClick))
	self.fields.btn_recycle:setTitle(i18n("common_text_1378"))
	self.fields.btn_recycle:addClickEventListener(handler(self, self.onRecycleClick))
	self.fields2.item_icon:setURL(publicRead.getIcon(gIDDef.DIVINE_BEAST_MARK_EXP))
	self.fields2.item_icon2:setURL(publicRead.getIcon(gIDDef.DIVINE_BEAST_MARK_ENERGY))
	self.selectedMarks, _ENV = self.fields2.item_icon2.setURL, self.fields2.item_icon2.setURL
	self.view:fixChildrenPos()
end
function DivineBeastMarkRecyclePanel:onShow()
	print("=======DivineBeastMarkRecyclePanel:onShow")
	self:updateView()
end
function DivineBeastMarkRecyclePanel:updateView()
	local bagMarkData = divineBeastMarkCtrl:getBagMarkList()
	self.markList, divineBeastMarkCtrl = divineBeastMarkCtrl, divineBeastMarkCtrl
	for _, v in pairs(bagMarkData) do
		local cfg = v.markCfg
		if v.slot == nil then
			divineBeastMarkCtrl = v.slot
			local v.slot.data, markData = v, v.slot
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
	self.selectedMarks, divineBeastMarkCtrl = table.sort, table.sort
	self.fields.list_marks:setNumItems(#self.markList)
	self.fields.Txt_tip:setVisible(#self.markList == 0)
	self:recountNum()
end
function DivineBeastMarkRecyclePanel:recountNum()
	local recountNum, recountNum2, recycleMarkMap = divineBeastMarkRead.getRecycleData(self.selectedMarks)
	self.recycleMarks = recycleMarkMap
	self.fields2.Txt_num:setString(recountNum)
	self.fields2.Txt_num2:setString(recountNum2)
	self.fields2.list:setNumItems(#self.recycleMarks)
	self.fields2.list:setWidth(self.fields2.list:getScrollPane():getContentWidth())
	self.fields2.group:ensureBoundsCorrect()
	self.fields.btn_recycle:setEnabled(table.nums(self.selectedMarks) > 0)
	self.fields.btn_close:setEnabled(table.nums(self.selectedMarks) > 0)
end
function DivineBeastMarkRecyclePanel:onChooseClick()
	SoraDPlaySound()
	local quality = tonumber(self.fields.ComboBox_sort:getValue())
	self.fields.ComboBox_sort:setTitle(i18n("Divine_beast_mark_text_28"))
	self.selectedMarks, _ENV = self.fields.ComboBox_sort.setTitle, self.fields.ComboBox_sort.setTitle
	for i, v in ipairs(self.markList) do
		if v.data.lock == 0 and quality >= v.data.markCfg.quality then
			self.selectedMarks[v.data.bagMarkId] = v.data
		end
	end
	self.fields.list_marks:setNumItems(#self.markList)
	self:recountNum()
end
function DivineBeastMarkRecyclePanel:onClearSelectClick()
	self.selectedMarks, _UPVALUE0_ = nil, nil
	self.fields.list_marks:setNumItems(#self.markList)
	self:recountNum()
end
function DivineBeastMarkRecyclePanel:onSelectAllClick()
	SoraDPlaySound()
	for i, v in ipairs(self.markList) do
		if v.data.lock == 0 then
			self.selectedMarks[v.data.bagMarkId] = v.data
		end
	end
	self.fields.list_marks:setNumItems(#self.markList)
	self:recountNum()
end
function DivineBeastMarkRecyclePanel:onRecycleClick()
	SoraDPlaySound()
	local _ENV, recycleData = SoraDPlaySound, SoraDPlaySound
	local isHaveRare = false
	local isHaveGold = false
	for k, v in pairs(self.selectedMarks) do
		table.insert(recycleData, v.bagMarkId)
		if v.markCfg.if_rare == 1 then
			isHaveRare = true
		end
		if v.markCfg.quality >= 4 then
			isHaveGold = true
		end
	end
	local remindKey = dailyRemindManager.REMIND_TYPE.divineBeastMarkRecycle
	if (isHaveRare or isHaveGold) and dailyRemindManager.checkNeedRemind(remindKey) then
		_ENV = remindKey
		remindKey.rtype = remindKey
		remindKey.content = i18n("Divine_beast_mark_text_103")
		function remindKey.confirmFunc()
			divineBeastMarkCtrl:sendRecycle(recycleData)
		end
		dailyRemindManager.showMessageBox(remindKey)
	else
		divineBeastMarkCtrl:sendRecycle(recycleData)
	end
end
function DivineBeastMarkRecyclePanel:onMarkClick(sender, mark)
	if mark == nil then
		return
	end
	if mark.lock == 1 then
		SoraDShowMsgTip(i18n("Divine_beast_mark_text_55"))
		return
	end
	self.selectedMarks[mark.bagMarkId] = self.selectedMarks[mark.bagMarkId] == nil and mark or nil
	sender:setSelected(self.selectedMarks[mark.bagMarkId] ~= nil)
	self:recountNum()
end
function DivineBeastMarkRecyclePanel:onItemRenderer(index, obj)
	local mark = self.markList[index + 1].data
	obj:initData(mark)
	obj:showLongPress()
	obj:setSelected(self.selectedMarks[mark.bagMarkId] ~= nil)
	obj:setClickCallback(handler(self, self.onMarkClick))
end
function DivineBeastMarkRecyclePanel:onRecycleItemRenderer(index, obj)
	if not obj.fields then
		obj.fields = fguiHelper.get_fields(obj)
	end
	local data = self.recycleMarks[index + 1]
	obj.fields.item:initData(data.markId)
	obj.fields.item:getSetupItemUI():hideLv()
	obj.fields.Txt_num:setString(data.count)
end
return DivineBeastMarkRecyclePanel
