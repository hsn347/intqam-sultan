local footballChampionCtrl = SoraDGetCtrl("footballChampionCtrl")
local footballChampionRead = include("footballChampionRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_Result = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ChampionContest/Com_Result", Com_Result)
function Com_Result:onInit()
	self:fixChildrenPos()
	self.fields.List_Award:setItemRenderer(handler(self, self.onItemRederer))
end
function Com_Result:onShow()
end
function Com_Result:initData(data)
	local config = footballChampionRead.getConfigByIndex(tonumber(data.index))
	local myAnswerConfig = footballChampionRead.getAnswerConfig(config.answer[data.myGuess])
	local answerConfig = footballChampionRead.getAnswerConfig(config.answer[data.result])
	self.isRight = data.result == data.myGuess
	self.controllers.c1:setSelectedIndex(self.isRight and 0 or 1)
	_UPVALUE2_ = self.isRight and 0 or 1
	;(self.isRight and 0 or 1)[1] = "id"
	;(self.isRight and 0 or 1)[2] = "count"
	self.awardList = serviceFunctions.tableFormat(self.isRight and config.right_reward or config.mistake_reward, self.isRight and 0 or 1)
	footballChampionRead = "count"
	;("count").time = SoraDConverTimeStr(config.end_time)
	self.fields.Text_EndTime:setString(i18n("champion_prediction_04", "count"))
	self.fields.Text_Answer:setString(i18n(config.question))
	footballChampionRead = i18n(config.question)
	i18n(config.question).var = i18n(myAnswerConfig.country)
	self.fields.Text_Myguess:setString(i18n("champion_prediction_14", i18n(config.question)))
	footballChampionRead = i18n("champion_prediction_14", i18n(config.question))
	i18n("champion_prediction_14", i18n(config.question)).var = i18n(answerConfig.country)
	self.fields.Text_Result:setString(i18n("champion_prediction_15", i18n("champion_prediction_14", i18n(config.question))))
	self.fields.List_Award:setNumItems(#self.awardList)
end
function Com_Result:onItemRederer(index, target)
	target:initData(self.awardList[index + 1].id, self.awardList[index + 1].count)
end
return Com_Result
