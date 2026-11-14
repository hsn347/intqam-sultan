local epicWarltCtrl = include("epicWarltCtrl")
local epicBattleArmyDetailView = class("epicBattleArmyDetailView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicBattleArmyDetailView")
	end
	return target
end)
function epicBattleArmyDetailView:ctor()
	self.bossData, _ENV, self.scaleActTarget = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_019"))
	self.ccs_bossHero = SoraDGetExtendChildFromCCSByName(self, "CCS_heroShowBanner_hero")
	self.scroll = SoraDGetChildByName(self, "ScrollView_content")
	self.txtTotalCount = SoraDGetChildByName(self, "Text_totalArmyCount")
	self.Node_attribute = SoraDGetChildByName(self, "Node_attribute")
	self.Node_attribute:setVisible(false)
	self.Node_midBar = SoraDGetChildByName(self, "Node_midBar")
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_tab")
	self.ccs_tab:setContentSize(cc.size(572, 56))
	self.ccs_tab:setNewStyle()
end
function epicBattleArmyDetailView:initData(data)
	self.bossData = data
	self.bossIndex = self.bossData.eventData.eventParam.bossId
	self.bossArmyList, epicWarltCtrl, self.bossHeroList = epicWarltCtrl.getBossHeroList(self.bossIndex), epicWarltCtrl.getBossHeroList(self.bossIndex), epicWarltCtrl.getBossHeroList(self.bossIndex)
	local total = 0
	for k, v in pairs(self.bossData.eventData.eventParam.curArmyList) do
		total = total + v
		epicWarltCtrl = nil
		;(nil).id = tonumber(k)
		;(nil).num = v
		table.insert(self.bossArmyList, nil)
	end
	table.sort(self.bossArmyList, function(a, b)
		return a.id > b.id
	end)
	self.bossArmyTotal = total
	self.bonusCount, self.bossArmyBonusList = epicWarltCtrl.getBossBonus(self.bossIndex)
	function epicWarltCtrl(a, b)
		return a.id > b.id
	end
	epicWarltCtrl, epicWarltCtrl, (function(a, b)
		return a.id > b.id
	end).tabNum = nil, nil, 2
	;(nil).title = i18n("buildDes_name_109")
	;(nil).tag = 1
	epicWarltCtrl, (nil)[1], (nil).handle = nil, nil, handler(self, self.onBtnDetailClick)
	;(nil).title = i18n("common_text_120")
	;(nil).tag = 2
	;(function(a, b)
		return a.id > b.id
	end).tabsetArray, (nil)[2], (nil).handle = nil, nil, handler(self, self.onBtnAttributeClick)
	self.ccs_tab:initView(function(a, b)
		return a.id > b.id
	end)
end
function epicBattleArmyDetailView:initView()
	self.ccs_bossHero:initData(self.bossHeroList)
	_ENV = nil
	;(nil).count = self.bossArmyTotal
	self.txtTotalCount:setString(i18n("common_text_466", nil))
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, #self.bossArmyList * 100)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for k, v in ipairs(self.bossArmyList) do
		local single = include("commonArmySingle").new()
		single:setPosition(sSize.width / 2, sH - k * 100)
		single:initData(v)
		single:addTo(self.scroll)
	end
end
function epicBattleArmyDetailView:initAttribute()
	local createSingle = function(index, info)
		local single = self.Node_attribute:clone()
		single:setVisible(true)
		local Image_aBg = SoraDGetChildByName(single, "Image_aBg")
		local Text_attribute = SoraDGetChildByName(single, "Text_attribute")
		local Text_value = SoraDGetChildByName(single, "Text_value")
		local value = info.value / 10 .. "%"
		Image_aBg:setVisible(index % 2 == 0)
		Text_attribute:setString(i18n(info.key))
		Text_value:setString(value)
		return single
	end
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, #self.bossArmyBonusList * 40)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for k, v in ipairs(self.bossArmyBonusList) do
		local single = createSingle(k, v)
		single:setPosition(sSize.width / 2, sH - k * 40 + 20)
		single:addTo(self.scroll)
	end
end
function epicBattleArmyDetailView:onBtnDetailClick()
	self.ccs_bossHero:setVisible(true)
	self.scroll:removeAllChildren()
	self.myArmyInUseOcxs, _ENV = self.scroll.removeAllChildren, self.scroll.removeAllChildren
	if #self.bossHeroList > 0 then
		self.ccs_bossHero:setPositionY(255)
		self.scroll:setContentSize(cc.size(580, 425))
		self.Node_midBar:setPositionY(135)
	else
		self.scroll:setContentSize(cc.size(580, 542))
		self.Node_midBar:setPositionY(252)
	end
	self.Node_midBar:setVisible(true)
	self:initView()
end
function epicBattleArmyDetailView:onBtnAttributeClick(button, event)
	self.ccs_bossHero:setVisible(false)
	self.scroll:removeAllChildren()
	self.myArmyInUseOcxs, _ENV = self.scroll.removeAllChildren, self.scroll.removeAllChildren
	self.scroll:setContentSize(cc.size(580, 580))
	self.Node_midBar:setVisible(false)
	self:initAttribute()
end
return epicBattleArmyDetailView
