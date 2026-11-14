local legendRewardRead = include("legendRewardRead")
local legendaryStageRewardPreview = class("legendaryStageRewardPreview", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateTouchPanel("legendaryStageRewardPreview")
		end
		if type(target) == "string" then
			return SoraDCreateTouchPanel(target)
		end
		return target
	end
end)
function legendaryStageRewardPreview:ctor()
	self:createUI()
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.commonPopBox_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.txtTotalPrice = SoraDGetChildByName(self, "txtTotalPrice")
	self.txtDes = SoraDGetChildByName(self, "txtDes")
	self.scrollViewInfo = SoraDGetChildByName(self, "ScrollView_Info")
	self.panelSingle = SoraDGetChildByName(self, "panel_single")
	self.img103 = SoraDGetChildByName(self, "Image_103")
	self.img1030 = SoraDGetChildByName(self, "Image_103_0")
	self.textDes = SoraDGetChildByName(self, "text_des")
	self.nodeItem = SoraDGetChildByName(self, "nodeItem")
	self.textDes0 = SoraDGetChildByName(self, "text_des_0")
	self.imgLine = SoraDGetChildByName(self, "Image_line")
	self.panelTitle = SoraDGetChildByName(self, "panelTitle")
	self.spLineTitle = SoraDGetChildByName(self, "Sprite_line_title")
	self.txtNum = SoraDGetChildByName(self, "txtNum")
	self.txtName = SoraDGetChildByName(self, "txtName")
	self.txtName:setString(i18n("common_text_2708"))
	self.txtNum:setString(i18n("common_text_2709"))
	self.scroll = include("commonAutoScrollList").new(self.scrollViewInfo)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
end
function legendaryStageRewardPreview:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function legendaryStageRewardPreview:init(data)
	dump(data, "legendaryStageRewardPreview:init(data)")
	self.data = data
	_ENV = nil
	;(nil).price = string.formatnumberthousands(self.data.totalPrice)
	self.txtTotalPrice:setString(i18n("common_text_3044", nil))
	_ENV = i18n("common_text_3044", nil)
	i18n("common_text_3044", nil).point = string.formatnumberthousands(self.data.needScore)
	self.txtDes:setString(i18n("common_text_4423", i18n("common_text_3044", nil)))
	local titleTxt
	if self.data._realRewardType then
		if self.data._realRewardType == gLegendStageRewardType.PERSONAL then
			_ENV = i18n("common_text_4423", i18n("common_text_3044", nil))
			i18n("common_text_4423", i18n("common_text_3044", nil)).num = self.data.stage
			titleTxt = i18n("common_text_3146", i18n("common_text_4423", i18n("common_text_3044", nil)))
		elseif self.data._realRewardType == gLegendStageRewardType.ALLIANCE then
			_ENV = i18n("common_text_4423", i18n("common_text_3044", nil))
			i18n("common_text_4423", i18n("common_text_3044", nil)).num = self.data.stage
			titleTxt = i18n("free_team_text_69", i18n("common_text_4423", i18n("common_text_3044", nil)))
		elseif self.data._realRewardType == gLegendStageRewardType.KILL then
			_ENV = i18n("common_text_4423", i18n("common_text_3044", nil))
			i18n("common_text_4423", i18n("common_text_3044", nil)).num = self.data.stage
			titleTxt = i18n("legendaryking_text_107", i18n("common_text_4423", i18n("common_text_3044", nil)))
		elseif self.data._realRewardType == gLegendStageRewardType.LOSE then
			_ENV = i18n("common_text_4423", i18n("common_text_3044", nil))
			i18n("common_text_4423", i18n("common_text_3044", nil)).num = self.data.stage
			titleTxt = i18n("legendaryking_text_108", i18n("common_text_4423", i18n("common_text_3044", nil)))
		end
	elseif self.data.rewardType == gLegendStageRewardType.PERSONAL then
		_ENV = i18n("common_text_4423", i18n("common_text_3044", nil))
		i18n("common_text_4423", i18n("common_text_3044", nil)).num = self.data.stage
		titleTxt = i18n("common_text_3146", i18n("common_text_4423", i18n("common_text_3044", nil)))
	elseif self.data.rewardType == gLegendStageRewardType.ALLIANCE then
		_ENV = i18n("common_text_4423", i18n("common_text_3044", nil))
		i18n("common_text_4423", i18n("common_text_3044", nil)).num = self.data.stage
		titleTxt = i18n("free_team_text_69", i18n("common_text_4423", i18n("common_text_3044", nil)))
	end
	self.commonPopBox_bg:setTitleName(titleTxt)
	local rewards = legendRewardRead.getStageRewardByType(self.data.stageType, self.data._realRewardType or self.data.rewardType, self.data.mapid)
	local stageRewards = rewards[self.data.stage].reward
	dump(stageRewards, "stageRewards", 10)
	local numRewards = #stageRewards
	self.itemList = stageRewards
	_ENV = i18n("common_text_4423", i18n("common_text_3044", nil))
	i18n("common_text_4423", i18n("common_text_3044", nil)).scroll = self.scroll
	self.scroll:updateScrollView(cc.size(560, 90), self.itemList, 1, i18n("common_text_4423", i18n("common_text_3044", nil)))
	_UPVALUE4_ = self.scroll.updateScrollView
	_UPVALUE3_, self.scroll.updateScrollView[1] = self.scroll, self.scroll
	_UPVALUE3_, self.scroll.updateScrollView[2] = self.scroll, self.panelTitle
	_UPVALUE3_, self.scroll.updateScrollView[3] = self.scroll, self.txtDes
	local _UPVALUE3_, self.scroll.updateScrollView[4], nodesArray = self.scroll, self.txtTotalPrice, self.scroll.updateScrollView
	self.scroll[1] = 2
	self.scroll[2] = 10
	local self.scroll[3], paddingArray = 10, self.scroll
	local accuH = SoraDAlignNodeArrayV(nodesArray, false, paddingArray)
	self.commonPopBox_bg:setSize(cc.size(580, accuH + 80))
end
function legendaryStageRewardPreview:onMessageListener()
end
function legendaryStageRewardPreview:createSingle()
	local ocx = self.panelSingle:clone()
	local single = include("legendRewardItem").new(ocx)
	single:setVisible(true)
	single:setScroll(self.scroll)
	single:setView(self)
	single:setPositionX(0)
	return ocx
end
return legendaryStageRewardPreview
