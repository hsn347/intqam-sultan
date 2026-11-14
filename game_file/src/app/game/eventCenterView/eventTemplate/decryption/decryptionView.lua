local decryptionCtrl = SoraDGetCtrl("decryptionCtrl")
local decryptionRead = include("decryptionRead")
local decryptionView = class("decryptionView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("decryptionView_ros")
	end
	return target
end)
function decryptionView:ctor()
	self:initWidget()
	self:addMessage()
	SoraDShowLoading(self)
	decryptionCtrl:sendReqGetInfo()
end
function decryptionView:addMessage(...)
	SoraDAddMessage(self, "MESSAGE_DECRYPTION_INFO_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_DECRYPTION_RECEIVE_BACK", handler(self, self.getRewardBack))
	SoraDAddMessage(self, "MESSAGE_DECRYPTION_REFRESH_TASK", handler(self, self.refreshSingleTask))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeEventClose))
end
function decryptionView:initWidget(...)
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("activity_name_05"))
	decryptionCtrl = i18n("activity_name_05")
	i18n("activity_name_05")[1] = "Button_help"
	self.Button_help = SoraDGetChildByFullPath(self.nodeTitle, i18n("activity_name_05"))
	self.Button_help:addTouchEventListener(function(button, etype)
		if etype == ccui.TouchEventType.ended then
			SoraDPlaySound()
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.ANNIVERSARY_UNCOVER)
		end
	end)
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	decryptionCtrl = "Top_Node"
	;("Top_Node")[1] = "Image_bg_main"
	self.Image_bg_main = SoraDGetChildByFullPath(self.Top_Node, "Top_Node")
	self.Image_bg_main:setVisible(false)
	decryptionCtrl = false
	;(false)[1] = "Node_items"
	self.Node_items = SoraDGetChildByFullPath(self.Image_bg_main, false)
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	decryptionCtrl = "Bottom_Node"
	;("Bottom_Node")[1] = "Text_des_bottom"
	self.Text_des = SoraDGetChildByFullPath(self.Bottom_Node, "Bottom_Node")
	self.Text_des:setString(i18n("anniversary_uncover_text_02"))
	decryptionCtrl = i18n("anniversary_uncover_text_02")
	i18n("anniversary_uncover_text_02")[1] = "Node_rewards"
	self.Node_rewards = SoraDGetChildByFullPath(self.Bottom_Node, i18n("anniversary_uncover_text_02"))
	decryptionCtrl = i18n("anniversary_uncover_text_02")
	i18n("anniversary_uncover_text_02")[1] = "Node_box"
	self.Node_box = SoraDGetChildByFullPath(self.Bottom_Node, i18n("anniversary_uncover_text_02"))
	decryptionCtrl = i18n("anniversary_uncover_text_02")
	i18n("anniversary_uncover_text_02")[1] = "Sprite_box"
	self.Sprite_box = SoraDGetChildByFullPath(self.Node_box, i18n("anniversary_uncover_text_02"))
	decryptionCtrl = i18n("anniversary_uncover_text_02")
	i18n("anniversary_uncover_text_02")[1] = "Node_effect"
	self.Node_effect = SoraDGetChildByFullPath(self.Node_box, i18n("anniversary_uncover_text_02"))
	decryptionCtrl = i18n("anniversary_uncover_text_02")
	i18n("anniversary_uncover_text_02")[1] = "Node_effect_down"
	self.Node_effect_down = SoraDGetChildByFullPath(self.Node_box, i18n("anniversary_uncover_text_02"))
	decryptionCtrl = i18n("anniversary_uncover_text_02")
	i18n("anniversary_uncover_text_02")[1] = "Image_touch"
	self.Image_touch = SoraDGetChildByFullPath(self.Node_box, i18n("anniversary_uncover_text_02"))
	self.Image_touch:setTouchEnabled(false)
	self.Image_touch:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			SoraDPlaySound()
			decryptionCtrl:sendReqGetReward(2, 9)
		end
	end)
	self.singleItem = SoraDGetChildByName(self, "Node_single_item")
	self.singleBox = SoraDGetChildByName(self, "Node_single_box")
	if display.height < 960 then
		self.Image_bg_main:setPositionY(self.Image_bg_main:getPositionY() + 40)
		decryptionCtrl = self.Image_bg_main:getPositionY() + 40
		;(self.Image_bg_main:getPositionY() + 40)[1] = "Panel_black"
		local Panel_black = SoraDGetChildByFullPath(self.Top_Node, self.Image_bg_main:getPositionY() + 40)
		Panel_black:setPositionY(Panel_black:getPositionY() + 30)
		Panel_black:setContentSize(cc.size(600, 580))
		self.Bottom_Node:setPositionY(self.Bottom_Node:getPositionY() - 20)
		decryptionCtrl = self.Bottom_Node:getPositionY() - 20
		;(self.Bottom_Node:getPositionY() - 20)[1] = "Sprite_frame_bottom"
		local Sprite_frame_bottom = SoraDGetChildByFullPath(self.Bottom_Node, self.Bottom_Node:getPositionY() - 20)
		Sprite_frame_bottom:setPositionY(Sprite_frame_bottom:getPositionY() - 15)
		self.Text_des:setPositionY(self.Text_des:getPositionY() - 20)
	elseif display.height > 960 then
		decryptionCtrl = self.Text_des.setPositionY
		self.Text_des.setPositionY[1] = "Node_frame_top"
		local Node_frame_top = SoraDGetChildByFullPath(self.Top_Node, self.Text_des.setPositionY)
		Node_frame_top:setVisible(true)
		local offset = display.height - 960
		if 300 < offset then
			local offsetB = offset - 300
			self.Bottom_Node:setPositionY(self.Bottom_Node:getPositionY() + offsetB)
			decryptionCtrl = self.Bottom_Node:getPositionY() + offsetB
			;(self.Bottom_Node:getPositionY() + offsetB)[1] = "Sprite_bg_bottom"
			local Sprite_bg = SoraDGetChildByFullPath(self.Bottom_Node, self.Bottom_Node:getPositionY() + offsetB)
			Sprite_bg:setPositionY(Sprite_bg:getPositionY() - offsetB)
			offset = 300
		end
		self.Top_Node:setPositionY(self.Top_Node:getPositionY() - offset)
		self.nodeTitle:setPositionY(self.nodeTitle:getPositionY() + offset)
		decryptionCtrl = self.nodeTitle:getPositionY() + offset
		;(self.nodeTitle:getPositionY() + offset)[1] = "Panel_cut"
		local Panel_cut = SoraDGetChildByFullPath(Node_frame_top, self.nodeTitle:getPositionY() + offset)
		Panel_cut:setContentSize(cc.size(640, offset))
	end
	decryptionCtrl = SoraDGetChildByFullPath(Node_frame_top, self.nodeTitle:getPositionY() + offset)
	SoraDGetChildByFullPath(Node_frame_top, self.nodeTitle:getPositionY() + offset)[1] = "Image_des_l"
	self.Image_des_l = SoraDGetChildByFullPath(self.Bottom_Node, (SoraDGetChildByFullPath(Node_frame_top, self.nodeTitle:getPositionY() + offset)))
	decryptionCtrl = SoraDGetChildByFullPath(Node_frame_top, self.nodeTitle:getPositionY() + offset)
	SoraDGetChildByFullPath(Node_frame_top, self.nodeTitle:getPositionY() + offset)[1] = "Image_des_r"
	self.Image_des_r = SoraDGetChildByFullPath(self.Bottom_Node, (SoraDGetChildByFullPath(Node_frame_top, self.nodeTitle:getPositionY() + offset)))
	local width = self.Text_des:getContentSize().width
	self.Image_des_l:setContentSize(cc.size(width / 2 + 55, self.Image_des_l:getContentSize().height))
	self.Image_des_r:setContentSize(cc.size(width / 2 + 55, self.Image_des_r:getContentSize().height))
	if display.height <= 960 then
		if display.height < 960 then
			self.Image_des_l:setPositionY(self.Image_des_l:getPositionY() - 20)
			self.Image_des_r:setPositionY(self.Image_des_r:getPositionY() - 20)
		end
		decryptionCtrl = self.Image_des_r:getPositionY() - 20
		;(self.Image_des_r:getPositionY() - 20)[1] = "Sprite_frame_l"
		local Sprite_frame_l = SoraDGetChildByFullPath(self.Top_Node, self.Image_des_r:getPositionY() - 20)
		Sprite_frame_l:setPositionY(Sprite_frame_l:getPositionY() + 30)
		decryptionCtrl = Sprite_frame_l:getPositionY() + 30
		;(Sprite_frame_l:getPositionY() + 30)[1] = "Sprite_frame_r"
		local Sprite_frame_r = SoraDGetChildByFullPath(self.Top_Node, Sprite_frame_l:getPositionY() + 30)
		Sprite_frame_r:setPositionY(Sprite_frame_r:getPositionY() + 30)
	end
end
function decryptionView:initData(...)
	SoraDCloseLoading(self)
	self.taskInfos = decryptionCtrl:getTaskInfos()
	self.Image_bg_main:setVisible(true)
	local item, posx, posy
	local index = 0
	local itemWidth = 115
	for i = 1, 5 do
		posy = itemWidth * (5 - i) - itemWidth * 2.5
		for j = 1, 5 do
			posx = itemWidth * j - itemWidth * 2.5
			if i ~= 5 and j ~= 5 then
				index = index + 1
				if self.taskInfos[index] and decryptionCtrl:checkTaskNotGet(self.taskInfos[index]) then
					item = self:createSingleItem()
					item:setName("item_" .. index)
					item:addTo(self.Node_items)
					item:setPosition(cc.p(posx, posy))
					_ENV = cc.p(posx, posy)
					cc.p(posx, posy).index = index
					cc.p(posx, posy).taskInfo = self.taskInfos[index]
					item:initData(cc.p(posx, posy))
				end
			elseif i ~= 5 or j ~= 5 then
				item = self:createSingleBox()
				item:addTo(self.Node_items)
				item:setPosition(cc.p(posx, posy))
				_ENV = cc.p(posx, posy)
				cc.p(posx, posy).row = i
				cc.p(posx, posy).col = j
				item:initData(cc.p(posx, posy))
			end
		end
	end
	decryptionRead = 9
	;(9)[1] = "id"
	;(9)[2] = "count"
	local rewards = serviceFunctions.tableFormat(decryptionRead.getBoxReward(9), 9)
	local dataCount = 4
	for i = 1, dataCount do
		local singleItem = include("itemSingleView").new()
		singleItem:setPosition(cc.p(100 * i - 250.0, 35))
		singleItem:addTo(self.Node_rewards)
		singleItem:setScale(0.55)
		_ENV, _ENV = cc.p(100 * i - 250.0, 35)
		cc.p(100 * i - 250.0, 35).id = rewards[i].id
		;(0.55).itemData, cc.p(100 * i - 250.0, 35).count = cc.p(100 * i - 250.0, 35)
		singleItem:initData(0.55)
		singleItem:setButtonTag(rewards[i].id)
		singleItem:setItemClickCallback(handler(self, self.showDetail))
	end
	self:refreshFinishBox()
end
function decryptionView:refreshFinishBox(...)
	if decryptionCtrl:checkBoxState(9) then
		if decryptionCtrl:checkBoxReceiveState(9) then
			self.Sprite_box:setSpriteFrame("icon_recruitsupplies_box_02.png")
			self.Node_effect:setVisible(false)
			self.Node_effect_down:setVisible(false)
			self.Image_touch:setTouchEnabled(false)
		else
			self.Sprite_box:setSpriteFrame("icon_recruitsupplies_box_01.png")
			self.Node_effect:setVisible(true)
			self.Node_effect_down:setVisible(true)
			self.Image_touch:setTouchEnabled(true)
		end
	else
		self.Sprite_box:setSpriteFrame("icon_recruitsupplies_box_01.png")
		self.Node_effect:setVisible(false)
		self.Node_effect_down:setVisible(false)
		self.Image_touch:setTouchEnabled(false)
	end
end
function decryptionView:createSingleItem(...)
	local item = self.singleItem:clone()
	decryptionCtrl = nil
	;(nil)[1] = "Sprite_index"
	item.Sprite_index = SoraDGetChildByFullPath(item, nil)
	decryptionCtrl = nil
	;(nil)[1] = "Node_effect"
	item.Node_effect = SoraDGetChildByFullPath(item, nil)
	decryptionCtrl = "Node_effect"
	;("Node_effect")[1] = "Sprite_31"
	SoraDMixtureGLONE(SoraDGetChildByFullPath(item.Node_effect, "Node_effect"))
	decryptionCtrl = SoraDGetChildByFullPath(item.Node_effect, "Node_effect")
	SoraDGetChildByFullPath(item.Node_effect, "Node_effect")[1] = "Image_touch"
	item.Image_touch = SoraDGetChildByFullPath(item, SoraDGetChildByFullPath(item.Node_effect, "Node_effect"))
	item.Image_touch:setTouchEnabled(true)
	item.Image_touch:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			SoraDPlaySound()
			local panel = SoraDCreatePanel("decryptionPopView_ros")
			_ENV = nil
			;(nil).index = item.index
			;(nil).taskInfo = item.taskInfo
			panel:initData(nil)
			panel:show()
		end
	end)
	function item:initData(data)
		if data.index then
			item.index = data.index
			local imageName = string.format("icon_decryption_%.2d.png", item.index)
			item.Sprite_index:setSpriteFrame(imageName)
		end
		if data.taskInfo then
			item.taskInfo = data.taskInfo
			if decryptionCtrl:checkTaskFinishAndNotGet(item.taskInfo) then
				item.Node_effect:setVisible(true)
				item:setLocalZOrder(10)
			end
		end
	end
	return item
end
function decryptionView:setItemFinish(item)
	item.Image_touch:setTouchEnabled(false)
	item.Sprite_index:runAction(cca.fadeOut(0.5))
	_UPVALUE1_ = cca.fadeOut(0.5)
	cca.fadeOut(0.5)[1] = "Sprite_frame"
	SoraDGetChildByFullPath(item, cca.fadeOut(0.5)):setVisible(false)
	local node = SoraDCreatAnimation("decryptionFinish", nil, false)
	node:addTo(item)
	_UPVALUE1_ = cca.fadeOut(0.5)
	cca.fadeOut(0.5)[1] = cca.delay(1.0166666666666666)
	cca.fadeOut(0.5)[2] = cca.callFunc(function()
		item:setVisible(false)
		item.Node_effect:setVisible(false)
	end)
	cca.fadeOut(0.5)[3] = cca.callFunc(function()
		item:setVisible(false)
		item.Node_effect:setVisible(false)
	end)
	item:runAction(cca.seq(cca.fadeOut(0.5)))
end
function decryptionView:createSingleBox(...)
	local item = self.singleBox:clone()
	decryptionCtrl = nil
	;(nil)[1] = "Sprite_arrow_up"
	item.Sprite_arrow_up = SoraDGetChildByFullPath(item, nil)
	decryptionCtrl = nil
	;(nil)[1] = "Sprite_arrow_left"
	item.Sprite_arrow_left = SoraDGetChildByFullPath(item, nil)
	decryptionCtrl = nil
	;(nil)[1] = "Sprite_box"
	item.Sprite_box = SoraDGetChildByFullPath(item, nil)
	decryptionCtrl = nil
	;(nil)[1] = "Node_effect"
	item.Node_effect = SoraDGetChildByFullPath(item, nil)
	decryptionCtrl = nil
	;(nil)[1] = "Image_touch"
	item.Image_touch = SoraDGetChildByFullPath(item, nil)
	item.Image_touch:setTouchEnabled(true)
	item.Image_touch:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			SoraDPlaySound()
			local panel = SoraDCreatePanel("decryptionRewardsPopView_ros")
			_ENV = nil
			;(nil).index = item.index
			panel:initData(nil)
			panel:show()
		end
	end)
	function item:initData(data)
		item.index = 0
		if data.row == 5 then
			item.Sprite_arrow_left:setVisible(false)
			item.index = 2 * data.col
		end
		if data.col == 5 then
			item.Sprite_arrow_up:setVisible(false)
			item.index = 2 * data.row - 1
		end
		item:setName("box_" .. item.index)
		item:setBoxState()
	end
	function item:setBoxState(...)
		item.Sprite_box:stopAllActions()
		item.Node_effect:stopAllActions()
		if decryptionCtrl:checkBoxState(item.index) then
			if decryptionCtrl:checkBoxReceiveState(item.index) then
				item.Sprite_box:setSpriteFrame("icon_Daily_reward_treasure_S_open.png")
				item.Image_touch:setTouchEnabled(false)
				item.Node_effect:setVisible(false)
			else
				item.Node_effect:setVisible(true)
				local delayTime = math.random(10, 40)
				_UPVALUE6_ = nil
				;(nil)[1] = cca.delay(delayTime / 120)
				;(nil)[2] = cca.rotateTo(0.125, 10)
				;(nil)[3] = cca.rotateTo(0.10833333333333334, -10)
				;(nil)[4] = cca.rotateTo(0.1, 8)
				;(nil)[5] = cca.rotateTo(0.08333333333333333, -5)
				;(nil)[6] = cca.rotateTo(0.075, 2)
				;(nil)[7] = cca.rotateTo(0.075, 0)
				;(nil)[8] = cca.rotateTo(0.075, 0)
				;(nil)[9] = cca.rotateTo(0.075, 0)
				local action = cca.repeatForever(cca.seq(nil))
				item.Sprite_box:runAction(action:clone())
				item.Node_effect:runAction(action:clone())
			end
		else
			item.Sprite_box:setSpriteFrame("icon_Daily_reward_treasure_S_close.png")
			item.Image_touch:setTouchEnabled(true)
		end
	end
	return item
end
function decryptionView:showDetail(target, etype)
	if etype == ccui.TouchEventType.ended or etype == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		self:stopAllActions()
		if self.tips then
			self.tips:removeFromParent()
			self.tips = nil
		end
	elseif etype == ccui.TouchEventType.began then
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(0.2)
		;(nil)[2] = cca.callFunc(function()
			if self.tips then
				self.tips:removeFromParent()
				self.tips = nil
			end
			self.tips = SoraDCreatePanel("commonItemTips")
			self.tips:initData(target:getTag())
			self.tips:setPosition(cc.p(180, 290))
			self.tips:addTo(self, 99)
		end)
		;(nil)[3] = cca.callFunc(function()
			if self.tips then
				self.tips:removeFromParent()
				self.tips = nil
			end
			self.tips = SoraDCreatePanel("commonItemTips")
			self.tips:initData(target:getTag())
			self.tips:setPosition(cc.p(180, 290))
			self.tips:addTo(self, 99)
		end)
		self:runAction(cca.seq(nil))
	end
end
function decryptionView:getRewardBack(target, redata)
	local index = redata.nIndex or 0
	if redata.nType == 1 then
		local item = self.Node_items:getChildByName("item_" .. index)
		if item then
			self:setItemFinish(item)
			self:refreshBoxAfterGetReward(index)
			self:refreshFinishBox()
		end
	elseif redata.nType == 2 then
		if index == 9 then
			self:refreshFinishBox()
		else
			self:refreshBoxByIndex(index)
		end
	end
end
function decryptionView:refreshSingleTask(target, redata)
	self.taskInfos = decryptionCtrl:getTaskInfos()
	local index = redata.nIndex or 0
	local item = self.Node_items:getChildByName("item_" .. index)
	if item then
		decryptionCtrl = index
		index.taskInfo = self.taskInfos[index]
		item:initData(index)
		self:refreshBoxAfterGetReward(index)
		self:refreshFinishBox()
	end
end
function decryptionView:refreshBoxAfterGetReward(index)
	local row = math.ceil(index / 4)
	local col = (index - 1) % 4 + 1
	row = 2 * row - 1
	col = 2 * col
	self:refreshBoxByIndex(row)
	self:refreshBoxByIndex(col)
end
function decryptionView:refreshBoxByIndex(index)
	local box = self.Node_items:getChildByName("box_" .. index)
	if box then
		box:setBoxState()
	end
end
function decryptionView:judgeEventClose(target, redata)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.DECRYPTION_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return decryptionView
