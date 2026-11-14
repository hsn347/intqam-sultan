local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DivineBeastMarkStarPanel = class("DivineBeastMarkStarPanel", baseFguiPanel)
local divineBeastMarkRead = include("divineBeastMarkRead")
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local activityExchangeMallRead = include("activityExchangeMallRead")
function DivineBeastMarkStarPanel:ctor(...)
	DivineBeastMarkStarPanel.super.ctor(self, ...)
	self.debug = true
	print("DivineBeastMarkStarPanel:ctor", self.viewName)
end
function DivineBeastMarkStarPanel:onInit()
	print("=======DivineBeastMarkStarPanel:onInit")
	self.fields.Com_title:initData(i18n("Divine_beast_mark_text_68"), handler(self, self.onClickClose))
	self.fields.list_marks:setVirtual()
	self.fields.list_marks:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_up:setTitle(i18n("Divine_beast_mark_text_65"))
	self.fields.Btn_up:addClickEventListener(handler(self, self.onUpClick))
	self.fields.Btn_more:setTitle(i18n("footballelf_15"))
	self.fields.Btn_more:addClickEventListener(handler(self, self.onMoreClick))
	self.fields.Txt_tip:setString(i18n("Divine_beast_mark_text_72"))
	self.mark = self.param.mark
	if not activityExchangeMallRead:getShopItemList(gActivityTimeActivityID.NORMAL_ACTIVITY_9001650) then
		local _ENV, showShopItemList = activityExchangeMallRead:getShopItemList(gActivityTimeActivityID.NORMAL_ACTIVITY_9001650), activityExchangeMallRead:getShopItemList(gActivityTimeActivityID.NORMAL_ACTIVITY_9001650)
	end
	for k, v in ipairs(showShopItemList) do
		if v.shopitem == self.mark.markId then
			self.curShopItem = v
			break
		end
	end
	if self.curShopItem == nil then
		self.fields.Btn_more:setVisible(false)
		self.fields.Btn_up:setPositionX(320)
	end
	self.view:fixChildrenPos()
end
function DivineBeastMarkStarPanel:onShow()
	print("=======DivineBeastMarkStarPanel:onShow")
	self:updateView()
end
function DivineBeastMarkStarPanel:updateView()
	self.selectedMarks, divineBeastMarkRead = nil, nil
	self.fields.Com_MC_Mark:initData(self.mark)
	self.fields.Com_MC_Stars1:initData(self.mark.star)
	self.fields.Com_MC_Stars2:initData(self.mark.star + 1)
	self.nextStarCfg = divineBeastMarkRead.getStarCfg(self.mark.star + 1)
	local nowMaxLv = divineBeastMarkRead.getMaxLv(self.mark.markId, self.mark.star)
	local nextMaxLv = divineBeastMarkRead.getMaxLv(self.mark.markId, self.mark.star + 1)
	divineBeastMarkRead = nil
	;(nil).num = nowMaxLv
	self.fields.txt_now:setString(i18n("Divine_beast_mark_text_67", nil))
	divineBeastMarkRead = i18n("Divine_beast_mark_text_67", nil)
	i18n("Divine_beast_mark_text_67", nil).num = nextMaxLv
	self.fields.txt_next:setString(i18n("Divine_beast_mark_text_67", i18n("Divine_beast_mark_text_67", nil)))
	local bagMarkData = divineBeastMarkCtrl:getBagMarkList()
	self.markList, divineBeastMarkRead = divineBeastMarkCtrl, divineBeastMarkCtrl
	for _, v in pairs(bagMarkData) do
		local cfg = v.markCfg
		if v.slot == nil and v.markId == self.mark.markId and v.star == 0 and v.bagMarkId ~= self.mark.bagMarkId then
			divineBeastMarkRead = v.bagMarkId
			local v.bagMarkId.data, markData = v, v.bagMarkId
			markData.order = -v.lv * 100 + cfg.quality * 10 + v.lock
			table.insert(self.markList, markData)
		end
	end
	table.sort(self.markList, function(a, b)
		if a.order ~= b.order then
			return a.order > b.order
		end
		return a.data.markId > b.data.markId
	end)
	local selectedNum = 0
	for i, v in ipairs(self.markList) do
		if v.data.lock == 0 then
			if selectedNum < self.nextStarCfg.need_mark then
				self.selectedMarks[v.data.bagMarkId] = v.data
				selectedNum = selectedNum + 1
			else
				self.selectedMarks[v.data.bagMarkId] = nil
			end
		end
	end
	self.fields.list_marks:setNumItems(#self.markList)
	self.fields.Txt_tip:setVisible(#self.markList == 0)
	self:recountNum()
end
function DivineBeastMarkStarPanel:recountNum()
	local selectedNum = table.nums(self.selectedMarks)
	_ENV = nil
	;(nil).num = self.nextStarCfg.need_mark
	;(nil).num2 = selectedNum
	self.fields.Txt_need:setString(i18n("Divine_beast_mark_text_70", nil))
	self.fields.Btn_up:setEnabled(selectedNum >= self.nextStarCfg.need_mark)
	self.selectedNum = selectedNum
end
function DivineBeastMarkStarPanel:onUpClick()
	SoraDPlaySound()
	local _ENV, useIds = SoraDPlaySound, SoraDPlaySound
	for k, v in pairs(self.selectedMarks) do
		table.insert(useIds, v.bagMarkId)
	end
	divineBeastMarkCtrl:sendUpStar(self.mark.bagMarkId, useIds)
	self:close()
end
function DivineBeastMarkStarPanel:onMoreClick()
	SoraDPlaySound()
	uiManager:show("DivineBeastMarkBuy", self.curShopItem)
end
function DivineBeastMarkStarPanel:onItemRenderer(index, obj)
	local mark = self.markList[index + 1].data
	obj:initData(mark)
	obj:showLongPress()
	obj:setSelected(self.selectedMarks[mark.bagMarkId] ~= nil)
	obj:setClickCallback(handler(self, self.onMarkClick))
end
function DivineBeastMarkStarPanel:onMarkClick(sender, mark)
	if mark == nil then
		return
	end
	if mark.lock == 1 then
		SoraDShowMsgTip(i18n("Divine_beast_mark_text_71"))
		return
	end
	if self.selectedMarks[mark.bagMarkId] == nil and table.nums(self.selectedMarks) >= self.nextStarCfg.need_mark then
		SoraDShowMsgTip(i18n("Divine_beast_mark_text_74"))
		return
	end
	self.selectedMarks[mark.bagMarkId] = self.selectedMarks[mark.bagMarkId] == nil and mark or nil
	sender:setSelected(self.selectedMarks[mark.bagMarkId] ~= nil)
	self:recountNum()
end
return DivineBeastMarkStarPanel
