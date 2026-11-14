local activity_9001734_Read = include("activity_9001734_Read")
local activity_9001734_Ctrl = SoraDGetCtrl("activity_9001734_Ctrl")
local constantRead = include("constantRead")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_RecordOptionSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001734/Com_RecordOptionSingle", Com_RecordOptionSingle)
function Com_RecordOptionSingle:onInit()
	local itemIdReward = constantRead.getConstValue("FOOTBALL_BETTING_REWARDITEM", 882801)
	self.fields.icon_item:setURL(publicRead.getIcon(itemIdReward))
	self:fixChildrenPos()
end
function Com_RecordOptionSingle:onShow()
end
function Com_RecordOptionSingle:initData(matchId, title)
	self.matchId = matchId
	self.title = title
	self.OptionsRecord = activity_9001734_Ctrl:getOptionsRecord(self.matchId, self.title)
	if not self.OptionsRecord then
		return
	end
	local isCorrect = activity_9001734_Ctrl:isPredictCorrect(self.matchId, self.title)
	self.controllers.c2:setSelectedIndex(isCorrect and 0 or 1)
	local titleCfg = activity_9001734_Read.getBetTitleCfg(self.title)
	local optionCfg = activity_9001734_Read.getOptionCfg(self.OptionsRecord.optionid)
	self.fields.text_option:setString(i18n(titleCfg.betTitle) .. ":" .. fguiHelper.getColorString("#FFC864", i18n(optionCfg.optionText)))
	local oddsId = activity_9001734_Ctrl:getOptionOddsId(self.matchId, self.title, self.OptionsRecord.optionid)
	local oddsCfg = activity_9001734_Read.getOddsCfg(oddsId)
	local odds = tonumber(oddsCfg.odds)
	local oddsType = 0
	if 2 <= odds and odds <= 4 then
		oddsType = 1
	elseif 4 < odds then
		oddsType = 2
	end
	self.controllers.c1:setSelectedIndex(oddsType)
	self.fields.text_odds:setString(odds)
	self.fields.text_reward:setString(isCorrect and math.ceil(self.OptionsRecord.num * oddsCfg.odds) or self.OptionsRecord.num)
end
return Com_RecordOptionSingle
