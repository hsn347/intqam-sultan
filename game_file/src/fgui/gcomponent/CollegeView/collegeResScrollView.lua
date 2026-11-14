local collegeDesRead = include("collegeDesRead")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local OFFSET = 100
local BORDER_WIDTH = 3
local COLOR_GAY = cc.c4f(0.34, 0.34, 0.34, 1.0)
local COLOR_HIGHT = cc.c4f(0.96, 0.67, 0.0, 1.0)
local baseComponent = require("fgui.base.baseComponent")
local collegeResScrollView = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CollegeView/collegeResScrollView", collegeResScrollView)
fgui.register_extension("ui://CollegeView/collegeWarScrollView", collegeResScrollView)
fgui.register_extension("ui://CollegeView/collegeDevelopScrollView", collegeResScrollView)
fgui.register_extension("ui://CollegeView/collegeDefScrollView", collegeResScrollView)
fgui.register_extension("ui://CollegeView/collegeSpecialScrollView", collegeResScrollView)
fgui.register_extension("ui://CollegeView/collegeSoldierScrollView", collegeResScrollView)
fgui.register_extension("ui://CollegeView/collegeCommanderScrollView", collegeResScrollView)
fgui.register_extension("ui://CollegeView/collegeHeroScrollView", collegeResScrollView)
fgui.register_extension("ui://CollegeView/collegeAdvancedMilitaryScrollView", collegeResScrollView)
fgui.register_extension("ui://CollegeView/warTechnologyScrollView", collegeResScrollView)
fgui.register_extension("ui://CollegeView/warBattleScrollView", collegeResScrollView)
fgui.register_extension("ui://CollegeView/warMilitaryScrollView", collegeResScrollView)
fgui.register_extension("ui://CollegeView/warCommandScrollView", collegeResScrollView)
fgui.register_extension("ui://CollegeView/warLightScrollView", collegeResScrollView)
function collegeResScrollView:onInit()
	self.lineArray, _ENV, self.treeType = TECHNOLOGY_ATTR.resource, TECHNOLOGY_ATTR.resource, TECHNOLOGY_ATTR.resource
end
function collegeResScrollView:onShow()
end
function collegeResScrollView:registerEvent()
	SoraDAddMessage(self, "MESSAGE_UPDATE_TECHNOLOGY", handler(self, self.updateLine))
end
function collegeResScrollView:initData(techType, queueType)
	self.treeType = techType
	self.lineArray, collegeDesRead, self.queueType = nil, nil, queueType
	self.tableTree = collegeDesRead.getTree(self.treeType)
	self.fields.frame_line_rl:clearContent()
	for i, v in ipairs(self.tableTree) do
		local index = tonumber(v) % 100
		local skillTarget = self.fields["CCS_skillLine_" .. index]
		local tData = technologyCtrl:getTechnoDataByID(tonumber(v), self.treeType)
		local isShowTech = tData and true or false
		skillTarget:setVisible(isShowTech)
		if isShowTech then
			skillTarget:initData(tonumber(v), self.treeType, self.queueType)
			local singleDetails = technologyCtrl:getTechnologyDetails(tonumber(v), 0)
			for j, nextTech in ipairs(singleDetails.tech) do
				local nextIndex = tonumber(nextTech.tid) % 100
				local skillNextTarget = self.fields["CCS_skillLine_" .. nextIndex]
				local posTo = cc.p(skillTarget:getPositionX() + OFFSET, skillTarget:getPositionY() + OFFSET)
				local posFrom = cc.p(skillNextTarget:getPositionX() + OFFSET, skillNextTarget:getPositionY() + OFFSET)
				local isOpenedTo = self:isOpenedLv(tonumber(nextTech.tid), self.treeType)
				local isOpenedFrom = self:isOpenedLv(tonumber(v), self.treeType)
				local lineColor = isOpenedTo and isOpenedFrom and COLOR_HIGHT or COLOR_GAY
				local line = SoraDDrawLine(posFrom, posTo, lineColor, BORDER_WIDTH)
				self.fields.frame_line:addChild(line)
				collegeDesRead = line
				line.posFrom = posFrom
				line.posTo = posTo
				line.toid = tonumber(v)
				line.type = self.treeType
				table.insert(self.lineArray, line)
			end
		end
	end
end
function collegeResScrollView:isOpenedLv(id, treeType)
	if not technologyCtrl:getTechnoDataByID(id, treeType) then
		local technologyCtrl, singleData = technologyCtrl:getTechnoDataByID(id, treeType), technologyCtrl:getTechnoDataByID(id, treeType)
	end
	return singleData.isOpened and singleData.currentLevel > 0
end
function collegeResScrollView:updateLine()
	for k, v in ipairs(self.lineArray) do
		local isOpenedTo = self:isOpenedLv(v.toid, v.type)
		if isOpenedTo and not v.lineLight then
			local line = SoraDDrawLine(v.posFrom, v.posTo, COLOR_HIGHT, BORDER_WIDTH, 3)
			self.fields.frame_line:addChild(line)
			_ENV = line
			line.posFrom = v.posFrom
			line.posTo = v.posTo
			line.toid = v.toid
			line.type = v.type
			line.lineLight = true
			table.insert(self.lineArray, line)
		end
	end
end
function collegeResScrollView:getCollegeSingleById(tid)
	self.tableTree = collegeDesRead.getTree(self.treeType)
	for i, v in ipairs(self.tableTree) do
		local index = tonumber(v) % 100
		local skillTarget = self.fields["CCS_skillLine_" .. index]
		if skillTarget:getTechID() == tid then
			self:scrollToObj(skillTarget)
			return skillTarget
		end
	end
end
return collegeResScrollView
