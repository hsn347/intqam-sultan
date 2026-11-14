local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local babelTowerCtrl = SoraDGetCtrl("babelTowerCtrl")
local babelTowerRead = gModuleMgr.sharedMgr("babelTowerRead")
local babelTowerFloorInfo = class("babelTowerFloorInfo", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("babelTowerFloorInfo")
end)
_UPVALUE3_ = "babelTowerFloorInfo"
;("babelTowerFloorInfo")[1] = "Promise_Summit_text_30"
;("babelTowerFloorInfo")[2] = "Promise_Summit_text_31"
local ("babelTowerFloorInfo")[3], eventName = "Promise_Summit_text_32", "babelTowerFloorInfo"
function babelTowerFloorInfo:onExitPanel()
	_ENV = nil
	;(nil).msg = "MESSAGE_BABEL_TOWER_REFRESH"
	;(nil).subMsg = "floorInfoClose"
	SoraDSendMessage(nil)
end
function babelTowerFloorInfo:ctor(properties)
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.textMonterName = SoraDGetChildByName(self.node, "Text_monterName")
	self.textMonterTalk = SoraDGetChildByName(self.node, "Text_monterTalk")
	self.textMonterTalk:setString(i18n("Promise_Summit_text_11"))
	self.textDropTip = SoraDGetChildByName(self.node, "Text_dropTip")
	self.textDropTip:setString(i18n("Promise_Summit_text_34"))
	self.textEventList = SoraDGetChildsArrayByName(self.node, "Text_name_", 3, 1)
	self.btnFight = SoraDGetChildByName(self.node, "Button_normal")
	if G_IS_UNITY then
		self.btnFight:getTitleRenderer():setAutoSize(fgui.AutoSizeType.Both)
	end
	self.nodeCostNum = SoraDGetChildByName(self.btnFight, "Node_NumCost")
	self.textNumCost = SoraDGetChildByName(self.nodeCostNum, "Text_NumCost")
	self.btnFight:addTouchEventListener(handler(self, self.btnFightClick))
	self.checkBox = SoraDGetChildByName(self, "CheckBox_1")
	self.checkBox:setSelected(babelTowerCtrl:getIsSkipInfo())
	self.Text_checkBox = SoraDGetChildByName(self, "Text_checkBox")
	self.Text_checkBox:setString(i18n("Promise_Summit_text_56"))
	self:addButterfly()
end
function babelTowerFloorInfo:initData(floor, door)
	self.door = door
	self.nowFloor = floor
	_ENV = nil
	;(nil).num = SoraDFPosX(door, 4)
	self.textMonterName:setString(i18n("Promise_Summit_text_10", nil))
	self.costItemNum = babelTowerRead:getCostItemAndNum(floor)
	self.itemNumHave = backpackCtrl:getItemCount(self.costItemNum[1])
	self.textNumCost = SoraDChangeTextToHtml(self.textNumCost)
	_ENV = i18n("Promise_Summit_text_10", nil)
	i18n("Promise_Summit_text_10", nil).member = self.itemNumHave
	_ENV, _ENV, i18n("Promise_Summit_text_10", nil).total = i18n("Promise_Summit_text_10", nil)
	self.costItemNum[2].member, i18n("Promise_Summit_text_10", nil).color = i18n("Promise_Summit_text_10", nil)
	self.textNumCost:setString(i18n_html("common_text_155", i18n("Promise_Summit_text_10", nil)))
	SoraDToCenter(self.nodeCostNum, 0, not SoraDFIsRA())
	for i, v in ipairs(self.textEventList) do
		v:setString(i18n(eventName[i]))
	end
	if babelTowerCtrl:isFirstClimb() then
		self.nodeCostNum:setVisible(false)
		self.btnFight:setTitleText(i18n("Promise_Summit_text_45"))
		self.btnFight:getTitleRenderer():setPositionY(36)
		SoraDAutoSizeButtonText(self.btnFight, cc.size(210, 60))
	else
		self.nodeCostNum:setVisible(true)
		self.btnFight:setTitleText(i18n("arena_btn_04"))
		self.btnFight:getTitleRenderer():setPositionY(G_IS_UNITY and 46 or 24)
		SoraDAutoSizeButtonText(self.btnFight, cc.size(210, 30))
	end
end
function babelTowerFloorInfo:btnFightClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if self.costItemNum[2] > self.itemNumHave and not babelTowerCtrl:isFirstClimb() then
			SoraDShowMsgBox(i18n("Promise_Summit_text_65"), i18n("common_text_204"), i18n("common_text_185"), function(eventType)
				if eventType == MSGBOX_CALLBACK_YES then
					self:openRechargeView()
				end
			end)
		else
			local sureFunc = function(isSelected)
				babelTowerCtrl = nil
				;(nil).floor = self.nowFloor
				;(nil).door = self.door
				babelTowerCtrl:reqTongtianTowerClimb(nil)
				babelTowerCtrl:setIsSkipInfo(isSelected)
				self:removeFromParent()
			end
			if self.checkBox:isSelected() then
				SoraDShowMsgBoxNew(i18n("Promise_Summit_text_57"), nil, i18n("common_text_185"), function(exitType, other)
					if exitType == MSGBOX_CALLBACK_YES then
						sureFunc(true)
						return
					end
				end)
			else
				sureFunc(false)
			end
		end
	end
end
function babelTowerFloorInfo:addButterfly()
	local spBufffly = display.newSprite("dh_xuyuanshuhd_00.png")
	spBufffly:addTo(self.node)
	spBufffly:setPosition(-200, 240)
	local frames = display.newFrames("dh_xuyuanshuhd_%.2d.png", 0, 21)
	local animation = display.newAnimation(frames, 2.45 / #frames)
	spBufffly:playAnimationForever(animation)
end
function babelTowerFloorInfo:openRechargeView()
	local giftData = self:getGiftInfo()
	if GLOBAL_GAME_RECHARGE_MODE then
		_ENV = nil
		;(nil).rechargeID = giftData and tonumber(giftData.ID)
		uiManager:show("rechargeView", nil)
	else
		local panel = SoraDCreatePanel("rechargeView")
		if giftData then
			panel:jumpToLimitNode(giftData.category, tonumber(giftData.ID))
		end
		panel:show()
	end
end
function babelTowerFloorInfo:getGiftInfo()
	local giftInfo = rechargeActivityCtrl:getHotActivityList()
	dump(giftInfo, "giftInfo", 10)
	_UPVALUE4_ = giftInfo
	giftInfo[1] = 13941
	giftInfo[2] = 13940
	giftInfo[3] = 13939
	giftInfo[4] = 13938
	for _, v in ipairs(giftInfo) do
		local item = giftInfo[tostring(v)]
		if item and tonumber(item.extraData) >= 1 then
			return item
		end
	end
end
return babelTowerFloorInfo
