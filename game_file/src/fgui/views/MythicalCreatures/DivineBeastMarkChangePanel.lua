local baseFguiPanel = require("fgui.base.baseFguiPanel")
local publicRead = include("publicRead")
local DivineBeastMarkChangePanel = class("DivineBeastMarkChangePanel", baseFguiPanel)
local divineBeastMarkRead = include("divineBeastMarkRead")
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local constantRead = include("constantRead")
function DivineBeastMarkChangePanel:ctor(...)
	self.isLRU = true
	DivineBeastMarkChangePanel.super.ctor(self, ...)
	print("DivineBeastMarkChangePanel:ctor", self.viewName)
end
function DivineBeastMarkChangePanel:onInit()
	print("=======DivineBeastMarkChangePanel:onInit")
	self.fields.Btn_switch:addClickEventListener(handler(self, self.onClickChange), 1)
	self.fields.Btn_switch:setTitle(i18n("Divine_beast_mark_change_01"))
	self.fields.Panel_bg:setTitle(i18n("Divine_beast_mark_change_01"))
	self.fields.Label_title:setString(i18n("Divine_beast_mark_change_02"))
	self.fields.List_marks:setItemProvider(handler(self, self.onItemProvider))
	self.fields.List_marks:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_marks:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onSelectedMark))
	self.fields.List_btns:setItemRenderer(handler(self, self.onItemRenderer2))
	self.markCfgs = divineBeastMarkRead.getDbMarkCfgs()
	self.maxQuality = divineBeastMarkRead.getMaxQuality()
	self.fields.icon:addLongPressListener(handler(self, self.onLongPress))
	self.fields2 = fguiHelper.get_fields(self.fields.Com_MC_Recycle)
	self.fields2.Txt_recount:setString(i18n("Divine_beast_mark_text_110"))
	self.fields2.list:setItemRenderer(handler(self, self.onRecycleItemRenderer))
	self.fields2.item_icon:setURL(publicRead.getIcon(gIDDef.DIVINE_BEAST_MARK_EXP))
	self.fields2.item_icon2:setURL(publicRead.getIcon(gIDDef.DIVINE_BEAST_MARK_ENERGY))
end
function DivineBeastMarkChangePanel:endShow()
	print("=======DivineBeastMarkChangePanel:endShow")
	self.mark = self.param.mark
	self.selectedType = nil
	self.fields.List_marks:removeChildrenToPool()
	self:initData(self.mark)
end
function DivineBeastMarkChangePanel:initData(mark)
	self.mark = mark
	self.itemID = self.mark.markCfg.ChangeSelling_itemid
	dump(self.itemID, "===============self.itemID")
	self.fields.Com_have:initData(self.itemID)
	self.fields.Btn_switch:setCostIcon(self.itemID)
	if self.mark.markCfg.if_rare > 0 then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.icon:setURL(self.mark.markCfg.icon)
	else
		dump(mark, "DivineBeastMarkChangePanel:initData")
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Com_item:initData(mark.markId)
		self.fields.Com_item:getSetupItemUI():initData(mark.markCfg, mark.lv, mark.star, mark.randomElem)
		self.fields.List_btns:setNumItems(5)
		self.fields.List_btns:setSelectedIndex(0)
	end
	self:selectedCallback(0)
	_UPVALUE1_, self.haveItem = self.fields.Com_have:updateNum(), self.fields.Com_have:updateNum()
	self.selectedMarks, self.fields.Com_have:updateNum()[1] = self.fields.Com_have:updateNum(), mark
	self:recountNum()
end
function DivineBeastMarkChangePanel:onItemProvider(index)
	local markCfg = self.showMarkCfgs[index + 1]
	if self.mark.markCfg.if_rare > 0 then
		return "ui://MythicalCreatures/Com_MC_ChangeMark2"
	else
		return "ui://MythicalCreatures/Com_MC_ChangeMark"
	end
end
function DivineBeastMarkChangePanel:onItemRenderer(index, obj)
	if not obj.fields then
		obj.fields = fguiHelper.get_fields(obj)
		if obj.fields.icon then
			obj.fields.icon:addLongPressListener(handler(self, self.onLongPress2))
		end
		obj:fixChildrenPos()
	end
	local markCfg = self.showMarkCfgs[index + 1]
	if self.mark.markCfg.if_rare > 0 then
		obj.fields.icon:setURL(markCfg.icon)
		obj.fields.title2:setString(i18n(markCfg.name))
		obj.fields.icon.markCfg = markCfg
	else
		obj.fields.Com_item:initData(markCfg.ID)
		obj.fields.Com_item.fields.item:getSetupItemUI():hideSelf()
		obj:setTitle(i18n(markCfg.name))
	end
	obj:fixChildrenPos()
end
function DivineBeastMarkChangePanel:onItemRenderer2(index, obj)
	fguiHelper.get_controllers(obj).c1:setSelectedIndex(index)
	if index == 0 then
		fguiHelper.get_fields(obj).Text_all:setString(i18n("common_text_635"))
	end
	obj:setSelected(index == self.selectedType)
	if obj.clickHandler == nil then
		obj:setTag(index)
		obj.clickHandler = true
		obj:addClickEventListener(handler(self, self.onBtnSelected))
	end
end
function DivineBeastMarkChangePanel:onBtnSelected(sender)
	local tag = sender:getTag()
	if tag == self.selectedType then
		return
	end
	self:selectedCallback(tag)
end
function DivineBeastMarkChangePanel:selectedCallback(tag)
	self.showMarkCfgs, _ENV, self.selectedType = nil, nil, tag
	for _, markCfg in pairs(self.markCfgs) do
		if markCfg.if_rare == self.mark.markCfg.if_rare and markCfg.quality == self.mark.markCfg.quality and markCfg.ChangePurchasePrice ~= 0 and markCfg.ID ~= self.mark.markId and (self.selectedType == 0 or markCfg.army_id == self.selectedType) then
			table.insert(self.showMarkCfgs, markCfg)
		end
	end
	self.fields.List_marks:setNumItems(#self.showMarkCfgs)
	self.fields.List_marks:setSelectedIndex(0)
	if #self.showMarkCfgs > 0 then
		self.fields.List_marks:scrollToView(0)
	end
	self:onSelectedMark()
end
function DivineBeastMarkChangePanel:onSelectedMark()
	local selectedIndex = self.fields.List_marks:getSelectedIndex()
	dump(selectedIndex, "DivineBeastMarkChangePanel:onSelectedMark")
	local markCfg = self.showMarkCfgs[selectedIndex + 1]
	if not markCfg then
		self.fields.Btn_switch:setEnabled(false)
		return
	end
	self.fields.Btn_switch:setEnabled(true)
	self.cost = markCfg.ChangePurchasePrice - self.mark.markCfg.ChangeSellingPrice
	self.fields.Btn_switch:setCost(self.itemID, self.cost)
end
function DivineBeastMarkChangePanel:onClickChange()
	SoraDPlaySound()
	if self.fields.Btn_switch:checkItem(true) then
		local selectedIndex = self.fields.List_marks:getSelectedIndex()
		local markCfg = self.showMarkCfgs[selectedIndex + 1]
		_ENV = nil
		_ENV = nil
		;(nil).name1 = i18n(self.mark.markCfg.name)
		;(nil).name2 = i18n(markCfg.name)
		;(nil).content = i18n("Divine_beast_mark_change_04", nil)
		;(nil).cancel = true
		;(nil).confirmFunc = function()
			if tolua.isnull(self) then
				return
			end
			divineBeastMarkCtrl:sendMarkChange(self.mark.bagMarkId, markCfg.ID)
			self:close()
		end
		uiManager:show("MessageBox", nil)
	end
end
function DivineBeastMarkChangePanel:onLongPress(button, startPos, endPos)
	SoraDPlaySound()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
	;(nil).id = self.mark.markId
	;(nil).pos = startPos
	SoraDSendMessage(nil)
end
function DivineBeastMarkChangePanel:onLongPress2(button, startPos, endPos)
	SoraDPlaySound()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
	;(nil).id = button.markCfg.ID
	;(nil).pos = startPos
	SoraDSendMessage(nil)
end
function DivineBeastMarkChangePanel:recountNum()
	local isVisible = table.nums(self.selectedMarks) > 0 and 0 < self.selectedMarks[1].lv
	self.fields.Com_MC_Recycle:setVisible(isVisible)
	self.controllers.c2:setSelectedIndex(isVisible and 1 or 0)
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
function DivineBeastMarkChangePanel:onRecycleItemRenderer(index, obj)
	if not obj.fields then
		obj.fields = fguiHelper.get_fields(obj)
	end
	local data = self.recycleMarks[index + 1]
	obj.fields.item:initData(data.markId)
	obj.fields.item:getSetupItemUI():hideLv()
	obj.fields.Txt_num:setString(data.count)
end
return DivineBeastMarkChangePanel
