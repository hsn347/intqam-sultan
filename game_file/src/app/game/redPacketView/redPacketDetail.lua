local gametop = gModuleMgr.getObject("gametop")
local lordLocalData = include("lordLocalData")
local chatFunctions = include("chatFunctions")
local redPacketDetail = class("redPacketDetail", function(target)
	if target == nil then
		return SoraDCreateBasePanel("redPacketDetail")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function redPacketDetail:ctor()
	self.needCallBack2SDK = true
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_Node")
	self.title:setTitle(i18n("common_text_1778"))
	self.mailViewFrame = SoraDGetExtendChildFromCCSByName(self, "CCS_mailViewFrame_node", true)
	self.text_playr = SoraDGetChildByName(self, "Top_text_player_name")
	self.text_send_time = SoraDGetChildByName(self, "Top_text_send_time")
	self.scrollView = SoraDGetExtendChildFromCCSByName(self, "CCS_redPacketDetailScrollView_node", true)
	self.text_bottom = SoraDGetChildByName(self, "text_bottom")
	self.text_info = SoraDGetChildByName(self, "text_info")
	self.topBar = SoraDGetChildByName(self, "Top_bar_bg")
	self.imgLine = SoraDGetChildByName(self, "Top_img_line")
	self.playerAvatarBoxNode = SoraDCreatePanel("playerAvatarBox")
	self.playerAvatarBoxNode:setContentSize(cc.size(self.playerAvatarBoxNode:getItemWidth(), self.playerAvatarBoxNode:getItemHeight()))
	self.playerAvatarBoxNode:setAnchorPoint(cc.p(0.5, 1))
	self.playerAvatarBoxNode:setPosition(cc.p(320, display.height - 110))
	self.playerAvatarBoxNode:addTo(self)
	self.playerAvatarBoxNode:setLocalZOrder(1)
	self.goldInfoPanel = SoraDGetChildByName(self, "Top_node_goldInfo")
	self.text_gold_number = SoraDGetChildByName(self, "text_gold_number")
	self.text_gold_info = SoraDGetChildByName(self, "text_gold_info")
	self.text_gold_info:setString(i18n("common_text_1783"))
	self.goldInfoPanel:setVisible(false)
	self.deltaGoldInfoHeight = 80
end
function redPacketDetail:initWithData(data)
	self.itemData = clone(data)
	self:initGoldInfo()
	local timeStr = os.date("%Y-%m-%d %H:%M:%S ", self.itemData.begintime)
	self.text_send_time:setString(timeStr)
	local iconID = self.itemData.iconid
	local headImg = lordLocalData.getHead(iconID)
	if self.itemData.npcId and self.itemData.npcId ~= 0 then
		headImg = chatFunctions:getNpcHead(self.itemData.npcId)
	end
	_ENV = chatFunctions:getNpcHead(self.itemData.npcId)
	chatFunctions:getNpcHead(self.itemData.npcId).playerId = self.itemData.sender
	chatFunctions:getNpcHead(self.itemData.npcId).imageId = iconID
	chatFunctions:getNpcHead(self.itemData.npcId).imgPlayer = headImg
	chatFunctions:getNpcHead(self.itemData.npcId).avatar = self.itemData.avatar
	chatFunctions:getNpcHead(self.itemData.npcId).chatType = nil
	local chatFunctions:getNpcHead(self.itemData.npcId).alv, avatarBoxData = nil, chatFunctions:getNpcHead(self.itemData.npcId)
	self.playerAvatarBoxNode:initWithData(avatarBoxData)
	local mailFunctions = include("mailFunctions")
	local name = self.itemData.nickname
	if self.itemData.type == 2 then
		name = mailFunctions:getWrappedName(self.itemData.allianceAbbr, self.itemData.nickname)
	end
	if self.itemData.npcId and self.itemData.npcId ~= 0 then
		name = chatFunctions:getNpcName(self.itemData.npcId)
	end
	self.redEnvelopesType = self.itemData.redEnvelopesType or gRedEnvelopesType.GOLD_GIFT
	if self.redEnvelopesType == gRedEnvelopesType.GOLD_GIFT then
		_ENV = nil
		;(nil).name = name
		self.text_playr:setString(i18n("common_text_1847", nil))
	else
		_ENV = i18n("common_text_1847", nil)
		i18n("common_text_1847", nil).name = name
		self.text_playr:setString(i18n("common_text_3476", i18n("common_text_1847", nil)))
	end
	self.scrollView:initWithData(self.itemData)
	if self.itemData.left ~= 0 then
		local countStr = string.format("%d/%d", #self.itemData.log, self.itemData.num)
		local claimGold = 0
		for i, v in ipairs(self.itemData.log) do
			claimGold = claimGold + v.gold
		end
		local goldStr = string.format("%d/%d", claimGold, self.itemData.total)
		_ENV = v.gold
		v.gold.count = countStr
		v.gold.gold = goldStr
		self.text_info:setString(i18n("common_text_1777", v.gold))
		if self.redEnvelopesType == gRedEnvelopesType.RED_PACKAGE_ACTIVITY then
			self.text_bottom:setString(i18n("common_text_4112"))
		else
			self.text_bottom:setString(i18n("common_text_1779"))
		end
	else
		_ENV = self.text_bottom
		self.text_bottom.count = self.itemData.num
		self.text_bottom.gold = self.itemData.total
		self.text_info:setString(i18n("common_text_1780", self.text_bottom))
		local timeStr = SoraDConvertSecondToString(self.itemData.lasttime - self.itemData.begintime)
		_ENV = i18n("common_text_1780", self.text_bottom)
		i18n("common_text_1780", self.text_bottom).time = timeStr
		self.text_bottom:setString(i18n("common_text_1784", i18n("common_text_1780", self.text_bottom)))
	end
end
function redPacketDetail:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UI_SHOW_ITEMINFO", handler(self, self.openItemInfo))
	SoraDAddMessage(self, "MESSAGE_UI_CLOSE_ITEMINFO", handler(self, self.closeItemInfo))
end
function redPacketDetail:initGoldInfo()
	local chatFunctions = include("chatFunctions")
	local isClaim = false
	local claimGold = 0
	local playerId = chatFunctions:getSelfId()
	for i, v in ipairs(self.itemData.log) do
		if playerId == v.uid then
			isClaim = true
			claimGold = v.gold
			break
		end
	end
	if isClaim then
		self.goldInfoPanel:setVisible(true)
		self.text_gold_number:setString(claimGold)
	else
		_UPVALUE2_ = self.text_gold_number
		self.text_gold_number[1] = self.topBar
		self.text_gold_number[2] = self.imgLine
		for i, v in ipairs(self.text_gold_number) do
			v:setPositionY(v:getPositionY() + self.deltaGoldInfoHeight)
		end
		self.scrollView:adjustHeight(self.deltaGoldInfoHeight)
	end
end
function redPacketDetail:openItemInfo(target, data)
	local itemID = data.id
	local item = data.item
	if self.itemTips == nil then
		self.itemTips = SoraDCreatePanel("commonItemTips")
		self.itemTips:setPositionY(50)
		self.itemTips:addTo(self)
		self.itemTips:setLocalZOrder(100)
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
	self.itemTips:initData(itemID)
end
function redPacketDetail:closeItemInfo(target, data)
	if self.itemTips then
		self.itemTips:setVisible(false)
	end
end
return redPacketDetail
