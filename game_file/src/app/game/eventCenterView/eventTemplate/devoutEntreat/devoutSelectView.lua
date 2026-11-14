local devoutEntreatCtrl = SoraDGetCtrl("devoutEntreatCtrl")
local devoutEntreatRead = include("devoutEntreatRead")
local devoutSelectView = class("devoutSelectView", function(target)
	return target or SoraDCreateTouchPanel("devoutSelectView")
end)
_ENV = "devoutSelectView"
;("devoutSelectView")[1] = "common_text_2697"
;("devoutSelectView")[2] = "begging_text_03"
local ("devoutSelectView")[3], titleName = "begging_text_02", "devoutSelectView"
function devoutSelectView:ctor()
	self.itemsEntity, _ENV = nil, nil
	self.beforeIndex = nil
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.scroll = SoraDGetChildByName(self, "ScrollView_reward")
	self.btnConfirm = SoraDGetChildByName(self, "Button_confirm")
	self.btnConfirm:setTitleText(i18n("common_text_054"))
	self.btnConfirm:addTouchEventListener(handler(self, self.btnClickConfirm))
	self.btnConfirm:setBright(false)
end
function devoutSelectView:initData(index)
	self.position = 9 - index
	self.beforeIndex = devoutEntreatCtrl:getIndexByPosition(self.position)
	local groupType = devoutEntreatRead.getGroupByPosition(index)
	self.groupInfoTbl = devoutEntreatRead.getGroupInfo(devoutEntreatCtrl:getClassType(), groupType)
	devoutEntreatCtrl = nil
	;(nil).type = i18n(titleName[groupType])
	self.ccs_bg:setTitleName(i18n("begging_text_07", nil))
	local scrollInner = self.scroll:getInnerContainer()
	local scrollInnerNewH = math.max(100 * table.nums(self.groupInfoTbl), self.scroll:getContentSize().height)
	local scrollW = self.scroll:getContentSize().width
	for i, v in ipairs(self.groupInfoTbl) do
		local single = include("commonSelectSingleResource").new()
		single:addTo(self.scroll)
		single:setPosition(0.5 * scrollW, scrollInnerNewH - 100 * i + 25)
		devoutEntreatCtrl = single.setPosition
		single.setPosition.id = v.item[1]
		local single.setPosition.count, temp = v.item[2], single.setPosition
		single:initData(temp, self.scroll)
		single:setHandle(handlerEx(self, self.btnClickSelected, v.index))
		table.insert(self.itemsEntity, single)
		print("···", v.index, devoutEntreatCtrl:isItemSelected(v.index))
		if self.beforeIndex == v.index then
			self.beforeEntity = single
			single:setCheck(true)
		elseif devoutEntreatCtrl:isItemSelected(v.index) then
			single:setCheckBoxGray()
		end
	end
	self.scroll:setInnerContainerSize(cc.size(scrollW, scrollInnerNewH))
	self.scroll:jumpToTop()
end
function devoutSelectView:btnClickSelected(index, button, eventType)
	self.btnConfirm:setBright(true)
	if self.beforeEntity then
		self.beforeEntity:setCheck(false)
	end
	self.beforeEntity = button
	self.index = index
end
function devoutSelectView:btnClickConfirm(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).position = self.position
		;(nil).index = self.index
		devoutEntreatCtrl:sendChooseMsg(nil)
		self:layerClickCallBack(self, ccui.TouchEventType.ended)
	end
end
return devoutSelectView
