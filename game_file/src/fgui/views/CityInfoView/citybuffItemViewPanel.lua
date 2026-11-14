local buffCtrl = SoraDGetCtrl("buffCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local buffDesRead = include("buffDesRead")
local itemLogic = include("itemLogic")
local itemDesRead = include("itemDesRead")
local CityEffectInfoRead = include("cityEffectInfoRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local citybuffItemViewPanel = class("citybuffItemViewPanel", baseFguiPanel)
function citybuffItemViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("citybuffItemViewPanel:ctor", self.viewName)
end
function citybuffItemViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function citybuffItemViewPanel:onInit()
	print("=======citybuffItemViewPanel:onInit")
	self.tblBuffList, _ENV, self.isHideCurrentSceneView = print, print, true
	self.fields.Com_title:initData("", handler(self, self.onClickClose))
	self.fields.Button_closeBuff:setString(i18n("common_text_2088"))
	self.fields.Button_closeBuff:addClickListener(handler(self, self.onBtnCloseBuffClick))
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
	self.fields.bar:setScale(SoraDFIsRA() and -1 or 1)
end
function citybuffItemViewPanel:onListRenderer(index, obj)
	obj:initData(self.tblBuffList[index + 1])
end
function citybuffItemViewPanel:onShow()
	print("=======citybuffItemViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.tableBuff = self.param.tableBuff
	self.isNewPlayer = self.param.isNewPlayer
	self:initData()
end
function citybuffItemViewPanel:initData()
	self.fields.Com_title:updateTitle(self.tableBuff.buffname)
	self.fields.Text_des:setString(self.tableBuff.buftip)
	if self.tableBuff.bid == gBuffEffect.MASSACRE and worldMapDefine.isInPyramid() then
		self.fields.Text_des:setString(self.tableBuff.buftip .. fguiHelper.getColorString("#FF0000", i18n("common_text_4707")))
	end
	self:update()
end
function citybuffItemViewPanel:update()
	local buffData = buffCtrl:queryCityBuff(self.tableBuff.bid)
	if self.isNewPlayer then
		buffData = buffCtrl:queryNewPlayerBuff(self.tableBuff.bid)
	end
	if buffData then
		if self.tableBuff.bid == gBuffEffect.ANTI_SCOUT then
			self.controllers.c1:setSelectedIndex(2)
		else
			self.controllers.c1:setSelectedIndex(1)
		end
		self.fields.bar:setMax(buffData:getProperty("time"))
		self.fields.Text_time:setTimeUpdateListener(function(time)
			if time <= 0 then
				self.controllers.c1:setSelectedIndex(0)
			end
			self.fields.bar:setValue(time)
			self = nil
			;(nil).time = SoraDConvertSecondToString(time)
			self.fields.Text_time:setString(i18n("common_text_421", nil))
		end)
		self.fields.Text_time:beginTime(buffData:getRemainTime())
		local id = buffData:getProperty("effectType")
		local value = buffData:getProperty("effect")
		if "boolean" == type(value) then
			self.fields.Text_int:setString(i18n("common_text_246"))
		elseif "number" == type(value) then
			buffCtrl = i18n("common_text_246")
			i18n("common_text_246").val = buffDesRead.getTitleValueWithValue(id, value)
			self.fields.Text_int:setString(i18n("common_text_2837", i18n("common_text_246")))
		end
		self.fields.Text_time:fixPos()
		self.fields.Text_int:fixPos()
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	self.tblBuffList, buffCtrl = self.controllers.c1.setSelectedIndex, self.controllers.c1.setSelectedIndex
	local buffCtrl, tblBuffList = self.controllers.c1.setSelectedIndex, self.controllers.c1.setSelectedIndex
	if not self.isNewPlayer then
		tblBuffList = buffCtrl:getBuffItemArray(self.tableBuff.bid)
	end
	table.sort(tblBuffList, function(a, b)
		return a < b
	end)
	for k, v in ipairs(tblBuffList) do
		local itemCount = backpackCtrl:getItemCount(v)
		local itemInfo = gModuleMgr.sharedMgr("shopltCtrl"):getShopItemByItemID(v)
		local limitInfo = itemInfo and shopCtrl:getLimitDataByID(itemInfo.shopItemID)
		if 0 < itemCount then
			if itemLogic.checkUseCond(v) then
				buffCtrl = i18n("common_text_2837", i18n("common_text_246"))
				i18n("common_text_2837", i18n("common_text_246")).iid = v
				i18n("common_text_2837", i18n("common_text_246")).count = itemCount
				table.insert(self.tblBuffList, i18n("common_text_2837", i18n("common_text_246")))
			end
		elseif itemInfo and itemLogic.checkUseCond(v) then
			buffCtrl = i18n("common_text_2837", i18n("common_text_246"))
			i18n("common_text_2837", i18n("common_text_246")).iid = v
			i18n("common_text_2837", i18n("common_text_246")).gold = itemInfo.price
			i18n("common_text_2837", i18n("common_text_246")).shopID = itemInfo.shopItemID
			table.insert(self.tblBuffList, i18n("common_text_2837", i18n("common_text_246")))
		end
	end
	self.fields.List:setNumItems(#self.tblBuffList)
end
function citybuffItemViewPanel:onBtnCloseBuffClick()
	SoraDPlaySound()
	buffCtrl:closeAntiScoutBuff()
end
return citybuffItemViewPanel
