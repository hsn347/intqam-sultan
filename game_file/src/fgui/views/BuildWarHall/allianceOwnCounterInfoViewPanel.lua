local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceOwnCounterInfoViewPanel = class("allianceOwnCounterInfoViewPanel", baseFguiPanel)
local allianceCounterSysCtrl = SoraDGetCtrl("allianceCounterSysCtrl")
function allianceOwnCounterInfoViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("allianceOwnCounterInfoViewPanel:ctor", self.viewName)
end
function allianceOwnCounterInfoViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceOwnCounterInfoViewPanel:onInit()
	print("=======allianceOwnCounterInfoViewPanel:onInit")
	self.view:fixChildrenPos(true)
	self.arrRes = SoraDGetChildsArrayByName(self, "Node_res_", 5, 1, false)
	self.nodeHead = SoraDGetChildByName(self, "CCS_commonHead_own")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelCastle = SoraDGetChildByName(self, "Text_castle")
	self.labelPoint = SoraDGetChildByName(self, "Text_point")
	self.nodeTextInfo = SoraDGetChildByName(self, "Node_text_info")
	self.nodeTitle1 = SoraDGetChildByName(self, "Node_title_1")
	self.labelTitle1 = SoraDGetChildByName(self, "Text_title_1")
	self.labelAtkCount = SoraDGetChildByName(self, "Text_atkCount")
	self.labelLostPower = SoraDGetChildByName(self, "Text_lostPower")
	self.labelLostRes = SoraDGetChildByName(self, "Text_lostRes")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnFight = SoraDGetChildByName(self, "Button_fight")
	self.labelTime = SoraDGetChildByName(self, "Text_time")
	self.labelTitle1:setString(i18n("CounterSystem_text_27"))
	self.labelLostRes:setString(i18n("CounterSystem_text_29"))
	self.labelTime:setString(i18n("CounterSystem_text_30"))
	self.btnHelp:setTitleText(i18n("common_text_3686"))
	self.btnFight:setTitleText(i18n("CounterSystem_btn_01"))
	self.btnHelp:addClickEventListener(handler(self, self.btnClickCallBack))
	self.btnFight:addClickEventListener(handler(self, self.btnClickCallBack))
end
function allianceOwnCounterInfoViewPanel:onShow()
	print("=======allianceOwnCounterInfoViewPanel:onShow")
end
function allianceOwnCounterInfoViewPanel:initData(data, isHelp)
	self.data = data
	self.isHelp = isHelp
	self:updateView()
	self.controllers.c2:setSelectedIndex(0)
	if self.isHelp then
		self.btnHelp:setVisible(false)
		self.controllers.c2:setSelectedIndex(1)
	end
end
function allianceOwnCounterInfoViewPanel:updateView()
	self.nodeHead:setHeadSprite(self.data.iconID, self.data.avatar)
	self.nodeHead:setPlayerID(self.data.uid)
	if self.data.abbr and self.data.abbr ~= "" then
		_ENV = nil
		;(nil).abbr = self.data.abbr
		;(nil).name = self.data.nickName
		self.fields.Panel_bg:setTitle(i18n("common_text_186", nil))
	else
		self.fields.Panel_bg:setTitle(self.data.nickName)
	end
	_ENV = i18n("common_text_186", nil)
	i18n("common_text_186", nil).num = string.formatnumberthousands(self.data.hostile)
	self.labelPoint:setString(i18n("CounterSystem_text_14", i18n("common_text_186", nil)))
	local trasnWarLv = function(clv)
		local buildLogic = include("buildLogic")
		local warLv = buildLogic.transformBuildLvToWarLv(clv)
		if 0 < warLv then
			_ENV = nil
			;(nil).lv = warLv
			return i18n("common_text_1948", nil)
		else
			return math.min(clv, CASTLE_MAXLV_NOWAR)
		end
	end
	_ENV = i18n("CounterSystem_text_14", i18n("common_text_186", nil))
	i18n("CounterSystem_text_14", i18n("common_text_186", nil)).lv = trasnWarLv(self.data.castleLv)
	self.labelCastle:setString(i18n("common_text_3514", i18n("CounterSystem_text_14", i18n("common_text_186", nil))))
	_ENV = i18n("common_text_3514", i18n("CounterSystem_text_14", i18n("common_text_186", nil)))
	i18n("common_text_3514", i18n("CounterSystem_text_14", i18n("common_text_186", nil))).num = string.formatnumberthousands(self.data.attackTimes)
	self.labelAtkCount:setString(i18n("CounterSystem_text_22", i18n("common_text_3514", i18n("CounterSystem_text_14", i18n("common_text_186", nil)))))
	_ENV = i18n("CounterSystem_text_22", i18n("common_text_3514", i18n("CounterSystem_text_14", i18n("common_text_186", nil))))
	i18n("CounterSystem_text_22", i18n("common_text_3514", i18n("CounterSystem_text_14", i18n("common_text_186", nil)))).num = string.formatnumberthousands(self.data.losePower)
	self.labelLostPower:setString(i18n("CounterSystem_text_28", i18n("CounterSystem_text_22", i18n("common_text_3514", i18n("CounterSystem_text_14", i18n("common_text_186", nil))))))
	self:updateRes()
end
function allianceOwnCounterInfoViewPanel:updateRes()
	local resDesRead = include("resDesRead")
	_UPVALUE5_ = "resDesRead"
	;("resDesRead")[1] = gIDDef.FOOD
	;("resDesRead")[2] = gIDDef.WOOD
	;("resDesRead")[3] = gIDDef.IRON
	;("resDesRead")[4] = gIDDef.MITHRIL
	local ("resDesRead")[5], resid = gIDDef.CRYSTAL, "resDesRead"
	local curi = 1
	for i, v in ipairs(resid) do
		if self.data.resInfo[tostring(v)] then
			self.arrRes[curi]:setVisible(true)
			self.arrRes[curi]:setIcon(resDesRead.getIcon(v))
			self.arrRes[curi]:setTitle(string.formatnumberthousands(self.data.resInfo[tostring(v)]))
			curi = curi + 1
		end
	end
end
function allianceOwnCounterInfoViewPanel:btnClickCallBack(button, type)
	SoraDPlaySound()
	if button == self.btnHelp then
		local panel = SoraDCreatePanel("allianceCounterMsgBox")
		panel:initData(self.data)
		panel:show()
	elseif self.isHelp then
		SoraDGotoWorldMapPoint(self.data.coordinate, true)
		SoraDRemoveAllPanelFromManager()
	else
		allianceCounterSysCtrl:getEnemyPos(self.data.uid)
		SoraDShowLoading()
	end
end
return allianceOwnCounterInfoViewPanel
