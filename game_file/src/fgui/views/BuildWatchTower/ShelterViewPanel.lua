local warShelterCtrl = SoraDGetCtrl("warShelterCtrl")
local buffCtrl = SoraDGetCtrl("buffCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local itemLogic = include("itemLogic")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ShelterViewPanel = class("ShelterViewPanel", baseFguiPanel)
function ShelterViewPanel:ctor(...)
	self.isLRU = true
	ShelterViewPanel.super.ctor(self, ...)
	print("ShelterViewPanel:ctor", self.viewName)
end
function ShelterViewPanel:onInit()
	print("=======ShelterViewPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initData(i18n("war_shelter_002"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_noneTip:setString(i18n("war_shelter_018"))
	self.fields.Label_title:setString(i18n("war_shelter_031"))
	self.fields.Com_add:addClickListener(handler(self, self.btnAddClick))
	self.fields.Button_operate:setString(i18n("war_shelter_025"))
	self.fields.Button_operate:addClickListener(handler(self, self.btnOperateClick))
	self.fields.Button_apply:setString(i18n("friend_btn_03"))
	self.fields.Button_apply:addClickListener(handler(self, self.btnApplyClick))
	self.fields.Label_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = fguiHelper.getColorString("#70C723", time)
		return i18n("war_shelter_006", nil)
	end)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function ShelterViewPanel:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1])
end
function ShelterViewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("common_text_1173")
	;(nil).content = i18n("war_shelter_005")
	uiManager:show("RuleView", nil)
end
function ShelterViewPanel:getItemList()
	local buffCtrl, tbList
	local tblBuffList = buffCtrl:getBuffItemArray(gBuffEffect.PEACE_SHIELD)
	table.sort(tblBuffList, function(a, b)
		return a < b
	end)
	for k, v in ipairs(tblBuffList) do
		local itemCount = backpackCtrl:getItemCount(v)
		local itemInfo = gModuleMgr.sharedMgr("shopltCtrl"):getShopItemByItemID(v)
		local limitInfo = itemInfo and shopCtrl:getLimitDataByID(itemInfo.shopItemID)
		if 0 < itemCount then
			if itemLogic.checkUseCond(v) then
				buffCtrl = nil
				;(nil).iid = v
				;(nil).count = itemCount
				table.insert(tbList, nil)
			end
		elseif itemInfo and itemLogic.checkUseCond(v) then
			buffCtrl = nil
			;(nil).iid = v
			;(nil).gold = itemInfo.price
			;(nil).shopID = itemInfo.shopItemID
			table.insert(tbList, nil)
		end
	end
	return tbList
end
function ShelterViewPanel:endShow()
	print("=======ShelterViewPanel:endShow")
	self.tag = 1
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("war_shelter_004")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("war_shelter_003")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onClickTab)
	;(nil).unDefaultClick = true
	self.fields.com_Tab:initView(nil)
	self.fields.com_Tab:setTabIndex(self.tag)
	warShelterCtrl:reqData()
	SoraDShowLoading(self)
end
function ShelterViewPanel:onClickTab(tag)
	self.tag = tag
	self:updateUI()
end
function ShelterViewPanel:setPlayerInfo()
	local shelter
	local leftTime = -1
	local isInSpecial = false
	if self.tag == 1 then
		shelter = warShelterCtrl:getShelterTo()
		leftTime = warShelterCtrl:getShelterToLeftTime()
		isInSpecial = warShelterCtrl:isInSpecialMap()
	else
		shelter = warShelterCtrl:getShelterFrom()
		leftTime = warShelterCtrl:getShelterFromLeftTime()
	end
	if shelter then
		self.fields.Com_head:setHeadSprite(shelter.headid, shelter.avatar)
		self.fields.Com_head:setPlayerID(shelter.uid)
		self.fields.Com_head:setKid(shelter.kid)
		self.fields.Text_name:setString(textParser.formatPlayerName(nil, shelter.name, shelter.kid))
	end
	if isInSpecial then
		self.fields.Label_time:endTime()
		self.fields.Label_time:setString(i18n("war_shelter_008"))
	elseif 0 < leftTime then
		self.fields.Label_time:setTimeEndListener(function()
			self.fields.Label_time:setString(i18n("war_shelter_007"))
		end)
		self.fields.Label_time:beginTime(leftTime)
	else
		self.fields.Label_time:endTime()
		self.fields.Label_time:setString(i18n("war_shelter_007"))
	end
end
function ShelterViewPanel:updateUI(target, data)
	SoraDCloseLoading(self)
	if self.tag == 1 then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Text_tip:setString(i18n("war_shelter_022"))
		self.fields.Text_status:setString(i18n("war_shelter_024"))
		local shelterTo = warShelterCtrl:getShelterTo()
		if shelterTo then
			self.fields.Com_add:setVisible(false)
			self.fields.Com_head:setVisible(true)
			self.fields.Text_name:setVisible(true)
			self.fields.Button_operate:setVisible(true)
			self.fields.Label_title:setVisible(true)
			self.fields.List:setVisible(true)
			self.itemList = self:getItemList()
			self.fields.List:setNumItems(#self.itemList)
			self:setPlayerInfo()
		else
			self.fields.Com_add:setVisible(true)
			self.fields.Com_head:setVisible(false)
			self.fields.Text_name:setVisible(false)
			self.fields.Button_operate:setVisible(false)
			self.fields.Label_title:setVisible(false)
			self.fields.List:setVisible(false)
			self.fields.Label_time:endTime()
			self.fields.Label_time:setString(i18n("war_shelter_009"))
		end
	else
		self.fields.Text_tip:setString(i18n("war_shelter_023"))
		self.fields.Text_status:setString(i18n("war_shelter_041"))
		local shelterFrom = warShelterCtrl:getShelterFrom()
		if shelterFrom then
			self.controllers.c1:setSelectedIndex(0)
			self.fields.Com_add:setVisible(false)
			self.fields.Com_head:setVisible(true)
			self.fields.Text_name:setVisible(true)
			self.fields.Button_operate:setVisible(true)
			self.fields.Label_title:setVisible(false)
			self.fields.List:setVisible(false)
			self:setPlayerInfo()
		else
			self.controllers.c1:setSelectedIndex(1)
		end
	end
	local isShowRed = warShelterCtrl:hasNewInviteRecvRed()
	self.fields.com_Tab:setBtnRedDot(2, isShowRed)
	self.fields.Button_apply:setReddot(isShowRed)
end
function ShelterViewPanel:btnAddClick()
	SoraDPlaySound()
	uiManager:show("ShelterSearch")
end
function ShelterViewPanel:btnOperateClick()
	SoraDPlaySound()
	if self.tag == 1 then
		_ENV = nil
		;(nil).content = i18n("war_shelter_010")
		;(nil).confirmFunc = function()
			warShelterCtrl:reqReleaseTo()
		end
		;(nil).cancelString = i18n("common_text_185")
		uiManager:show("MessageBox", nil)
	else
		_ENV = nil
		;(nil).content = i18n("war_shelter_017")
		;(nil).confirmFunc = function()
			warShelterCtrl:reqReleaseFrom()
		end
		;(nil).cancelString = i18n("common_text_185")
		uiManager:show("MessageBox", nil)
	end
end
function ShelterViewPanel:btnApplyClick()
	SoraDPlaySound()
	uiManager:show("ShelterApply")
end
return ShelterViewPanel
