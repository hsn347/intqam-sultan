local publicRead = include("publicRead")
local cavalryRiseUtil = include("cavalryRiseUtil")
local cavalryRiseCtrl = SoraDGetCtrl("cavalryRiseCtrl")
local cavalryRiseRead = include("cavalryRiseRead")
local CAVALRY_RISE_AWARD_TYPE = cavalryRiseUtil.CAVALRY_RISE_AWARD_TYPE
local cavalryRiseAwardPreviewView = class("cavalryRiseAwardPreviewView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("cavalryRiseAwardPreviewView")
	end
	return target
end)
function cavalryRiseAwardPreviewView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeReward = SoraDGetChildByName(self, "Node_reward")
	self.nodeTitleGold = SoraDGetChildByName(self, "Node_titleGold")
	self.nodeTitleNormal = self.nodeTitleGold:clone()
	self.nodeTitleNormal:addTo(self.nodeTitleGold:getParent())
	local imgTitlel = SoraDGetChildByName(self.nodeTitleNormal, "Image_l")
	local imgTitler = SoraDGetChildByName(self.nodeTitleNormal, "Image_r")
	imgTitlel:loadTexture("frame_zqlz_rankbg_02.png", ccui.TextureResType.plistType)
	imgTitler:loadTexture("frame_zqlz_rankbg_02.png", ccui.TextureResType.plistType)
	local txtTitleGold = SoraDChangeTextToHtml(SoraDGetChildByName(self.nodeTitleGold, "Text_reward_title"))
	local txtTitleNormal = SoraDChangeTextToHtml(SoraDGetChildByName(self.nodeTitleNormal, "Text_reward_title"))
	_ENV = SoraDGetChildByName(self.nodeTitleNormal, "Text_reward_title")
	_ENV, _ENV, SoraDGetChildByName(self.nodeTitleNormal, "Text_reward_title").var = "cavalryrise_text_20", i18n("cavalryrise_text_20"), i18n("cavalryrise_text_20")
	i18n("cavalryrise_text_20").var, ("cavalryrise_text_20").color = "cavalryrise_text_20", "#FADC28"
	txtTitleGold:setString(i18n_html("cavalryrise_text_12", SoraDGetChildByName(self.nodeTitleNormal, "Text_reward_title")))
	_ENV = i18n_html("cavalryrise_text_12", SoraDGetChildByName(self.nodeTitleNormal, "Text_reward_title"))
	_ENV, _ENV, i18n_html("cavalryrise_text_12", SoraDGetChildByName(self.nodeTitleNormal, "Text_reward_title")).var = "cavalryrise_text_21", i18n("cavalryrise_text_21"), i18n("cavalryrise_text_21")
	i18n("cavalryrise_text_21").var, ("cavalryrise_text_21").color = "cavalryrise_text_21", "#D7AF5F"
	txtTitleNormal:setString(i18n_html("cavalryrise_text_13", i18n_html("cavalryrise_text_12", SoraDGetChildByName(self.nodeTitleNormal, "Text_reward_title"))))
	self.single = SoraDGetChildByName(self, "Node_single")
	self.single:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "ScrollView_award")
	self:initData()
end
function cavalryRiseAwardPreviewView:setTitle(str)
	self.ccs_bg:setTitleName(str or i18n("summoned_text_07"))
end
function cavalryRiseAwardPreviewView:initData()
	self.itemList, CAVALRY_RISE_AWARD_TYPE = nil, nil
	self.itemList[CAVALRY_RISE_AWARD_TYPE.CAVALRY_RISE_AWARD_TYPE_GOLD], CAVALRY_RISE_AWARD_TYPE = nil, nil
	self.itemList[CAVALRY_RISE_AWARD_TYPE.CAVALRY_RISE_AWARD_TYPE_NORMAL], CAVALRY_RISE_AWARD_TYPE = nil, nil
	local insertAward = function(itemData, awardType)
		local awardList = self.itemList[awardType]
		for _, v in ipairs(itemData) do
			awardList[#awardList + 1] = v
		end
	end
	if not cavalryRiseRead:getAwardShowList(cavalryRiseCtrl:getClassType()) then
		local CAVALRY_RISE_AWARD_TYPE, awardShowList = cavalryRiseRead:getAwardShowList(cavalryRiseCtrl:getClassType()), cavalryRiseRead:getAwardShowList(cavalryRiseCtrl:getClassType())
	end
	dump(awardShowList, "awardShowList", 10)
	for _, v in ipairs(awardShowList) do
		local awardType = v.type or CAVALRY_RISE_AWARD_TYPE.CAVALRY_RISE_AWARD_TYPE_NORMAL
		insertAward(v.award, awardType)
	end
	dump(self.itemList, "self.itemList", 10)
	self:initScrollList()
end
function cavalryRiseAwardPreviewView:initScrollList()
	self.scrollH = 0
	self:updateScrollData()
	self:updateScrollPos()
end
local TITLE_HEIGHT = 50
local SCROLL_ITEM_HEIGHT = 70
function cavalryRiseAwardPreviewView:updateScrollPos()
	local sSize = self.scroll:getContentSize()
	local listHeight = self.scrollH + 10
	local sH = math.max(sSize.height, listHeight)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self.nodeReward:setPositionY(sH)
end
function cavalryRiseAwardPreviewView:updateScrollData()
	for k, v in ipairs(self.itemList) do
		self:getSingle_Title(k)
		self:getSingle_AwardPanel(k, v)
	end
end
function cavalryRiseAwardPreviewView:getSingle_Title(taskType)
	local single
	if taskType == CAVALRY_RISE_AWARD_TYPE.CAVALRY_RISE_AWARD_TYPE_GOLD then
		single = self.nodeTitleGold
	else
		single = self.nodeTitleNormal
	end
	self.scrollH = self.scrollH + TITLE_HEIGHT
	single:setPositionY(-self.scrollH)
	return single
end
function cavalryRiseAwardPreviewView:getSingle_AwardPanel(taskType, itemInfo)
	for i, v in ipairs(itemInfo) do
		local single = self.single:clone()
		single:addTo(self.nodeReward)
		single:setVisible(true)
		single:setPositionY(-self.scrollH)
		local award = SoraDGetExtendChildFromCCSByName(single, "CCS_commonItemAward_item")
		award:initData(v.id, nil)
		award:setOwnView(self)
		award:setOwnScroll(self.scroll)
		award:setBaseScale(1)
		local img_bg_item = SoraDGetChildByName(single, "img_bg_item")
		img_bg_item:setVisible(i % 2 == 1)
		local textName = SoraDGetChildByName(single, "Text_name")
		local textNum = SoraDGetChildByName(single, "Text_num")
		textName:setString(publicRead.getName(v.id))
		textNum:setString(string.format("X%d", v.count))
		self.scrollH = self.scrollH + SCROLL_ITEM_HEIGHT
		single:setPositionY(-self.scrollH)
	end
end
return cavalryRiseAwardPreviewView
