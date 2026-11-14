local remainsWarRead = include("remainsWarRead")
local remainsWarltCtrl = include("remainsWarltCtrl")
local scrollNode = include("scrollNode")
local teamInfoSingle = class("teamInfoSingle", function(target)
	return target
end)
local colorGray = cc.c3b(123, 123, 123)
local colorNormal = cc.c3b(255, 255, 255)
function teamInfoSingle:ctor()
	self.listNode, _ENV, self.scrollItems, _ENV = nil, nil, nil, nil
	self.single = SoraDGetChildByName(self, "Node_single")
	self.single:setVisible(false)
	self.tableSingleData, _ENV = self.single.setVisible, self.single.setVisible
	local remainsWarUtil = include("remainsWarUtil")
	self.isXianXia = remainsWarUtil.checkIsInRemainsXianXia()
end
function teamInfoSingle:initData(data)
	self.tableSingleData = data
	table.sort(self.tableSingleData, function(team1, team2)
		return team1.uid < team2.uid
	end)
	self:updateNodeList()
end
function teamInfoSingle:initSingle(single)
	local framehead = SoraDGetChildByName(single, "frame_head")
	if framehead then
		framehead = scrollNode.new(framehead)
		framehead:setSwallowTouches(false)
		framehead:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function teamInfoSingle:getSingle()
	local single
	if #self.listNode > 0 then
		single = table.remove(self.listNode)
	else
		single = self.single:clone()
		single:addTo(self)
		self:initSingle(single)
	end
	single:setVisible(true)
	return single
end
function teamInfoSingle:recycleSingle()
	for _, v in ipairs(self.scrollItems) do
		v:setVisible(false)
		table.insert(self.listNode, v)
	end
	self.scrollItems, _ENV = ipairs(self.scrollItems)
end
function teamInfoSingle:setSingleView(single, headData, index)
	local framehead = SoraDGetChildByName(single, "frame_head")
	if framehead then
		framehead:setTag(index)
		framehead:setScroll(self.scroll)
	end
	local iconhead = SoraDGetChildByName(single, "icon_head")
	SoraDGetHeadFromManager(iconhead, headData.headid, headData.avatar)
	local name = headData.nickName
	local allianceAbbr = headData.allianceAbb
	if allianceAbbr ~= nil and string.len(allianceAbbr) > 0 then
		_ENV = nil
		;(nil).abbr = allianceAbbr
		;(nil).name = headData.nickName
		name = i18n("common_text_186", nil)
	end
	if headData.fromKid then
		name = name .. "#" .. tostring(headData.fromKid)
	end
	local txtName = SoraDGetChildByName(single, "Text_name")
	txtName:setString(name)
	local txtDanNum = SoraDGetChildByName(single, "Text_dan_num")
	local strDanNum = remainsWarRead.getDanName(headData.segment)
	_ENV = nil
	;(nil).name = strDanNum
	txtDanNum:setString(i18n("remains_text_130", nil))
	local txtScoreNum = SoraDGetChildByName(single, "Text_score_num")
	local strScoreNum = string.formatnumberthousands(headData.point)
	if self.isXianXia then
		_ENV = i18n("remains_text_130", nil)
		i18n("remains_text_130", nil).num = strScoreNum
		txtScoreNum:setString(i18n("common_text_2556", i18n("remains_text_130", nil)))
	else
		_ENV = i18n("common_text_2556", i18n("remains_text_130", nil))
		i18n("common_text_2556", i18n("remains_text_130", nil)).num = strScoreNum
		txtScoreNum:setString(i18n("remains_text_128", i18n("common_text_2556", i18n("remains_text_130", nil))))
	end
	if self.isXianXia then
		SoraDGetChildByName(single, "Node_score_font"):setVisible(false)
	else
		local score = remainsWarltCtrl.getRuinsWarGrade(headData.point)
		local strScore = remainsWarRead.getScoreName(score)
		local txtScoreFont = SoraDGetChildByName(single, "Text_score_font")
		txtScoreFont:setString(strScore)
	end
	if headData.isIn then
		single:setColor(colorNormal)
	else
		single:setColor(colorGray)
	end
end
local SINGLE_HEIGHT = 105
function teamInfoSingle:updateNodeData()
	for i, v in ipairs(self.tableSingleData) do
		local single = self:getSingle()
		self:setSingleView(single, v, i)
		single:setPositionY(-(i - 1) * SINGLE_HEIGHT)
		table.insert(self.scrollItems, single)
	end
end
function teamInfoSingle:updateNodeList()
	self:recycleSingle()
	self:updateNodeData()
end
function teamInfoSingle:getHeight()
	return #self.scrollItems * SINGLE_HEIGHT + 20
end
function teamInfoSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local index = button:getTag()
		if index and 0 < index and self.tableSingleData[index] and self.handle then
			self.handle(self.tableSingleData[index])
		end
	end
end
function teamInfoSingle:setHandle(handle)
	self.handle = handle
end
function teamInfoSingle:setScroll(scroll)
	self.scroll = scroll
end
return teamInfoSingle
