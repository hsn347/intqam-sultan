local legendLordWarltCtrl = include("legendLordWarltCtrl")
local publicRead = include("publicRead")
local effectUI = include("effectUI")
local legendaryKingReward = class("legendaryKingReward", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateTouchPanel("legendaryKingReward")
		end
		if type(target) == "string" then
			return SoraDCreateTouchPanel(target)
		end
		return target
	end
end)
function legendaryKingReward:ctor()
	self:createUI()
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.bg_frame = SoraDGetChildByName(self, "bg_frame")
	self.Image_4 = SoraDGetChildByName(self, "Image_4")
	self.Image_4_0 = SoraDGetChildByName(self, "Image_4_0")
	self.frame_Daily_reward_lace_red_02_2 = SoraDGetChildByName(self, "frame_Daily_reward_lace_red_02_2")
	self.frame_Daily_reward_lace_red_01_4 = SoraDGetChildByName(self, "frame_Daily_reward_lace_red_01_4")
	self.frame_Daily_reward_lace_red_02_2_0 = SoraDGetChildByName(self, "frame_Daily_reward_lace_red_02_2_0")
	self.frame_Daily_reward_lace_red_01_4_0 = SoraDGetChildByName(self, "frame_Daily_reward_lace_red_01_4_0")
	self.top_lacel = SoraDGetChildByName(self, "top_lacel")
	self.Node_effect = SoraDGetChildByName(self, "Node_effect")
	self.dh_rcjl_01 = SoraDGetChildByName(self, "dh_rcjl_01")
	self.Particle_1 = SoraDGetChildByName(self, "Particle_1")
	self.Particle_2 = SoraDGetChildByName(self, "Particle_2")
	self.Particle_3 = SoraDGetChildByName(self, "Particle_3")
	self.Particle_3_0 = SoraDGetChildByName(self, "Particle_3_0")
	self.Particle_4 = SoraDGetChildByName(self, "Particle_4")
	self.Particle_4_0 = SoraDGetChildByName(self, "Particle_4_0")
	self.Particle_5 = SoraDGetChildByName(self, "Particle_5")
	self.Particle_5_0 = SoraDGetChildByName(self, "Particle_5_0")
	self.Particle_6 = SoraDGetChildByName(self, "Particle_6")
	self.Particle_7 = SoraDGetChildByName(self, "Particle_7")
	self.Particle_8 = SoraDGetChildByName(self, "Particle_8")
	self.Particle_8_0 = SoraDGetChildByName(self, "Particle_8_0")
	self.Particle_9_0 = SoraDGetChildByName(self, "Particle_9_0")
	self.Node_particle = SoraDGetChildByName(self, "Node_particle")
	self.Particle_15 = SoraDGetChildByName(self, "Particle_15")
	self.Particle_16 = SoraDGetChildByName(self, "Particle_16")
	self.Panel_item_1 = SoraDGetChildByName(self, "Panel_item_1")
	self.Panel_item_2 = SoraDGetChildByName(self, "Panel_item_2")
	self.Panel_item_3 = SoraDGetChildByName(self, "Panel_item_3")
	self.Panel_1 = SoraDGetChildByName(self, "Panel_1")
	self.Text_Title = SoraDGetChildByName(self, "Text_Title")
	self.btn_more = SoraDGetChildByName(self, "btn_more")
	self.btn_confirm = SoraDGetChildByName(self, "btn_confirm")
	self.btn_more:addTouchEventListener(handler(self, self.onClickBtnMore))
	self.btn_confirm:addTouchEventListener(handler(self, self.onClickBtnConfirm))
	self.btn_more:setTitleText(i18n("common_text_486"))
	self.btn_confirm:setTitleText(i18n("common_text_204"))
	_UPVALUE3_ = self.btn_confirm.setTitleText
	self.rewardNodeArray, self.btn_confirm.setTitleText[1] = self.btn_confirm.setTitleText, self.Panel_item_1
	self.rewardNodeArray, self.btn_confirm.setTitleText[2] = self.btn_confirm.setTitleText, self.Panel_item_2
	self.rewardNodeArray, self.btn_confirm.setTitleText[3] = self.btn_confirm.setTitleText, self.Panel_item_3
end
function legendaryKingReward:createUI()
end
function legendaryKingReward:init(mapid)
	self.mapid = mapid
	self.kingReward = legendLordWarltCtrl.getLegendLordWarRankReward(1, self.mapid)
	if worldMapDefine.isKingStarMapId(self.mapid) then
		self.Text_Title:setString(i18n("kingstarbattle_text_58"))
	else
		self.Text_Title:setString(i18n("common_text_4219"))
	end
	for i, v in ipairs(self.rewardNodeArray) do
		local Image_bg = SoraDGetChildByName(v, "Image_bg")
		local Image_item = SoraDGetChildByName(v, "Image_item")
		local Text_item_name = SoraDGetChildByName(v, "Text_item_name")
		local reward = self.kingReward[i]
		local itemId = reward.id
		local itemNum = reward.count
		Image_bg:loadTexture(publicRead.getBg(itemId), ccui.TextureResType.plistType)
		Image_item:loadTexture(publicRead.getIcon(itemId), ccui.TextureResType.plistType)
		local itemName = publicRead.getName(itemId)
		legendLordWarltCtrl = i18n("common_text_4219")
		i18n("common_text_4219").name = itemName
		i18n("common_text_4219").count = itemNum
		Text_item_name:setString(i18n("common_text_1460", i18n("common_text_4219")))
		Image_bg.itemId = itemId
		Image_bg:setTouchEnabled(true)
		Image_bg:addTouchEventListener(handler(self, self.onClick_show))
	end
	self.glow1, self.glow2 = effectUI.getItemEffect()
	self.glow1:addTo(self.Panel_item_2)
	self.glow1:setScale(1.2)
	self.glow1:setPosition(cc.p(80, 70))
	self.glow1:setLocalZOrder(-1)
	self.glow1:setScale(1.4)
	self.glow2:addTo(self.Panel_item_2)
	self.glow2:setScale(1.2)
	self.glow2:setPosition(cc.p(60, 70))
	self.glow2:setLocalZOrder(1)
	self.glow2:setScale(1.4)
end
function legendaryKingReward:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UI_LEGENDKINGREWARD_SHOW_ITEMINFO", handler(self, self.msgShowItemInfo))
end
function legendaryKingReward:onClick_show(sender, event)
	if event == ccui.TouchEventType.began then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(sender, self.scroll, event) then
			print("node is not on view")
			return
		end
		SoraDPlaySound()
		self:openItemInfo(sender.itemId, sender)
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
		self:closeItemInfo()
	elseif event == ccui.TouchEventType.ended then
		self:closeItemInfo()
	end
end
function legendaryKingReward:openItemInfo(id, sender)
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_LEGENDKINGREWARD_SHOW_ITEMINFO"
	;(nil).isShow = true
	;(nil).id = id
	;(nil).item = sender
	SoraDSendMessage(nil)
end
function legendaryKingReward:closeItemInfo()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_LEGENDKINGREWARD_SHOW_ITEMINFO"
	;(nil).isShow = false
	SoraDSendMessage(nil)
end
function legendaryKingReward:msgShowItemInfo(target, data)
	local isShow = data.isShow
	if isShow == true then
		self:openItemInfoMsg(data)
	else
		self:closeItemInfoMsg(data)
	end
end
function legendaryKingReward:openItemInfoMsg(data)
	local itemID = data.id
	local item = data.item
	if self.itemTips == nil then
		self.itemTips = SoraDCreatePanel("commonItemTips")
		self.itemTips:setPositionY(50)
		self.itemTips:addTo(self)
		self.itemTips:setLocalZOrder(10)
		self.itemTips:setVisible(false)
	end
	local worldPos = item:convertToWorldSpace(cc.p(0, 0))
	local nodePos = self:convertToNodeSpace(worldPos)
	local deltaTipX = 0
	if SoraDFIsRA() then
		deltaTipX = 0
	else
		deltaTipX = -280
	end
	if nodePos.x > 300 then
		self.itemTips:setPositionX(nodePos.x + 15 + deltaTipX)
	else
		self.itemTips:setPositionX(nodePos.x + 325 + deltaTipX)
	end
	self.itemTips:setPositionY(nodePos.y + 200)
	self.itemTips:setVisible(true)
	if gIDType.EQUIPMENT == JudgeItemType(itemID) then
		local equipDesRead = include("equipDesRead")
		local equipmentltCtrl = include("equipmentltCtrl")
		local itemName = equipDesRead.getName(itemID)
		local baseProperty, mayVal = equipmentltCtrl.getEquipmentBaseProperty(itemID, 999, 0)
		local baseString = equipDesRead.getAttrName(baseProperty, mayVal)
		local itemContent = baseString .. "\n" .. i18n("common_text_1344")
		self.itemTips:customData(itemName, itemContent)
	else
		self.itemTips:initData(itemID)
	end
end
function legendaryKingReward:closeItemInfoMsg(data)
	if self.itemTips then
		self.itemTips:setVisible(false)
	end
end
function legendaryKingReward:onClickBtnMore(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if worldMapDefine.isKingStarMapId(self.mapid) then
			local panel = SoraDCreatePanelByFixName("kingStarRewardDetail")
			panel:init(self.mapid)
			panel:show()
		else
			local panel = SoraDCreatePanel("legendaryKingRewardDetail")
			panel:init(self.mapid)
			panel:show()
		end
	end
end
function legendaryKingReward:onClickBtnConfirm(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:closePanel()
	end
end
return legendaryKingReward
