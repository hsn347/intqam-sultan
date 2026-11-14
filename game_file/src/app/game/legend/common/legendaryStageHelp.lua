local legendRewardRead = include("legendRewardRead")
local legendaryStageHelp = class("legendaryStageHelp", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateTouchPanel("legendaryStageHelp")
		end
		if type(target) == "string" then
			return SoraDCreateTouchPanel(target)
		end
		return target
	end
end)
function legendaryStageHelp:ctor()
	self:createUI()
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.commonPopBox_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.scrollViewInfo = SoraDGetChildByName(self, "ScrollView_Info")
	self.txtScore = SoraDGetChildByName(self, "txtScore")
	self.txtTip = SoraDGetChildByName(self, "txtTip")
	self.panelItem = SoraDGetChildByName(self, "panelItem")
	self.topLine = SoraDGetChildByName(self, "top_line")
	self.panelLine = SoraDGetChildByName(self, "panel_line")
	self.commonPopBox_bg:setTitleName(i18n("common_text_4421"))
	self.scroll = include("commonAutoScrollList").new(self.scrollViewInfo)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
end
function legendaryStageHelp:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function legendaryStageHelp:init(data)
	self.data = data
	local score = data.score
	_ENV = nil
	;(nil).num = string.formatnumberthousands(score)
	self.txtScore:setString(i18n("common_text_2557", nil))
	if self.data.stageType == gLegendStageType.KING then
		self.txtTip:setString(i18n("legendaryking_text_33"))
	elseif self.data.stageType == gLegendStageType.KING_STAR then
		self.txtTip:setString(i18n("kingstarbattle_text_40"))
	elseif self.data.stageType == gLegendStageType.HEGEMON then
		self.txtTip:setString(i18n("hegemon_text_53"))
	end
	local reqType
	if data.personalType == gLegendPersonalStageRewardType.NORMAL then
	elseif data.personalType == gLegendPersonalStageRewardType.KILL then
		self.txtTip:setString(i18n("legendaryking_text_102"))
		reqType = 1
	elseif data.personalType == gLegendPersonalStageRewardType.LOSE then
		self.txtTip:setString(i18n("legendaryking_text_103"))
		reqType = 2
	end
	local scoreConf = legendRewardRead.getScoreConf(self.data.stageType, self.data.mapid)
	if not scoreConf then
		return
	end
	self.itemList, _ENV = self.data.stageType, self.data.stageType
	if reqType then
		for i, v in ipairs(scoreConf) do
			if v.type == reqType then
				_ENV = i18n("legendaryking_text_103")
				i18n("legendaryking_text_103").index = i
				i18n("legendaryking_text_103").scoreInfo = v
				table.insert(self.itemList, i18n("legendaryking_text_103"))
			end
		end
	else
		for i, v in ipairs(scoreConf) do
			_ENV = i18n("legendaryking_text_103")
			i18n("legendaryking_text_103").index = i
			i18n("legendaryking_text_103").scoreInfo = v
			table.insert(self.itemList, i18n("legendaryking_text_103"))
		end
	end
	dump(self.itemList, "self.itemList ")
	_ENV = table.insert
	table.insert.scroll = self.scroll
	self.scroll:updateScrollView(cc.size(560, 35), self.itemList, 1, table.insert)
	SoraDGetAutoHeightLabelNew(self.txtTip, 500, false)
	_UPVALUE4_ = SoraDGetAutoHeightLabelNew
	_UPVALUE3_, SoraDGetAutoHeightLabelNew[1] = self.scroll, self.scroll
	_UPVALUE3_, SoraDGetAutoHeightLabelNew[2] = self.scroll, self.panelLine
	_UPVALUE3_, SoraDGetAutoHeightLabelNew[3] = self.scroll, self.txtTip
	local _UPVALUE3_, SoraDGetAutoHeightLabelNew[4], nodesArray = self.scroll, self.txtScore, SoraDGetAutoHeightLabelNew
	self.scroll[1] = 2
	self.scroll[2] = 10
	local self.scroll[3], paddingArray = 10, self.scroll
	local accuH = SoraDAlignNodeArrayV(nodesArray, false, paddingArray)
	self.topLine:setPositionY(self.txtScore:getPositionY() + 4)
	self.commonPopBox_bg:setSize(cc.size(580, accuH + 80))
end
function legendaryStageHelp:onMessageListener()
end
function legendaryStageHelp:createSingle()
	local ocx = self.panelItem:clone()
	local single = include("legendStageHelpItem").new(ocx)
	single:setVisible(true)
	single:setScroll(self.scroll)
	single:setView(self)
	single:setPositionX(0)
	return ocx
end
return legendaryStageHelp
