local footballChampionCtrl = SoraDGetCtrl("footballChampionCtrl")
local footballChampionRead = include("footballChampionRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_Question = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ChampionContest/Com_Question", Com_Question)
function Com_Question:onInit()
	self:fixChildrenPos()
	for i = 1, 3 do
		self.fields["Check" .. i]:addClickListener(handler(self, self.onClickCheck))
	end
	self.fields.Check1:setString(i18n("common_text_290"))
	self.fields.Check2:setString(i18n("country_enumeration_33"))
	self.fields.Check3:setString(i18n("common_text_290"))
	self.fields.Text_VS:setString("VS")
	self.fields.Button_Add:addClickListener(handler(self, self.onClickAdd))
	self.fields.Button_Exchange:addClickListener(handler(self, self.onClickAdd))
	self.fields.List_Choose:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List_Choose:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onClickItemEnter))
end
function Com_Question:onShow()
end
function Com_Question:initData(data)
	self.matchIndex = data.id
	self.answer = data.answer
	self.myGuess = footballChampionCtrl:getMyGuess(data.id)
	self.end_time = data.end_time
	if data.type == 1 then
		print("01")
		if table.nums(data.answer) == 2 then
			self.controllers.c1:setSelectedIndex(4)
		else
			self.controllers.c1:setSelectedIndex(0)
		end
	elseif table.nums(data.answer) >= 20 then
		self.controllers.c1:setSelectedIndex(self.myGuess and 2 or 1)
		if self.myGuess then
			local config = footballChampionRead.getAnswerConfig(self.myGuess)
			self.fields.Text_ChooseName:setString(i18n(config.country))
			self.fields.Icon_Country:setURL(config.flag)
		end
	else
		self.controllers.c1:setSelectedIndex(3)
	end
	if data.question ~= "" then
		self.fields.Title_Question:setString(i18n(data.question))
		self.fields.Title2:setString(i18n(data.question))
	end
	self.fields.Text_BeginTime:setString(SoraDConverTimeStr(data.game_time))
	footballChampionCtrl = SoraDConverTimeStr(data.game_time)
	SoraDConverTimeStr(data.game_time).time = SoraDConverTimeStr(data.end_time)
	self.fields.Text_EndTime:setString(i18n("champion_prediction_04", SoraDConverTimeStr(data.game_time)))
	if data.type == 1 then
		if table.nums(data.answer) == 2 then
			local config1 = footballChampionRead.getAnswerConfig(data.answer[1])
			local config2 = footballChampionRead.getAnswerConfig(data.answer[2])
			self.fields.Com_Nat1:setString(i18n(config1.country))
			self.fields.Com_Nat3:setString(i18n(config2.country))
			self.fields.Com_Nat1:setIcon(config1.flag)
			self.fields.Com_Nat3:setIcon(config2.flag)
			self.fields.Check2:setString(i18n("common_text_290"))
			self.fields.Check2:setPositionX(self.fields.Check3:getPositionX())
		else
			self.fields.Check2:setString(i18n("country_enumeration_33"))
			self.fields.Check2:setPositionX(222)
			for i, v in ipairs(data.answer) do
				local config = footballChampionRead.getAnswerConfig(v)
				if self.fields["Com_Nat" .. i] then
					self.fields["Com_Nat" .. i]:setString(i18n(config.country))
					if config.flag ~= "" then
						self.fields["Com_Nat" .. i]:setIcon(config.flag)
					end
				end
			end
		end
		self.controllers.c2:setSelectedIndex(self.myGuess and self.myGuess - 1 or 3)
	elseif table.nums(data.answer) < 20 then
		self.answer = data.answer
		self.fields.List_Choose:setNumItems(#self.answer)
		if self.myGuess then
		end
	end
end
function Com_Question:onClickCheck()
	SoraDPlaySound()
	local index = self.controllers.c2:getSelectedIndex()
	if not self.myGuess or self.myGuess ~= index + 1 then
		print("index", index)
		_ENV = index
		index.matchIndex = self.matchIndex
		index.answerIndex = index + 1
		footballChampionCtrl:reqFootballChampionGuess(index)
		self.myGuess = index + 1
	end
end
function Com_Question:onItemRederer(index, target)
	local answerIndex = self.answer[index + 1]
	local config = footballChampionRead.getAnswerConfig(answerIndex)
	if config then
		target:setString(i18n(config.country))
	end
	print("self.myGuess", self.myGuess, index + 1, i18n(config.country))
	target:setSelected(self.myGuess == index + 1)
	target:fixChildrenPos()
end
function Com_Question:onClickItemEnter()
	print("onClickItemEnter")
	SoraDPlaySound()
	local index = self.fields.List_Choose:getSelectedIndex() + 1
	print("self.fields.List", index)
	if index == 0 then
		return
	end
	if self.end_time <= serviceFunctions.systemTime() then
		SoraDShowMsgTip(i18n("champion_prediction_20"))
		_ENV = i18n("champion_prediction_20")
		i18n("champion_prediction_20").msg = "MESSAGE_FOOTBALL_CHAMPION_REFRESH"
		SoraDSendMessage(i18n("champion_prediction_20"))
		return
	end
	_ENV = i18n("champion_prediction_20")
	i18n("champion_prediction_20").matchIndex = self.matchIndex
	i18n("champion_prediction_20").answerIndex = index
	footballChampionCtrl:reqFootballChampionGuess(i18n("champion_prediction_20"))
end
function Com_Question:onClickItem()
	SoraDPlaySound()
	print("onClickItem")
	if self.end_time <= serviceFunctions.systemTime() then
		SoraDShowMsgTip(i18n("champion_prediction_20"))
		_ENV = i18n("champion_prediction_20")
		i18n("champion_prediction_20").msg = "MESSAGE_FOOTBALL_CHAMPION_REFRESH"
		SoraDSendMessage(i18n("champion_prediction_20"))
		return
	end
	local index = self.fields.List_Choose:getSelectedIndex() + 1
	print("self.fields.List", index)
	_ENV = index
	index.matchIndex = self.matchIndex
	index.answerIndex = index
	footballChampionCtrl:reqFootballChampionGuess(index)
end
function Com_Question:onClickAdd()
	SoraDPlaySound()
	if self.end_time <= serviceFunctions.systemTime() then
		SoraDShowMsgTip(i18n("champion_prediction_20"))
		_ENV = i18n("champion_prediction_20")
		i18n("champion_prediction_20").msg = "MESSAGE_FOOTBALL_CHAMPION_REFRESH"
		SoraDSendMessage(i18n("champion_prediction_20"))
		return
	end
	_ENV = i18n("champion_prediction_20")
	i18n("champion_prediction_20").answer = self.answer
	i18n("champion_prediction_20").matchIndex = self.matchIndex
	uiManager:show("footballChoose", i18n("champion_prediction_20"))
end
return Com_Question
