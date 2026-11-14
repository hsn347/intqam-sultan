local soldierRushRead = include("soldierRushRead")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_chapterProgress = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_chapterProgress", Com_chapterProgress)
function Com_chapterProgress:onInit()
	self.fields.bar:setMax(100)
	self.fields.bar:fixPos()
	self.fields.bar:setScaleX(SoraDFIsRA() and 1 or -1)
	self.fields.star:fixPos()
	self.fields.Text_star:fixPos()
	self.fields.r1:fixPos()
	self.fields.r2:fixPos()
	self.fields.r3:fixPos()
end
function Com_chapterProgress:onShow()
end
function Com_chapterProgress:initData(chapter)
	local _, curStars = soldierRushCtrl:getChpaterInfo(chapter)
	self.fields.Text_star:setString(curStars)
	local soldierRushCtrl, stageList = self.fields.Text_star.setString, self.fields.Text_star.setString
	for index = 1, 3 do
		local needStars = soldierRushRead.getChapterStarCfg(chapter, index)
		table.insert(stageList, needStars)
	end
	local percent = SoraDGetStagePercentNew(curStars, stageList)
	self.fields.bar:setValue(percent)
	for i = 1, 3 do
		self.fields["r" .. i]:initData(chapter, i, curStars)
	end
end
return Com_chapterProgress
