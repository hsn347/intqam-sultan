local gametop = gModuleMgr.getObject("gametop")
local godArmsCtrl = gametop.playertop_:getModule("godArmsCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local buildLogic = include("buildLogic")
local buildDesRead = include("buildDescribeRead")
local condParser = include("condParser")
local itemDesRead = include("itemDesRead")
local equipDesRead = include("equipDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArtifactUnlockPanel = class("ArtifactUnlockPanel", baseFguiPanel)
function ArtifactUnlockPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ArtifactUnlockPanel:ctor", self.viewName)
end
function ArtifactUnlockPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ArtifactUnlockPanel:onInit()
	print("=======ArtifactUnlockPanel:onInit")
	self.handle = self.proxy.param.handle
	self.curData = self.proxy.param.data
	self.fields.Panel_bg:setString(i18n("weapon_btn_06"))
	self.fields.Text_des:setString(i18n("weapon_text_27"))
	self.fields.Button_free:setString(i18n("common_text_740"))
	self.fields.Button_unlockItem1:setString(i18n("common_text_4347"))
	self.fields.Button_unlockItem2:setString(i18n("common_text_4347"))
	self.fields.Button_unlockItem1:addClickListener(handlerEx(self, self.btnAddUnlockItemClickCallBack, 1))
	self.fields.Button_unlockItem2:addClickListener(handlerEx(self, self.btnAddUnlockItemClickCallBack, 2))
	self.fields.Button_Cost:setString(i18n("weapon_btn_01"))
	self.fields.Button_Cost:addClickListener(handler(self, self.btnUnlockClickCallBack))
	self.fields.Button_free:addClickListener(handler(self, self.btnUnlockClickCallBack))
	self.fields.Button_free:setEnabled(false)
end
function ArtifactUnlockPanel:onShow()
	print("=======ArtifactUnlockPanel:onShow")
	self:updateView()
end
function ArtifactUnlockPanel:updateView()
	local str = ""
	local ret = false
	local canUnlock = 0
	condParser, self.canFreeUnlock = nil, false
	condParser, (nil)[1] = self.fields.Text_unlock1, self.fields.Text_unlock1
	local condParser, (nil)[2], strTabel = self.fields.Text_unlock1, self.fields.Text_unlock2, nil
	self.fields.Text_unlock1[1] = self.fields.Button_unlockItem1
	local self.fields.Text_unlock1[2], btnTabel = self.fields.Button_unlockItem2, self.fields.Text_unlock1
	self.fields.Text_unlock1:setVisible(false)
	self.fields.Text_unlock2:setVisible(false)
	self.fields.Button_unlockItem1:setVisible(false)
	self.fields.Button_unlockItem2:setVisible(false)
	for i, v in ipairs(self.curData.unlockCondition) do
		if v.type == ARMS_UNLOCK_TYPE.UNLOCK_CASTLE then
			local warLv = buildLogic.transformBuildLvToWarLv(v.value)
			_ENV = nil
			;(nil).condtype = gCondType.buildlv
			;(nil).id = v.id
			;(nil).condvalue = v.value
			ret = condParser.verify(nil)
			if 0 < warLv then
				_ENV = v.value
				v.value.build = buildDesRead.getName(v.id)
				v.value.lv = warLv
				str = i18n("common_text_1957", v.value)
			else
				_ENV = v.value
				v.value.name = buildDesRead.getName(v.id)
				v.value.lv = v.value
				str = i18n("common_text_334", v.value)
			end
		elseif v.type == ARMS_UNLOCK_TYPE.UNLOCK_ARMS_LEVEL then
			_ENV = ARMS_UNLOCK_TYPE.UNLOCK_ARMS_LEVEL
			ARMS_UNLOCK_TYPE.UNLOCK_ARMS_LEVEL.condtype = gCondType.artifactlv
			ARMS_UNLOCK_TYPE.UNLOCK_ARMS_LEVEL.id = v.id
			ARMS_UNLOCK_TYPE.UNLOCK_ARMS_LEVEL.condvalue = v.value
			ret = condParser.verify(ARMS_UNLOCK_TYPE.UNLOCK_ARMS_LEVEL)
			_ENV = v.value
			v.value.name = equipDesRead.getArtifactName(v.id)
			v.value.lv = v.value
			str = i18n("common_text_334", v.value)
		elseif v.type == ARMS_UNLOCK_TYPE.UNLOCK_ITEM then
			_ENV = ARMS_UNLOCK_TYPE.UNLOCK_ITEM
			ARMS_UNLOCK_TYPE.UNLOCK_ITEM.condtype = gCondType.itemcount
			ARMS_UNLOCK_TYPE.UNLOCK_ITEM.id = v.id
			ARMS_UNLOCK_TYPE.UNLOCK_ITEM.condvalue = v.value
			ret = condParser.verify(ARMS_UNLOCK_TYPE.UNLOCK_ITEM)
			_ENV = v.value
			v.value.name = itemDesRead.getName(v.id)
			_ENV = v.id
			v.id.member = backpackCtrl:getItemCount(v.id)
			v.id.total = v.value
			v.value.num = i18n("common_text_155", v.id)
			str = i18n("common_text_036", v.value)
		end
		strTabel[i]:setColor(ret and display.COLOR_WHITE or display.COLOR_RED)
		strTabel[i]:setString(str)
		strTabel[i]:setVisible(true)
		if ret then
			canUnlock = canUnlock + 1
		end
	end
	self.canFreeUnlock = canUnlock >= #self.curData.unlockCondition and 0 < canUnlock
	if self.canFreeUnlock then
		self.fields.Button_free:setEnabled(true)
	end
	if self.curData.immedCondition[1] then
		local immedCondition = self.curData.immedCondition[1]
		if immedCondition.type == ARMS_UNLOCK_TYPE.UNLOCK_GOLD then
			self.fields.Button_Cost:setCost(gIDDef.GOLD, immedCondition.value)
			self.controllers.c1:setSelectedIndex(0)
		else
			self.controllers.c1:setSelectedIndex(1)
		end
	else
		self.controllers.c1:setSelectedIndex(1)
	end
	if self.curData.weaponID == 6400131 then
		self.fields.Button_unlockItem1:setVisible(true)
		self.fields.Button_unlockItem2:setVisible(true)
	end
end
function ArtifactUnlockPanel:btnUnlockClickCallBack()
	SoraDPlaySound()
	local unlockFun = function(...)
		if self.handle then
			self.handle()
		end
		godArmsCtrl:reqUnlock(self.curData.weaponID)
		SoraDShowLoading()
		self:removeFromParent()
	end
	if self.canFreeUnlock then
		unlockFun()
		return
	end
	local immedCondition = self.curData.immedCondition[1]
	if immedCondition.type == ARMS_UNLOCK_TYPE.UNLOCK_GOLD then
		_ENV = nil
		;(nil).gold = immedCondition.value
		;(nil).name = i18n(self.curData.name)
		SoraDShowBuyBox(i18n("artifact_text_36", nil), immedCondition.value, i18n("common_text_740"), function(type)
			if type == MSGBOX_CALLBACK_YES then
				unlockFun()
			end
		end)
	else
		_ENV = i18n("artifact_text_36", nil)
		i18n("artifact_text_36", nil).condtype = gCondType.itemcount
		i18n("artifact_text_36", nil).id = immedCondition.id
		i18n("artifact_text_36", nil).condvalue = immedCondition.value
		local ret = condParser.verify((i18n("artifact_text_36", nil)))
		if ret then
			unlockFun()
		elseif self.curData.actionNode.unlockShopItem then
			SoraDShowMsgBox(i18n("artifact_text_40"), i18n("common_text_477"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					_ENV = nil
					;(nil).type = 1
					;(nil).mid = self.curData.actionNode.unlockShopItem
					uiManager:show("bagView", nil)
				end
			end)
		elseif self.curData.actionNode.unlockByGift then
			SoraDShowMsgTip(i18n("artifact_text_37"))
		else
			SoraDShowMsgTip(i18n("artifact_text_19"))
		end
	end
end
function ArtifactUnlockPanel:btnAddUnlockItemClickCallBack(index)
	SoraDPlaySound()
	local immedCondition = self.curData.unlockCondition[index]
	_ENV = nil
	_ENV = nil
	;(nil).name = include("itemDesRead").getName(immedCondition.id)
	;(nil).title = i18n("equip_text_27", nil)
	_ENV, (nil).defaultBtnTitle = i18n("common_text_477"), i18n("common_text_477")
	i18n("common_text_477")[1] = i18n("return_lcks_text_036")
	_ENV, (nil).itemTitle, i18n("common_text_477")[2] = i18n("common_text_477"), i18n("common_text_477"), i18n("activity_name_9001168")
	i18n("common_text_477")[1] = function()
		_ENV = nil
		;(nil).type = 1
		;(nil).jumpStore = "btnOther"
		uiManager:show("bagView", nil)
	end
	_ENV, (nil).btnCallBack, i18n("common_text_477")[2] = i18n("common_text_477"), i18n("common_text_477"), function()
		local _eventState = SoraDGetCtrl("activityShowCtrl"):getStateByID(gActivityTimeActivityID.WRATH_BEAST_ACTIVITY)
		if clientEventMgr.judgeIsOnShow(_eventState) then
			local panel = SoraDCreatePanel("wrathBeastMainView")
			panel.ccs_tab:clickByTag(2)
			panel:show()
		else
			SoraDShowMsgTip(i18n("devilvalley_text_08"))
		end
	end
	i18n("common_text_477")[1] = nil
	;(nil).btnCallBackParam, i18n("common_text_477")[2] = i18n("common_text_477"), nil
	local (nil).size, param = 2, nil
	uiManager:show("GetWayPopBox", param)
end
return ArtifactUnlockPanel
