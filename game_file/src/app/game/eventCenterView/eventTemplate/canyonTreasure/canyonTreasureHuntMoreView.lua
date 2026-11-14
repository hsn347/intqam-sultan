local gametop = gModuleMgr.getObject("gametop")
local canyonTreasureCtrl = gametop.playertop_:getModule("canyonTreasureCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local canyonTreasureHuntRead = include("canyonTreasureHuntRead")
local canyonTreasureHuntMoreView = class("canyonTreasureHuntMoreView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("canyonTreasureHuntMoreView")
	end
	return target
end)
function canyonTreasureHuntMoreView:ctor()
	self:initControls()
end
function canyonTreasureHuntMoreView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.activityID = gActivityTimeActivityID.CANYON_TREASURE_HUNT
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	local preViewHeight = 960
	local curHeight = display.height
	local setSize = cc.size(self.ccs_bg:getContentSize().width, self.ccs_bg:getContentSize().height + curHeight - preViewHeight - 200)
	self.ccs_bg:setSize(setSize)
	self.ccs_bg:setPositionY(-setSize.height / 2)
	self.Image_1:setPositionX(setSize.width / 2)
	self.Top_Size_ScrollView_info:setContentSize(cc.size(570, setSize.height - 200))
	self.Top_Size_ScrollView_info:setPositionY(setSize.height / 2 - 150)
	self.ccs_bg:setTitleName(i18n("Canyon_Treasur_text_26"))
	self.canyouType = gCanyonTreasureHuntType.HIGH
	local ccs_tab = SoraDCreatePanel("commonTabBtnEX")
	ccs_tab:addTo(self.Center_Node)
	ccs_tab:setPosition(0, self.ccs_bg:getSize().height / 2 - 80)
	ccs_tab:setContentSize(cc.size(574, 56))
	ccs_tab:setNewStyle()
	_ENV, _ENV, self.ccs_tab = ccs_tab, ccs_tab.setNewStyle, ccs_tab
	ccs_tab.title = i18n("Canyon_Treasur_text_02")
	_ENV, ccs_tab.setNewStyle[1], ccs_tab.handle = ccs_tab, ccs_tab, handler(self, self.btn_onClick_btns)
	ccs_tab.title = i18n("Canyon_Treasur_text_03")
	ccs_tab.setNewStyle[2], ccs_tab.handle = ccs_tab, handler(self, self.btn_onClick_btns)
	local tabConfig = ccs_tab.setNewStyle
	_ENV = self
	self.tabNum = #tabConfig
	self.defaultClick = self.canyouType
	self.tabsetArray = tabConfig
	self.ccs_tab:initView(self)
	self.text_tip:setString(i18n("Canyon_Treasur_text_23"))
	self.Text_times:setString(i18n("Canyon_Treasur_text_21"))
	self.Text_discount_value:setString(i18n("Canyon_Treasur_text_22"))
	self.Text_times:setPosition(SoraDFSign(145), self.ccs_bg:getSize().height / 2 - 125)
	self.Text_discount_value:setPosition(-SoraDFSign(145), self.ccs_bg:getSize().height / 2 - 125)
	SoraDSetTextWidthHeight(self.text_tip, cc.size(550, 60))
end
function canyonTreasureHuntMoreView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function canyonTreasureHuntMoreView:initScroll(canyonType)
	local dataTypeTable = canyonTreasureHuntRead.getDisCountByType(canyonType)
	if next(dataTypeTable) then
		self.Top_Size_ScrollView_info:removeAllChildren()
		local scrollH = math.max(self.Top_Size_ScrollView_info:getContentSize().height, #dataTypeTable * 90)
		self.Top_Size_ScrollView_info:setInnerContainerSize(cc.size(self.Top_Size_ScrollView_info:getContentSize().width, scrollH))
		for i, v in ipairs(dataTypeTable) do
			local cell = self.Node_single:clone()
			cell:setPosition(self.Top_Size_ScrollView_info:getContentSize().width / 2, scrollH - (i - 1) * 35)
			cell:addTo(self.Top_Size_ScrollView_info)
			local Text_rank = SoraDGetChildByName(cell, "Text_rank")
			local imgWhite = SoraDGetChildByName(cell, "Image_71")
			local Text_discount = SoraDGetChildByName(cell, "Text_discount")
			if v.num[1] >= 500 then
				Text_rank:setString(string.format("%d+", 500))
			else
				Text_rank:setString(string.format("%d-%d", v.num[1], v.num[2]))
			end
			Text_discount:setString(v.dicount .. "%")
			imgWhite:setVisible(i % 2 ~= 0)
		end
	end
end
function canyonTreasureHuntMoreView:initData(canyonType)
	if not canyonType then
		return
	end
	self:initScroll(canyonType)
end
function canyonTreasureHuntMoreView:btn_onClick_btns(tag, name)
	print("slkdjfsdlkfjslkdjf", tag)
	self:initData(tag)
end
function canyonTreasureHuntMoreView:btnTreasureCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowLoading()
		canyonTreasureCtrl:reqLottery(self.otherData.canyonTreasureType, self.otherData.times, true)
		self:removeFromParent()
	end
end
function canyonTreasureHuntMoreView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return canyonTreasureHuntMoreView
