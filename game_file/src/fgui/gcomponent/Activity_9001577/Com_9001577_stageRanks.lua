local baseComponent = require("fgui.base.baseComponent")
local Com_9001577_stageRanks = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001577/Com_9001577_stageRanks", Com_9001577_stageRanks)
local activity_9001577_Ctrl = SoraDGetCtrl("activity_9001577_Ctrl")
function Com_9001577_stageRanks:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
end
function Com_9001577_stageRanks:onShow()
	self.fields.title1:setString(i18n("common_text_3579"))
	self.fields.title2:setString(i18n("legendaryking_title_03"))
end
function Com_9001577_stageRanks:initData()
	for i = 1, 6 do
		local myRankInfo = activity_9001577_Ctrl:getMyStageRankInfo(i)
		dump(myRankInfo, "myRankInfo")
		local rankStr = myRankInfo == nil or i > activity_9001577_Ctrl:getCurrentStage() and "-" or (myRankInfo.rank == nil or myRankInfo.rank <= 0) and "/" or myRankInfo.rank <= 5000 and myRankInfo.rank or "5000+"
		self.fields["rank" .. i]:setString(i)
		self.fields["score" .. i]:setString(rankStr)
	end
end
return Com_9001577_stageRanks
