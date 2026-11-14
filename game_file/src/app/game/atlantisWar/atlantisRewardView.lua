local atlantisActivityRead = include("atlantisActivityRead")
local atlantisWarUtil = include("atlantisWarUtil")
local atlantisRewardView = class("atlantisRewardView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("atlantisRewardView")
end)
function atlantisRewardView:ctor(properties)
	self.rewardList, atlantisWarUtil, self.no1List, atlantisWarUtil, self.itemList, atlantisWarUtil, self.titleList, atlantisWarUtil = nil, nil, nil, nil, nil, nil, nil, nil
	self.palaceTimeDays = atlantisWarUtil.getPalaceTimeDays()
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.nodeCommonPopBox:setTitleName(i18n("common_text_2194"))
	self.btnSingleWar = SoraDGetChildByName(self, "Button_1")
	self.btnSeasonWar = SoraDGetChildByName(self, "Button_2")
	self.textSingle = SoraDGetChildByName(self, "Text_Single")
	self.textSeason = SoraDGetChildByName(self, "Text_Season")
	self.textSeason:setString(i18n("atlantiswar_text_0045"))
	self.textSingle:setString(i18n("atlantiswar_text_0044"))
	self.btnSeasonWar:setTag(2)
	self.btnSingleWar:setTag(1)
	self.btnSeasonWar:addTouchEventListener(handler(self, self.btnChooseType))
	self.btnSingleWar:addTouchEventListener(handler(self, self.btnChooseType))
	self.btnSeasonWar:setHeight(66)
	self.btnSingleWar:setHeight(66)
	self.nodeCommonTabBtnEX = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_2")
	self.nodeCommonTabBtnEX:setContentSize(cc.size(547, 56))
	self.nodeCommonTabBtnEX:setNewStyle(true)
	self.scrollItem = SoraDGetChildByName(self, "ScrollView")
	self.scrollItem:addEventListener(handler(self, self.scrollEventCallBack))
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.nodeTitle = SoraDGetChildByName(self, "Node_Title")
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self.Node_kno1 = SoraDGetChildByName(self, "Node_kno1")
	self:btnChooseType(self.btnSingleWar, ccui.TouchEventType.ended)
end
function atlantisRewardView:initData(target, data)
end
function atlantisRewardView:updateScroll()
	local scrollInner = self.scrollItem:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scrollItem:getContentSize().height
	_ENV = self.scrollItem
	self.scrollItem.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scrollItem.endY, tableShowH = offsetY + 1.5 * scrollH, self.scrollItem
	local posY = self.totalHeight
	for i, v in ipairs(self.rewardList) do
		posY = posY - (v.singleH or 0)
		if v.point then
			if posY < tableShowH.beginY or posY > tableShowH.endY then
				v.point:setVisible(false)
				if v.isTitle then
					table.insert(self.titleList, v.point)
				elseif v.isKingdomNO1 then
					table.insert(self.no1List, v.point)
				else
					table.insert(self.itemList, v.point)
				end
				v.point = nil
			else
				if v.isTitle then
					self:updateTitleItem(v)
				elseif v.isKingdomNO1 then
					self:updateKingdomNO1Item(v)
				else
					_ENV = nil
					;(nil).scroll = self.scrollItem
					v.point:initData(v, nil)
					v.point:showLine(i ~= #self.rewardList and not self.rewardList[i + 1].isTitle and not self.rewardList[i].isKNO1)
				end
				v.point:setVisible(true)
				v.point:setPosition(273.5, posY)
			end
		elseif posY >= tableShowH.beginY and posY <= tableShowH.endY then
			if v.isTitle then
				if 0 < #self.titleList then
					v.point = table.remove(self.titleList)
				else
					v.point = self.nodeTitle:clone()
					v.point:addTo(self.scrollItem)
				end
				self:updateTitleItem(v)
			elseif v.isKingdomNO1 then
				if 0 < #self.no1List then
					v.point = table.remove(self.no1List)
				else
					v.point = self:createKingdomNO1Item()
					v.point:addTo(self.scrollItem)
				end
				self:updateKingdomNO1Item(v)
			else
				if 0 < #self.itemList then
					v.point = table.remove(self.itemList)
				else
					v.point = include("atlantisRewardSingle").new(self.nodeSingle:clone())
					v.point:addTo(self.scrollItem)
				end
				_ENV = self.nodeSingle:clone()
				self.nodeSingle:clone().scroll = self.scrollItem
				v.point:initData(v, self.nodeSingle:clone())
				v.point:showLine(i ~= #self.rewardList and not self.rewardList[i + 1].isTitle and not self.rewardList[i].isKNO1)
			end
			v.point:setPosition(273.5, posY)
			v.point:setVisible(true)
		end
	end
end
function atlantisRewardView:createKingdomNO1Item(...)
	local Node_kno1 = self.Node_kno1:clone()
	local Button_palace = SoraDGetChildByName(Node_kno1, "Button_palace")
	Button_palace:addTouchEventListener(function(target, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			_ENV, _ENV = nil, nil
			_ENV = nil
			;(nil).day = self.palaceTimeDays
			;(nil).title = i18n("atlantiswar_text_0271", nil)
			_ENV = nil
			;(nil).day = self.palaceTimeDays
			;(nil).des = i18n("atlantiswar_text_0394", nil)
			;(nil).customData, (nil).skinType = nil, DRESS_PREVIEW_TYPE.PALACE
			uiManager:show("commonDressPreview", nil)
		end
	end)
	local Button_sign = SoraDGetChildByName(Node_kno1, "Button_sign")
	Button_sign:addTouchEventListener(function(target, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			_ENV, _ENV = nil, nil
			_ENV = nil
			;(nil).day = self.palaceTimeDays
			;(nil).title = i18n("atlantiswar_text_0392", nil)
			_ENV = nil
			;(nil).day = self.palaceTimeDays
			;(nil).des = i18n("atlantiswar_text_0396", nil)
			;(nil).customData, (nil).skinType = nil, DRESS_PREVIEW_TYPE.SIGN
			uiManager:show("commonDressPreview", nil)
		end
	end)
	return Node_kno1
end
function atlantisRewardView:updateKingdomNO1Item(item)
	local Text_dressName = SoraDGetChildByName(item.point, "Text_dressName")
	_ENV = nil
	;(nil).day = self.palaceTimeDays
	Text_dressName:setString(i18n("atlantiswar_text_0271", nil))
	local palaceInfoRead = include("palaceInfoRead")
	if palaceInfoRead.checkAtlantisPalaceBuff() then
		_ENV, _ENV = i18n("atlantiswar_text_0271", nil)
		_ENV, palaceInfoRead.checkAtlantisPalaceBuff()[1], i18n("atlantiswar_text_0271", nil).lang = i18n("atlantiswar_text_0271", nil)
		_ENV, palaceInfoRead.checkAtlantisPalaceBuff()[2], i18n("atlantiswar_text_0271", nil).lang = i18n("atlantiswar_text_0271", nil)
		palaceInfoRead.checkAtlantisPalaceBuff()[3], i18n("atlantiswar_text_0271", nil).lang = i18n("atlantiswar_text_0271", nil)
		local desCfg = palaceInfoRead.checkAtlantisPalaceBuff()
		for i = 1, 3 do
			local Node_attr = SoraDGetChildByName(item.point, "Node_attr" .. i)
			local Text_dressAttr = SoraDGetChildByName(Node_attr, "Text_dressAttr")
			Text_dressAttr:setString(desCfg[i].lang)
		end
	else
		Text_dressName:setPositionY(50)
		for i = 1, 3 do
			local Node_attr = SoraDGetChildByName(item.point, "Node_attr" .. i)
			Node_attr:setVisible(false)
		end
	end
	local Text_signName = SoraDGetChildByName(item.point, "Text_signName")
	_ENV = Node_attr.setVisible
	Node_attr.setVisible.day = self.palaceTimeDays
	Text_signName:setString(i18n("atlantiswar_text_0392", Node_attr.setVisible))
end
function atlantisRewardView:updateTitleItem(item)
	local nodeAutoCenter = SoraDGetChildByName(item.point, "Node_AutoCenter")
	local imgIcon = SoraDGetChildByName(nodeAutoCenter, "Image_Icon")
	local textTitle = SoraDGetChildByName(nodeAutoCenter, "Text_Title")
	textTitle:setString(i18n(item.titleStr))
	imgIcon:setVisible(false)
	if item.titleIcon then
		imgIcon:setVisible(true)
		imgIcon:loadTexture(item.titleIcon, ccui.TextureResType.plistType)
	end
	SoraDToCenter(nodeAutoCenter, 5)
end
function atlantisRewardView:btnChooseType(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		self.isSeasonReward = tag == 2
		self.textSingle:setColor(not self.isSeasonReward and cc.c3b(255, 245, 175) or cc.c3b(144, 132, 97))
		self.textSeason:setColor(self.isSeasonReward and cc.c3b(255, 245, 175) or cc.c3b(144, 132, 97))
		self.btnSingleWar:setIcon(not self.isSeasonReward and "btn_alliance_special.png" or "btn_alliance_click.png")
		self.btnSeasonWar:setIcon(self.isSeasonReward and "btn_alliance_special.png" or "btn_alliance_click.png")
		local _ENV, param = self.btnSeasonWar.setIcon, self.btnSeasonWar.setIcon
		if not self.isSeasonReward then
			_ENV = self.isSeasonReward
			self.isSeasonReward.tabNum = 3
			_ENV, _ENV, self.isSeasonReward.defaultClick = 144, self.isSeasonReward and "btn_alliance_special.png" or "btn_alliance_click.png", 1
			;(144).title = i18n("atlantiswar_text_0046")
			;(144).handle = handler(self, self.btnTabClick)
			;(144).tag = 1
			_ENV, (self.isSeasonReward and "btn_alliance_special.png" or "btn_alliance_click.png")[1], (144).fontSize = 144, 144, 20
			;(144).title = i18n("atlantiswar_text_0047")
			;(144).handle = handler(self, self.btnTabClick)
			;(144).tag = 2
			_ENV, (self.isSeasonReward and "btn_alliance_special.png" or "btn_alliance_click.png")[2], (144).fontSize = 144, 144, 20
			;(144).title = i18n("lord_title_01")
			;(144).handle = handler(self, self.btnTabClick)
			;(144).tag = 3
			param, self.isSeasonReward.tabsetArray, (self.isSeasonReward and "btn_alliance_special.png" or "btn_alliance_click.png")[3], (144).fontSize = self.isSeasonReward, self.isSeasonReward and "btn_alliance_special.png" or "btn_alliance_click.png", 144, 20
		else
			_ENV = self.isSeasonReward
			self.isSeasonReward.tabNum = 4
			_ENV, _ENV, self.isSeasonReward.defaultClick = 144, self.isSeasonReward and "btn_alliance_special.png" or "btn_alliance_click.png", 1
			;(144).title = i18n("atlantiswar_text_0046")
			;(144).handle = handler(self, self.btnTabClick)
			;(144).tag = 1
			_ENV, (self.isSeasonReward and "btn_alliance_special.png" or "btn_alliance_click.png")[1], (144).fontSize = 144, 144, 20
			;(144).title = i18n("atlantiswar_text_0048")
			;(144).handle = handler(self, self.btnTabClick)
			;(144).tag = 2
			_ENV, (self.isSeasonReward and "btn_alliance_special.png" or "btn_alliance_click.png")[2], (144).fontSize = 144, 144, 20
			;(144).title = i18n("atlantiswar_text_0047")
			;(144).handle = handler(self, self.btnTabClick)
			;(144).tag = 3
			_ENV, (self.isSeasonReward and "btn_alliance_special.png" or "btn_alliance_click.png")[3], (144).fontSize = 144, 144, 20
			;(144).title = i18n("lord_title_01")
			;(144).handle = handler(self, self.btnTabClick)
			;(144).tag = 4
			param, self.isSeasonReward.tabsetArray, (self.isSeasonReward and "btn_alliance_special.png" or "btn_alliance_click.png")[4], (144).fontSize = self.isSeasonReward, self.isSeasonReward and "btn_alliance_special.png" or "btn_alliance_click.png", 144, 20
		end
		self.nodeCommonTabBtnEX:initView(param)
	end
end
function atlantisRewardView:btnTabClick(tag, name)
	self:recycleAll()
	if not self.isSeasonReward then
		self.rewardType = tag
	else
		self.rewardType = tag + 3
	end
	self.textTips:setString(i18n(string.format("atlantiswar_text_005%d", self.rewardType)))
	self.rewardList = atlantisActivityRead.getRewardList(self.rewardType)
	dump(self.rewardList, "rewardList", 100)
	self.totalHeight = math.max(503, atlantisActivityRead.getScrollHeight(self.rewardType))
	print("totalHeight", self.totalHeight)
	self.scrollItem:setInnerContainerSize(cc.size(547, self.totalHeight))
	self.scrollItem:jumpToTop()
	self:updateScroll()
end
function atlantisRewardView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScroll()
	end
end
function atlantisRewardView:recycleAll()
	for i, v in ipairs(self.rewardList) do
		if v.point then
			v.point:setVisible(false)
			if v.isTitle then
				table.insert(self.titleList, v.point)
			elseif v.isKingdomNO1 then
				table.insert(self.no1List, v.point)
			else
				table.insert(self.itemList, v.point)
			end
			v.point = nil
		end
	end
	self.rewardList, _ENV = ipairs(self.rewardList)
end
function atlantisRewardView:onExitPanel()
	self:recycleAll()
end
return atlantisRewardView
