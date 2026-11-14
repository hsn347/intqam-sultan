local gametop = gModuleMgr.getObject("gametop")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaAllStarRead = include("nebulaAllStarRead")
local publicRead = include("publicRead")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarHospitalPanel = class("NebulaAllStarHospitalPanel", baseFguiPanel)
function NebulaAllStarHospitalPanel:ctor(...)
	NebulaAllStarHospitalPanel.super.ctor(self, ...)
	print("NebulaAllStarHospitalPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.curValue = nil
	self.NumOfTreatments = nebulaAllStarRead.getConstValue("NumOfTreatments", 1000)
	self.HealingItemPay = nebulaAllStarRead.getConstValue("HealingItemPay")
end
function NebulaAllStarHospitalPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CommonDispatch"
	end
	return self._packageList
end
function NebulaAllStarHospitalPanel:onInit()
	print("=======NebulaAllStarHospitalPanel:onInit")
	self.fields.Com_title:initData(i18n("NebulaAllstar_145"), handler(self, self.onClickClose))
	self.fields.Button_armyHelp:addClickListener(handler(self, self.onClickBtnArmyHelp))
	self.fields.Text_cure:setString(i18n("NebulaAllstar_401"))
	self.fields.Com_slider:setSliderCallBack(handler(self, self.onSliderCallBack))
	self.fields.Button_cure:setString(i18n("Divine_beast_text_08"))
	self.fields.Button_cure:addClickListener(handler(self, self.onClickBtnCure))
	self.fields.Text_des:setString(i18n("NebulaAllstar_150"))
	_UPVALUE2_ = self.fields.Text_des.setString
	self.fields.Text_des.setString[1] = gIDDef.NEBULA_ALLSTAR_BANDAGE
	local self.fields.Text_des.setString[2], config = self.HealingItemPay, self.fields.Text_des.setString
	local itemName = publicRead.getName(config[1])
	_ENV = i18n("NebulaAllstar_150")
	i18n("NebulaAllstar_150").name = itemName
	i18n("NebulaAllstar_150").num = self.NumOfTreatments
	self.fields.Text_itemTip:setString(i18n("NebulaAllstar_147", i18n("NebulaAllstar_150")))
	self.itemList, _ENV = self.fields.Text_itemTip.setString, self.fields.Text_itemTip.setString
	for i = 1, 2 do
		local obj = self.fields["Com_item" .. i]
		local itemID = config[i]
		if itemID then
			local _fields = fguiHelper.get_fields(obj)
			_fields.Com_item:initData(itemID)
			_fields.Com_item:hideFrameAndQuality()
			_fields.Button_add:addClickListener(handlerEx(self, self.onClickBtnAdd, itemID))
			_ENV = handlerEx(self, self.onClickBtnAdd, itemID)
			handlerEx(self, self.onClickBtnAdd, itemID).widget = _fields.title
			handlerEx(self, self.onClickBtnAdd, itemID).itemID = itemID
			handlerEx(self, self.onClickBtnAdd, itemID).Text_cost = _fields.Text_cost
			table.insert(self.itemList, handlerEx(self, self.onClickBtnAdd, itemID))
		else
			obj:setVisible(false)
		end
	end
end
function NebulaAllStarHospitalPanel:onShow()
	print("=======NebulaAllStarHospitalPanel:onShow")
	self:updateCureArmy()
	local selfUid = gametop.playertop_:getPlayerID()
	nebulaAllStarCtrl:reqPlayerData(selfUid, "NebulaAllStarHospitalPanel")
end
function NebulaAllStarHospitalPanel:onClickBtnArmyHelp()
	SoraDPlaySound()
	uiManager:show("NebulaAllStarHospitalHelp")
end
function NebulaAllStarHospitalPanel:onClickBtnAdd(itemID)
	SoraDPlaySound()
	if itemID == self.HealingItemPay and nebulaAllStarUtil.isWarTest() then
		SoraDShowMsgTip(i18n("NebulaAllstar_288"))
		return
	end
	_ENV = i18n("NebulaAllstar_288")
	i18n("NebulaAllstar_288").itemID = itemID
	uiManager:show("CommonSourceGuide", i18n("NebulaAllstar_288"))
end
function NebulaAllStarHospitalPanel:onSliderCallBack(curValue)
	if self.curValue == curValue then
		return
	end
	self.curValue = curValue
	if self.curValue == 0 then
		self.fields.Button_cure:setEnabled(false)
	else
		self.fields.Button_cure:setEnabled(true)
	end
	local useNum = math.ceil(self.curValue / self.NumOfTreatments)
	for __, cfg in ipairs(self.itemList) do
		local _useNum = math.min(cfg.totalNum, useNum)
		_ENV = nil
		;(nil).num = string.formatnumberthousands(_useNum)
		cfg.Text_cost:setString(i18n("NebulaAllstar_400", nil))
		useNum = useNum - _useNum
	end
end
function NebulaAllStarHospitalPanel:onClickBtnCure()
	SoraDPlaySound()
	if self.curValue and self.curValue > 0 then
		nebulaAllStarCtrl:reqCureArmy(self.curValue)
		SoraDShowLoading(self:displayObject())
	end
end
function NebulaAllStarHospitalPanel:updateCureArmy(...)
	self:updateItemCount()
	self:updateTextCurNum()
	self:updateComSlider()
end
function NebulaAllStarHospitalPanel:updateBandageCount(...)
	self:updateItemCount()
	self:updateComSlider(true)
end
function NebulaAllStarHospitalPanel:updateWoundedArmy(...)
	self:updateItemCount()
	self:updateTextCurNum()
	self:updateComSlider(true)
end
function NebulaAllStarHospitalPanel:updateItemCount(...)
	local itemCount = 0
	for __, cfg in ipairs(self.itemList) do
		cfg.totalNum = nebulaAllStarCtrl:getItemCount(cfg.itemID)
		itemCount = itemCount + cfg.totalNum
		local num = string.formatnumberthousands(cfg.totalNum)
		_ENV = nil
		;(nil).num = num
		cfg.widget:setString(i18n("common_text_531", nil))
	end
	self.itemCount = itemCount
end
function NebulaAllStarHospitalPanel:updateTextCurNum(...)
	local woundedArmy = nebulaAllStarCtrl:getWoundedArmy()
	nebulaAllStarCtrl = nil
	;(nil).num = string.formatnumberthousands(woundedArmy)
	self.fields.Text_curNum:setString(i18n("NebulaAllstar_146", nil))
end
function NebulaAllStarHospitalPanel:updateComSlider(holdValue)
	local woundedArmy = nebulaAllStarCtrl:getWoundedArmy()
	local maxValue = math.min(woundedArmy, self.itemCount * self.NumOfTreatments)
	local curValue = 0
	if holdValue then
		curValue = self.curValue or 0
		self.curValue = nil
	end
	nebulaAllStarCtrl = nil
	;(nil).maxValue = maxValue
	;(nil).minValue = 0
	;(nil).curValue = curValue
	;(nil).allowZero = true
	self.fields.Com_slider:initData(nil)
end
return NebulaAllStarHospitalPanel
