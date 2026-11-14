local manorCityRead = include("manorCityRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local publicRead = include("publicRead")
local manorCityUtil = include("manorCityUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ManorDressUpgradePanel = class("ManorDressUpgradePanel", baseFguiPanel)
function ManorDressUpgradePanel:ctor(...)
	self.isLRU = true
	ManorDressUpgradePanel.super.ctor(self, ...)
	print("ManorDressUpgradePanel:ctor", self.viewName)
end
function ManorDressUpgradePanel:onInit()
	print("=======ManorDressUpgradePanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_055"))
	self.fields.Button_upgrade:setString(i18n("common_text_055"))
	self.fields.Button_upgrade:addClickListener(handler(self, self.onClickBtnUpgrade))
	self.fields.Text_build:setString(i18n("text_key"))
	self.fields.Button_piece:setString(i18n("common_text_1889"))
	self.fields.Button_piece:addClickListener(handler(self, self.onClickBtnPiece))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Label_title:setString(i18n("garden_text_02"))
	local _fields = fguiHelper.get_fields(self.fields.Com_need)
	_fields.Button_add:addClickListener(handler(self, self.onClickBtnAdd))
	self.bar_need = _fields.bar
	if not SoraDFIsRA() then
		self.fields.Com_need:fixChildrenPos()
		local _fields = fguiHelper.get_fields(self.fields.Button_piece)
		_fields.Text_num:fixPos()
	end
end
function ManorDressUpgradePanel:endShow()
	print("=======ManorDressUpgradePanel:endShow")
	SoraDCloseLoading(self)
	self.dressID = self.param.dressID
	if manorCityCtrl:getDressIsMaxLv(self.dressID) then
		self:closePanel()
		return
	end
	local dressLv = manorCityCtrl:getDressLv(self.dressID)
	local costRes = manorCityRead.getDressCostRes(self.dressID, dressLv + 1)
	self.costID = costRes[1]
	self.costCount = costRes[2]
	self.pieceID = manorCityRead.getDressItemPieceID(self.costID)
	self.fields.Com_need:setIcon(publicRead.getIcon(self.costID))
	self.fields.Button_piece:setIcon(publicRead.getIcon(self.pieceID))
	self:initData()
end
function ManorDressUpgradePanel:initData()
	local dressLv = manorCityCtrl:getDressLv(self.dressID)
	local costRes = manorCityRead.getDressCostRes(self.dressID, dressLv + 1)
	self.costID = costRes[1]
	self.costCount = costRes[2]
	self:showDressInfo()
	self:updateComNeed()
	self.bar_need:setMax(self.costCount)
	self:updateBtnPiece()
	self.tableUpData = manorCityUtil.getDressUpgradeInfo(self.dressID, dressLv)
	self.fields.List:setNumItems(#self.tableUpData)
end
function ManorDressUpgradePanel:showDressInfo()
	local buildName = manorCityRead.getDressName(self.dressID)
	self.fields.Text_build:setString(buildName)
	local _fields = fguiHelper.get_fields(self.fields.Com_build)
	local quality = manorCityRead.getDressQuality(self.dressID)
	local bgName = manorCityRead.getDressQualityBg(quality)
	_fields.bg:setURL(bgName)
	local imageName = manorCityRead.getDressSmallImage(self.dressID)
	_fields.Image_build:setURL(imageName)
	local lv = manorCityCtrl:getDressLv(self.dressID)
	manorCityRead = nil
	;(nil).lv = lv
	local lvStr = i18n("common_text_100", nil)
	_fields.Text_lv:setString(lvStr)
end
function ManorDressUpgradePanel:updateComNeed()
	local itemHave = manorCityCtrl:getItemCount(self.costID)
	self.bar_need:setValue(itemHave)
end
function ManorDressUpgradePanel:updateBtnPiece()
	local showPiece = self.pieceID > 0
	self.fields.Button_piece:setVisible(showPiece)
	if not showPiece then
		return
	end
	local _fields = fguiHelper.get_fields(self.fields.Button_piece)
	local itemCount = manorCityCtrl:getItemCount(self.pieceID)
	_fields.Text_num:setString(itemCount)
end
function ManorDressUpgradePanel:onClickBtnUpgrade(context)
	SoraDPlaySound()
	local itemHave = manorCityCtrl:getItemCount(self.costID)
	if itemHave < self.costCount then
		local itemName = publicRead.getName(self.costID)
		_ENV = nil
		;(nil).item = itemName
		SoraDShowMsgTip(i18n("jinn_skill_23", nil))
		return
	end
	manorCityCtrl:reqDressUpLv(self.dressID)
	SoraDShowLoading(self)
end
function ManorDressUpgradePanel:onClickBtnPiece(context)
	SoraDPlaySound()
	local fullCost = 0
	local dressLv = manorCityCtrl:getDressLv(self.dressID)
	local maxLv = manorCityRead.getDressMaxLv(self.dressID)
	for i = dressLv + 1, maxLv do
		local costRes = manorCityRead.getDressCostRes(self.dressID, i)
		fullCost = fullCost + costRes[2] or 0
	end
	_ENV = nil
	;(nil).toID = self.costID
	;(nil).costCount = self.costCount
	;(nil).fullCost = fullCost
	uiManager:show("ManorDressExchange", nil)
end
function ManorDressUpgradePanel:onItemRenderer(index, obj)
	local data = self.tableUpData[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	local state = obj:getController("state")
	if data.isNew then
		state:setSelectedIndex(1)
	elseif data.isLock then
		state:setSelectedIndex(2)
	else
		state:setSelectedIndex(0)
	end
	if data.isLock then
		local unlockLv = data.unlockLv
		_ENV = nil
		;(nil).num = unlockLv
		local unlockStr = "(" .. i18n("artifact_text_01", nil) .. ")"
		_ENV = nil
		;(nil).color = "#FF0000"
		unlockStr = SoraDWrapHtmlTagByStyle(unlockStr, nil)
		_fields.Text_title:setString(data.title .. unlockStr)
		_fields.Text_valueLock:setString(data.value)
	else
		_fields.Text_title:setString(data.title)
		_fields.Text_value1:setString(data.value)
		_fields.Text_value2:setString(data.nextValue)
	end
	if not SoraDFIsRA() then
		state:fix()
		obj:fixChildrenPos()
		_fields.arr_value:fix()
	end
end
function ManorDressUpgradePanel:onMsgDressExchange(...)
	self:updateComNeed()
	self:updateBtnPiece()
end
function ManorDressUpgradePanel:onMsgBackpackUpdate()
	self:updateComNeed()
	self:updateBtnPiece()
end
function ManorDressUpgradePanel:onMsgDressUpdate(target, event)
	SoraDCloseLoading(self)
	if manorCityCtrl:getDressIsMaxLv(self.dressID) then
		self:closePanel()
		return
	end
	self:initData()
	local upDressID = event.upDressID
	if upDressID and upDressID == self.dressID then
		self.fields.ani_glow:setVisible(true)
		local mv_glow = self.fields.ani_glow:getChild("mv_glow")
		mv_glow:setFrames("dh_baoshi_kuang_%02d.png", function()
			self.fields.ani_glow:setVisible(false)
		end)
	end
end
function ManorDressUpgradePanel:onClickBtnAdd(context)
	SoraDPlaySound()
	local getWayStr = manorCityRead.getDressGetWay(self.dressID)
	_ENV = nil
	;(nil).itemID = self.costID
	;(nil).desStr = getWayStr
	uiManager:show("CommonSourceGuide", nil)
end
return ManorDressUpgradePanel
