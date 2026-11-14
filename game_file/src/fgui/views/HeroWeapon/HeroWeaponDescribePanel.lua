local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
local heroWeaponRead = include("heroWeaponRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroWeaponDescribePanel = class("HeroWeaponDescribePanel", baseFguiPanel)
function HeroWeaponDescribePanel:ctor(...)
	HeroWeaponDescribePanel.super.ctor(self, ...)
	print("HeroWeaponDescribePanel:ctor", self.viewName)
end
function HeroWeaponDescribePanel:onInit()
	print("=======HeroWeaponDescribePanel:onInit")
	self.isMaxView = false
	self.fields.Panel_bg:setString(i18n("common_text_777"))
	self.fields.Btn_merge:setString(i18n("common_text_1352"))
	self.fields.Btn_merge:addClickListener(handler(self, self.btnMergeClick))
	self.fields.Btn_merge:setEnabled(false)
	self.fields.Button_preview:setString(i18n("HeroWeapon_57"))
	self.fields.Button_preview:addClickListener(handler(self, self.btnPreviewClick))
	self.fields.nbg:fix()
	self.fields.Btn_merge:fixPos()
	self.fields.Button_preview:fixPos()
	self.fields.ComboBox:fixPos()
end
function HeroWeaponDescribePanel:onShow()
	print("=======HeroWeaponDescribePanel:onShow")
	self.weaponId = self.param.data.weaponId
	self.lv = self.param.data.lv or 0
	self.stage = self.param.data.stage or 0
	self.mergeCount = 1
	self:initData()
end
function HeroWeaponDescribePanel:initComboBox()
	local _ENV, items
	local _ENV, values
	self.mergeCount = math.min(self.mergeNum, self.mergeCount)
	for i = 1, 4 do
		if i <= self.mergeNum then
			_ENV = nil
			;(nil).num = i
			table.insert(items, i18n("HeroWeapon_65", nil))
			table.insert(values, i)
		end
	end
	table.insert(items, i18n("HeroWeapon_64"))
	table.insert(values, self.mergeNum)
	_ENV = i18n("HeroWeapon_64")
	i18n("HeroWeapon_64").items = items
	i18n("HeroWeapon_64").values = values
	i18n("HeroWeapon_64").changedCallback = handler(self, self.onComboBoxClick)
	self:setComboBox(self.fields.ComboBox, i18n("HeroWeapon_64"))
	local dropdown = self.fields.ComboBox:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxList:setSelectedIndex(math.min(self.mergeCount - 1, 4))
	end)
	_ENV = self
	self.num = self.mergeCount
	self.fields.ComboBox:setTitle(i18n("HeroWeapon_65", self))
end
function HeroWeaponDescribePanel:onComboBoxClick()
	SoraDPlaySound()
	self.mergeCount = tonumber(self.fields.ComboBox:getValue())
end
function HeroWeaponDescribePanel:initData()
	SoraDCloseLoading(self)
	local data = heroWeaponRead.getWeaponCfg(self.weaponId, self.stage)
	self.fields.weapon:initData(data)
	local recipientName = heroWeaponRead.getRecipientName(self.weaponId)
	self.controllers.c1:setSelectedIndex(recipientName and 1 or 0)
	self.view:fixChildrenPos()
	if recipientName then
		self.fields.Text_pro:setString(recipientName)
	end
	self.fields.nbg:setSpriteFrame(heroWeaponRead.getWeaponNBg(self.weaponId))
	self:setPreview()
	local chipID = data.synthesis[1]
	local need = data.synthesis[2]
	local num = backpackCtrl:getItemCount(chipID)
	self.mergeNum = math.floor(num / need)
	self.fields.item:initData(chipID)
	_ENV = heroWeaponRead.getWeaponNBg(self.weaponId)
	heroWeaponRead.getWeaponNBg(self.weaponId).num = fguiHelper.getColorString(need > num and "#E02B2B" or "#FFFBD5", num)
	heroWeaponRead.getWeaponNBg(self.weaponId).need = need
	self.fields.Text_count:setString(i18n("%{num}/%{need}", heroWeaponRead.getWeaponNBg(self.weaponId)))
	self.fields.Btn_merge:setEnabled(need <= num)
	local isHave = heroWeaponCtrl:getWeaponByID(self.weaponId) and true or false
	self.fields.Text_curMaxStage:setVisible(isHave)
	self.fields.Text_toMaxNeed:setVisible(isHave)
	if isHave then
		_ENV = i18n("%{num}/%{need}", heroWeaponRead.getWeaponNBg(self.weaponId))
		i18n("%{num}/%{need}", heroWeaponRead.getWeaponNBg(self.weaponId)).stage = heroWeaponCtrl:getWeaponMaxStage(self.weaponId)
		self.fields.Text_curMaxStage:setString(i18n("HeroWeapon_62", i18n("%{num}/%{need}", heroWeaponRead.getWeaponNBg(self.weaponId))))
		local maxStage = heroWeaponCtrl:getWeaponMaxStage(self.weaponId)
		local curNum, needNum = heroWeaponCtrl:getToMaxNeed(self.weaponId, math.floor(num / need))
		_ENV = math.floor(num / need)
		math.floor(num / need).num = fguiHelper.getColorString(curNum < needNum and "#E02B2B" or "#D7C39B", curNum)
		math.floor(num / need).need = needNum
		self.fields.Text_toMaxNeed:setString(i18n("HeroWeapon_63", math.floor(num / need)))
		self.fields.Text_toMaxNeed:setVisible(maxStage < heroWeaponRead.getMaxStage())
	end
	self.fields.ComboBox:setVisible(1 < self.mergeNum)
	if 1 < self.mergeNum then
		self:initComboBox()
	else
		self.mergeCount = 1
	end
end
function HeroWeaponDescribePanel:cloneData(data)
	local _ENV, cloneData
	for k, v in pairs(data) do
		cloneData[k] = v
	end
	return cloneData
end
function HeroWeaponDescribePanel:setAttr(data)
	self.fields.stars:setStage(data.stage)
	self.fields.Com_attr:initData(data)
end
function HeroWeaponDescribePanel:setPreview()
	self.fields.Button_preview:setString(self.isMaxView and i18n("HeroWeapon_61") or i18n("HeroWeapon_57"))
	local data = heroWeaponRead.getWeaponCfg(self.weaponId, self.stage)
	_ENV = nil
	;(nil).name = heroWeaponRead.getWeaponName(self.weaponId)
	_ENV = nil
	;(nil).lv = self.isMaxView and heroWeaponRead.getMaxLv() or self.lv
	;(nil).lv = i18n("common_text_100", nil)
	self.fields.Text_name:setString(i18n("%{lv} %{name}", nil))
	if self.isMaxView then
		local cfg = heroWeaponRead.getWeaponCfg(self.weaponId, heroWeaponRead.getMaxStage())
		data = self:cloneData(cfg)
		data.lv = heroWeaponRead.getMaxLv()
	end
	self:setAttr(data)
end
function HeroWeaponDescribePanel:btnPreviewClick()
	SoraDPlaySound()
	self.isMaxView = not self.isMaxView
	self:setPreview()
end
function HeroWeaponDescribePanel:btnMergeClick()
	SoraDPlaySound()
	heroWeaponCtrl:reqMerge(self.weaponId, self.mergeCount)
	SoraDShowLoading(self)
end
return HeroWeaponDescribePanel
