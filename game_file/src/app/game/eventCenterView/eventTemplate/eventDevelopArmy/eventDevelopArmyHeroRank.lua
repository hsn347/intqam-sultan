local gametop = gModuleMgr.getObject("gametop")
local newActivityCtrl = gametop.playertop_:getModule("newActivityCtrl")
local publicRead = include("publicRead")
local eventDevelopArmyHeroRank = class("eventDevelopArmyHeroRank", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventDevelopArmyHeroRank")
	end
	return target
end)
function eventDevelopArmyHeroRank:ctor()
	self.tabData, _ENV = nil, nil
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_eventPerson")
	self.ccs_title:setTitle(i18n("common_text_1875"))
	self.Image_eventBg = SoraDGetChildByName(self, "Image_eventBg")
	self.Image_eventBg:loadTexture(SoraDCheckPNG("bg_Development_army.png", gDefaultPNG.ACTIVITY_BG), ccui.TextureResType.plistType)
	self.text_myRank = SoraDGetChildByName(self, "Text_myRank")
	self.btn_help = SoraDGetChildByName(self, "Button_help")
	self.btn_help:addTouchEventListener(handler(self, self.btnHelpClickCallBack))
	self.btn_history = SoraDGetChildByName(self, "Button_historyRank")
	self.btn_history:setTitleText(i18n("common_text_2713"))
	self.btn_history:addTouchEventListener(handler(self, self.btnHistoryClickCallBack))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_rank")
	SoraDGetChildByName(self, "Size_Tile_bg"):setFillType(1)
	self:initData()
	self:initScroll()
end
function eventDevelopArmyHeroRank:initData()
	self.tabData = newActivityCtrl:getDevelopArmyRankReward()
	local info = newActivityCtrl:getDevelopArmamentInfo()
	local rank = info.rank < 1 and "5000+" or info.rank
	newActivityCtrl = nil
	;(nil).rank = rank
	self.text_myRank:setString(i18n("common_text_825", nil))
end
function eventDevelopArmyHeroRank:initScroll()
	local headNum = #self.tabData
	local singleNum = 0
	for i = 1, #self.tabData do
		singleNum = singleNum + #self.tabData[i].reward
	end
	local scrollH = math.max(self.scroll:getContentSize().height, 40 * headNum + 60 * singleNum)
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	local innerHeight = 0
	for i = 1, #self.tabData do
		local data = self.tabData[i]
		local head = self:getPanelHead(data.rank)
		head:setPosition(cc.p(0, scrollH - 40 - innerHeight))
		head:addTo(self.scroll)
		innerHeight = innerHeight + 40
		for j = 1, #data.reward do
			local single = self:getPanelSingle(data.reward[j])
			single:setPosition(cc.p(0, scrollH - 60 - innerHeight))
			single:addTo(self.scroll)
			innerHeight = innerHeight + 60
		end
	end
end
function eventDevelopArmyHeroRank:btnHelpClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("common_text_2727"))
	end
end
function eventDevelopArmyHeroRank:btnHistoryClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("eventDevelopArmyHistoryRank"):show()
	end
end
function eventDevelopArmyHeroRank:getPanelHead(rank)
	local single = SoraDGetChildByName(self, "Panel_head"):clone()
	local str = ""
	if rank[1] == rank[2] then
		str = "NO." .. rank[1]
	else
		str = "NO." .. rank[1] .. "~" .. "NO." .. rank[2]
	end
	SoraDGetChildByName(single, "Text_rank"):setString(str)
	return single
end
function eventDevelopArmyHeroRank:getPanelSingle(reward)
	local single = SoraDGetChildByName(self, "Panel_single"):clone()
	local des = SoraDGetChildByName(single, "Text_itemDes")
	local num = SoraDGetChildByName(single, "BitmapFontLabel_num")
	local line = SoraDGetChildByName(single, "Image_line")
	line:setOpacity(20)
	des:setString(publicRead.getName(reward.id))
	num:setString("x" .. reward.count)
	local item = SoraDGetExtendChildFromCCSByName(single, "CCS_commonItemAward")
	item:setScale(0.55)
	item:setBaseScale(1.0)
	item:setOwnView(self)
	item:initData(reward.id)
	return single
end
return eventDevelopArmyHeroRank
