local gametop = gModuleMgr.getObject("gametop")
local allianceScience = gametop.playertop_:getModule("allianceScience")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local baseComponent = require("fgui.base.baseComponent")
local Com_Science = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceScienceView/Com_Science", Com_Science)
_ENV = fgui.register_extension
fgui.register_extension.RECOMMEND = 1
fgui.register_extension.OPEN = 2
local fgui.register_extension.LOCK, SingleDataType = 3, fgui.register_extension
function Com_Science:onInit()
	self.fields.Text_point:fixChildrenPos()
	self.fields.Text_score:fixChildrenPos()
	self.fields.Text_point:fixPos()
	self.fields.Text_score:fixPos()
	_ENV = self.fields.Text_score.fixPos
	self.fields.Text_score.fixPos[1] = true
	self.tableAllianceScienceListState, self.fields.Text_score.fixPos[2] = self.fields.Text_score.fixPos, false
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self:updateData()
end
function Com_Science:onShow()
end
function Com_Science:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_DONATE_SUCCESS", handler(self, self.updateNextGroup))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_SCIENCE_ADD_RECOMMEND_SUCCESS", handler(self, self.updateAllData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_SCIENCE_REMOVE_RECOMMEND_SUCCESS", handler(self, self.updateAllData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_SCIENCE_DATA_BACK", handler(self, self.updateAllData))
end
function Com_Science:onItemRenderer(index, target)
	dump(self.tableAllianceScienceListState, "tableAllianceScienceListState")
	if self.tableAllianceScienceListState[index + 1] == nil then
		table.insert(self.tableAllianceScienceListState, false)
	end
	target:initData(self.tableScienceList[index + 1])
	target:setState(self.tableAllianceScienceListState[index + 1])
end
function Com_Science:updateData()
	self.tableScienceList, allianceScience = nil, nil
	local tableRecommand = allianceScience:getRecommendList()
	if not allianceScience:getScienceGroup() then
		local allianceScience, tableOpenList = allianceScience:getScienceGroup(), allianceScience:getScienceGroup()
	end
	local tableNextList, needlv = allianceScience:getNextGroupSciIDList()
	allianceScience = nil
	;(nil).index = 0
	;(nil).data = tableRecommand
	;(nil).singleDataType = 1
	;(nil).isOpened = true
	table.insert(self.tableScienceList, nil)
	local lastOpenIndex = 1
	for k, v in pairs(tableOpenList) do
		allianceScience = k
		k.index = tonumber(k)
		k.data = v
		k.singleDataType = 2
		self.tableScienceList[tonumber(k) + 1], k.isOpened = k, true
		lastOpenIndex = math.max(tonumber(k), lastOpenIndex)
	end
	dump(tableNextList, "tableNextList")
	if tableNextList and next(tableNextList) then
		allianceScience = "tableNextList"
		;("tableNextList").index = lastOpenIndex + 1
		;("tableNextList").data = tableNextList
		;("tableNextList").singleDataType = 3
		;("tableNextList").isOpened = false
		;("tableNextList").needLv = needlv
		table.insert(self.tableScienceList, "tableNextList")
	end
	local curPoint = memberMgr:getOwnMember():getProperty("playerHonor")
	self.fields.Text_point:setString(string.formatnumberthousands(curPoint))
	self.fields.Text_score:setString(string.formatnumberthousands(allianceMgr:getAllianceProperty("bonus")))
	allianceScience = string.formatnumberthousands(allianceMgr:getAllianceProperty("bonus"))
	string.formatnumberthousands(allianceMgr:getAllianceProperty("bonus")).lv = allianceScience:getCurSciTotalLv()
	self.fields.Text_lv:setString(i18n("common_text_2474", string.formatnumberthousands(allianceMgr:getAllianceProperty("bonus"))))
	self.fields.List:setNumItems(#self.tableScienceList)
end
function Com_Science:updateNextGroup(target, data)
	local sciid = data.sciid
	if sciid ~= nil then
		for i, v in ipairs(self.tableScienceList) do
			if v.singleDataType == SingleDataType.RECOMMEND or v.singleDataType == SingleDataType.OPEN then
				for si, sv in ipairs(v.data) do
					print(si, sv.id, type(sv.id), type(sciid))
					if sv.id == sciid then
						v.data[si] = allianceScience:getScienceData(sciid)
					end
				end
			end
		end
	end
	local tableOpenList = allianceScience:getScienceGroup()
	local tableNextList, needlv = allianceScience:getNextGroupSciIDList()
	if tableNextList and next(tableNextList) then
		if table.nums(tableOpenList) > #self.tableScienceList then
			self:updateData()
		elseif table.nums(tableOpenList) == #self.tableScienceList and self.fields.List:getChildAt(#self.tableScienceList - 1) then
			self.fields.List:getChildAt(#self.tableScienceList - 1):updateNextGroup(false)
		end
	elseif tableNextList == nil and table.nums(tableOpenList) > #self.tableScienceList and self.fields.List:getChildAt(#self.tableScienceList - 1) then
		self.fields.List:getChildAt(#self.tableScienceList - 1):updateNextGroup(false)
	end
	local curPoint = memberMgr:getOwnMember():getProperty("playerHonor")
	self.fields.Text_point:setString(string.formatnumberthousands(curPoint))
	self.fields.Text_score:setString(string.formatnumberthousands(allianceMgr:getAllianceProperty("bonus")))
	_ENV = string.formatnumberthousands(allianceMgr:getAllianceProperty("bonus"))
	string.formatnumberthousands(allianceMgr:getAllianceProperty("bonus")).lv = allianceScience:getCurSciTotalLv()
	self.fields.Text_lv:setString(i18n("common_text_2474", string.formatnumberthousands(allianceMgr:getAllianceProperty("bonus"))))
end
function Com_Science:updateAllData(target, data)
	self:updateData()
end
function Com_Science:jumpToSicence(sid)
	print("jumpToSicence")
	local allianceltCtrl = include("allianceltCtrl")
	local id = tonumber(allianceltCtrl.scienceAttr(sid, gAScienceInfo.GROUP))
	local height = 0
	local scrollH = 0
	local num = self.fields.List:numChildren()
	for i, v in ipairs(self.tableScienceList) do
		local isLaunch = v.index == id
		self.tableAllianceScienceListState[i] = isLaunch
		if self.fields.List:getChildAt(i - 1) then
			self.fields.List:getChildAt(i - 1):setState(isLaunch)
			scrollH = scrollH + self.fields.List:getChildAt(i - 1):getHeight()
		end
		if isLaunch and self.fields.List:getChildAt(i - 1) then
			height = 56 * (i - 1) + self.fields.List:getChildAt(i - 1):getOffsetBySid(sid)
			print("height", self.fields.List:getChildAt(i - 1):getOffsetBySid(sid))
		end
	end
	local scrollPanel = self.fields.List:getScrollPane()
	local listH = self.fields.List:getContentSize().height
	local _overlapSizeH = scrollH - listH
	print("height", height, _overlapSizeH, height - listH / 2, scrollH)
	if 0 < _overlapSizeH then
		local perY = (height - listH / 2) / _overlapSizeH
		scrollPanel:setPercY(perY, ani)
	end
end
return Com_Science
