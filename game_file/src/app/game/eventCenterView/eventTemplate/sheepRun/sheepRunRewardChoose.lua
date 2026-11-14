local gametop = gModuleMgr.getObject("gametop")
local contactCtrl = gametop.playertop_:getModule("contactCtrl")
local sheepRunCtrl = SoraDGetCtrl("sheepRunCtrl")
local sheepRunRead = include("sheepRunRead")
local sheepRunRewardChoose = class("sheepRunRewardChoose", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("sheepRunRewardChoose")
end)
function sheepRunRewardChoose:ctor(properties)
	_UPVALUE3_ = nil
	self.poolNames, (nil)[1] = nil, "runningSheep_text_04"
	self.poolNames, (nil)[2] = nil, "runningSheep_text_03"
	self.poolNames, (nil)[3] = nil, "runningSheep_text_02"
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("runningSheep_text_23"))
	self.ccs_head = SoraDGetExtendChildFromCCSByName(self, "CCS_commonHead_head")
	self.ccs_head:setVisible(false)
	self.ccs_head:setTouchEnabled(false)
	self.textTips_1 = SoraDGetChildByName(self, "Text_Tips_1")
	self.textTips_1:setString(i18n(self.poolNames[sheepRunCtrl:getCurPool()]))
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.textTips:setString(i18n("runningSheep_text_10"))
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.text_friend = SoraDGetChildByName(self, "Text_friend")
	self.btn_friend = SoraDGetChildByName(self, "Btn_choose_friend")
	self.btn_friend:addTouchEventListener(handler(self, self.onBtnFirend))
	self.btn_go = SoraDGetChildByName(self, "Button_receive")
	self.btn_go:addTouchEventListener(handler(self, self.onBtnGo))
	self.btn_go:setTitleText(i18n("common_text_1139"))
	self.tmpItem = SoraDGetChildByName(self, "Node_Item")
	self.btn_delete_friend = SoraDGetChildByName(self, "Button_remove_friend")
	self.btn_delete_friend:addTouchEventListener(handler(self, self.onDeleteFriend))
	self.chooseID = sheepRunCtrl:getChooseID()
	self:initData()
	self:updateFriendHead()
end
function sheepRunRewardChoose:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SHEEP_RUN_CHOOSE_FRIEND", handler(self, self.onFriendChoose))
	SoraDAddMessage(self, "MESSAGE_SHEEP_RUN_CHOOSE_REWARD", handler(self, self.onRewardChoose))
	SoraDAddMessage(self, "MESSAGE_SHEEP_RUN_DELETE_FRIEND", handler(self, self.onFriendChoose))
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_STATUS_UPDATE", handler(self, self.onFriendChoose))
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_DATA_BACK", handler(self, self.onFriendChoose))
end
function sheepRunRewardChoose:initData()
	self.items, sheepRunCtrl = nil, nil
	local rewards = sheepRunCtrl:getCurRewards()
	for i, v in ipairs(rewards) do
		local newItem = self.tmpItem:clone()
		newItem:setScale(0.8)
		local item = include("commonItemAward").new(SoraDGetChildByName(newItem, "Item"))
		item:setBaseScale(1)
		item:setOwnView(self)
		item:initData(v.item, v.num)
		if v.heightlight then
			item:showLightEffect()
		end
		item:setHandle(handler(self, self.onItemClick))
		SoraDGetChildByName(item, "Button_item").isLongTouch = true
		local heartSp = SoraDGetChildByName(newItem, "Node_check")
		heartSp:setVisible(self.chooseID == v.item)
		local heartSpBg = SoraDGetChildByName(newItem, "Node_check_bg")
		heartSpBg:setVisible(self.chooseID ~= v.item)
		newItem:addTo(self.nodeAward)
		table.insert(self.items, newItem)
	end
	self.nodeAward:setAnchorPoint(cc.p(0.5, 1))
	SoraDautoSortPos(self.nodeAward, 3, 1, cc.size(100, 115), not SoraDFIsRA())
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	guideCtrl:updateGuideModule(gGuideModule.SHEEP_RUN_ACTIVITY)
end
function sheepRunRewardChoose:updateFriendHead()
	local curContactData = sheepRunCtrl:getCurContactData()
	self.ccs_head:setVisible(curContactData ~= nil)
	if not curContactData then
		self.text_friend:setString(i18n("runningSheep_text_25"))
		return
	end
	self.ccs_head:setHeadSprite(curContactData.headid or curContactData.iconID, curContactData.avatar)
	self.ccs_head:setPlayerID(curContactData.uid)
	self.ccs_head:setKid(curContactData.kid or curContactData.sourceKid)
	sheepRunCtrl = i18n("runningSheep_text_25")
	i18n("runningSheep_text_25").name = curContactData.name
	self.text_friend:setString(i18n("runningSheep_text_26", i18n("runningSheep_text_25")))
end
function sheepRunRewardChoose:onFriendChoose(target, data)
	_UPVALUE2_ = nil
	;(nil)[1] = self
	;(nil)[2] = self.updateFriendHead
	dump(nil)
	self:updateFriendHead()
end
function sheepRunRewardChoose:onBtnGo(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.chooseID == nil then
			SoraDShowMsgTip(i18n("runningSheep_text_12"))
			return
		end
		local choosItem = sheepRunCtrl:getChooseItem()
		sheepRunCtrl:reqChooseReward(choosItem.item, choosItem.num)
	end
end
function sheepRunRewardChoose:onBtnFirend(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local mapList = contactCtrl:getContactList()
		if table.nums(mapList) <= 0 then
			local tip = i18n("runningSheep_text_15")
			SoraDShowMsgBoxNew(tip, i18n("common_text_477"), nil, function(exitType, other)
				if exitType ~= MSGBOX_CALLBACK_YES then
					return
				end
				_ENV = nil
				;(nil).viewType = 2
				uiManager:show("friendView", nil)
			end)
		else
			SoraDCreatePanel("sheepRunFriends"):show()
		end
	end
end
function sheepRunRewardChoose:onDeleteFriend(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgBoxNew(i18n("runningSheep_text_29"), nil, nil, function(exitType, other)
			if exitType ~= MSGBOX_CALLBACK_YES then
				return
			end
			sheepRunCtrl:reqDeleteFriend()
		end)
	end
end
function sheepRunRewardChoose:onRewardChoose()
	self:removeFromParent()
end
function sheepRunRewardChoose:onItemClick(target, event, itemID)
	self.chooseID = itemID
	sheepRunCtrl:setChooseID(self.chooseID)
	for i, v in ipairs(self.items) do
		local item = SoraDGetChildByName(v, "Item")
		local heartSp = SoraDGetChildByName(v, "Node_check")
		heartSp:setVisible(self.chooseID == item.itemID)
		local heartSpBg = SoraDGetChildByName(v, "Node_check_bg")
		heartSpBg:setVisible(self.chooseID ~= item.itemID)
	end
end
function sheepRunRewardChoose:gameGuide_getTarget(itemName, parameters)
	if itemName == "frist_item" then
		return SoraDGetChildByName(self.items[1], "Button_item")
	end
	return SoraDGetChildByName(self, itemName)
end
return sheepRunRewardChoose
