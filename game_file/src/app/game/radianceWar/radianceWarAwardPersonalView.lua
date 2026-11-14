local radianceActivityCtrl = SoraDGetCtrl("radianceActivityCtrl")
local publicRead = include("publicRead")
local radianceWarRead = include("radianceWarRead")
local radianceWarAwardPersonalView = class("radianceWarAwardPersonalView", function(target)
	target = target or SoraDCreateBasePanel("radianceWarAwardPersonalView")
	if not target then
		target = SoraDCreateBasePanel("radianceWarAwardPersonalView")
		SoraDDeviceFitOffset(target)
	end
	return target
end)
local REWARD_VIEW_TYPE = include("radianceWarDef").REWARD_VIEW_TYPE
_ENV = "radianceWarDef"
;("radianceWarDef").awardTitle = 1
local _ENV, ("radianceWarDef").awardItem, nodeType = nil, 3, "radianceWarDef"
;(nil).REWARD_VIEW_TYPE_CHECKPOINT = 1
local (nil).REWARD_VIEW_TYPE_PALACE, REWARD_VIEW_TYPE_NEXT = 2, nil
function radianceWarAwardPersonalView:ctor(properties)
	self.scrollItems, REWARD_VIEW_TYPE, self.listNode, REWARD_VIEW_TYPE, self.rewardViewType = REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_PERSONAL, REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_PERSONAL, REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_PERSONAL, REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_PERSONAL, REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_PERSONAL
	for _, v in pairs(nodeType) do
		self.listNode[v], REWARD_VIEW_TYPE = nil, nil
	end
	self.scroll = SoraDGetChildByName(self, "ScrollView_Size")
	self.scroll:setSwallowTouches(false)
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self.nodeTitle = SoraDGetChildByName(self, "Node_Title")
	local Text_Tips = SoraDGetChildByName(self, "Text_Tips")
	Text_Tips:setString(i18n("brightWar_text_193"))
	self.btnRank = SoraDGetChildByName(self, "Button_Rank")
	self.btnRank:addTouchEventListener(handler(self, self.btnRankClick))
	self.nodeCommonTabBtnEX = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_Top_Persion")
	if self.nodeCommonTabBtnEX then
		REWARD_VIEW_TYPE = self.nodeCommonTabBtnEX
		self.nodeCommonTabBtnEX.tabNum = 2
		REWARD_VIEW_TYPE, REWARD_VIEW_TYPE, self.nodeCommonTabBtnEX.defaultClick = "CCS_commonTabBtnEX_Top_Persion", self, 1
		;("CCS_commonTabBtnEX_Top_Persion").title = i18n("brightWar_text_210")
		;("CCS_commonTabBtnEX_Top_Persion").handle = handler(self, self.btnTabClick)
		REWARD_VIEW_TYPE, self[1], ("CCS_commonTabBtnEX_Top_Persion").tag = "CCS_commonTabBtnEX_Top_Persion", "CCS_commonTabBtnEX_Top_Persion", REWARD_VIEW_TYPE_NEXT.REWARD_VIEW_TYPE_CHECKPOINT
		;("CCS_commonTabBtnEX_Top_Persion").title = i18n("brightWar_text_209")
		;("CCS_commonTabBtnEX_Top_Persion").handle = handler(self, self.btnTabClick)
		self.nodeCommonTabBtnEX.tabsetArray, self[2], ("CCS_commonTabBtnEX_Top_Persion").tag = self, "CCS_commonTabBtnEX_Top_Persion", REWARD_VIEW_TYPE_NEXT.REWARD_VIEW_TYPE_PALACE
		local param = self.nodeCommonTabBtnEX
		self.nodeCommonTabBtnEX:initView(param)
	end
	SoraDAutoSizeButtonText(self.btnRank, cc.size(210, 70))
end
function radianceWarAwardPersonalView:btnTabClick(showViewType)
	self.showViewType = showViewType
	self.scroll:jumpToTop()
	if self.showViewType == REWARD_VIEW_TYPE_NEXT.REWARD_VIEW_TYPE_CHECKPOINT then
		self.btnRank:setTitleText(i18n("brightWar_text_207"))
		self:initData(2)
	else
		self.btnRank:setTitleText(i18n("brightWar_text_211"))
		self:initData(6)
	end
end
function radianceWarAwardPersonalView:initData(rewardType)
	self:initScroll(radianceWarRead.getRewardList(rewardType))
	self:updateScrollPos()
	self:updateScrollList()
end
local TITLE_HEIGHT = 45
local ITEM_HEIGHT = 100
local TITLE_EXTRA = 58
function radianceWarAwardPersonalView:initScroll(awardList)
	self:recycleAll()
	self.scrollH = 0
	self.offsetY = nil
	for i, v in ipairs(awardList) do
		_ENV = nil
		;(nil).point = nil
		;(nil).posY = 0
		;(nil).nodeType = nodeType.awardTitle
		;(nil).title = v.title
		;(nil).describe = v.describe
		;(nil).frameName = v.type == 5 and "frame_gmzz_zcjl2.png" or "frame_gmzz_zcjl.png"
		table.insert(self.scrollItems, nil)
		self.scrollH = self.scrollH + TITLE_HEIGHT
		if v.describe then
			self.scrollH = self.scrollH + TITLE_EXTRA
		end
		for k, item in ipairs(v.reward) do
			_ENV = nil
			;(nil).point = nil
			;(nil).posY = 0
			;(nil).nodeType = nodeType.awardItem
			;(nil).data = item
			;(nil).isLastOne = k == table.nums(v.reward) and i ~= table.nums(awardList)
			table.insert(self.scrollItems, nil)
			self.scrollH = self.scrollH + ITEM_HEIGHT
		end
	end
end
function radianceWarAwardPersonalView:updateScrollPos()
	local sSize = self.scroll:getContentSize()
	local listHeight = self.scrollH
	local sH = math.max(sSize.height, listHeight)
	local posY = sH
	for _, v in ipairs(self.scrollItems) do
		if v.nodeType == nodeType.awardTitle then
			posY = posY - TITLE_HEIGHT
			if v.describe then
				posY = posY - TITLE_EXTRA
			end
		elseif v.nodeType == nodeType.awardItem then
			posY = posY - ITEM_HEIGHT
		end
		v.posY = posY
	end
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
end
function radianceWarAwardPersonalView:updateScrollList()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	if self.offsetY and math.abs(self.offsetY - offsetY) < 100 then
		return
	end
	self.offsetY = offsetY
	local scrollH = self.scroll:getContentSize().height
	local beginY = math.max(0, offsetY - 150)
	local endY = offsetY + scrollH + 150
	for i, v in ipairs(self.scrollItems) do
		if v.point then
			if beginY > v.posY or endY < v.posY then
				self:recycleSingle(v)
			end
		elseif beginY <= v.posY and endY >= v.posY then
			local single = self:getSingle(v.nodeType)
			single:setPosition(0, v.posY)
			self:refreshAward(single, v, i)
			v.point = single
		end
	end
end
function radianceWarAwardPersonalView:refreshAward(itemSingle, data, index)
	local nType = data.nodeType
	if nType == nodeType.awardTitle then
		local textDescribe = SoraDGetChildByName(itemSingle, "Text_Describe")
		if textDescribe and data.describe then
			textDescribe:setString(i18n(data.describe))
		end
		SoraDGetChildByName(itemSingle, "frame_gmzz_zcjl_Right"):setSpriteFrame(data.frameName)
		SoraDGetChildByName(itemSingle, "frame_gmzz_zcjl_Left"):setSpriteFrame(data.frameName)
		local texFrame = SoraDGetChildByName(itemSingle, "dh_Tex_gmzz_005_1")
		SoraDGetChildByName(itemSingle, "Particle_1"):setVisible(index == 1)
		texFrame:stopAllActions()
		texFrame:setOpacity(0)
		if index == 1 then
			_ENV = i18n(data.describe)
			i18n(data.describe)[1] = cca.fadeTo(1, 0.6)
			i18n(data.describe)[2] = cca.fadeTo(1, 0)
			i18n(data.describe)[3] = cca.fadeTo(1, 0)
			i18n(data.describe)[4] = cca.fadeTo(1, 0)
			texFrame:runAction(cca.repeatForever(cca.seq(i18n(data.describe))))
		end
		SoraDGetChildByName(itemSingle, "Text_Title"):setString(i18n(data.title))
	elseif nType == nodeType.awardItem then
		itemSingle:getChildByName("Image_quality"):loadTexture(publicRead.getBg(data.data.id), ccui.TextureResType.plistType)
		itemSingle:getChildByName("Image_icon"):loadTexture(publicRead.getIcon(data.data.id), ccui.TextureResType.plistType)
		itemSingle:getChildByName("Text_name"):setString(publicRead.getName(data.data.id))
		nodeType = publicRead.getName(data.data.id)
		publicRead.getName(data.data.id).num = "x"
		publicRead.getName(data.data.id).char = data.data.count
		itemSingle:getChildByName("Text_num"):setString(i18n("common_text_1470", publicRead.getName(data.data.id)))
		itemSingle:getChildByName("Button_item"):setItemInfo(self:getParent(), data.data.id, data.data.count)
		itemSingle:getChildByName("Image_line"):setVisible(not data.isLastOne)
	end
end
function radianceWarAwardPersonalView:getSingle(nType)
	local single
	if not self.listNode[nType] then
		local _ENV, listNode = self.listNode[nType], self.listNode[nType]
	end
	if 0 < #listNode then
		single = table.remove(listNode)
	else
		if nType == nodeType.awardTitle then
			single = self.nodeTitle:clone()
		elseif nType == nodeType.awardItem then
			single = self.nodeSingle:clone()
			local buttonItem = SoraDGetChildByName(single, "Button_item")
			buttonItem = include("commonBtnInstance").new(buttonItem)
		end
		single:addTo(self.scroll)
	end
	single:setVisible(true)
	return single
end
function radianceWarAwardPersonalView:recycleAll()
	for i, v in ipairs(self.scrollItems) do
		self:recycleSingle(v)
	end
	self.scrollItems, _ENV = ipairs(self.scrollItems)
end
function radianceWarAwardPersonalView:recycleSingle(single)
	local nType = single.nodeType
	local point = single.point
	if point then
		if nType == nodeType.awardTitle then
			point:setVisible(false)
			table.insert(self.listNode[nType], point)
			single.point = nil
		elseif nType == nodeType.awardItem then
			point:setVisible(false)
			table.insert(self.listNode[nType], point)
			single.point = nil
		end
	end
end
function radianceWarAwardPersonalView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScrollList()
	end
end
function radianceWarAwardPersonalView:btnRankClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local allianceMgr = _G.SoraDGetCtrl("allianceMgr")
		if not allianceMgr:hasJoinAlliance() then
			SoraDShowMsgTip(i18n("notice_0066"))
			return
		end
		local tag = target:getTag()
		if radianceActivityCtrl:getWarStatus() > include("radianceWarDef").RADIANCE_WAR_STATE.RESULT then
			local panel = SoraDCreatePanel("radianceWarIntegralView")
			panel:jumpToRank(self.rewardViewType, self.showViewType)
			panel:show()
		else
			SoraDShowMsgTip(i18n("devilvalley_text_08"))
		end
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return radianceWarAwardPersonalView
