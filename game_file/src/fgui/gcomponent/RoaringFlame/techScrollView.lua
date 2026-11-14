local OFFSET = 5
local OFFSET_SINGLE = 15
local BORDER_WIDTH = 3
local COLOR_GAY = cc.c4f(0.5215686274509804, 0.2823529411764706, 0.17647058823529413, 0.5)
local COLOR_HIGHT = cc.c4f(0.9764705882352941, 0.8784313725490196, 0.33725490196078434, 1.0)
local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local techScrollView = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/techScrollView", techScrollView)
function techScrollView:onInit()
	self.lineArray, _UPVALUE0_ = nil, nil
end
function techScrollView:onShow()
	self:initData()
end
function techScrollView:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_TECHNOLOGY", handler(self, self.updateLine))
end
function techScrollView:initData()
	self.lineArray, roaringFlameWarRead = nil, nil
	local techTree = roaringFlameWarRead.getTechnologyTree()
	local roaringFlameWarRead, techTreeRE
	local techTreeNext = roaringFlameWarRead.getTechnologyTreeNext()
	for i, v in ipairs(techTree) do
		local skillTarget = self.fields["CCS_skillLine_" .. i]
		skillTarget:initData(v)
		techTreeRE[v] = skillTarget
	end
	for i, v in ipairs(techTree) do
		local skillTarget = self.fields["CCS_skillLine_" .. i]
		for j, nextTechId in ipairs(techTreeNext[v]) do
			local skillNextTarget = techTreeRE[nextTechId]
			local posFrom = cc.p(skillTarget:getPositionX() + OFFSET, skillTarget:getPositionY() + OFFSET - OFFSET_SINGLE)
			local posTo = cc.p(skillNextTarget:getPositionX() + OFFSET, skillNextTarget:getPositionY() + OFFSET - OFFSET_SINGLE)
			local isOpenedTo = self:isOpenedLv(nextTechId)
			local isOpenedFrom = self:isOpenedLv(v)
			local lineColor = isOpenedTo and isOpenedFrom and COLOR_HIGHT or COLOR_GAY
			local line = SoraDDrawLine(posFrom, posTo, lineColor, BORDER_WIDTH)
			self.fields.frame_line:addChild(line)
			roaringFlameWarRead = line
			line.posFrom = posFrom
			line.posTo = posTo
			line.toid = nextTechId
			table.insert(self.lineArray, line)
		end
	end
end
function techScrollView:updateData()
	local techTree = roaringFlameWarRead.getTechnologyTree()
	for i, v in ipairs(techTree) do
		local skillTarget = self.fields["CCS_skillLine_" .. i]
		skillTarget:initData(v)
	end
end
function techScrollView:isOpenedLv(id)
	return roaringFlameWarCtrl:getTechnologyLv(id) > 0
end
function techScrollView:updateLine()
	for k, v in ipairs(self.lineArray) do
		local isOpenedTo = self:isOpenedLv(v.toid)
		if isOpenedTo and not v.lineLight then
			local line = SoraDDrawLine(v.posFrom, v.posTo, COLOR_HIGHT, BORDER_WIDTH, 3)
			self.fields.frame_line:addChild(line)
			_ENV = line
			line.posFrom = v.posFrom
			line.posTo = v.posTo
			line.toid = v.toid
			line.lineLight = true
			table.insert(self.lineArray, line)
		end
	end
end
return techScrollView
