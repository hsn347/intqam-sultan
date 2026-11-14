local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local manorCityUtil = include("manorCityUtil")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local guideCtrl = SoraDGetCtrl("guideCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ManorCityViewPanel = class("ManorCityViewPanel", baseFguiPanel)
function ManorCityViewPanel:ctor(...)
	self.isLRU = true
	ManorCityViewPanel.super.ctor(self, ...)
	print("ManorCityViewPanel:ctor", self.viewName)
end
function ManorCityViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "MainUI"
	end
	return self._packageList
end
function ManorCityViewPanel:onInit()
	print("=======ManorCityViewPanel:onInit")
	self.fields.builderIcon1:setModel(0)
	self.fields.builderIcon2:setModel(0)
	self.fields.farmHelpIcon:initData(i18n("Socialize_text_05"), backpackCtrl:getItemCount(CONST_ARRAY.GARDEN_WATERING_ITEM[1]))
	self.fields.farmHelpIcon:addClickListener(handler(self, self.onClickFarmHelp))
	self.fields.banquetIcon:initData(i18n("Socialize_text_35"))
	self.fields.banquetIcon:addClickListener(handler(self, self.onClickBanquet))
	self.fields.com_res:isRunAnimation(true)
	self.fields.Button_back:addClickListener(handler(self, self.onClickBtnBack))
	self.fields.Button_visit:setString(i18n("garden_btn_05"))
	self.fields.Button_visit:addClickListener(handler(self, self.onClickBtnVisit))
	self.fields.Button_shop:setString(i18n("allianceWar_shop_title"))
	self.fields.Button_shop:addClickListener(handler(self, self.onClickBtnShop))
	self.fields.Button_record:setString(i18n("Socialize_text_07"))
	self.fields.Button_record:addClickListener(handler(self, self.onClickBtnRecord))
	self.fields.Button_buffPandect:setString(i18n("magic_lamp_title_09"))
	self.fields.Button_buffPandect:addClickListener(handler(self, self.onClickBtnBuffPandect))
	if not SoraDFIsRA() then
		self.controllers.viewType:fix()
		self.fields.Button_visit:fixPos()
		self.fields.Button_shop:fixPos()
		self.fields.Button_record:fixPos()
		self.fields.Button_buffPandect:fixPos()
		self.fields.builderIcon1:fixPos()
		self.fields.builderIcon2:fixPos()
		self.fields.farmHelpIcon:fixPos()
		self.fields.banquetIcon:fixPos()
		self.fields.Com_player:fixPos()
		self.fields.Com_player:fixChildrenPos()
		self.fields.Com_player:fixChildren()
	end
	if userSDKManager.isDebug() then
		self.fields.Button_cheat:setVisible(true)
		self.fields.Button_cheat:setTitleText("作弊")
		self.fields.Button_cheat:addClickListener(function()
			SoraDPlaySound()
			uiManager:show("CheatView")
		end)
	else
		self.fields.Button_cheat:setVisible(false)
	end
end
function ManorCityViewPanel:endShow()
	print("=======ManorCityViewPanel:endShow")
	self.isInVisit = false
	self.fields.com_res:updateResource()
	self:updateBtnShop()
	self:updateBuilderIcon()
	if not self.param then
		_ENV = self.param
	end
	self.pendingMainCityGardenTipParam = self.param
	self.hasHandledMainCityGardenTipParam = false
	local selfUid = SoraDGetPlayerID()
	if not self.param then
		_ENV = self.param
	end
	local visitUid = self.param.visitUid
	visitUid = visitUid or selfUid
	self.fromGardenWarVisit = visitUid ~= selfUid and worldMapDefine.isInGarden()
	manorCityCtrl:reqGardenMapQueryMap(visitUid)
	if visitUid == selfUid then
		manorCityCtrl:reqDressInit()
		self.controllers.viewType:setSelectedIndex(0)
	else
		self.controllers.viewType:setSelectedIndex(1)
	end
end
function ManorCityViewPanel:onHide()
	self:disableShack()
	if self.fields and self.fields.ManorUIBottom and self.fields.ManorUIBottom.removeSeedBookFinger then
		self.fields.ManorUIBottom:removeSeedBookFinger()
	end
end
function ManorCityViewPanel:onClickClose()
	SoraDPlaySound()
	self:disableShack()
	self:closePanel()
	manorCityUtil.outGardenWar()
end
function ManorCityViewPanel:onClickBtnBack()
	SoraDPlaySound()
	self:disableShack()
	if self.fromGardenWarVisit then
		if worldMapDefine.isInGarden() then
			uiManager:close("ManorCityView")
		else
			manorCityCtrl:reqInWarMap()
		end
	elseif manorCityCtrl:getIsUnLock() then
		local mapData = manorCityCtrl:getGardenMapData()
		_ENV = manorCityCtrl
		local manorCityCtrl.uid, player = SoraDGetPlayerID(), manorCityCtrl
		_ENV = nil
		;(nil).msg = "MESSAGE_MANOR_CITY_MAP_INIT"
		;(nil).mapData = mapData
		;(nil).player = player
		SoraDSendMessage(nil)
	else
		self:closePanel()
		manorCityUtil.outGardenWar()
	end
end
function ManorCityViewPanel:onClickBtnVisit()
	SoraDPlaySound()
	self:disableShack()
	manorCityCtrl:reqGardenMapRandomVisit()
	SoraDShowLoading()
end
function ManorCityViewPanel:onClickBtnShop()
	SoraDPlaySound()
end
function ManorCityViewPanel:onClickBtnRecord()
	SoraDPlaySound()
	uiManager:show("FarmHelpRecord")
end
function ManorCityViewPanel:onClickFarmHelp()
	SoraDPlaySound()
	manorCityCtrl:reqFarmlandAssist(self.player.uid)
end
function ManorCityViewPanel:onClickBanquet()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_MANOR_CITY_ENTER_BUILD"
	;(nil).buildID = MANOR_BUILD_ID.BANQUET
	SoraDSendMessage(nil)
end
function ManorCityViewPanel:onMsgUpgradeBuildQueue(target, event)
	print("==ManorCityViewPanel:onMsgUpgradeBuildQueue==")
	self.fields.builderIcon1:updateView()
end
function ManorCityViewPanel:onMsgTechBuildQueue(target, event)
	print("==ManorCityViewPanel:onMsgTechBuildQueue==")
	self.fields.builderIcon2:updateView()
end
function ManorCityViewPanel:onMsgMapInit(target, event)
	print("==ManorCityViewPanel:onMsgMapInit==")
	if not event.player then
		local _ENV, player = event.player, event.player
	end
	self:initVisitData(player)
	self:handleMainCityGardenTipParam(player)
	SoraDCreateDelayTimer(self, function()
		self:checkManorGuide(player)
	end, 0)
end
function ManorCityViewPanel:delayCheckSelfManorGuide()
	if self.isInVisit then
		return
	end
	SoraDCreateDelayTimer(self, function()
		self = nil
		;(nil).uid = SoraDGetPlayerID()
		self:checkManorGuide(nil)
	end, 0)
end
function ManorCityViewPanel:handleMainCityGardenTipParam(player)
