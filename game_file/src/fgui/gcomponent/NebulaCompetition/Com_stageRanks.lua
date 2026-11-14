local baseComponent = require("fgui.base.baseComponent")
local Com_stageRanks = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaCompetition/Com_stageRanks", Com_stageRanks)
local nebulaCompetitionCtrl = SoraDGetCtrl("nebulaCompetitionCtrl")
function Com_stageRanks:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
end
function Com_stageRanks:onShow()
	self.fields.title1:setString(i18n("common_text_3579"))
	self.fields.title2:setString(i18n("legendaryking_title_03"))
end
function Com_stageRanks:initData()
	for i = 1, 6 do
		local myRankInfo = nebulaCompetitionCtrl:getMyStageRankInfo(i)
		dump(myRankInfo, "myRankInfo")
		local rankStr = myRankInfo == nil or i > nebulaCompetitionCtrl:getCurrentStage() and "-" or (myRankInfo.rank == nil or myRankInfo.rank <= 0) and "/" or myRankInfo.rank <= 5000 and myRankInfo.rank or "5000+"
		self.fields["rank" .. i]:setString(i)
		self.fields["score" .. i]:setString(rankStr)
	end
end
return Com_stageRanks
