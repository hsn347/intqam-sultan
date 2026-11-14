local raidersLostArkGetKeyPopView = class("raidersLostArkGetKeyPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("raidersLostArkGetKeyPopView")
	end
	return target
end)
local raidersLostArkRead = include("raidersLostArkRead")
local publicRead = include("publicRead")
local raidersLostArkCtrl = SoraDGetCtrl("raidersLostArkCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
function raidersLostArkGetKeyPopView:ctor()
	self:initControls()
end
function raidersLostArkGetKeyPopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", function(...)
		self:initData(self.chooseIndex)
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_RAIDER_LOST_ARK_OPEN_CHEST_NUM_LIMIT", function(target, data)
		SoraDCloseLoading(self)
		local chestInfo = raidersLostArkRead:getTreasureChestInfo(self.chooseIndex)
		_ENV = nil
		;(nil).name = i18n(chestInfo.name)
		SoraDShowMsgTip(i18n("Martial_arts_text_31", nil))
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function raidersLostArkGetKeyPopView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.Panel_cut:setPositionY(display.height / 2)
	self.Text_name:setString(i18n("Martial_arts_text_38"))
	self.txtKill:setString(i18n("Martial_arts_text_40"))
	self.txtGetGoldBox:setString(i18n("Martial_arts_text_41"))
	self.txtGetGoldBox_2:setString(i18n("Martial_arts_text_42"))
	self.btnKillGo:setTitleText(i18n("common_text_477"))
	self.txtGoldOwn:setString(i18n("common_text_246"))
	self.txtGoldOwn_2:setString(i18n("common_text_246"))
	SoraDSetTextWidthHeight(self.txtGetGoldBox, cc.size(350, 60))
	SoraDSetTextWidthHeight(self.txtGetGoldBox_2, cc.size(350, 60))
	self.activityID = gActivityTimeActivityID.RAIDERS_LOST_ARK
	self.btnKillGo:addTouchEventListener(handler(self, self.onKillGoClick))
	self.btnGetGold:addTouchEventListener(handler(self, self.onQuickBuyClick))
	self.btnGetGold_2:addTouchEventListener(handler(self, self.onQuickBuyClick))
	self.btnGetGold:setTag(725801)
	self.btnGetGold_2:setTag(725901)
end
function raidersLostArkGetKeyPopView:initData(chooseIndex)
	self.chooseIndex = chooseIndex
	if not self.chooseIndex then
		return
	end
	local chestInfo = raidersLostArkRead:getTreasureChestInfo(self.chooseIndex)
	local keyTable = raidersLostArkRead:getTreasureKeyTable(self.chooseIndex)
	local keyNameStr = ""
	for i, v in ipairs(keyTable) do
		local singleKey = publicRead.getName(v)
		if i == 1 then
			keyNameStr = keyNameStr .. singleKey
		elseif i <= #keyTable then
			keyNameStr = keyNameStr .. "、" .. singleKey
		end
	end
	raidersLostArkRead = nil
	;(nil).name = keyNameStr
	;(nil).box = i18n(chestInfo.name)
	self.txtBox:setString(i18n("Martial_arts_text_02", nil))
	local keyBoxCount = backpackCtrl:getItemCount(725801)
	local keyBoxCount2 = backpackCtrl:getItemCount(725901)
	raidersLostArkRead = i18n("Martial_arts_text_02", nil)
	i18n("Martial_arts_text_02", nil).count = keyBoxCount
	self.txtOwnBox:setString(i18n("common_text_1377", i18n("Martial_arts_text_02", nil)))
	raidersLostArkRead = i18n("common_text_1377", i18n("Martial_arts_text_02", nil))
	i18n("common_text_1377", i18n("Martial_arts_text_02", nil)).count = keyBoxCount2
	self.txtOwnBox_2:setString(i18n("common_text_1377", i18n("common_text_1377", i18n("Martial_arts_text_02", nil))))
	self.txtOwnBox:setColor(0 < keyBoxCount and cc.c3b(215, 195, 155) or cc.c3b(255, 0, 0))
	self.txtOwnBox_2:setColor(0 < keyBoxCount2 and cc.c3b(215, 195, 155) or cc.c3b(255, 0, 0))
end
function raidersLostArkGetKeyPopView:onKillGoClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local currentScene = display.getRunningScene()
		if currentScene.name == "MainScene" then
			local currentView = currentScene:currentSceneShowView()
			if currentView.__cname ~= "worldMapView" then
				_ENV = nil
				;(nil).msg = "MESSAGE_MAINSCEN_ONSHOW"
				;(nil).viewType = VIEW_TYPE_MAP
				SoraDSendMessage(nil)
			end
		end
		SoraDRemoveAllPanelFromManager()
		_ENV = nil
		mildGuideManager:starToWorldAndKillMonster(nil)
	end
end
function raidersLostArkGetKeyPopView:onQuickBuyClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local keyBoxCount = backpackCtrl:getItemCount(button:getTag())
		if 0 < keyBoxCount then
			if button:getTag() == 725801 then
				_ENV, _ENV = button:getTag()
				button:getTag().id = button:getTag()
				button:getTag().itemData, button:getTag().count = button:getTag()
				uiManager:show("newItemSingleUse", button:getTag())
			else
				_ENV = button:getTag()
				button:getTag().itemID = button:getTag()
				uiManager:show("CommonSelectResourceBox", button:getTag())
			end
		else
			local msgBoxPanel = SoraDShowMsgBox(i18n("Martial_arts_text_04"), i18n("common_text_477"), nil, function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					if GLOBAL_GAME_RECHARGE_MODE then
						_ENV = nil
						;(nil).rechargeID = 13920
						uiManager:show("rechargeView", nil)
					else
						local panel = SoraDCreatePanel("rechargeView")
						panel:expect2SelectTabEx(gRechargeCenterCategory.HOTGIFT, 13920)
						panel:show()
					end
				end
			end)
		end
	end
end
function raidersLostArkGetKeyPopView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return raidersLostArkGetKeyPopView
