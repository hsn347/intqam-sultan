local buildLogic = include("buildLogic")
local allianceCounterSysCtrl = SoraDGetCtrl("allianceCounterSysCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceCounterInfoViewPanel = class("allianceCounterInfoViewPanel", baseFguiPanel)
function allianceCounterInfoViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("allianceCounterInfoViewPanel:ctor", self.viewName)
end
function allianceCounterInfoViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceCounterInfoViewPanel:onInit()
	print("=======allianceCounterInfoViewPanel:onInit")
	self.view:fixChildrenPos()
	self.labelPower = SoraDGetChildByName(self, "Text_power")
	self.btnInfo = SoraDGetChildByName(self, "Button_info")
	self.nodeHead = SoraDGetChildByName(self, "CCS_commonHead_own")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelCastle = SoraDGetChildByName(self, "Text_castle")
	self.labelPoint = SoraDGetChildByName(self, "Text_point")
	self.nodeTextInfo = SoraDGetChildByName(self, "Node_text_info")
	self.labelTitle1 = SoraDGetChildByName(self, "Text_title_1")
	self.labelTitle2 = SoraDGetChildByName(self, "Text_title_2")
	self.btnPublish = SoraDGetChildByName(self, "Button_publish")
	self.labelTime = SoraDGetChildByName(self, "Text_time")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.nodeCopy = SoraDGetChildByName(self, "Node_copy")
	self.labelTitle1:setString(i18n("CounterSystem_text_16"))
	self.labelTitle2:setString(i18n("CounterSystem_text_18"))
	self.labelDes:setString(i18n("CounterSystem_text_19"))
	self.btnPublish:setTitleText(i18n("CounterSystem_btn_01"))
	self.btnInfo:addClickEventListener(handler(self, self.btnInfoClickCallBack))
	self.btnPublish:addClickEventListener(handler(self, self.btnCounterClickCallBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_COUNTER_ENEMY_INFO", function(target, data)
		if self.data and data.enemyData and data.enemyData.uid == self.data.uid then
			self.data = data.enemyData
			self:updateView()
			self:initScroll()
			SoraDCloseLoading(self)
		end
	end)
	self.fields.list1:setItemRenderer(handler(self, self.onPlayerRenderer))
	self.fields.list2:setItemRenderer(handler(self, self.onItemRenderer))
end
function allianceCounterInfoViewPanel:onShow()
	print("=======allianceCounterInfoViewPanel:onShow")
end
function allianceCounterInfoViewPanel:initData(data)
	self.data = data
	self:updateView()
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.updateTime))
	end
	self:updateTime()
	SoraDShowLoading(self)
	allianceCounterSysCtrl:getAllianceEnemyInfoReq(self.data.uid)
end
function allianceCounterInfoViewPanel:updateTime()
	local leftTime = self.data.time + 1296000 - serviceFunctions.systemTime()
	local day = math.floor(leftTime / 86400)
	local daystr = 0 < day and tostring(day) .. "D " or ""
	_ENV = nil
	;(nil).time = daystr .. os.date("%H:%M:%S", leftTime)
	self.labelTime:setString(i18n("CounterSystem_text_20", nil))
	if leftTime <= 0 then
		self:removeFromParent()
	end
end
function allianceCounterInfoViewPanel:updateView()
	_ENV = nil
	;(nil).num1 = string.formatnumberthousands(self.data.completedPower)
	;(nil).num2 = string.formatnumberthousands(self.data.targetPower)
	self.labelPower:setString(i18n("CounterSystem_text_17", nil))
	self.nodeHead:setHeadSprite(self.data.iconID, self.data.avatar)
	self.nodeHead:setPlayerID(self.data.uid)
	if self.data.abbr and self.data.abbr ~= "" then
		_ENV = i18n("CounterSystem_text_17", nil)
		i18n("CounterSystem_text_17", nil).abbr = self.data.abbr
		i18n("CounterSystem_text_17", nil).name = self.data.nickName
		self.fields.Panel_bg:setTitle(i18n("common_text_186", i18n("CounterSystem_text_17", nil)))
	else
		self.fields.Panel_bg:setTitle(self.data.nickName)
	end
	_ENV = i18n("common_text_186", i18n("CounterSystem_text_17", nil))
	i18n("common_text_186", i18n("CounterSystem_text_17", nil)).num = string.formatnumberthousands(self.data.hostile)
	self.labelPoint:setString(i18n("CounterSystem_text_14", i18n("common_text_186", i18n("CounterSystem_text_17", nil))))
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
	_ENV = i18n("CounterSystem_text_14", i18n("common_text_186", i18n("CounterSystem_text_17", nil)))
	i18n("CounterSystem_text_14", i18n("common_text_186", i18n("CounterSystem_text_17", nil))).lv = trasnWarLv(self.data.castleLv)
	self.labelCastle:setString(i18n("common_text_3514", i18n("CounterSystem_text_14", i18n("common_text_186", i18n("CounterSystem_text_17", nil)))))
	self:initItem()
end
function allianceCounterInfoViewPanel:onItemRenderer(index, item)
	local v = self.data.completeRewards[index + 1]
	item:initData(v.id, v.count)
end
function allianceCounterInfoViewPanel:initItem()
	self.fields.list2:setNumItems(#self.data.completeRewards)
end
function allianceCounterInfoViewPanel:initScroll()
	self.fields.list1:setNumItems(math.ceil(#self.data.attackList / 2))
end
function allianceCounterInfoViewPanel:onPlayerRenderer(index, ocx)
	ocx:fixChildrenPos(true)
	local curi = math.ceil((index + 1) / 2)
	local datar = self.data.attackList[curi]
	local datal = self.data.attackList[curi + 1]
	if index % 2 == 0 then
		ocx:getChildByName("Image_single"):setVisible(false)
	end
	ocx.nodeRight = SoraDGetChildByName(ocx, "Node_right")
	ocx.nodeLeft = SoraDGetChildByName(ocx, "Node_left")
	if datar then
		local head = SoraDGetChildByName(ocx, "head_right")
		head:setPlayerID(datar.uid)
		head:setHeadSprite(datar.iconID, datar.avatar)
		SoraDGetChildByName(ocx, "Text_name_right"):setString(datar.nickName)
	else
		ocx.nodeRight:setVisible(false)
	end
	if datal then
		local head = SoraDGetChildByName(ocx, "head_left")
		head:setPlayerID(datal.uid)
		head:setHeadSprite(datal.iconID, datal.avatar)
		SoraDGetChildByName(ocx, "Text_name_left"):setString(datal.nickName)
	else
		ocx.nodeLeft:setVisible(false)
	end
end
function allianceCounterInfoViewPanel:btnCounterClickCallBack(button, type)
	SoraDPlaySound()
	allianceCounterSysCtrl:getEnemyPos(self.data.uid)
	SoraDShowLoading()
end
function allianceCounterInfoViewPanel:btnInfoClickCallBack(button, type)
	SoraDPlaySound()
	local panel = uiManager:show("allianceCounterLogView").view
	panel:initData(self.data.uid)
end
return allianceCounterInfoViewPanel
