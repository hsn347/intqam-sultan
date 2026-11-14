local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local lordSkillDesRead = include("lordSkillDesRead")
local lordSkillModuleAPI = include("lordSkillModuleAPI")
local baseComponent = require("fgui.base.baseComponent")
local skillDevelopScroll = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/skillDevelopScroll", skillDevelopScroll)
function skillDevelopScroll:onInit()
	self.type = LORD_ATTR.Develop
	self.frame_line = cc.DrawNode:create()
	self.frame_line:setPosition(100, 100)
	self.fields.frame_line:setContent(self.frame_line)
	self.frame_line_hl = cc.DrawNode:create()
	self.frame_line_hl:setPosition(100, 100)
	self.fields.frame_line_hl:setContent(self.frame_line_hl)
	self.fields.frame_line_rl:setContentSize(cc.size(0, 0))
end
function skillDevelopScroll:onShow()
end
function skillDevelopScroll:initData(skillTreeData, setID)
	self.skillTreeData = skillTreeData
	self.setID = setID
	self.skillTreeKey = lordSkillDesRead.getTree(self.type)
	self.fields.frame_line_rl:clearContent()
	for i, v in ipairs(self.skillTreeKey) do
		local index = tonumber(v) % 100
		local skillTarget = self.fields["CCS_skillLine_" .. index]
		skillTarget:initData(self.skillTreeData[v], self.type, self.setID)
		local tablePostSkills = lordSkillModuleAPI:getSkillPost(v)
		for j, nextTech in ipairs(tablePostSkills) do
			local nextIndex = tonumber(nextTech) % 100
			local skillNextTarget = self.fields["CCS_skillLine_" .. nextIndex]
			local line = include("skillScrollLine").new()
			self.fields.frame_line_rl:setContent(line)
			lordSkillDesRead = nil
			;(nil).x = skillNextTarget:getPositionX()
			;(nil).y = 30 - skillNextTarget:getPositionY()
			line:setPosition(cc.p(nil))
			local posX = skillTarget:getPositionX() - skillNextTarget:getPositionX()
			local posY = skillTarget:getPositionY() - skillNextTarget:getPositionY()
			lordSkillDesRead = cc.p(nil)
			cc.p(nil).id = nextTech
			cc.p(nil).toid = v
			cc.p(nil).setID = self.setID
			cc.p(nil).type = self.type
			cc.p(nil).posX = posX
			cc.p(nil).posY = -posY
			line:initData(cc.p(nil))
		end
	end
end
function skillDevelopScroll:jumpToSkillID(skillID)
	local index = tonumber(skillID) % 100
	local obj = self.fields["CCS_skillLine_" .. index]
	self:scrollToObj(obj)
	return obj
end
function skillDevelopScroll:scrollToObj(obj, ani)
	local scrollPanel = self:getScrollPane()
	local objPosY = obj:getY()
	local objH = obj:getContentSize().height
	local listH = self:getContentSize().height
	local scrollH = 5400
	local _overlapSizeH = math.abs(scrollH - listH)
	if 0 < _overlapSizeH then
		local perY = (objPosY + objH / 2 - listH / 2) / _overlapSizeH
		scrollPanel:setPercY(perY, ani)
	end
end
function skillDevelopScroll:jumpToTopAni()
	self:getScrollPane():setPercY(0, true)
end
return skillDevelopScroll
