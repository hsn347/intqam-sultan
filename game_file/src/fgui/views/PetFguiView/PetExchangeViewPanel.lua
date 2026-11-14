local petExchangeCtrl = SoraDGetCtrl("petExchangeCtrl")
local petExchangeltCtrl = gModuleMgr.sharedMgr("petExchangeltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local petltCtrl = include("petltCtrl")
local petCtrl = SoraDGetCtrl("petCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local PetExchangeViewPanel = class("PetExchangeViewPanel", baseFguiPanel)
local targetPetId = 1253
local targetPetShardId = 804501
function PetExchangeViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("PetExchangeViewPanel:ctor", self.viewName)
end
function PetExchangeViewPanel:onInit()
	print("=======PetExchangeViewPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_3799"), handler(self, self.onClickClose))
	self.fields.Com_item:initData(targetPetShardId)
	self.fields.Com_item:setClickCallback(handler(self, self.onBtnPetItem))
	self.fields.btn_unlock:addClickListener(handler(self, self.onClick_btn_unlock))
	self.fields.text_lock_info:setString(i18n("common_text_3801"))
	self.fields.Button_OneKey:setString(i18n("common_text_3804"))
	self.fields.Button_OneKey:addClickListener(handler(self, self.onClick_Button_OneKey))
	self.fields.Button_Buy:addClickListener(handler(self, self.onClick_Button_Buy))
	self.fields.Button_Exchange:addClickListener(handler(self, self.onClick_Button_Exchange))
	_ENV = handler(self, self.onClick_Button_Exchange)
	handler(self, self.onClick_Button_Exchange).title = i18n("common_text_282")
	handler(self, self.onClick_Button_Exchange).id = gIDDef.GOLD
	self:initButtonCost(self.fields.Button_Buy, handler(self, self.onClick_Button_Exchange))
	_ENV = handler(self, self.onClick_Button_Exchange)
	handler(self, self.onClick_Button_Exchange).title = i18n("common_text_1889")
	handler(self, self.onClick_Button_Exchange).id = gIDDef.PET_POINT
	self:initButtonCost(self.fields.Button_Exchange, handler(self, self.onClick_Button_Exchange))
	self.fields.List_exchange:setItemRenderer(handler(self, self.onExchangeItemRenderer))
	self.fields.text_bottom_info:setString(i18n("common_text_3800"))
	self.fields.Text_noData:setString(i18n("common_text_3806"))
	self.fields.List_reclaim:setItemRenderer(handler(self, self.onReclaimItemRenderer))
	if not SoraDFIsRA() then
		self.fields.text_lock_info:fixPos()
		self.fields.Image_unlock:fixPos()
		self.fields.btn_unlock:fixPos()
		self.fields.Label_score:getChild("title"):fixPos()
		self.fields.Label_score:getChild("icon"):fixPos()
	end
end
function PetExchangeViewPanel:onShow()
	print("=======PetExchangeViewPanel:onShow")
	self:updateReclaim()
	self:updateExchange()
	self:updatePetScore()
	self:updateExchangeArea()
	local _ENV, selTabIndex = self, self.param and self.param.selTabIndex or 1
	_ENV, _ENV, self.defaultClick = nil, nil, selTabIndex
	_ENV, (nil)[1], (nil).title = nil, nil, i18n("common_text_3983")
	self.tabsetArray, (nil)[2], (nil).title = nil, nil, i18n("common_text_1889")
	local self.callback, param = handler(self, self.onClickTab), self
	self.fields.Com_tab:initView(param)
	lordInfoCtrl:getLordBattleInfoReq()
end
function PetExchangeViewPanel:onClickTab(index)
	self.selTabIndex = index
	self.controllers.c1:setSelectedIndex(index - 1)
end
function PetExchangeViewPanel:updatePetScore()
	local score = petExchangeCtrl:getCurrentPoint()
	self.fields.Label_score:setString(string.formatnumberthousands(score))
end
function PetExchangeViewPanel:updateExchangeArea()
	local isAlreadyUnlock = petCtrl:petIsAleadyUnlock(targetPetId)
	local __, __, debrisFlag = petExchangeCtrl:isCanExchangEagle()
	if isAlreadyUnlock or debrisFlag then
		self.controllers.c2:setSelectedIndex(1)
		self:updateExchange()
	else
		self.controllers.c2:setSelectedIndex(0)
		self:udpatePetArea()
		self:updateExchange()
	end
end
function PetExchangeViewPanel:udpatePetArea(...)
	_UPVALUE3_ = nil
	;(nil)[1] = self.fields.Button_Buy
	;(nil)[2] = self.fields.Button_Exchange
	local (nil)[3], btnArray = self.fields.Button_OneKey, nil
	local canExchange, tableUnlockData = petExchangeCtrl:isCanExchangEagle()
	for i, v in ipairs(btnArray) do
		v:setEnabled(canExchange)
	end
	self.fields.Node_unlock:setVisible(not canExchange)
	local goldCost = petExchangeCtrl:getEagleExchangeCost(gPetExchangeEagleType.GOLD)
	petExchangeCtrl = nil
	;(nil).count = goldCost
	self:initButtonCost(self.fields.Button_Buy, nil)
	local scoreCost = petExchangeCtrl:getEagleExchangeCost(gPetExchangeEagleType.POINT)
	petExchangeCtrl = v.setEnabled
	v.setEnabled.count = scoreCost
	self:initButtonCost(self.fields.Button_Exchange, v.setEnabled)
end
function PetExchangeViewPanel:onBtnPetItem(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).petid = targetPetId
	uiManager:show("PetFguiView", nil)
end
function PetExchangeViewPanel:onClick_btn_unlock(...)
	SoraDPlaySound()
	local canUnlock, tableUnlockData = petExchangeCtrl:isCanExchangEagle()
	if not canUnlock then
		self.tblUnlock = self.proxy:convertUnLockData(tableUnlockData)
		_ENV = nil
		;(nil).isExchange = true
		;(nil).tblUnlock = self.tblUnlock
		uiManager:show("PetUnlockView", nil)
	end
end
function PetExchangeViewPanel:onClick_Button_OneKey(...)
	SoraDPlaySound()
	uiManager:show("PetOneKeyView")
end
function PetExchangeViewPanel:onClick_Button_Buy(...)
	SoraDPlaySound()
	_ENV = nil
	_ENV, (nil).sliderBoxType = gSoldierBoxType.PET_EXCHANGE_BY_GOLD_EAGLE, gSoldierBoxType.PET_EXCHANGE_BY_GOLD_EAGLE
	gSoldierBoxType.PET_EXCHANGE_BY_GOLD_EAGLE.id = targetPetShardId
	;(nil).itemData, gSoldierBoxType.PET_EXCHANGE_BY_GOLD_EAGLE.count = gSoldierBoxType.PET_EXCHANGE_BY_GOLD_EAGLE, 1
	;(nil).exchangeType = gPetExchangeEagleType.GOLD
	;(nil).handle = handler(self, self.exchangeByItemGoldEagleBack)
	uiManager:show("PetItemFeedView", nil)
end
function PetExchangeViewPanel:exchangeByItemGoldEagleBack(data)
	dump(data, "金币兑换老鹰回调")
	petExchangeCtrl:reqEagleExchange(gPetExchangeEagleType.GOLD, data.num)
end
function PetExchangeViewPanel:onClick_Button_Exchange(...)
	SoraDPlaySound()
	local scoreCost = petExchangeCtrl:getEagleExchangeCost(gPetExchangeEagleType.POINT)
	local score = petExchangeCtrl:getCurrentPoint()
	if scoreCost > score then
		SoraDShowMsgTip(i18n("common_text_3827"))
		return
	end
	_ENV = i18n("common_text_3827")
	_ENV, i18n("common_text_3827").sliderBoxType = gSoldierBoxType.PET_EXCHANGE_BY_SCORE_EAGLE, gSoldierBoxType.PET_EXCHANGE_BY_SCORE_EAGLE
	gSoldierBoxType.PET_EXCHANGE_BY_SCORE_EAGLE.id = targetPetShardId
	i18n("common_text_3827").itemData, gSoldierBoxType.PET_EXCHANGE_BY_SCORE_EAGLE.count = gSoldierBoxType.PET_EXCHANGE_BY_SCORE_EAGLE, 1
	i18n("common_text_3827").exchangeType = gPetExchangeEagleType.POINT
	i18n("common_text_3827").handle = handler(self, self.exchangeByItemScoreEagleBack)
	uiManager:show("PetItemFeedView", i18n("common_text_3827"))
end
function PetExchangeViewPanel:exchangeByItemScoreEagleBack(data)
	dump(data, "积分兑换老鹰回调")
	petExchangeCtrl:reqEagleExchange(gPetExchangeEagleType.POINT, data.num)
end
function PetExchangeViewPanel:updateReclaim()
	self.itemsData_Reclaim = backpackCtrl:getPetPointItemList()
	self.fields.List_reclaim:setNumItems(#self.itemsData_Reclaim)
	self.fields.Text_noData:setVisible(#self.itemsData_Reclaim == 0)
end
function PetExchangeViewPanel:onReclaimItemRenderer(index, obj)
	local itemData = self.itemsData_Reclaim[index + 1]
	obj:init(itemData)
	obj:setItemDelegate(handler(self, self.singleReclaimClick))
end
function PetExchangeViewPanel:singleReclaimClick(itemData)
	print("点击回收按钮回调----")
	if not itemData then
		return
	end
	local showItemView = function()
		_ENV = nil
		;(nil).sliderBoxType = gSoldierBoxType.PET_RECLAIM
		;(nil).itemData = itemData
		;(nil).handle = handler(self, self.reclaimByItemBack)
		uiManager:show("PetItemFeedView", nil)
	end
	local isPetDebrisid, petid = petltCtrl.getDebrisidIsExist(itemData.id)
	if not isPetDebrisid then
		showItemView()
		return
	end
	local isUnlock = petCtrl:petIsAleadyUnlock(petid)
	if isUnlock then
		showItemView()
		return
	end
	SoraDShowMsgBox(i18n("pet_text_11"), i18n("common_text_054"), i18n("common_text_185"), function(callBack)
		if callBack == MSGBOX_CALLBACK_YES then
			showItemView()
		end
	end)
end
function PetExchangeViewPanel:reclaimByItemBack(data)
	dump(data, "回收回调")
	SoraDShowLoading(self:displayObject())
	petExchangeCtrl:reqExchangePoint(data.id, data.num)
end
function PetExchangeViewPanel:updateExchange()
	self.itemsData_Exchange = petExchangeltCtrl:getItemExchangeData()
	self.fields.List_exchange:setNumItems(#self.itemsData_Exchange)
end
function PetExchangeViewPanel:onExchangeItemRenderer(index, obj)
	local itemData = self.itemsData_Exchange[index + 1]
	obj:init(itemData)
	obj:setItemDelegate(handler(self, self.singleExchangeClick))
end
function PetExchangeViewPanel:singleExchangeClick(itemData)
	if not itemData then
		return
	end
	_ENV = nil
	;(nil).sliderBoxType = gSoldierBoxType.PET_EXCHANGE_BY_SCORE
	;(nil).itemData = itemData
	;(nil).handle = handler(self, self.exchangeByItemBack)
	uiManager:show("PetItemFeedView", nil)
end
function PetExchangeViewPanel:exchangeByItemBack(data)
	dump(data, "通用兑换回调")
	SoraDShowLoading(self:displayObject())
	petExchangeCtrl:reqExchangeNormal(data.index, data.num)
end
function PetExchangeViewPanel:sMsgUpdatePetScore(target, data)
	self:updatePetScore()
end
function PetExchangeViewPanel:sMsgUpdateReclaimList(target, data)
	self:updateReclaim()
end
function PetExchangeViewPanel:sMsgUpdateExchangeList(target, data)
	self:updateExchange()
end
function PetExchangeViewPanel:sMsgUpdateExchangeArea(target, data)
	self:udpatePetArea()
end
function PetExchangeViewPanel:sMsgUpdateExchangeGold(target, data)
end
function PetExchangeViewPanel:sMsgReclaimBack(target, data)
	print("PetExchangeViewPanel:sMsgReclaimBack(target, data)")
	SoraDCloseLoading(self:displayObject())
	if data.err == gErrDef.Err_None then
		self:updatePetScore()
		self:updateReclaim()
		self:udpatePetArea()
		self:updateExchange()
	else
		SoraDShowMsgTip("Error! Code = " .. data.err)
	end
end
function PetExchangeViewPanel:sMsgExchagneNormalBack(target, data)
	print("PetExchangeViewPanel:sMsgExchagneNormalBack(target, data)")
	SoraDCloseLoading(self)
	if data.err == gErrDef.Err_None then
		self:updatePetScore()
		self:updateExchange()
		self:updateReclaim()
	else
		SoraDShowMsgTip("Exchange Error! Code = " .. data.err)
	end
end
function PetExchangeViewPanel:sMsgExchangeEagleBack(target, data)
	print("PetExchangeViewPanel:sMsgExchangeEagleBack(target, data)")
	SoraDCloseLoading(self:displayObject())
	if data.err == gErrDef.Err_None then
		self:updatePetScore()
		self:updateExchangeArea()
	else
		SoraDShowMsgTip("Exchange Error! Code = " .. data.err)
	end
end
function PetExchangeViewPanel:sMsgUpdateFcInfo(...)
	print("请求最新击杀消息========")
end
function PetExchangeViewPanel:initButtonCost(obj, data)
	local _fields = fguiHelper.get_fields(obj)
	if not SoraDFIsRA() then
		_fields.Text_gold:fixPos()
		_fields.Icon_gold:fixPos()
	end
	if data.id then
		local iconPng = publicRead.getIcon(data.id)
		_fields.Icon_gold:setURL(iconPng)
	end
	if data.count then
		_fields.Text_gold:setString(string.formatnumberthousands(data.count))
	end
	if data.title then
		_fields.Text_title:setString(data.title)
	end
end
return PetExchangeViewPanel
